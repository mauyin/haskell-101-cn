{- |
Week 7 - 练习: Blockfrost API 查询
===================================

本练习涵盖：
- 使用 req 库发送 HTTP 请求
- 解析 Blockfrost API 响应
- 错误处理和重试

前置条件：
- 路径 B: 注册 Blockfrost 并获取 API Key
- 或路径 A: 使用示例数据模拟

如何使用：
1. 设置 API Key (如果使用真实 API)
2. 完成每个 TODO
3. 在 GHCi 中测试
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Week07API where

import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as BS8
import Data.Text (Text)
import GHC.Generics
import Control.Monad.IO.Class (liftIO)
import Control.Exception (try, SomeException)

-- ============================================================================
-- API 配置
-- ============================================================================

-- | Blockfrost 配置
data BlockfrostConfig = BlockfrostConfig
  { apiKey  :: Text
  , isTestnet :: Bool
  } deriving (Show)

-- 创建测试网配置
testnetConfig :: Text -> BlockfrostConfig
testnetConfig key = BlockfrostConfig key True

-- 创建主网配置
mainnetConfig :: Text -> BlockfrostConfig
mainnetConfig key = BlockfrostConfig key False

-- API 基础 URL
apiBaseUrl :: BlockfrostConfig -> Url 'Https
apiBaseUrl config
  | isTestnet config = https "cardano-testnet.blockfrost.io"
  | otherwise = https "cardano-mainnet.blockfrost.io"


-- ============================================================================
-- Exercise Set 3: Blockfrost API (5 题)
-- ============================================================================

-- 练习 3.1: 查询地址余额
-- |
-- 地址信息数据类型
data AddressInfo = AddressInfo
  { address       :: Text
  , amount        :: [AmountUnit]
  , stake_address :: Maybe Text
  , type_         :: Text
  , script        :: Bool
  } deriving (Show, Generic)

instance FromJSON AddressInfo where
  parseJSON = withObject "AddressInfo" $ \v -> AddressInfo
    <$> v .: "address"
    <$> v .: "amount"
    <$> v .:? "stake_address"
    <$> v .: "type"
    <$> v .: "script"

data AmountUnit = AmountUnit
  { unit     :: Text      -- "lovelace" 或 PolicyId.AssetName
  , quantity :: Text      -- 数量（字符串形式）
  } deriving (Show, Generic, FromJSON)

-- TODO: 查询地址信息
queryAddressInfo 
  :: BlockfrostConfig 
  -> Text           -- 地址
  -> IO (Either String AddressInfo)
queryAddressInfo config addr = undefined
-- 提示:
-- 1. 构建 URL: /api/v0/addresses/{address}
-- 2. 使用 req GET
-- 3. 添加 header "project_id" apiKey
-- 4. 解析响应为 AddressInfo

-- TODO: 查询地址余额（只返回 Lovelace）
queryAddressBalance :: BlockfrostConfig -> Text -> IO (Either String Integer)
queryAddressBalance config addr = undefined
-- 提示:
-- 1. 调用 queryAddressInfo
-- 2. 从 amount 中找到 unit == "lovelace"
-- 3. 解析 quantity 为 Integer

-- TODO: 格式化显示余额
displayBalance :: Integer -> String
displayBalance lovelace = undefined
-- 提示: show (fromIntegral lovelace / 1000000) ++ " ADA"


-- 练习 3.2: 获取 UTxO 列表
-- |
-- UTxO 数据类型
data UTxO = UTxO
  { tx_hash   :: Text
  , tx_index  :: Int
  , output_index :: Int
  , amount    :: [AmountUnit]
  , block     :: Text
  , data_hash :: Maybe Text
  } deriving (Show, Generic, FromJSON)

-- TODO: 查询 UTxOs
queryUTxOs 
  :: BlockfrostConfig
  -> Text           -- 地址
  -> IO (Either String [UTxO])
queryUTxOs config addr = undefined
-- 提示:
-- 1. URL: /api/v0/addresses/{address}/utxos
-- 2. 类似 queryAddressInfo
-- 3. 响应是数组

-- TODO: 显示 UTxO 列表
displayUTxOs :: [UTxO] -> String
displayUTxOs utxos = undefined
-- 提示:
-- 1. 遍历 UTxOs
-- 2. 显示 tx_hash, tx_index, amount
-- 3. 美化格式


-- 练习 3.3: 查询交易历史
-- |
-- 交易历史数据类型
data TxHistory = TxHistory
  { tx_hash       :: Text
  , tx_index      :: Int
  , block_height  :: Int
  , block_time    :: Int
  } deriving (Show, Generic, FromJSON)

-- TODO: 查询交易历史（最近10笔）
queryRecentTransactions 
  :: BlockfrostConfig
  -> Text           -- 地址
  -> IO (Either String [TxHistory])
queryRecentTransactions config addr = undefined
-- 提示:
-- URL: /api/v0/addresses/{address}/transactions
-- 可以添加查询参数: ?count=10&order=desc


-- 练习 3.4: 查询区块信息
-- |
-- 区块信息数据类型
data BlockInfo = BlockInfo
  { blockHeight     :: Int
  , blockHash       :: Text
  , blockTime       :: Int
  , blockTxCount    :: Int
  , blockSlot       :: Int
  , blockEpoch      :: Int
  } deriving (Show, Generic)

instance FromJSON BlockInfo where
  parseJSON = withObject "BlockInfo" $ \v -> BlockInfo
    <$> v .: "height"
    <$> v .: "hash"
    <$> v .: "time"
    <$> v .: "tx_count"
    <$> v .: "slot"
    <$> v .: "epoch"

-- TODO: 查询最新区块
queryLatestBlock :: BlockfrostConfig -> IO (Either String BlockInfo)
queryLatestBlock config = undefined
-- 提示:
-- URL: /api/v0/blocks/latest


-- 练习 3.5: 错误处理
-- |
-- API 错误类型
data APIError
  = NetworkError String
  | HTTPError Int String
  | ParseError String
  | RateLimitError
  deriving (Show, Eq)

-- TODO: 带错误处理的 API 请求
safeAPIRequest 
  :: FromJSON a
  => BlockfrostConfig
  -> Text            -- 端点路径 (如 "blocks/latest")
  -> IO (Either APIError a)
safeAPIRequest config endpoint = undefined
-- 提示:
-- 1. 使用 try 捕获异常
-- 2. 检查 HTTP 状态码
-- 3. 处理 429 (Rate Limit)
-- 4. 解析响应

-- TODO: 带重试的请求
requestWithRetry 
  :: FromJSON a
  => Int               -- 最大重试次数
  -> BlockfrostConfig
  -> Text
  -> IO (Either APIError a)
requestWithRetry maxRetries config endpoint = undefined
-- 提示:
-- 1. 调用 safeAPIRequest
-- 2. 如果失败且重试次数未用完，递归调用
-- 3. 可以添加延迟 (threadDelay)


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- 构建完整的 API 路径
buildApiPath :: Text -> [Text]
buildApiPath endpoint = ["api", "v0"] ++ T.splitOn "/" endpoint

-- 发送 GET 请求（基础版）
simpleGet 
  :: FromJSON a
  => BlockfrostConfig
  -> Text
  -> IO (JsonResponse a)
simpleGet config endpoint = runReq defaultHttpConfig $ do
  let url = foldl (/:) (apiBaseUrl config) (buildApiPath endpoint)
  req GET url NoReqBody jsonResponse 
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))


-- ============================================================================
-- 测试和示例
-- ============================================================================

-- 测试配置（使用你的 API Key）
testConfig :: BlockfrostConfig
testConfig = testnetConfig "testnetXXXXXXXXXXXXXXXX"
-- 注意：替换为你自己的 API Key！

-- 测试地址（Cardano testnet）
testAddress :: Text
testAddress = "addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp"

-- 测试：查询余额
testQueryBalance :: IO ()
testQueryBalance = do
  putStrLn "=== 测试 3.1: 查询地址余额 ==="
  result <- queryAddressBalance testConfig testAddress
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right balance -> do
      putStrLn $ "Address: " ++ T.unpack testAddress
      putStrLn $ "Balance: " ++ displayBalance balance

-- 测试：查询 UTxOs
testQueryUTxOs :: IO ()
testQueryUTxOs = do
  putStrLn "\n=== 测试 3.2: 查询 UTxOs ==="
  result <- queryUTxOs testConfig testAddress
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right utxos -> do
      putStrLn $ "UTxO count: " ++ show (length utxos)
      putStrLn $ displayUTxOs utxos

-- 测试：查询交易历史
testQueryTransactions :: IO ()
testQueryTransactions = do
  putStrLn "\n=== 测试 3.3: 查询交易历史 ==="
  result <- queryRecentTransactions testConfig testAddress
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right txs -> do
      putStrLn $ "Recent transactions: " ++ show (length txs)
      mapM_ (\tx -> putStrLn $ "  " ++ T.unpack (tx_hash tx)) 
            (take 5 txs)

-- 测试：查询最新区块
testQueryBlock :: IO ()
testQueryBlock = do
  putStrLn "\n=== 测试 3.4: 查询最新区块 ==="
  result <- queryLatestBlock testConfig
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right block -> do
      putStrLn $ "Block height: " ++ show (blockHeight block)
      putStrLn $ "Block hash: " ++ T.unpack (blockHash block)
      putStrLn $ "Tx count: " ++ show (blockTxCount block)

-- 运行所有 API 测试
runAPITests :: IO ()
runAPITests = do
  putStrLn "注意：需要设置有效的 Blockfrost API Key"
  putStrLn "或使用路径 A（示例数据）完成练习\n"
  
  testQueryBalance
  testQueryUTxOs
  testQueryTransactions
  testQueryBlock
  
  putStrLn "\n完成所有 API 测试！"


-- ============================================================================
-- 路径 A: 使用示例数据（不需要 API）
-- ============================================================================

-- | 从本地文件模拟 API 响应
mockQueryAddressInfo :: Text -> IO (Either String AddressInfo)
mockQueryAddressInfo addr = do
  content <- BSL.readFile "sample-data/address-info.json"
  return $ eitherDecode content

mockQueryUTxOs :: Text -> IO (Either String [UTxO])
mockQueryUTxOs addr = do
  content <- BSL.readFile "sample-data/utxos.json"
  return $ eitherDecode content

-- 使用模拟数据进行测试
testWithMockData :: IO ()
testWithMockData = do
  putStrLn "=== 使用示例数据测试 ==="
  
  -- 测试地址信息
  addrResult <- mockQueryAddressInfo testAddress
  case addrResult of
    Left err -> putStrLn $ "地址查询错误: " ++ err
    Right info -> do
      putStrLn $ "Address: " ++ T.unpack (address info)
      putStrLn $ "Type: " ++ T.unpack (type_ info)
  
  -- 测试 UTxOs
  utxoResult <- mockQueryUTxOs testAddress
  case utxoResult of
    Left err -> putStrLn $ "UTxO 查询错误: " ++ err
    Right utxos -> do
      putStrLn $ "\nUTxO count: " ++ show (length utxos)

{-
使用说明：

路径 A（使用示例数据）：
ghci> :load Week07API.hs
ghci> testWithMockData

路径 B（使用 Blockfrost API）：
1. 注册 https://blockfrost.io
2. 获取 testnet API key
3. 修改 testConfig 中的 apiKey
4. ghci> runAPITests

注意事项：
- Blockfrost 免费额度：50,000 请求/天
- 请求速率限制：10 请求/秒
- 建议先用示例数据测试，确保代码正确后再用真实 API

记得完成所有 TODO！
-}

