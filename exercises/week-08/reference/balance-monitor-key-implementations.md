# Balance Monitor - 关键实现参考

本文档提供余额监控器项目的关键实现代码片段和技术说明。

---

## 📋 目录

1. [监控列表管理](#监控列表管理)
2. [余额查询](#余额查询)
3. [监控循环实现](#监控循环实现)
4. [变化检测算法](#变化检测算法)
5. [通知系统](#通知系统)
6. [数据持久化](#数据持久化)
7. [配置管理](#配置管理)
8. [并发查询优化](#并发查询优化)
9. [错误处理和重试](#错误处理和重试)
10. [命令行界面](#命令行界面)

---

## 监控列表管理

### 添加和删除地址

```haskell
module Monitor.Tracker where

import Data.Time (getCurrentTime)
import Monitor.Types

-- | 添加地址到监控列表
addMonitoredAddress :: Address -> Maybe String -> [MonitoredAddress] -> IO [MonitoredAddress]
addMonitoredAddress addr mlabel addrs = do
  now <- getCurrentTime
  let newAddr = MonitoredAddress
        { maAddress = addr
        , maLabel = mlabel
        , maAddedAt = now
        , maLastChecked = Nothing
        , maLastBalance = Nothing
        }
  return $ newAddr : addrs

-- | 删除监控地址
removeMonitoredAddress :: Address -> [MonitoredAddress] -> [MonitoredAddress]
removeMonitoredAddress addr = filter (\ma -> maAddress ma /= addr)

-- | 查找监控地址
findMonitoredAddress :: Address -> [MonitoredAddress] -> Maybe MonitoredAddress
findMonitoredAddress addr = find (\ma -> maAddress ma == addr)

-- | 更新地址的最后检查信息
updateCheckedInfo :: Address -> Lovelace -> UTCTime -> [MonitoredAddress] -> [MonitoredAddress]
updateCheckedInfo addr balance time = map update
  where
    update ma
      | maAddress ma == addr = ma 
          { maLastChecked = Just time
          , maLastBalance = Just balance
          }
      | otherwise = ma
```

### 地址验证

```haskell
-- | 验证地址格式（testnet）
validateTestnetAddress :: String -> Either MonitorError Address
validateTestnetAddress addr
  | "addr_test1" `isPrefixOf` addr = Right (Address addr)
  | "addr1" `isPrefixOf` addr = 
      Left $ ValidationError "Mainnet addresses not supported. Use testnet addresses."
  | otherwise = 
      Left $ ValidationError "Invalid address format"
```

---

## 余额查询

### 单个地址查询

```haskell
{-# LANGUAGE OverloadedStrings #-}

module Monitor.Query where

import Control.Concurrent (threadDelay)
import Control.Monad.Except (runExceptT, throwError, liftIO)
import Data.Aeson ((.:), Value)
import qualified Data.Aeson as Aeson
import Network.HTTP.Req
import Monitor.Types

-- | 查询单个地址余额
queryBalance :: Config -> Address -> IO (Either MonitorError Lovelace)
queryBalance config addr = runExceptT $ do
  let apiConfig = cfgAPI config
  let endpoint = apiEndpoint apiConfig
  let apiKey = apiKey apiConfig
  
  -- 构建请求
  let url = endpoint ++ "/api/v0/addresses/" ++ getAddress addr
  
  liftIO $ putStr "."  -- 显示进度点
  
  -- 发送请求
  response <- liftIO $ try $ runReq defaultHttpConfig $ do
    let (urlScheme, options) = parseUrl url
    req GET urlScheme NoReqBody jsonResponse $
      header "project_id" (BS.pack apiKey)
  
  case response of
    Left (err :: HttpException) -> 
      throwError $ NetworkError (show err)
    Right resp -> do
      let jsonValue = responseBody resp :: Value
      parseBalanceFromResponse jsonValue

-- | 从 Blockfrost 响应中解析余额
parseBalanceFromResponse :: Value -> ExceptT MonitorError IO Lovelace
parseBalanceFromResponse val = do
  case Aeson.fromJSON val of
    Aeson.Error err -> throwError $ ParseError err
    Aeson.Success obj -> do
      amounts <- obj .: "amount"
      -- 查找 lovelace 单位
      case find (\a -> a .: "unit" == "lovelace") amounts of
        Just lovelaceObj -> do
          quantity <- lovelaceObj .: "quantity"
          return $ Lovelace (read quantity)
        Nothing -> throwError $ ParseError "Lovelace not found in response"

-- | 格式化余额显示
formatBalance :: Lovelace -> String
formatBalance (Lovelace l) = 
  let ada = fromIntegral l / 1000000.0 :: Double
  in printf "%.6f ADA" ada
```

### 批量查询所有地址

```haskell
-- | 查询所有地址余额（带进度显示）
queryAllBalances :: Config -> [Address] -> IO [(Address, Either MonitorError Lovelace)]
queryAllBalances config addrs = do
  putStr "Querying balances "
  results <- mapM (queryWithDelay config) addrs
  putStrLn " done"
  return results

-- | 带延迟的查询（避免 API 限流）
queryWithDelay :: Config -> Address -> IO (Address, Either MonitorError Lovelace)
queryWithDelay config addr = do
  result <- queryBalance config addr
  threadDelay 100000  -- 等待 100ms
  return (addr, result)

-- | 并发查询（使用 async）
queryAllBalancesConcurrent :: Config -> [Address] -> IO [(Address, Either MonitorError Lovelace)]
queryAllBalancesConcurrent config addrs = do
  -- 分批处理，每批 5 个地址
  let batches = chunksOf 5 addrs
  results <- forM batches $ \batch -> do
    asyncResults <- mapConcurrently (queryBalance config) batch
    return $ zip batch asyncResults
  return $ concat results
```

---

## 监控循环实现

### 主监控循环

```haskell
module Monitor.Tracker where

import Control.Concurrent (threadDelay)
import Control.Exception (catch, SomeException)
import Control.Monad (forever, when)
import Data.Time (getCurrentTime)
import Monitor.Types
import qualified Monitor.Query as Query
import qualified Monitor.Notify as Notify
import qualified Monitor.Storage as Storage

-- | 主监控循环
monitorLoop :: Config -> MonitorState -> IO ()
monitorLoop config initialState = do
  putStrLn "═══════════════════════════════════"
  putStrLn "  Cardano Balance Monitor Started"
  putStrLn "═══════════════════════════════════"
  putStrLn ""
  putStrLn $ "Monitoring " ++ show (length $ msAddresses initialState) ++ " address(es)"
  putStrLn $ "Check interval: " ++ show (monInterval $ cfgMonitor config) ++ " seconds"
  putStrLn "Press Ctrl+C to stop"
  putStrLn ""
  
  loop initialState
  where
    loop state = do
      -- 执行一次检查
      newState <- performCheck config state
      
      -- 保存状态
      Storage.saveState (stgDataDir $ cfgStorage config) newState
      
      -- 等待下一次检查
      let interval = monInterval $ cfgMonitor config
      putStrLn $ "Next check in " ++ show interval ++ " seconds...\n"
      threadDelay (interval * 1000000)
      
      -- 继续循环
      loop newState

-- | 执行一次检查
performCheck :: Config -> MonitorState -> IO MonitorState
performCheck config state = do
  now <- getCurrentTime
  putStrLn $ "[" ++ formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" now ++ "] Checking balances..."
  
  -- 查询所有余额
  (changes, updatedAddrs) <- updateBalances config (msAddresses state)
  
  -- 发送通知
  when (not $ null changes) $ do
    putStrLn $ "Found " ++ show (length changes) ++ " change(s)!"
    mapM_ (Notify.notifyChange config) changes
  
  -- 更新状态
  return $ state
    { msAddresses = updatedAddrs
    , msHistory = changes ++ msHistory state
    , msLastSaved = now
    }

-- | 更新所有地址余额
updateBalances :: Config -> [MonitoredAddress] -> IO ([BalanceChange], [MonitoredAddress])
updateBalances config addrs = do
  let addresses = map maAddress addrs
  
  -- 查询所有余额
  results <- Query.queryAllBalances config addresses
  
  -- 提取成功的查询
  let successes = [(addr, bal) | (addr, Right bal) <- results]
  let failures = [(addr, err) | (addr, Left err) <- results]
  
  -- 报告失败
  mapM_ reportFailure failures
  
  -- 检测变化
  detectChanges addrs successes
  where
    reportFailure (addr, err) =
      putStrLn $ "⚠ Error querying " ++ show addr ++ ": " ++ show err
```

---

## 变化检测算法

### 核心检测逻辑

```haskell
-- | 检测余额变化
detectChanges 
  :: [MonitoredAddress]           -- 当前监控地址列表
  -> [(Address, Lovelace)]        -- 新查询的余额
  -> IO ([BalanceChange], [MonitoredAddress])
detectChanges addrs newBalances = do
  now <- getCurrentTime
  
  let results = map (detectSingle now) addrs
  
  let changes = catMaybes $ map fst results
  let updatedAddrs = map snd results
  
  return (changes, updatedAddrs)
  where
    -- 检测单个地址的变化
    detectSingle :: UTCTime -> MonitoredAddress -> (Maybe BalanceChange, MonitoredAddress)
    detectSingle now ma =
      case (maLastBalance ma, lookup (maAddress ma) newBalances) of
        -- 有旧余额，有新余额 -> 比较
        (Just oldBalance, Just newBalance) ->
          let updated = ma { maLastChecked = Just now, maLastBalance = Just newBalance }
          in if oldBalance /= newBalance
               then (Just $ createChange ma oldBalance newBalance now, updated)
               else (Nothing, updated)
        
        -- 无旧余额，有新余额 -> 首次检查
        (Nothing, Just newBalance) ->
          let updated = ma { maLastChecked = Just now, maLastBalance = Just newBalance }
          in (Nothing, updated)  -- 首次不算变化
        
        -- 查询失败 -> 保持原状
        (_, Nothing) ->
          (Nothing, ma)
    
    -- 创建变化记录
    createChange :: MonitoredAddress -> Lovelace -> Lovelace -> UTCTime -> BalanceChange
    createChange ma oldBal newBal time =
      let delta = getLovelace newBal - getLovelace oldBal
      in BalanceChange
           { bcAddress = maAddress ma
           , bcTime = time
           , bcOld = oldBal
           , bcNew = newBal
           , bcDelta = delta
           }
```

### 变化分类

```haskell
-- | 变化类型
data ChangeType = Increase | Decrease | NoChange
  deriving (Eq, Show)

-- | 分类变化
classifyChange :: BalanceChange -> ChangeType
classifyChange change
  | bcDelta change > 0 = Increase
  | bcDelta change < 0 = Decrease
  | otherwise = NoChange

-- | 按类型过滤变化
filterByType :: ChangeType -> [BalanceChange] -> [BalanceChange]
filterByType changeType = filter (\c -> classifyChange c == changeType)

-- | 计算总变化量
totalDelta :: [BalanceChange] -> Integer
totalDelta = sum . map bcDelta
```

---

## 通知系统

### 控制台通知

```haskell
module Monitor.Notify where

import Data.Time (formatTime, defaultTimeLocale)
import Monitor.Types
import Monitor.Query (formatBalance)

-- | 发送变化通知
notifyChange :: Config -> BalanceChange -> IO ()
notifyChange config change = do
  if notifyConsole (cfgNotification config)
    then displayChange (cfgNotification config) change
    else return ()

-- | 显示变化（带颜色）
displayChange :: NotificationConfig -> BalanceChange -> IO ()
displayChange config change = do
  let useColor = notifyColor config
  
  putStrLn $ colorize useColor Yellow "═══════════════════════════════════"
  putStrLn $ colorize useColor Cyan "  Balance Change Detected"
  putStrLn $ colorize useColor Yellow "═══════════════════════════════════"
  putStrLn ""
  
  putStrLn $ "Address: " ++ formatAddress (bcAddress change)
  
  -- 显示变化（带符号和颜色）
  let delta = bcDelta change
  let deltaColor = if delta > 0 then Green else Red
  let deltaSymbol = if delta > 0 then "↑" else "↓"
  
  putStrLn $ "Change:  " ++ colorize useColor deltaColor (deltaSymbol ++ " " ++ formatBalance (Lovelace $ abs delta))
  putStrLn $ "Old:     " ++ formatBalance (bcOld change)
  putStrLn $ "New:     " ++ formatBalance (bcNew change)
  putStrLn $ "Time:    " ++ formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
  putStrLn ""
  
  -- 可选声音通知
  when (notifySound config) $ do
    beep

-- | 颜色类型
data Color = Red | Green | Yellow | Blue | Cyan | White
  deriving (Eq, Show)

-- | ANSI 颜色代码
colorCode :: Color -> String
colorCode Red = "\ESC[31m"
colorCode Green = "\ESC[32m"
colorCode Yellow = "\ESC[33m"
colorCode Blue = "\ESC[34m"
colorCode Cyan = "\ESC[36m"
colorCode White = "\ESC[37m"

-- | 重置颜色
resetColor :: String
resetColor = "\ESC[0m"

-- | 应用颜色
colorize :: Bool -> Color -> String -> String
colorize False _ text = text
colorize True color text = colorCode color ++ text ++ resetColor

-- | 系统提示音
beep :: IO ()
beep = putStr "\a"
```

### 格式化和统计

```haskell
-- | 格式化变化为单行文本
formatChange :: BalanceChange -> String
formatChange change =
  let time = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
      addr = take 20 (getAddress $ bcAddress change) ++ "..."
      delta = bcDelta change
      symbol = if delta > 0 then "↑" else "↓"
  in time ++ " | " ++ addr ++ " | " ++ symbol ++ " " ++ formatBalance (Lovelace $ abs delta)

-- | 显示变化摘要
displaySummary :: [BalanceChange] -> IO ()
displaySummary changes = do
  putStrLn "Change Summary:"
  putStrLn $ "  Total changes: " ++ show (length changes)
  
  let increases = filterByType Increase changes
  let decreases = filterByType Decrease changes
  
  putStrLn $ "  Increases: " ++ show (length increases)
  putStrLn $ "  Decreases: " ++ show (length decreases)
  putStrLn ""
  putStrLn $ "  Net change: " ++ formatBalance (Lovelace $ totalDelta changes)
```

---

## 数据持久化

### 状态保存和加载

```haskell
module Monitor.Storage where

import Control.Exception (catch, IOException)
import Data.Aeson (encodeFile, eitherDecodeFileStrict)
import Data.Time (getCurrentTime, formatTime, defaultTimeLocale)
import System.Directory (createDirectoryIfMissing, doesFileExist, copyFile, listDirectory, removeFile)
import System.FilePath ((</>), takeFileName)
import Monitor.Types

-- | 状态文件路径
stateFile :: FilePath -> FilePath
stateFile dataDir = dataDir </> "monitor-state.json"

-- | 备份文件路径（带时间戳）
backupFile :: FilePath -> UTCTime -> FilePath
backupFile dataDir time =
  let timestamp = formatTime defaultTimeLocale "%Y%m%d-%H%M%S" time
  in dataDir </> ("monitor-state.backup." ++ timestamp ++ ".json")

-- | 创建默认状态
defaultState :: IO MonitorState
defaultState = do
  now <- getCurrentTime
  return $ MonitorState
    { msAddresses = []
    , msHistory = []
    , msLastSaved = now
    }

-- | 确保数据目录存在
ensureDataDir :: FilePath -> IO ()
ensureDataDir dir = createDirectoryIfMissing True dir

-- | 保存状态
saveState :: FilePath -> MonitorState -> IO ()
saveState dataDir state = do
  -- 1. 确保目录存在
  ensureDataDir dataDir
  
  -- 2. 创建备份
  let statePath = stateFile dataDir
  exists <- doesFileExist statePath
  when exists $ do
    now <- getCurrentTime
    let backupPath = backupFile dataDir now
    copyFile statePath backupPath `catch` \(_ :: IOException) -> return ()
  
  -- 3. 保存新状态
  encodeFile statePath state
  
  -- 4. 清理旧备份（只保留最近 N 个）
  cleanOldBackups dataDir 5

-- | 加载状态
loadState :: FilePath -> IO (Either String MonitorState)
loadState dataDir = do
  let path = stateFile dataDir
  exists <- doesFileExist path
  
  if exists
    then do
      result <- eitherDecodeFileStrict path
      case result of
        Left err -> do
          putStrLn $ "Error loading state: " ++ err
          putStrLn "Attempting to load from backup..."
          loadLatestBackup dataDir
        Right state -> return $ Right state
    else do
      -- 没有状态文件，返回默认状态
      state <- defaultState
      return $ Right state

-- | 加载最新备份
loadLatestBackup :: FilePath -> IO (Either String MonitorState)
loadLatestBackup dataDir = do
  backups <- findBackups dataDir
  case backups of
    [] -> Right <$> defaultState
    (latest:_) -> eitherDecodeFileStrict (dataDir </> latest)

-- | 查找所有备份文件
findBackups :: FilePath -> IO [FilePath]
findBackups dataDir = do
  exists <- doesFileExist dataDir
  if not exists
    then return []
    else do
      files <- listDirectory dataDir
      let backups = filter ("monitor-state.backup." `isPrefixOf`) files
      return $ reverse $ sort backups  -- 最新的在前面

-- | 清理旧备份
cleanOldBackups :: FilePath -> Int -> IO ()
cleanOldBackups dataDir keepCount = do
  backups <- findBackups dataDir
  let toDelete = drop keepCount backups
  mapM_ (removeFile . (dataDir </>)) toDelete
```

### CSV 导出

```haskell
-- | 导出变化历史到 CSV
exportCSV :: [BalanceChange] -> FilePath -> IO ()
exportCSV changes path = do
  let header = "Time,Address,Old Balance (Lovelace),New Balance (Lovelace),Change (Lovelace),Change (ADA)\n"
  let rows = map formatRow changes
  writeFile path (header ++ unlines rows)
  putStrLn $ "✓ Exported " ++ show (length changes) ++ " changes to " ++ path
  where
    formatRow change =
      let time = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
          addr = getAddress (bcAddress change)
          oldBal = show (getLovelace $ bcOld change)
          newBal = show (getLovelace $ bcNew change)
          delta = show (bcDelta change)
          deltaADA = printf "%.6f" (fromIntegral (bcDelta change) / 1000000.0 :: Double)
      in intercalate "," [time, addr, oldBal, newBal, delta, deltaADA]

-- | 导出监控地址列表
exportAddressList :: [MonitoredAddress] -> FilePath -> IO ()
exportAddressList addrs path = do
  let header = "Address,Label,Added At,Last Checked,Last Balance (ADA)\n"
  let rows = map formatRow addrs
  writeFile path (header ++ unlines rows)
  putStrLn $ "✓ Exported " ++ show (length addrs) ++ " addresses to " ++ path
  where
    formatRow ma =
      let addr = getAddress (maAddress ma)
          label = fromMaybe "" (maLabel ma)
          addedAt = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (maAddedAt ma)
          lastChecked = maybe "" (formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S") (maLastChecked ma)
          lastBalance = maybe "" (formatBalance) (maLastBalance ma)
      in intercalate "," [addr, label, addedAt, lastChecked, lastBalance]
```

---

## 配置管理

### YAML 配置

```haskell
module Monitor.Config where

import Data.Yaml (decodeFileEither, encodeFile, ParseException)
import System.Directory (doesFileExist)
import Monitor.Types

-- | 默认配置
defaultConfig :: Config
defaultConfig = Config
  { cfgAPI = APIConfig
      { apiKey = "testnetXXXXXXXXXXXX"
      , apiEndpoint = "https://cardano-testnet.blockfrost.io"
      }
  , cfgMonitor = MonitorConfig
      { monInterval = 300        -- 5 分钟
      , monRetryCount = 3
      , monRetryDelay = 5
      }
  , cfgStorage = StorageConfig
      { stgDataDir = ".cardano-monitor"
      , stgBackupCount = 5
      }
  , cfgNotification = NotificationConfig
      { notifyConsole = True
      , notifyColor = True
      , notifySound = False
      }
  }

-- | 加载配置
loadConfig :: FilePath -> IO (Either String Config)
loadConfig path = do
  exists <- doesFileExist path
  if exists
    then do
      result <- decodeFileEither path
      return $ case result of
        Left err -> Left (prettyPrintParseException err)
        Right cfg -> Right cfg
    else do
      putStrLn $ "Config file not found: " ++ path
      putStrLn "Using default configuration"
      return $ Right defaultConfig

-- | 保存默认配置
saveDefaultConfig :: FilePath -> IO ()
saveDefaultConfig path = do
  encodeFile path defaultConfig
  putStrLn $ "✓ Default configuration saved to: " ++ path
  putStrLn ""
  putStrLn "Please edit the file and add your Blockfrost API key:"
  putStrLn $ "  " ++ path

-- | 友好的错误信息
prettyPrintParseException :: ParseException -> String
prettyPrintParseException err = "YAML parse error: " ++ show err
```

### 配置验证

```haskell
-- | 验证配置
validateConfig :: Config -> Either String Config
validateConfig config = do
  -- 检查 API key
  when (apiKey (cfgAPI config) == "testnetXXXXXXXXXXXX") $
    Left "Please set a valid Blockfrost API key in config file"
  
  -- 检查间隔
  when (monInterval (cfgMonitor config) < 10) $
    Left "Monitor interval must be at least 10 seconds"
  
  -- 检查数据目录
  when (null $ stgDataDir $ cfgStorage config) $
    Left "Data directory cannot be empty"
  
  return config
```

---

## 并发查询优化

### 使用 async 并发查询

```haskell
import Control.Concurrent.Async (mapConcurrently, race)
import Control.Concurrent (threadDelay)

-- | 并发查询多个地址（带超时）
queryAllBalancesAsync :: Config -> [Address] -> IO [(Address, Either MonitorError Lovelace)]
queryAllBalancesAsync config addrs = do
  -- 分批处理，每批 5 个地址
  let batches = chunksOf 5 addrs
  
  results <- forM batches $ \batch -> do
    -- 并发查询一批地址
    batchResults <- mapConcurrently (queryWithTimeout config 10) batch
    
    -- 批次间延迟
    threadDelay 500000  -- 500ms
    
    return $ zip batch batchResults
  
  return $ concat results

-- | 带超时的查询
queryWithTimeout :: Config -> Int -> Address -> IO (Either MonitorError Lovelace)
queryWithTimeout config timeoutSec addr = do
  result <- race (threadDelay $ timeoutSec * 1000000) (queryBalance config addr)
  case result of
    Left _ -> return $ Left $ NetworkError "Query timeout"
    Right res -> return res

-- | 分块
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)
```

---

## 错误处理和重试

### 重试逻辑

```haskell
-- | 带重试的查询
queryWithRetry :: Config -> Address -> IO (Either MonitorError Lovelace)
queryWithRetry config addr = do
  let retryCount = monRetryCount $ cfgMonitor config
  let retryDelay = monRetryDelay $ cfgMonitor config
  
  go retryCount retryDelay
  where
    go 0 _ = queryBalance config addr
    go n delay = do
      result <- queryBalance config addr
      case result of
        Left (NetworkError _) -> do
          putStrLn $ "Retrying in " ++ show delay ++ "s... (" ++ show n ++ " left)"
          threadDelay (delay * 1000000)
          go (n-1) (delay * 2)  -- 指数退避
        _ -> return result
```

---

## 命令行界面

### 完整的命令执行

```haskell
-- | 执行命令
runCommand :: Config -> Command -> IO ()
runCommand config cmd = case cmd of
  Help -> showHelp
  
  Version -> putStrLn "Cardano Balance Monitor v0.1.0"
  
  InitConfig path -> Cfg.saveDefaultConfig path
  
  Add addr mlabel -> do
    -- 1. 验证地址
    case validateTestnetAddress (getAddress addr) of
      Left err -> putStrLn $ "✗ " ++ show err
      Right validAddr -> do
        -- 2. 加载状态
        stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
        state <- case stateResult of
          Left err -> Storage.defaultState
          Right s -> return s
        
        -- 3. 检查重复
        case findMonitoredAddress validAddr (msAddresses state) of
          Just _ -> putStrLn $ "✗ Address already being monitored"
          Nothing -> do
            -- 4. 添加地址
            newAddrs <- addMonitoredAddress validAddr mlabel (msAddresses state)
            let newState = state { msAddresses = newAddrs }
            
            -- 5. 保存状态
            Storage.saveState (stgDataDir $ cfgStorage config) newState
            
            -- 6. 显示结果
            putStrLn $ "✓ Added address to monitoring list"
            case mlabel of
              Just label -> putStrLn $ "  Label: " ++ label
              Nothing -> return ()
  
  Remove addr -> do
    stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
    case stateResult of
      Left err -> putStrLn $ "✗ Error: " ++ err
      Right state -> do
        -- 确认删除
        confirmed <- confirm $ "Remove " ++ formatAddress addr ++ " from monitoring?"
        if confirmed
          then do
            let newAddrs = removeMonitoredAddress addr (msAddresses state)
            let newState = state { msAddresses = newAddrs }
            Storage.saveState (stgDataDir $ cfgStorage config) newState
            putStrLn "✓ Address removed"
          else
            putStrLn "Cancelled"
  
  List -> do
    stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
    case stateResult of
      Left err -> putStrLn $ "✗ Error: " ++ err
      Right state -> do
        let addrs = msAddresses state
        if null addrs
          then putStrLn "No addresses being monitored"
          else do
            putStrLn $ "Monitoring " ++ show (length addrs) ++ " address(es):\n"
            displayMonitoredAddresses addrs
  
  Start mInterval -> do
    -- 加载状态
    stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
    case stateResult of
      Left err -> putStrLn $ "✗ Error: " ++ err
      Right state -> do
        -- 检查是否有地址
        when (null $ msAddresses state) $ do
          putStrLn "✗ No addresses to monitor. Add addresses first:"
          putStrLn "  balance-monitor add <address> [label]"
          exitFailure
        
        -- 更新间隔（如果提供）
        let config' = case mInterval of
              Just interval -> updateInterval config interval
              Nothing -> config
        
        -- 启动监控
        monitorLoop config' state
  
  History mAddr -> do
    stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
    case stateResult of
      Left err -> putStrLn $ "✗ Error: " ++ err
      Right state -> do
        let history = case mAddr of
              Nothing -> msHistory state
              Just addr -> filter (\c -> bcAddress c == addr) (msHistory state)
        
        if null history
          then putStrLn "No change history"
          else do
            putStrLn $ "Change history (" ++ show (length history) ++ " events):\n"
            mapM_ (putStrLn . formatChange) history
  
  Export path -> do
    stateResult <- Storage.loadState (stgDataDir $ cfgStorage config)
    case stateResult of
      Left err -> putStrLn $ "✗ Error: " ++ err
      Right state -> Storage.exportCSV (msHistory state) path
```

---

## 💡 实现技巧

### 1. 优雅退出

```haskell
import System.Posix.Signals (installHandler, Handler(Catch), sigINT, sigTERM)

-- | 设置信号处理
setupSignalHandlers :: IO () -> IO ()
setupSignalHandlers cleanup = do
  installHandler sigINT (Catch $ cleanup >> exitSuccess) Nothing
  installHandler sigTERM (Catch $ cleanup >> exitSuccess) Nothing
  return ()

-- | 在 main 中使用
main :: IO ()
main = do
  -- 设置清理函数
  setupSignalHandlers $ do
    putStrLn "\nStopping monitor..."
    putStrLn "Saving state..."
  
  -- 运行监控
  runMonitor
```

### 2. 性能优化

```haskell
-- | 使用 Map 加速地址查找
type AddressMap = Map Address MonitoredAddress

-- | 转换为 Map
toAddressMap :: [MonitoredAddress] -> AddressMap
toAddressMap = Map.fromList . map (\ma -> (maAddress ma, ma))

-- | 快速更新
updateBalanceInMap :: Address -> Lovelace -> UTCTime -> AddressMap -> AddressMap
updateBalanceInMap addr bal time = Map.adjust update addr
  where
    update ma = ma { maLastChecked = Just time, maLastBalance = Just bal }
```

---

**注意**: 这些实现提供了核心功能的参考，实际应用中可能需要根据具体需求调整。
