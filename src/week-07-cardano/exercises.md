# Week 7: Cardano 简介 + Haskell 实践 - 练习作业

## 📥 下载练习文件

练习文件位于：`exercises/week-07/`

```bash
cd exercises/week-07/tasks
```

## ⚙️ 环境设置

**重要**：本周练习有三种路径可选，根据你的学习目标选择：

### 路径 A：使用示例数据（推荐初学者）✨

**难度**：★☆☆☆☆  
**所需时间**：2-3 小时  
**优点**：无需任何 Cardano 安装，专注于 Haskell 编程

- ✅ 使用提供的示例 JSON 文件
- ✅ 所有练习都可以完成
- ✅ 学习 JSON 解析和数据处理
- ❌ 不能查询真实区块链

**设置步骤**：
```bash
# 无需特殊设置！直接开始编程
ghci Week07Exercises.hs
```

### 路径 B：使用 Blockfrost API（推荐）🚀

**难度**：★★☆☆☆  
**所需时间**：3-4 小时  
**优点**：查询真实区块链，无需运行节点

- ✅ 查询真实的 Cardano 测试网数据
- ✅ 免费 API（50,000 请求/天）
- ✅ 完整的练习体验
- ❌ 需要注册 Blockfrost 账号

**设置步骤**：
1. 访问 https://blockfrost.io
2. 注册免费账号
3. 创建 Testnet 项目
4. 复制 API Key
5. 在练习中使用

### 路径 C：本地节点（可选，高级）⚡

**难度**：★★★★☆  
**所需时间**：5+ 小时（包括同步时间）  
**优点**：完全控制，学习节点操作

- ✅ 完整的 Cardano 体验
- ✅ 学习 cardano-cli
- ✅ 可以提交真实交易（测试网）
- ❌ 需要同步测试网（~20GB）

**设置步骤**：见 `SETUP-GUIDE.md`

---

## 📋 练习概览

| 练习集 | 难度 | 题目数 | 预计时间 | 路径 |
|--------|------|--------|----------|------|
| Set 1: JSON 解析 | ★☆☆ | 5 | 30分钟 | A/B/C |
| Set 2: 地址操作 | ★★☆ | 5 | 30分钟 | A/B/C |
| Set 3: Blockfrost API | ★★☆ | 5 | 45分钟 | B/C |
| Set 4: 交易构建（模拟） | ★★★ | 5 | 45分钟 | A/B/C |
| Set 5: 项目 | ★★★ | 2 | 2小时 | A/B/C |

**总计**：22 道练习，预计 4-5 小时

---

## Exercise Set 1: JSON 解析 (5 题)

### 学习目标
- 使用 aeson 解析 Cardano 交易 JSON
- 提取交易信息
- 处理嵌套的 JSON 结构

### 前置知识
- Week 5: aeson 库
- Week 6: Maybe/Either 错误处理

### 练习 1.1: 解析简单交易

解析一个简单的 Cardano 交易，提取基本信息。

**任务**：
```haskell
-- 定义交易数据类型
data SimpleTx = SimpleTx
  { txId    :: String
  , txFee   :: Integer
  , txValid :: Bool
  } deriving (Show)

-- TODO: 实现 FromJSON 实例
instance FromJSON SimpleTx where
  parseJSON = ?

-- TODO: 解析文件
parseSimpleTx :: FilePath -> IO (Either String SimpleTx)
parseSimpleTx = ?
```

**测试数据**：`sample-data/simple-tx.json`

**预期输出**：
```
Transaction ID: abc123...
Fee: 170000 Lovelace (0.17 ADA)
Valid: True
```

### 练习 1.2: 提取交易输入

解析交易的输入列表。

**任务**：
```haskell
data TxInput = TxInput
  { inputTxId  :: String
  , inputIndex :: Int
  } deriving (Show)

-- TODO: 解析交易的所有输入
extractInputs :: FilePath -> IO (Either String [TxInput])
extractInputs = ?
```

**测试数据**：`sample-data/transaction.json`

**预期输出**：
```
Input #0: abc123...#0
Input #1: def456...#1
Total inputs: 2
```

### 练习 1.3: 解析输出和金额

解析交易输出，包括地址和金额。

**任务**：
```haskell
data TxOutput = TxOutput
  { outputAddress :: String
  , outputLovelace :: Integer
  } deriving (Show)

-- TODO: 解析所有输出
extractOutputs :: FilePath -> IO (Either String [TxOutput])
extractOutputs = ?

-- TODO: 计算总输出金额
totalOutputValue :: [TxOutput] -> Integer
totalOutputValue = ?
```

### 练习 1.4: 解析元数据

处理交易元数据（如果存在）。

**任务**：
```haskell
data TxMetadata = TxMetadata
  { metadataLabel :: Integer
  , metadataValue :: Value  -- aeson 的 Value 类型
  } deriving (Show)

-- TODO: 提取元数据（可能不存在）
extractMetadata :: FilePath -> IO (Either String (Maybe [TxMetadata]))
extractMetadata = ?
```

**测试数据**：`sample-data/tx-with-metadata.json`

### 练习 1.5: 完整交易摘要

生成交易的完整摘要。

**任务**：
```haskell
data TxSummary = TxSummary
  { summaryId          :: String
  , summaryInputCount  :: Int
  , summaryOutputCount :: Int
  , summaryTotalInput  :: Integer
  , summaryTotalOutput :: Integer
  , summaryFee         :: Integer
  } deriving (Show)

-- TODO: 生成摘要
generateSummary :: FilePath -> IO (Either String TxSummary)
generateSummary = ?

-- TODO: 美化显示
displaySummary :: TxSummary -> String
displaySummary = ?
```

**预期输出**：
```
=== Transaction Summary ===
ID: abc123...
Inputs:  2 UTxOs
Outputs: 2 UTxOs
Total In:  50.000000 ADA
Total Out: 49.830000 ADA
Fee:        0.170000 ADA
Balanced: ✓
```

---

## Exercise Set 2: 地址操作 (5 题)

### 学习目标
- 解析 Cardano 地址
- 验证地址格式
- 提取地址信息

### 练习 2.1: 地址类型识别

识别地址类型（测试网/主网、支付/脚本等）。

**任务**：
```haskell
data AddressType 
  = MainnetPayment
  | MainnetScript
  | TestnetPayment
  | TestnetScript
  deriving (Show, Eq)

-- TODO: 识别地址类型
identifyAddressType :: String -> Maybe AddressType
identifyAddressType = ?
```

**测试用例**：
```haskell
identifyAddressType "addr1q..." == Just MainnetPayment
identifyAddressType "addr_test1q..." == Just TestnetPayment
identifyAddressType "addr1w..." == Just MainnetScript
identifyAddressType "invalid" == Nothing
```

### 练习 2.2: 验证地址

验证地址的 Bech32 格式。

**任务**：
```haskell
-- TODO: 验证地址格式
validateAddress :: String -> Bool
validateAddress = ?

-- TODO: 详细验证（返回错误信息）
validateAddressDetailed :: String -> Either String ()
validateAddressDetailed = ?
```

### 练习 2.3: 提取质押地址

从支付地址中提取质押部分（如果存在）。

**任务**：
```haskell
-- TODO: 提取质押地址
extractStakeAddress :: String -> Maybe String
extractStakeAddress = ?
```

### 练习 2.4: 地址摘要

生成地址的可读摘要。

**任务**：
```haskell
data AddressSummary = AddressSummary
  { addrNetwork :: String    -- "mainnet" 或 "testnet"
  , addrType    :: String    -- "payment" 或 "script"
  , addrShort   :: String    -- 缩短的地址（前8+后6字符）
  , hasStake    :: Bool
  } deriving (Show)

-- TODO: 生成摘要
summarizeAddress :: String -> Either String AddressSummary
summarizeAddress = ?
```

**预期输出**：
```
Address: addr_test1q...abcdef
Network: testnet
Type: payment
Has stake: Yes
Short: addr_tes...abcdef
```

### 练习 2.5: 批量地址验证

验证多个地址并生成报告。

**任务**：
```haskell
-- TODO: 验证地址列表
validateAddresses :: [String] -> [(String, Either String AddressSummary)]
validateAddresses = ?

-- TODO: 生成验证报告
generateValidationReport :: [(String, Either String AddressSummary)] -> String
generateValidationReport = ?
```

---

## Exercise Set 3: Blockfrost API (5 题)

### 学习目标
- 使用 req 库发送 HTTP 请求
- 处理 API 响应
- 错误处理和重试

### 前置条件
- 完成路径 B 的设置（注册 Blockfrost）
- 或使用示例数据模拟

### 练习 3.1: 查询地址余额

查询地址的 ADA 余额。

**任务**：
```haskell
-- TODO: 查询地址信息
queryAddressBalance :: String -> String -> IO (Either String Integer)
queryAddressBalance apiKey address = ?

-- TODO: 格式化显示余额
displayBalance :: Integer -> String
displayBalance lovelace = ?
```

**测试地址**（测试网）：
```
addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp
```

**预期输出**：
```
Address: addr_test1qz...
Balance: 100.523000 ADA (100523000 Lovelace)
```

### 练习 3.2: 获取 UTxO 列表

获取地址的所有 UTxO。

**任务**：
```haskell
data UTxO = UTxO
  { utxoTxHash  :: String
  , utxoIndex   :: Int
  , utxoAmount  :: Integer
  , utxoBlock   :: String
  } deriving (Show)

-- TODO: 查询 UTxOs
queryUTxOs :: String -> String -> IO (Either String [UTxO])
queryUTxOs apiKey address = ?

-- TODO: 显示 UTxO 列表
displayUTxOs :: [UTxO] -> String
displayUTxOs = ?
```

### 练习 3.3: 查询交易历史

获取地址的交易历史。

**任务**：
```haskell
data TxHistory = TxHistory
  { txHash       :: String
  , txBlockTime  :: Integer
  , txBlockHeight :: Int
  } deriving (Show)

-- TODO: 查询交易历史（最近10笔）
queryRecentTransactions :: String -> String -> IO (Either String [TxHistory])
queryRecentTransactions apiKey address = ?
```

### 练习 3.4: 查询区块信息

查询最新区块信息。

**任务**：
```haskell
data BlockInfo = BlockInfo
  { blockHeight :: Int
  , blockHash   :: String
  , blockTime   :: Integer
  , blockTxCount :: Int
  } deriving (Show)

-- TODO: 查询最新区块
queryLatestBlock :: String -> IO (Either String BlockInfo)
queryLatestBlock apiKey = ?
```

### 练习 3.5: 错误处理

实现健壮的 API 错误处理。

**任务**：
```haskell
data APIError
  = NetworkError String
  | HTTPError Int String
  | ParseError String
  | RateLimitError
  deriving (Show)

-- TODO: 带错误处理的 API 请求
safeAPIRequest 
  :: String            -- API Key
  -> String            -- Endpoint
  -> IO (Either APIError Value)
safeAPIRequest = ?

-- TODO: 带重试的请求
requestWithRetry 
  :: Int               -- 最大重试次数
  -> IO (Either APIError Value)
  -> IO (Either APIError Value)
requestWithRetry = ?
```

---

## Exercise Set 4: 交易构建（模拟）(5 题)

### 学习目标
- 理解交易构建流程
- 计算交易费用
- 平衡交易

### 注意
这部分是**模拟**交易构建，不会提交到区块链。

### 练习 4.1: 构建简单支付交易

构建基本的支付交易结构。

**任务**：
```haskell
-- 简化的交易结构
data TxBuild = TxBuild
  { buildInputs  :: [TxInput]
  , buildOutputs :: [TxOutput]
  , buildFee     :: Integer
  } deriving (Show)

-- TODO: 构建简单支付
buildSimplePayment 
  :: [UTxO]        -- 可用的 UTxOs
  -> String        -- 收款地址
  -> Integer       -- 金额（Lovelace）
  -> String        -- 找零地址
  -> Either String TxBuild
buildSimplePayment = ?
```

### 练习 4.2: 计算最小费用

根据交易大小计算费用。

**任务**：
```haskell
-- Cardano 费用参数
feeConstant :: Integer
feeConstant = 155381  -- Lovelace

feePerByte :: Integer
feePerByte = 44       -- Lovelace per byte

-- TODO: 估算交易大小
estimateTxSize :: TxBuild -> Integer
estimateTxSize = ?

-- TODO: 计算费用
calculateFee :: TxBuild -> Integer
calculateFee = ?
```

### 练习 4.3: 选择 UTxO

实现 UTxO 选择算法。

**任务**：
```haskell
-- TODO: 简单选择策略（贪心）
selectUTxOs :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOs targetAmount utxos = ?

-- TODO: 最优选择策略（尽量减少找零）
selectUTxOsOptimal :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOsOptimal = ?
```

### 练习 4.4: 平衡交易

确保交易平衡（输入 = 输出 + 费用）。

**任务**：
```haskell
-- TODO: 检查交易是否平衡
isBalanced :: TxBuild -> Bool
isBalanced = ?

-- TODO: 平衡交易（添加找零）
balanceTransaction 
  :: TxBuild
  -> String        -- 找零地址
  -> Either String TxBuild
balanceTransaction = ?
```

### 练习 4.5: 验证交易

验证交易的有效性。

**任务**：
```haskell
data ValidationError
  = InsufficientFunds
  | NegativeChange
  | InvalidInput String
  | InvalidOutput String
  deriving (Show, Eq)

-- TODO: 验证交易
validateTransaction :: TxBuild -> Either ValidationError ()
validateTransaction = ?

-- TODO: 完整的交易检查
fullTxCheck :: TxBuild -> Either String ()
fullTxCheck = ?
```

---

## Exercise Set 5: 实战项目 (2 个)

### 项目 1: 地址余额查询器 ⭐⭐⭐

构建一个命令行工具，批量查询多个地址的余额。

#### 功能需求

1. **读取地址列表**
   - 从文件或命令行参数读取
   - 支持一次查询多个地址

2. **查询余额**
   - 使用 Blockfrost API 查询
   - 或使用示例数据（路径 A）

3. **显示结果**
   - 格式化的表格输出
   - 显示总计

4. **错误处理**
   - 无效地址警告
   - API 错误处理
   - 重试机制

5. **缓存**
   - 缓存查询结果避免重复请求
   - 支持刷新

#### 项目结构

```
balance-checker/
├── balance-checker.cabal
├── src/
│   ├── API.hs           -- API 调用
│   ├── Cache.hs         -- 缓存实现
│   ├── Display.hs       -- 格式化输出
│   └── Types.hs         -- 数据类型
├── app/
│   └── Main.hs          -- 主程序
└── README.md
```

#### 使用示例

```bash
# 查询单个地址
$ cabal run balance-checker -- addr_test1q...

Address: addr_test1q...
Balance: 100.523 ADA
UTxOs: 3

# 查询多个地址
$ cabal run balance-checker -- --file addresses.txt

╔════════════════════════════════════════════════╤════════════╗
║ Address                                        │ Balance    ║
╠════════════════════════════════════════════════╪════════════╣
║ addr_test1qz...                                │ 100.52 ADA ║
║ addr_test1qq...                                │  50.00 ADA ║
║ addr_test1qp...                                │   0.00 ADA ║
╠════════════════════════════════════════════════╪════════════╣
║ TOTAL                                          │ 150.52 ADA ║
╚════════════════════════════════════════════════╧════════════╝

# 使用缓存
$ cabal run balance-checker -- addr_test1q... --cached
Using cached data...
```

#### 完成标准

- [ ] 支持路径 A（示例数据）
- [ ] 支持路径 B（Blockfrost API）
- [ ] 命令行参数解析
- [ ] 格式化表格输出
- [ ] 错误处理
- [ ] 缓存机制（可选）
- [ ] 测试覆盖（可选）

#### 时间估计

- 基本功能：1 小时
- 完整功能：2 小时
- 测试和优化：+30 分钟

---

### 项目 2: 交易浏览器 ⭐⭐⭐

构建一个交易查看器，美观地显示交易详情。

#### 功能需求

1. **解析交易**
   - 从文件或 API 加载
   - 完整解析所有字段

2. **美化显示**
   - 输入/输出的树形结构
   - 颜色高亮（可选）
   - 金额格式化

3. **交易验证**
   - 检查余额
   - 验证签名（仅检查存在性）

4. **导出**
   - JSON 格式
   - 人类可读格式
   - CSV 格式（可选）

5. **交互模式**
   - 命令行交互界面
   - 查看详细信息

#### 项目结构

```
tx-explorer/
├── tx-explorer.cabal
├── src/
│   ├── Parser.hs        -- 交易解析
│   ├── Validator.hs     -- 交易验证
│   ├── Display.hs       -- 美化显示
│   ├── Export.hs        -- 导出功能
│   └── Types.hs         -- 数据类型
├── app/
│   └── Main.hs
├── test-data/
│   └── sample-tx.json
└── README.md
```

#### 使用示例

```bash
# 显示交易
$ cabal run tx-explorer -- transaction.json

╔═══════════════════════════════════════════════════════╗
║           Transaction Details                         ║
╠═══════════════════════════════════════════════════════╣
║ ID: abc123def456...                                   ║
║ Block: 8234567                                        ║
║ Time: 2025-01-15 10:30:45 UTC                         ║
╚═══════════════════════════════════════════════════════╝

Inputs (2):
  ├─ abc123...#0
  │  ├─ Address: addr_test1qz...
  │  └─ Amount: 50.000000 ADA
  │
  └─ def456...#1
     ├─ Address: addr_test1qq...
     └─ Amount: 30.000000 ADA

Outputs (2):
  ├─ Output #0
  │  ├─ Address: addr_test1qp...
  │  └─ Amount: 60.000000 ADA
  │
  └─ Output #1 (Change)
     ├─ Address: addr_test1qz...
     └─ Amount: 19.830000 ADA

Summary:
  Total Input:  80.000000 ADA
  Total Output: 79.830000 ADA
  Fee:           0.170000 ADA
  Status: ✓ Balanced

# 导出为 CSV
$ cabal run tx-explorer -- transaction.json --export csv

# 交互模式
$ cabal run tx-explorer -- --interactive
> load transaction.json
> show inputs
> show outputs
> validate
> export json output.json
> quit
```

#### 完成标准

- [ ] 解析完整交易 JSON
- [ ] 美化显示（树形结构）
- [ ] 验证交易平衡
- [ ] 至少一种导出格式
- [ ] 错误处理
- [ ] 交互模式（可选）
- [ ] 颜色支持（可选）

#### 时间估计

- 基本功能：1 小时
- 美化输出：30 分钟
- 导出功能：30 分钟
- 交互模式：+1 小时（可选）

---

## Optional Advanced: 真实测试网练习

### 高级练习 1: 设置测试网节点

跟随 `SETUP-GUIDE.md` 中的路径 C，设置本地测试网节点。

### 高级练习 2: 使用 cardano-cli

使用 `cardano-cli` 命令查询区块链：

```bash
# 查询地址余额
cardano-cli query utxo \
  --address addr_test1q... \
  --testnet-magic 1

# 查询协议参数
cardano-cli query protocol-parameters \
  --testnet-magic 1 \
  --out-file params.json
```

### 高级练习 3: 构建并提交交易

构建一个真实的测试网交易并提交：

1. 生成密钥对
2. 获取测试 ADA（水龙头）
3. 构建交易
4. 签名
5. 提交到测试网
6. 验证上链

**警告**：这需要完整的 cardano-node 设置。

---

## 📊 评估标准

### 必做（80 分）

- [ ] 完成 Set 1（JSON 解析）- 20 分
- [ ] 完成 Set 2（地址操作）- 20 分
- [ ] 完成 Set 4（交易构建）- 20 分
- [ ] 完成项目 1 或项目 2 - 20 分

### 推荐（100 分）

- [ ] 完成 Set 3（Blockfrost API）- +10 分
- [ ] 完成两个项目 - +10 分

### 挑战（120 分）

- [ ] 完成高级练习 - +20 分
- [ ] 项目添加额外功能 - +10 分

---

## 💡 学习建议

### 对于初学者

1. **从路径 A 开始**：使用示例数据，专注于 Haskell 编程
2. **按顺序完成**：Set 1 → Set 2 → Set 4 → 项目 1
3. **参考讲义**：遇到困难回顾对应章节
4. **运行示例**：查看 `examples/` 中的完整示例

### 对于进阶者

1. **选择路径 B**：使用 Blockfrost API 体验真实数据
2. **完成所有练习**：包括 Set 3
3. **完成两个项目**：每个项目添加额外功能
4. **编写测试**：使用 Week 6 学到的测试技能

### 对于高级学习者

1. **挑战路径 C**：设置本地节点
2. **完成高级练习**：实际提交交易
3. **深入 cardano-api**：使用真实的 cardano-api 库
4. **创建自己的工具**：基于本周学习的知识

---

## 🔗 资源链接

### 示例数据
- `sample-data/simple-tx.json` - 简单交易
- `sample-data/transaction.json` - 完整交易
- `sample-data/tx-with-metadata.json` - 带元数据的交易
- `sample-data/address-info.json` - 地址信息
- `sample-data/utxos.json` - UTxO 集合

### 参考实现
- `examples/parse-tx-example.hs` - 交易解析示例
- `examples/blockfrost-client.hs` - API 客户端示例
- `examples/address-tools.hs` - 地址工具示例

### 解决方案
- `solutions/Week07Exercises.hs` - 所有练习的参考答案
- `solutions/balance-checker/` - 项目 1 完整实现
- `solutions/tx-explorer/` - 项目 2 完整实现

---

## ❓ 常见问题

### Q: 我必须注册 Blockfrost 吗？

A: 不必！你可以使用路径 A，用示例数据完成所有练习。Blockfrost 是可选的，但能提供更好的学习体验。

### Q: 练习会修改真实区块链吗？

A: 不会！所有练习都是只读的或者是模拟的。即使使用 Blockfrost，也只是查询数据，不会提交任何交易。

### Q: 我需要真正的 ADA 吗？

A: 不需要！如果你选择高级练习（路径 C），可以从测试网水龙头免费获取测试 ADA。

### Q: 项目应该完成到什么程度？

A: 至少实现所有基本功能。额外功能（如缓存、颜色、交互模式）是加分项。

### Q: 练习卡住了怎么办？

A: 
1. 查看讲义对应章节
2. 运行 `examples/` 中的示例代码
3. 参考 `solutions/` 中的答案
4. 在社区论坛提问

---

## 🎯 完成本周练习后

你将能够：

✅ 解析和处理 Cardano 交易数据  
✅ 查询 Cardano 区块链（通过 API）  
✅ 构建实用的 Cardano 命令行工具  
✅ 理解 eUTxO 模型和交易结构  
✅ 应用前几周学到的 Haskell 知识  

**准备好挑战 Week 8 的结课项目了吗？** 🚀

---

**现在开始你的 Cardano Haskell 之旅！祝编码愉快！** 🎉

