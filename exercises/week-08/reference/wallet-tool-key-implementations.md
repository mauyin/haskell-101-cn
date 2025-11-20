# Wallet Tool - 关键实现参考

本文档提供钱包工具项目的关键实现代码片段和技术说明。

---

## 📋 目录

1. [地址生成](#地址生成)
2. [地址验证和格式化](#地址验证和格式化)
3. [API 调用实现](#api-调用实现)
4. [余额查询](#余额查询)
5. [UTxO 查看](#utxo-查看)
6. [UTxO 选择算法](#utxo-选择算法)
7. [交易构建](#交易构建)
8. [费用计算](#费用计算)
9. [状态持久化](#状态持久化)
10. [命令行界面](#命令行界面)

---

## 地址生成

### 实现思路

虽然这是模拟实现（不是真实的密码学地址生成），但我们要确保生成的地址格式符合 Cardano testnet 地址规范。

### 完整实现

```haskell
module Wallet.Address where

import Control.Monad (replicateM)
import Data.List (find, isPrefixOf)
import System.Random (randomRIO)
import Wallet.Types

-- | 生成新地址（模拟）
-- 格式: "addr_test1q" + 50个随机字符
generateAddress :: IO Address
generateAddress = do
  randomPart <- replicateM 50 randomChar
  return $ Address $ "addr_test1q" ++ randomPart

-- | 生成随机字符（小写字母和数字）
randomChar :: IO Char
randomChar = do
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  idx <- randomRIO (0, length chars - 1)
  return $ chars !! idx
```

### 关键点

1. **前缀**: testnet 地址使用 `addr_test1`
2. **长度**: 实际 Cardano 地址约 58-108 个字符
3. **字符集**: bech32 编码使用特定字符集，这里简化为小写字母和数字

---

## 地址验证和格式化

### 地址验证

```haskell
-- | 验证地址格式
validateAddress :: String -> Either WalletError Address
validateAddress addr
  | "addr_test1" `isPrefixOf` addr && length addr >= 20 = 
      Right (Address addr)
  | "addr_test1" `isPrefixOf` addr = 
      Left $ ValidationError "Address too short"
  | otherwise = 
      Left $ ValidationError "Invalid address format. Must start with 'addr_test1'"
```

### 地址格式化（显示）

```haskell
-- | 格式化地址用于显示（截断中间部分）
-- 示例: "addr_test1q...abc123"
formatAddress :: Address -> String
formatAddress (Address addr) =
  if length addr <= 20
    then addr
    else take 12 addr ++ "..." ++ drop (length addr - 6) addr
```

### 地址列表操作

```haskell
-- | 添加地址到列表
addAddress :: AddressInfo -> [AddressInfo] -> [AddressInfo]
addAddress addr addrs = addr : addrs

-- | 从列表中移除地址
removeAddress :: Address -> [AddressInfo] -> [AddressInfo]
removeAddress addr addrs = filter (\ai -> aiAddress ai /= addr) addrs

-- | 在列表中查找地址
findAddress :: Address -> [AddressInfo] -> Maybe AddressInfo
findAddress addr addrs = find (\ai -> aiAddress ai == addr) addrs
```

---

## API 调用实现

### 使用 req 库调用 Blockfrost API

```haskell
{-# LANGUAGE OverloadedStrings #-}

module Wallet.API where

import Control.Concurrent (threadDelay)
import Control.Monad.Except (ExceptT, throwError, liftIO)
import Data.Aeson (Value, eitherDecode, (.:))
import qualified Data.Aeson as Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy as BSL
import Data.Text (Text)
import qualified Data.Text as T
import Network.HTTP.Req
import Wallet.Types

-- | 查询地址信息
queryAddressInfo :: Config -> Address -> ExceptT WalletError IO Value
queryAddressInfo config (Address addr) = do
  let endpoint = cfgApiEndpoint config
  let apiKey = cfgApiKey config
  
  -- 构建请求
  let url = endpoint ++ "/api/v0/addresses/" ++ addr
  
  response <- liftIO $ runReq defaultHttpConfig $ do
    let (urlScheme, urlPath) = parseUrl url
    req GET urlScheme NoReqBody jsonResponse $
      header "project_id" (BS.pack apiKey)
  
  return $ responseBody response

-- | 解析 URL
parseUrl :: String -> (Url 'Https, Option 'Https)
parseUrl url = 
  case useHttpsURI =<< parseURI (T.pack url) of
    Just (urlScheme, options) -> (urlScheme, options)
    Nothing -> error "Invalid URL"

-- | 查询 UTxOs
queryUTxOs :: Config -> Address -> ExceptT WalletError IO [UTxO]
queryUTxOs config (Address addr) = do
  let endpoint = cfgApiEndpoint config
  let apiKey = cfgApiKey config
  let url = endpoint ++ "/api/v0/addresses/" ++ addr ++ "/utxos"
  
  response <- liftIO $ runReq defaultHttpConfig $ do
    let (urlScheme, urlPath) = parseUrl url
    req GET urlScheme NoReqBody jsonResponse $
      header "project_id" (BS.pack apiKey)
  
  let jsonValue = responseBody response :: Value
  parseUTxOsResponse jsonValue

-- | 解析 UTxO 响应
parseUTxOsResponse :: Value -> ExceptT WalletError IO [UTxO]
parseUTxOsResponse val = 
  case Aeson.fromJSON val of
    Aeson.Success utxos -> return utxos
    Aeson.Error err -> throwError $ ParseError err
```

### 带重试的 API 调用

```haskell
-- | 带重试逻辑的请求
requestWithRetry :: Int -> IO (Either WalletError a) -> IO (Either WalletError a)
requestWithRetry 0 action = action
requestWithRetry n action = do
  result <- action
  case result of
    Left (NetworkError _) -> do
      putStrLn $ "Network error, retrying... (" ++ show n ++ " attempts left)"
      threadDelay 1000000  -- 等待 1 秒
      requestWithRetry (n-1) action
    Left (APIError msg) | "429" `isInfixOf` msg -> do
      -- API 限流，等待更长时间
      putStrLn "Rate limited, waiting 5 seconds..."
      threadDelay 5000000
      requestWithRetry (n-1) action
    _ -> return result
  where
    isInfixOf needle haystack = needle `elem` words haystack
```

---

## 余额查询

### 实现

```haskell
module Wallet.Balance where

import Control.Monad.Except (runExceptT)
import Text.Printf (printf)
import Wallet.Types
import qualified Wallet.API as API

-- | 查询余额
queryBalance :: Config -> Address -> IO (Either WalletError Lovelace)
queryBalance config addr = runExceptT $ do
  -- 调用 API
  jsonValue <- API.queryAddressInfo config addr
  
  -- 解析余额
  parseBalance jsonValue

-- | 解析余额响应
parseBalance :: Value -> ExceptT WalletError IO Lovelace
parseBalance val = do
  case Aeson.fromJSON val of
    Aeson.Success addrInfo -> do
      -- Blockfrost 返回 amount 数组，需要找到 lovelace
      let amounts = addrInfo .: "amount"
      case find (\a -> a .: "unit" == "lovelace") amounts of
        Just lovelaceAmount -> do
          quantity <- lovelaceAmount .: "quantity"
          return $ Lovelace (read quantity)
        Nothing -> throwError $ ParseError "Lovelace amount not found"
    Aeson.Error err -> throwError $ ParseError err

-- | 转换 Lovelace 到 ADA
lovelaceToAda :: Lovelace -> Double
lovelaceToAda (Lovelace l) = fromIntegral l / 1000000.0

-- | 格式化余额显示
formatBalance :: Lovelace -> String
formatBalance lovelace = printf "%.6f ADA" (lovelaceToAda lovelace)

-- | 显示余额信息
displayBalance :: Address -> Lovelace -> IO ()
displayBalance addr lovelace = do
  putStrLn $ "Address: " ++ formatAddress addr
  putStrLn $ "Balance: " ++ formatBalance lovelace
  putStrLn $ "        (" ++ show (getLovelace lovelace) ++ " Lovelace)"
```

---

## UTxO 查看

### 实现

```haskell
-- | 查询并显示 UTxOs
queryAndDisplayUTxOs :: Config -> Address -> IO ()
queryAndDisplayUTxOs config addr = do
  result <- runExceptT $ API.queryUTxOs config addr
  case result of
    Left err -> putStrLn $ "Error: " ++ show err
    Right utxos -> displayUTxOs utxos

-- | 显示 UTxO 列表
displayUTxOs :: [UTxO] -> IO ()
displayUTxOs utxos = do
  putStrLn $ "Found " ++ show (length utxos) ++ " UTxOs:"
  putStrLn ""
  
  -- 表头
  putStrLn "  TxHash                                    | Index | Amount (ADA)"
  putStrLn "  " ++ replicate 70 '-'
  
  -- 每个 UTxO
  mapM_ displayUTxO utxos
  
  -- 总计
  let total = sum $ map utxoAmount utxos
  putStrLn ""
  putStrLn $ "Total: " ++ formatBalance total

-- | 显示单个 UTxO
displayUTxO :: UTxO -> IO ()
displayUTxO utxo = do
  let txHash = getTxHash $ txOutRefHash $ utxoRef utxo
  let txIndex = getTxIndex $ txOutRefIndex $ utxoRef utxo
  let amount = utxoAmount utxo
  
  putStrLn $ "  " 
    ++ take 40 txHash ++ " | " 
    ++ show txIndex ++ "     | " 
    ++ formatBalance amount
```

---

## UTxO 选择算法

### 简单选择策略（First-Fit）

```haskell
-- | 选择足够的 UTxOs 来覆盖所需金额
-- 策略：按金额从大到小排序，依次选择直到满足需求
selectInputs :: Lovelace -> [UTxO] -> Either WalletError [UTxO]
selectInputs required utxos = 
  let sorted = sortBy (comparing (Down . utxoAmount)) utxos
      selected = go required sorted []
  in case selected of
       Nothing -> Left InsufficientFunds
       Just inputs -> Right inputs
  where
    go :: Lovelace -> [UTxO] -> [UTxO] -> Maybe [UTxO]
    go need [] acc 
      | need <= 0 = Just acc
      | otherwise = Nothing
    go need (u:us) acc =
      let newNeed = need - utxoAmount u
      in if newNeed <= 0
           then Just (u:acc)
           else go newNeed us (u:acc)
```

### 更智能的选择策略（Largest-First with Optimization）

```haskell
-- | 优化的 UTxO 选择
-- 尝试找到最小的满足条件的 UTxO 组合
selectInputsOptimized :: Lovelace -> [UTxO] -> Either WalletError [UTxO]
selectInputsOptimized required utxos =
  -- 策略 1: 尝试找单个足够大的 UTxO
  case find (\u -> utxoAmount u >= required) utxos of
    Just singleUTxO -> Right [singleUTxO]
    Nothing -> 
      -- 策略 2: 使用多个 UTxO
      selectInputs required utxos
```

---

## 交易构建

### 完整的交易构建过程

```haskell
-- | 构建支付交易
buildTransaction 
  :: Address      -- ^ 发送方地址
  -> Address      -- ^ 接收方地址
  -> Lovelace     -- ^ 发送金额
  -> [UTxO]       -- ^ 可用 UTxOs
  -> Either WalletError Transaction
buildTransaction fromAddr toAddr amount utxos = do
  -- 1. 估算费用
  let estimatedFee = estimateFee []  -- 先粗略估算
  
  -- 2. 计算总需求（金额 + 费用）
  let totalNeeded = amount + estimatedFee
  
  -- 3. 选择输入 UTxOs
  selectedInputs <- selectInputs totalNeeded utxos
  
  -- 4. 重新估算费用（基于实际输入数量）
  let actualFee = estimateFee selectedInputs
  let totalNeededWithFee = amount + actualFee
  
  -- 5. 检查是否足够
  let inputSum = sum $ map utxoAmount selectedInputs
  when (inputSum < totalNeededWithFee) $
    throwError InsufficientFunds
  
  -- 6. 计算找零
  let changeAmount = inputSum - totalNeededWithFee
  
  -- 7. 构建输出
  let outputs = if changeAmount > 0
                  then [ TxOut toAddr amount
                       , TxOut fromAddr changeAmount  -- 找零
                       ]
                  else [ TxOut toAddr amount ]
  
  -- 8. 检查找零是否为负（不应该发生）
  when (changeAmount < 0) $
    throwError NegativeChange
  
  -- 9. 创建交易
  let tx = Transaction
        { txInputs = selectedInputs
        , txOutputs = outputs
        , txFee = actualFee
        }
  
  -- 10. 验证交易平衡
  validateTransaction tx
  
  return tx
```

---

## 费用计算

### 简化的费用计算

```haskell
-- | 估算交易费用
-- 简化版本：固定费用 + 基于输入/输出数量的可变费用
estimateFee :: [UTxO] -> Lovelace
estimateFee inputs = 
  let baseFee = 155000  -- 基础费用 0.155 ADA
      perInputFee = 5000   -- 每个输入 0.005 ADA
      inputCount = length inputs
      totalFee = baseFee + (perInputFee * fromIntegral inputCount)
  in Lovelace totalFee

-- | 更精确的费用估算（基于交易大小）
estimateFeeDetailed :: [UTxO] -> [TxOut] -> Lovelace
estimateFeeDetailed inputs outputs =
  let -- 计算交易大小（字节）
      inputSize = length inputs * 180  -- 每个输入约 180 字节
      outputSize = length outputs * 43  -- 每个输出约 43 字节
      baseSize = 14  -- 交易基础大小
      totalSize = baseSize + inputSize + outputSize
      
      -- 费用率：0.000044 ADA/字节
      feeRate = 44 :: Integer
      fee = (feeRate * fromIntegral totalSize) `div` 1000
  in Lovelace (max 155000 fee)  -- 最小费用 0.155 ADA
```

---

## 状态持久化

### 保存和加载状态

```haskell
module Wallet.Storage where

import Control.Exception (catch, IOException)
import Data.Aeson (encodeFile, decodeFileStrict, eitherDecodeFileStrict)
import Data.Time (getCurrentTime)
import System.Directory (createDirectoryIfMissing, doesFileExist, copyFile)
import System.FilePath ((</>))
import qualified Data.Map as Map
import Wallet.Types

-- | 状态文件路径
stateFile :: FilePath -> FilePath
stateFile dataDir = dataDir </> "wallet-state.json"

-- | 备份文件路径
backupFile :: FilePath -> FilePath
backupFile dataDir = dataDir </> "wallet-state.json.bak"

-- | 创建默认状态
defaultState :: IO WalletState
defaultState = do
  now <- getCurrentTime
  return $ WalletState
    { wsAddresses = []
    , wsCache = Map.empty
    , wsLastUpdate = now
    }

-- | 确保数据目录存在
ensureDataDir :: FilePath -> IO ()
ensureDataDir dir = createDirectoryIfMissing True dir

-- | 保存状态
saveState :: FilePath -> WalletState -> IO ()
saveState dataDir state = do
  -- 1. 确保目录存在
  ensureDataDir dataDir
  
  -- 2. 备份旧文件
  let statePath = stateFile dataDir
  let backupPath = backupFile dataDir
  
  exists <- doesFileExist statePath
  when exists $ do
    copyFile statePath backupPath `catch` \(_ :: IOException) -> return ()
  
  -- 3. 保存新状态
  encodeFile statePath state

-- | 加载状态
loadState :: FilePath -> IO (Either String WalletState)
loadState dataDir = do
  let path = stateFile dataDir
  exists <- doesFileExist path
  
  if exists
    then do
      result <- eitherDecodeFileStrict path
      case result of
        Left err -> do
          putStrLn $ "Warning: Failed to load state: " ++ err
          putStrLn "Trying backup file..."
          loadBackup dataDir
        Right state -> return $ Right state
    else do
      -- 文件不存在，返回默认状态
      state <- defaultState
      return $ Right state

-- | 加载备份文件
loadBackup :: FilePath -> IO (Either String WalletState)
loadBackup dataDir = do
  let backupPath = backupFile dataDir
  exists <- doesFileExist backupPath
  
  if exists
    then eitherDecodeFileStrict backupPath
    else Right <$> defaultState
```

---

## 命令行界面

### 命令执行完整实现

```haskell
-- | 执行命令
runCommand :: Config -> Command -> IO ()
runCommand config cmd = case cmd of
  Help -> showHelp
  
  Version -> putStrLn "Cardano Wallet Tool v0.1.0"
  
  Generate mlabel -> do
    -- 1. 加载状态
    stateResult <- Storage.loadState (cfgDataDir config)
    state <- case stateResult of
      Left err -> do
        putStrLn $ "Warning: " ++ err
        Storage.defaultState
      Right s -> return s
    
    -- 2. 生成新地址
    addr <- Address.generateAddress
    now <- getCurrentTime
    
    let addrInfo = AddressInfo
          { aiAddress = addr
          , aiLabel = mlabel
          , aiCreated = now
          }
    
    -- 3. 添加到状态
    let newState = state { wsAddresses = Address.addAddress addrInfo (wsAddresses state) }
    
    -- 4. 保存状态
    Storage.saveState (cfgDataDir config) newState
    
    -- 5. 显示结果
    putStrLn $ "✓ Generated new address:"
    putStrLn $ "  " ++ getAddress addr
    case mlabel of
      Just label -> putStrLn $ "  Label: " ++ label
      Nothing -> return ()
  
  List -> do
    -- 加载并显示所有地址
    stateResult <- Storage.loadState (cfgDataDir config)
    case stateResult of
      Left err -> putStrLn $ "Error: " ++ err
      Right state -> do
        let addrs = wsAddresses state
        if null addrs
          then putStrLn "No addresses found. Generate one with: wallet-tool generate"
          else do
            putStrLn $ "Found " ++ show (length addrs) ++ " address(es):\n"
            putStrLn "  Address                                     | Label      | Created"
            putStrLn "  " ++ replicate 70 '-'
            mapM_ displayAddressInfo addrs
  
  Balance addr -> do
    putStrLn "Querying balance..."
    result <- Balance.queryBalance config addr
    case result of
      Left err -> putStrLn $ "✗ Error: " ++ show err
      Right balance -> do
        putStrLn $ "✓ Balance: " ++ Balance.formatBalance balance
  
  UTxOs addr -> do
    putStrLn "Querying UTxOs..."
    queryAndDisplayUTxOs config addr
  
  Send fromAddr toAddr amt -> do
    let amountLovelace = Lovelace (round $ amt * 1000000)
    
    putStrLn $ "Building transaction:"
    putStrLn $ "  From:   " ++ Address.formatAddress fromAddr
    putStrLn $ "  To:     " ++ Address.formatAddress toAddr
    putStrLn $ "  Amount: " ++ show amt ++ " ADA"
    putStrLn ""
    
    -- 1. 查询 UTxOs
    putStrLn "1. Querying available UTxOs..."
    utxosResult <- runExceptT $ API.queryUTxOs config fromAddr
    case utxosResult of
      Left err -> putStrLn $ "✗ Error: " ++ show err
      Right utxos -> do
        putStrLn $ "   Found " ++ show (length utxos) ++ " UTxOs"
        
        -- 2. 构建交易
        putStrLn "2. Building transaction..."
        case Tx.buildTransaction fromAddr toAddr amountLovelace utxos of
          Left err -> putStrLn $ "✗ Error: " ++ show err
          Right tx -> do
            putStrLn "   ✓ Transaction built successfully"
            putStrLn ""
            
            -- 3. 显示交易详情
            putStrLn "Transaction details:"
            putStrLn $ "  Inputs:  " ++ show (length $ txInputs tx)
            putStrLn $ "  Outputs: " ++ show (length $ txOutputs tx)
            putStrLn $ "  Fee:     " ++ Balance.formatBalance (txFee tx)
            putStrLn ""
            
            -- 4. 保存交易
            putStrLn "3. Saving transaction..."
            txPath <- Tx.saveTransaction tx
            putStrLn $ "   ✓ Saved to: " ++ txPath
            putStrLn ""
            putStrLn "NOTE: This is a simulated transaction."
            putStrLn "To submit to the blockchain, you would need to sign it with your private key."

-- | 显示地址信息
displayAddressInfo :: AddressInfo -> IO ()
displayAddressInfo info = do
  let addr = Address.formatAddress (aiAddress info)
  let label = maybe "-" id (aiLabel info)
  let created = formatTime defaultTimeLocale "%Y-%m-%d %H:%M" (aiCreated info)
  putStrLn $ "  " ++ addr ++ " | " ++ label ++ " | " ++ created
```

---

## 💡 实现技巧和最佳实践

### 1. 错误处理

使用 `ExceptT` monad transformer 统一处理错误：

```haskell
type WalletM = ExceptT WalletError IO

-- 使用示例
doSomething :: WalletM Result
doSomething = do
  value <- liftIO someIOAction
  when (invalid value) $ throwError (ValidationError "Invalid value")
  return processedValue
```

### 2. 日志和调试

```haskell
-- 简单的日志函数
logInfo :: String -> IO ()
logInfo msg = putStrLn $ "[INFO] " ++ msg

logError :: String -> IO ()
logError msg = putStrLn $ "[ERROR] " ++ msg

-- 调试模式
debug :: Bool -> String -> IO ()
debug debugMode msg = when debugMode $ putStrLn $ "[DEBUG] " ++ msg
```

### 3. 配置管理

```haskell
-- 从环境变量或配置文件加载
loadConfig :: IO Config
loadConfig = do
  apiKey <- lookupEnv "BLOCKFROST_API_KEY"
  case apiKey of
    Just key -> return $ Config key defaultEndpoint defaultDataDir
    Nothing -> do
      putStrLn "Warning: BLOCKFROST_API_KEY not set"
      return defaultConfig
```

### 4. 用户体验

```haskell
-- 显示进度
withProgress :: String -> IO a -> IO a
withProgress msg action = do
  putStr $ msg ++ "... "
  result <- action
  putStrLn "✓"
  return result

-- 确认提示
confirm :: String -> IO Bool
confirm msg = do
  putStr $ msg ++ " (y/n): "
  response <- getLine
  return $ response `elem` ["y", "Y", "yes", "Yes"]
```

---

## 🔍 测试建议

### 单元测试示例

```haskell
spec :: Spec
spec = do
  describe "Address operations" $ do
    it "generates valid testnet addresses" $ do
      addr <- generateAddress
      validateAddress (getAddress addr) `shouldSatisfy` isRight
    
    it "formats addresses correctly" $ do
      let addr = Address "addr_test1q" ++ replicate 50 'a'
      formatAddress addr `shouldBe` "addr_test1q...aaaaaa"
  
  describe "UTxO selection" $ do
    it "selects sufficient UTxOs" $ do
      let utxos = [UTxO ... (Lovelace 1000000), UTxO ... (Lovelace 2000000)]
      let result = selectInputs (Lovelace 1500000) utxos
      result `shouldSatisfy` isRight
    
    it "fails when insufficient funds" $ do
      let utxos = [UTxO ... (Lovelace 1000000)]
      let result = selectInputs (Lovelace 2000000) utxos
      result `shouldBe` Left InsufficientFunds
```

---

## 📚 相关资源

- [Cardano 文档](https://docs.cardano.org)
- [Blockfrost API 文档](https://docs.blockfrost.io)
- [req 库文档](https://hackage.haskell.org/package/req)
- [aeson 库文档](https://hackage.haskell.org/package/aeson)

---

**注意**: 这些实现是教学参考，生产环境需要更完善的错误处理、安全检查和性能优化。
