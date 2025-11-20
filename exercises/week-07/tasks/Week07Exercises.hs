{- |
Week 7 - 练习: Cardano 简介 + Haskell 实践
=========================================

本练习涵盖：
- JSON 解析 (Cardano 交易)
- 地址操作和验证
- 交易构建（模拟）

依赖库：
本文件需要以下库：
- aeson: JSON 解析 (cabal install aeson)
- text: 文本处理 (cabal install text)
- bytestring: 字节串处理 (cabal install bytestring)

或使用项目的 .cabal 文件自动安装：
  cd balance-checker/  # 或 tx-explorer/
  cabal build

如何使用：
1. 安装依赖（见上）
2. 完成每个 TODO
3. 在 GHCi 中测试：ghci> :load Week07Exercises.hs
4. 运行测试函数验证实现
5. 对照 solutions/ 中的参考答案
-}

{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Week07Exercises where

import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString as BS
import Data.Text (Text)
import qualified Data.Text as T
import GHC.Generics
import Data.List (isPrefixOf)
import Data.Char (isAlphaNum)

-- ============================================================================
-- Exercise Set 1: JSON 解析 (5 题)
-- ============================================================================

-- 练习 1.1: 解析简单交易
-- |
-- 定义简单交易数据类型并解析
data SimpleTx = SimpleTx
  { txId    :: String
  , txFee   :: Integer
  , txValid :: Bool
  } deriving (Show, Eq, Generic)

-- TODO: 实现 FromJSON 实例
instance FromJSON SimpleTx where
  parseJSON = undefined
  -- 提示: 使用 withObject 和 (.:) 操作符

-- TODO: 从文件解析简单交易
parseSimpleTx :: FilePath -> IO (Either String SimpleTx)
parseSimpleTx path = undefined
-- 提示:
-- 1. 使用 BSL.readFile 读取文件
-- 2. 使用 eitherDecode 解析 JSON


-- 练习 1.2: 提取交易输入
-- |
-- 定义交易输入类型
data TxInput = TxInput
  { inputTxId  :: String
  , inputIndex :: Int
  } deriving (Show, Eq, Generic)

instance FromJSON TxInput where
  parseJSON = withObject "TxInput" $ \v -> TxInput
    <$> v .: "txId"
    <$> v .: "txIndex"

-- | 完整交易结构（简化）
data Transaction = Transaction
  { transactionId   :: String
  , transactionBody :: TxBody
  } deriving (Show, Eq, Generic)

data TxBody = TxBody
  { inputs  :: [TxInput]
  , outputs :: [TxOutput]
  , fee     :: Integer
  , ttl     :: Maybe Integer
  } deriving (Show, Eq, Generic)

instance FromJSON Transaction where
  parseJSON = withObject "Transaction" $ \v -> Transaction
    <$> v .: "id"
    <$> v .: "body"

instance FromJSON TxBody where
  parseJSON = withObject "TxBody" $ \v -> TxBody
    <$> v .: "inputs"
    <$> v .: "outputs"
    <$> v .: "fee"
    <$> v .:? "ttl"

-- TODO: 提取交易的所有输入
extractInputs :: FilePath -> IO (Either String [TxInput])
extractInputs path = undefined
-- 提示:
-- 1. 解析 Transaction
-- 2. 提取 transactionBody 的 inputs


-- 练习 1.3: 解析输出和金额
-- |
-- 交易输出类型
data TxOutput = TxOutput
  { outputAddress :: String
  , outputValue   :: TxValue
  } deriving (Show, Eq, Generic)

data TxValue = TxValue
  { lovelace :: Integer
  } deriving (Show, Eq, Generic)

instance FromJSON TxOutput where
  parseJSON = withObject "TxOutput" $ \v -> TxOutput
    <$> v .: "address"
    <$> v .: "value"

instance FromJSON TxValue where
  parseJSON = withObject "TxValue" $ \v -> TxValue
    <$> v .: "lovelace"

-- TODO: 提取所有输出
extractOutputs :: FilePath -> IO (Either String [TxOutput])
extractOutputs path = undefined
-- 提示: 类似 extractInputs

-- TODO: 计算总输出金额
totalOutputValue :: [TxOutput] -> Integer
totalOutputValue = undefined
-- 提示: sum $ map (lovelace . outputValue) outputs


-- 练习 1.4: 解析元数据
-- |
-- 元数据类型（简化版）
data TxMetadata = TxMetadata
  { metadataLabel :: Integer
  , metadataValue :: Value  -- aeson 的 Value 类型
  } deriving (Show, Eq)

-- | 带元数据的交易
data TransactionWithMeta = TransactionWithMeta
  { txId       :: String
  , txBody     :: TxBody
  , txMetadata :: Maybe Object  -- JSON 对象
  } deriving (Show, Eq, Generic)

instance FromJSON TransactionWithMeta where
  parseJSON = withObject "TransactionWithMeta" $ \v -> TransactionWithMeta
    <$> v .: "id"
    <$> v .: "body"
    <$> v .:? "metadata"

-- TODO: 提取元数据（如果存在）
extractMetadata :: FilePath -> IO (Either String (Maybe Object))
extractMetadata path = undefined
-- 提示:
-- 1. 解析 TransactionWithMeta
-- 2. 返回 txMetadata 字段


-- 练习 1.5: 完整交易摘要
-- |
-- 交易摘要类型
data TxSummary = TxSummary
  { summaryId          :: String
  , summaryInputCount  :: Int
  , summaryOutputCount :: Int
  , summaryTotalInput  :: Integer  -- 注意: 需要从 UTxO 集合查询
  , summaryTotalOutput :: Integer
  , summaryFee         :: Integer
  } deriving (Show, Eq)

-- TODO: 生成交易摘要
generateSummary :: FilePath -> IO (Either String TxSummary)
generateSummary path = undefined
-- 提示:
-- 1. 解析交易
-- 2. 提取 inputs, outputs, fee
-- 3. 计算总数
-- 4. 注意: summaryTotalInput 在真实场景需要查询 UTxO
--    这里可以简化为 0 或者从其他文件读取

-- TODO: 美化显示摘要
displaySummary :: TxSummary -> String
displaySummary summary = undefined
-- 提示: 使用 unlines 和字符串插值
-- 格式参考:
-- === Transaction Summary ===
-- ID: ...
-- Inputs: N
-- 等等


-- ============================================================================
-- Exercise Set 2: 地址操作 (5 题)
-- ============================================================================

-- 练习 2.1: 地址类型识别
-- |
-- 地址类型
data AddressType 
  = MainnetPayment
  | MainnetScript
  | TestnetPayment
  | TestnetScript
  deriving (Show, Eq)

-- TODO: 识别地址类型
identifyAddressType :: String -> Maybe AddressType
identifyAddressType addr = undefined
-- 提示:
-- - addr1q... = MainnetPayment
-- - addr1w... = MainnetScript
-- - addr_test1q... = TestnetPayment
-- - addr_test1w... = TestnetScript


-- 练习 2.2: 验证地址
-- |
-- 基本地址验证
-- TODO: 验证地址格式
validateAddress :: String -> Bool
validateAddress addr = undefined
-- 提示:
-- 1. 检查前缀 (addr1 或 addr_test1)
-- 2. 检查长度 (通常 > 50 字符)
-- 3. 检查字符集 (Bech32: 0-9, a-z, 不含 1, b, i, o)

-- TODO: 详细验证（返回错误信息）
validateAddressDetailed :: String -> Either String ()
validateAddressDetailed addr = undefined
-- 提示: 逐步检查，返回具体错误


-- 练习 2.3: 提取质押地址
-- |
-- 从支付地址中提取质押部分（简化版）
-- TODO: 提取质押地址
extractStakeAddress :: String -> Maybe String
extractStakeAddress addr = undefined
-- 提示:
-- 实际实现需要解码 Bech32 和解析地址结构
-- 这里可以简化为: 如果是主网/测试网支付地址，返回示例质押地址
-- 在真实场景需要使用 cardano-api 库


-- 练习 2.4: 地址摘要
-- |
-- 地址摘要
data AddressSummary = AddressSummary
  { addrNetwork :: String    -- "mainnet" 或 "testnet"
  , addrType    :: String    -- "payment" 或 "script"
  , addrShort   :: String    -- 缩短的地址
  , hasStake    :: Bool
  } deriving (Show, Eq)

-- TODO: 生成地址摘要
summarizeAddress :: String -> Either String AddressSummary
summarizeAddress addr = undefined
-- 提示:
-- 1. 使用 identifyAddressType
-- 2. 生成短地址: take 10 addr ++ "..." ++ takeEnd 6 addr
-- 3. 判断是否有质押 (支付地址通常有)


-- 练习 2.5: 批量地址验证
-- |
-- 验证多个地址
-- TODO: 验证地址列表
validateAddresses :: [String] -> [(String, Either String AddressSummary)]
validateAddresses addrs = undefined
-- 提示: map (\addr -> (addr, summarizeAddress addr)) addrs

-- TODO: 生成验证报告
generateValidationReport :: [(String, Either String AddressSummary)] -> String
generateValidationReport results = undefined
-- 提示:
-- 1. 统计成功/失败数量
-- 2. 列出每个地址的状态
-- 3. 美化输出


-- ============================================================================
-- Exercise Set 4: 交易构建（模拟）(5 题)
-- ============================================================================

-- 练习 4.1: 构建简单支付交易
-- |
-- UTxO 数据类型
data UTxO = UTxO
  { utxoTxHash  :: String
  , utxoIndex   :: Int
  , utxoAmount  :: Integer
  , utxoAddress :: String
  } deriving (Show, Eq)

-- | 交易构建结构
data TxBuild = TxBuild
  { buildInputs  :: [TxInput]
  , buildOutputs :: [TxOutput]
  , buildFee     :: Integer
  } deriving (Show, Eq)

-- TODO: 构建简单支付
buildSimplePayment 
  :: [UTxO]        -- 可用的 UTxOs
  -> String        -- 收款地址
  -> Integer       -- 金额（Lovelace）
  -> String        -- 找零地址
  -> Either String TxBuild
buildSimplePayment utxos toAddr amount changeAddr = undefined
-- 提示:
-- 1. 选择足够的 UTxOs (使用 selectUTxOs)
-- 2. 创建支付输出
-- 3. 计算找零
-- 4. 估算费用
-- 5. 调整找零


-- 练习 4.2: 计算最小费用
-- |
-- Cardano 费用参数
feeConstant :: Integer
feeConstant = 155381  -- Lovelace

feePerByte :: Integer
feePerByte = 44       -- Lovelace per byte

-- TODO: 估算交易大小
estimateTxSize :: TxBuild -> Integer
estimateTxSize tx = undefined
-- 提示:
-- 简化公式: 
-- inputSize = length buildInputs * 43
-- outputSize = length buildOutputs * 43
-- overhead = 10
-- total = inputSize + outputSize + overhead

-- TODO: 计算费用
calculateFee :: TxBuild -> Integer
calculateFee tx = undefined
-- 提示: feeConstant + feePerByte * estimateTxSize tx


-- 练习 4.3: 选择 UTxO
-- |
-- UTxO 选择策略

-- TODO: 简单选择策略（贪心）
selectUTxOs :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOs targetAmount utxos = undefined
-- 提示:
-- 1. 按金额从大到小排序
-- 2. 选择 UTxOs 直到总和 >= targetAmount + 估算费用
-- 3. 如果余额不足，返回 Left "Insufficient funds"

-- TODO: 最优选择策略
selectUTxOsOptimal :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOsOptimal targetAmount utxos = undefined
-- 提示: 尝试找到最接近 targetAmount 的组合


-- 练习 4.4: 平衡交易
-- |
-- 交易平衡

-- TODO: 检查交易是否平衡
isBalanced :: TxBuild -> Bool
isBalanced tx = undefined
-- 提示:
-- sum(inputs) == sum(outputs) + fee

-- TODO: 平衡交易（添加找零）
balanceTransaction 
  :: TxBuild
  -> String        -- 找零地址
  -> Either String TxBuild
balanceTransaction tx changeAddr = undefined
-- 提示:
-- 1. 计算 inputSum 和 outputSum
-- 2. change = inputSum - outputSum - fee
-- 3. 如果 change > 0, 添加找零输出
-- 4. 如果 change < 0, 返回错误


-- 练习 4.5: 验证交易
-- |
-- 交易验证

data ValidationError
  = InsufficientFunds
  | NegativeChange
  | InvalidInput String
  | InvalidOutput String
  | FeeError String
  deriving (Show, Eq)

-- TODO: 验证交易
validateTransaction :: TxBuild -> Either ValidationError ()
validateTransaction tx = undefined
-- 提示:
-- 1. 检查 inputs 非空
-- 2. 检查 outputs 非空
-- 3. 检查地址有效
-- 4. 检查余额
-- 5. 检查费用合理

-- TODO: 完整的交易检查
fullTxCheck :: TxBuild -> Either String ()
fullTxCheck tx = undefined
-- 提示: 组合多个检查


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- 辅助：转换 Lovelace 到 ADA
lovelaceToAda :: Integer -> Double
lovelaceToAda lovelace = fromIntegral lovelace / 1000000

-- 辅助：转换 ADA 到 Lovelace
adaToLovelace :: Double -> Integer
adaToLovelace ada = round (ada * 1000000)

-- 辅助：格式化金额
formatAmount :: Integer -> String
formatAmount lovelace = 
  show (lovelaceToAda lovelace) ++ " ADA (" ++ show lovelace ++ " Lovelace)"

-- 辅助：缩短字符串
shortenString :: Int -> Int -> String -> String
shortenString prefixLen suffixLen str
  | length str <= prefixLen + suffixLen = str
  | otherwise = take prefixLen str ++ "..." ++ drop (length str - suffixLen) str


-- ============================================================================
-- 测试数据和测试函数
-- ============================================================================

-- 测试数据：UTxO 集合
sampleUTxOs :: [UTxO]
sampleUTxOs =
  [ UTxO "abc123..." 0 50000000 "addr_test1qz..."
  , UTxO "def456..." 1 30000000 "addr_test1qz..."
  , UTxO "ghi789..." 0 20000000 "addr_test1qz..."
  ]

-- 测试：解析简单交易
testSimpleTx :: IO ()
testSimpleTx = do
  putStrLn "=== 测试 1.1: 解析简单交易 ==="
  result <- parseSimpleTx "sample-data/simple-tx.json"
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right tx -> do
      putStrLn $ "Transaction ID: " ++ txId tx
      putStrLn $ "Fee: " ++ formatAmount (txFee tx)
      putStrLn $ "Valid: " ++ show (txValid tx)

-- 测试：提取输入
testExtractInputs :: IO ()
testExtractInputs = do
  putStrLn "\n=== 测试 1.2: 提取交易输入 ==="
  result <- extractInputs "sample-data/transaction.json"
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right inputs -> do
      putStrLn $ "Input count: " ++ show (length inputs)
      mapM_ (\(i, input) -> 
        putStrLn $ "  Input #" ++ show i ++ ": " 
                ++ inputTxId input ++ "#" ++ show (inputIndex input))
        (zip [0..] inputs)

-- 测试：地址类型识别
testAddressType :: IO ()
testAddressType = do
  putStrLn "\n=== 测试 2.1: 地址类型识别 ==="
  let testAddrs =
        [ "addr1q..."
        , "addr_test1q..."
        , "addr1w..."
        , "invalid"
        ]
  mapM_ (\addr -> 
    putStrLn $ addr ++ " -> " ++ show (identifyAddressType addr))
    testAddrs

-- 测试：交易构建
testBuildPayment :: IO ()
testBuildPayment = do
  putStrLn "\n=== 测试 4.1: 构建支付交易 ==="
  let result = buildSimplePayment 
                 sampleUTxOs 
                 "addr_test1qr..." 
                 60000000 
                 "addr_test1qz..."
  case result of
    Left err -> putStrLn $ "错误: " ++ err
    Right tx -> do
      putStrLn $ "Inputs: " ++ show (length $ buildInputs tx)
      putStrLn $ "Outputs: " ++ show (length $ buildOutputs tx)
      putStrLn $ "Fee: " ++ formatAmount (buildFee tx)
      putStrLn $ "Balanced: " ++ show (isBalanced tx)

-- 运行所有测试
runAllTests :: IO ()
runAllTests = do
  testSimpleTx
  testExtractInputs
  testAddressType
  testBuildPayment
  putStrLn "\n完成所有测试！"

{-
在 GHCi 中测试：

ghci> :load Week07Exercises.hs
ghci> runAllTests

单独测试：
ghci> testSimpleTx
ghci> testAddressType

记得先完成所有 TODO！
-}

