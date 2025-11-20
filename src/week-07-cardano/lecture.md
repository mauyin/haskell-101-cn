# Week 7: Cardano 简介 + Haskell 实践 - 详细讲义

## 目录

1. [为什么 Cardano 使用 Haskell](#1-为什么-cardano-使用-haskell)
2. [Cardano 架构概览](#2-cardano-架构概览)
3. [eUTxO 模型](#3-eutxo-模型)
4. [交易解剖](#4-交易解剖)
5. [使用 cardano-api](#5-使用-cardano-api)
6. [用 Haskell 查询 Cardano](#6-用-haskell-查询-cardano)
7. [实用模式](#7-实用模式)

---

## 1. 为什么 Cardano 使用 Haskell

### 1.1 区块链需要什么？

区块链系统有特殊的要求：

1. **正确性**：一个 bug 可能导致资金损失
2. **安全性**：必须抵御各种攻击
3. **可验证性**：代码行为必须可预测
4. **并发性**：处理大量同时交易
5. **持久性**：代码必须长期稳定运行

**传统语言的问题**：
- C/C++：内存安全问题、空指针、缓冲区溢出
- Python/JavaScript：类型不安全、运行时错误
- Java/C#：可变状态、并发难题

### 1.2 函数式编程的优势

Haskell 作为纯函数式语言，天然适合区块链：

#### 纯函数 (Pure Functions)

```haskell
-- 纯函数：相同输入总是产生相同输出
calculateFee :: Integer -> Integer -> Integer
calculateFee inputSum outputSum = inputSum - outputSum

-- 不纯的函数（在 Haskell 中需要 IO 类型标记）
getCurrentTime :: IO UTCTime  -- 明确标记副作用
```

**好处**：
- 函数行为完全可预测
- 容易测试：不需要模拟环境
- 容易推理：看函数签名就知道它做什么

#### 不可变性 (Immutability)

```haskell
-- 数据默认不可变
data Transaction = Transaction
  { txInputs  :: [TxInput]
  , txOutputs :: [TxOutput]
  } deriving (Show, Eq)

-- 创建新交易而不是修改旧交易
addOutput :: TxOutput -> Transaction -> Transaction
addOutput output tx = tx { txOutputs = output : txOutputs tx }
```

**好处**：
- 没有意外的数据修改
- 并发安全（无锁编程）
- 历史记录自然保留

#### 强类型系统 (Strong Type System)

```haskell
-- 类型防止错误
newtype Lovelace = Lovelace Integer  -- Ada 的最小单位
newtype Address = Address ByteString

-- 编译时捕获错误
transfer :: Address -> Address -> Lovelace -> Transaction
transfer from to amount = ...

-- 错误！不能传递 Integer
-- transfer addr1 addr2 1000000  -- 编译错误

-- 正确
transfer addr1 addr2 (Lovelace 1000000)  -- 类型安全
```

**好处**：
- 很多bug在编译时就被捕获
- 重构更安全
- 类型即文档

### 1.3 Haskell 在 Cardano 中的具体应用

#### 正式验证 (Formal Verification)

Haskell 的数学性质使得正式验证更容易：

```haskell
-- 可以数学证明的性质
prop_feePositive :: Transaction -> Bool
prop_feePositive tx =
  sumInputs tx >= sumOutputs tx  -- 费用总是非负

-- QuickCheck 可以测试成千上万的情况
-- 接近于证明
```

#### 领域特定语言 (DSL)

Haskell 擅长构建 DSL，Plutus（Cardano 的智能合约语言）就是一个 Haskell DSL：

```haskell
-- Plutus 脚本（简化示例）
validator :: Datum -> Redeemer -> ScriptContext -> Bool
validator dat red ctx = 
  -- 用 Haskell 编写智能合约逻辑
  traceIfFalse "invalid signature" (checkSignature red ctx)
```

#### 并发和异步

Haskell 的 STM (Software Transactional Memory) 使并发编程安全：

```haskell
-- Cardano 节点使用 STM 处理并发
processBlock :: Block -> STM ()
processBlock block = do
  currentState <- readTVar ledgerState
  let newState = applyBlock block currentState
  writeTVar ledgerState newState  -- 原子操作
```

### 1.4 Cardano 的 Haskell 生态

Cardano 相关的主要 Haskell 项目：

| 项目 | 用途 | 语言 |
|------|------|------|
| cardano-node | 区块链节点 | Haskell |
| cardano-cli | 命令行工具 | Haskell |
| cardano-wallet | 钱包后端 | Haskell |
| cardano-db-sync | 数据库同步 | Haskell |
| Plutus | 智能合约平台 | Haskell |

**你会注意到**：核心基础设施全部用 Haskell 编写！

### 1.5 其他区块链的语言选择

对比其他区块链：

| 区块链 | 主要语言 | 特点 |
|--------|----------|------|
| Bitcoin | C++ | 性能优先，但容易出bug |
| Ethereum | Go, Solidity | 快速开发，安全性较弱 |
| Cardano | Haskell | 正确性优先，学习曲线陡 |
| Polkadot | Rust | 性能+安全平衡 |

**Cardano 的选择**：宁可开发慢一点，也要确保正确性。

### 💡 关键要点

1. **函数式编程 = 更安全的区块链**
2. **Haskell 的类型系统 = 更少的 bug**
3. **纯函数 = 更容易验证**
4. **不可变性 = 更容易推理**
5. **Cardano 全栈使用 Haskell**

---

## 2. Cardano 架构概览

### 2.1 整体架构

```
┌─────────────────────────────────────────────┐
│              应用层 (Applications)            │
│   钱包、DApp、浏览器、交易所                    │
└─────────────────────────────────────────────┘
                     ↕
┌─────────────────────────────────────────────┐
│            API 层 (APIs & Services)          │
│   cardano-wallet、Blockfrost、cardano-graphql│
└─────────────────────────────────────────────┘
                     ↕
┌─────────────────────────────────────────────┐
│           节点层 (cardano-node)              │
│  ┌─────────────┬──────────────┬───────────┐ │
│  │  Consensus  │   Ledger     │  Network  │ │
│  │  (共识层)    │  (账本层)     │  (网络层)  │ │
│  └─────────────┴──────────────┴───────────┘ │
└─────────────────────────────────────────────┘
                     ↕
┌─────────────────────────────────────────────┐
│           区块链 (Blockchain)                │
│   ═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══           │
└─────────────────────────────────────────────┘
```

### 2.2 节点结构

#### Consensus Layer (共识层)

**职责**：决定哪些区块是有效的

```haskell
-- 简化的共识接口
data Block = Block
  { blockHeader :: BlockHeader
  , blockBody   :: [Transaction]
  }

validateBlock :: Block -> ChainState -> Either Error ChainState
```

Cardano 使用 **Ouroboros** 共识协议（权益证明 PoS）。

#### Ledger Layer (账本层)

**职责**：维护区块链状态

```haskell
-- 账本状态（简化）
data LedgerState = LedgerState
  { utxoSet      :: UTxOSet       -- 所有未花费输出
  , accountState :: AccountState  -- 账户状态
  , poolState    :: PoolState     -- 质押池状态
  }

applyTransaction :: Transaction -> LedgerState -> Either Error LedgerState
```

#### Network Layer (网络层)

**职责**：节点间通信

```haskell
-- 网络消息类型（简化）
data Message
  = RequestBlock BlockHash
  | SendBlock Block
  | RequestTx TxHash
  | SendTx Transaction
```

### 2.3 链下 vs 链上代码

#### 链上代码 (On-chain)

- 运行在区块链上
- Plutus 智能合约
- 验证交易的有效性
- **不是本课程的重点**

#### 链下代码 (Off-chain)

- 运行在用户的机器上
- 构建交易
- 查询区块链状态
- 管理密钥
- **本周的重点！**

```
┌──────────────────────────────────────┐
│      你的 Haskell 应用 (链下)          │
│                                      │
│  1. 构建交易                          │
│  2. 签名                             │
│  3. 提交到节点                        │
└──────────────────────────────────────┘
              ↓
┌──────────────────────────────────────┐
│         cardano-node                 │
│                                      │
│  4. 验证交易                          │
│  5. 加入内存池                        │
│  6. 打包进区块                        │
└──────────────────────────────────────┘
```

### 2.4 Haskell 在 Cardano 生态中的角色

#### cardano-node

完整的区块链节点，用 Haskell 编写：

```bash
# 启动节点
cardano-node run \
  --config config.json \
  --topology topology.json \
  --database-path db/
```

#### cardano-cli

命令行工具，也是 Haskell 编写：

```bash
# 查询地址余额
cardano-cli query utxo \
  --address addr_test1... \
  --testnet-magic 1
```

#### cardano-api

Haskell 库，用于编程方式操作 Cardano：

```haskell
import Cardano.Api

-- 构建交易
buildTransaction :: NetworkId -> TxBodyContent -> Either TxBodyError TxBody
```

**本周重点**：我们将使用 `cardano-api` 类型和 JSON 数据，但不一定要安装完整节点。

### 2.5 数据流

```
用户输入
  ↓
你的 Haskell 程序
  ↓
cardano-api 类型
  ↓
序列化为 JSON/CBOR
  ↓
cardano-cli 或 API
  ↓
cardano-node
  ↓
区块链
```

### 💡 关键要点

1. **Cardano 是分层架构**：共识、账本、网络
2. **链上 vs 链下**：本周学链下编程
3. **cardano-node**：用 Haskell 编写的完整节点
4. **cardano-api**：Haskell 库，用于构建应用
5. **我们的重点**：用 Haskell 处理 Cardano 数据

---

## 3. eUTxO 模型

### 3.1 什么是 UTXO？

UTXO = **Unspent Transaction Output**（未花费交易输出）

#### 类比：现金模型

想象你的钱包里有：
- 一张 50 元纸币
- 两张 20 元纸币
- 一张 10 元纸币

**总额**：100 元

当你要支付 60 元时：
1. 你拿出 50 元和 20 元纸币（总共 70 元）
2. 收银员收走 60 元
3. 找你 10 元

**UTXO 就像这样**：你有一些"钞票"（UTxO），花费时必须整个花掉，然后找零。

### 3.2 Bitcoin 的 UTXO 模型

Bitcoin 使用简单的 UTXO 模型：

```
┌─────────────────────────────────┐
│  Alice 的 UTxO Set              │
├─────────────────────────────────┤
│  UTxO #1: 5 BTC                 │
│  UTxO #2: 3 BTC                 │
│  UTxO #3: 2 BTC                 │
├─────────────────────────────────┤
│  总额: 10 BTC                    │
└─────────────────────────────────┘
```

#### 交易示例

Alice 要给 Bob 发送 4 BTC：

```
输入:                 输出:
┌──────────┐          ┌──────────┐
│ UTxO #1  │  ──────> │ Bob:     │
│ 5 BTC    │          │ 4 BTC    │
└──────────┘          └──────────┘
                      ┌──────────┐
                      │ Alice:   │
                      │ 0.9 BTC  │  (找零)
                      └──────────┘
                      ┌──────────┐
                      │ 矿工费:   │
                      │ 0.1 BTC  │
                      └──────────┘
```

**规则**：
- `sum(inputs) = sum(outputs) + fee`
- 输入的 UTxO 被"花费"（销毁）
- 创建新的 UTxO

### 3.3 Ethereum 的账户模型

对比：Ethereum 使用账户模型：

```
┌─────────────────────────────────┐
│  Alice 的账户                    │
├─────────────────────────────────┤
│  余额: 10 ETH                    │
│  Nonce: 42                      │
│  代码: (空)                      │
└─────────────────────────────────┘
```

转账时：
```
Alice.balance -= 4 ETH
Bob.balance += 4 ETH
```

**区别**：
- UTXO：像现金，每笔资金有独立"身份"
- 账户：像银行账户，只有总余额

### 3.4 Extended UTXO (eUTxO)

Cardano 扩展了 UTXO 模型，添加了：

1. **Datum**：附加在 UTxO 上的数据
2. **Redeemer**：花费 UTxO 时提供的数据
3. **Script Context**：交易的上下文信息

```haskell
-- Cardano 的 UTxO（简化）
data TxOut = TxOut
  { txOutAddress :: Address      -- 地址
  , txOutValue   :: Value         -- 金额（可以是多种代币）
  , txOutDatum   :: Maybe Datum   -- 附加数据
  }

data TxIn = TxIn
  { txInRef :: TxOutRef           -- 引用哪个 UTxO
  }

-- 花费时需要提供
data Redeemer = ...  -- 取决于脚本
```

#### eUTxO 的优势

```
┌────────────────────────────────────┐
│  UTxO 不仅是"钱"，还可以携带数据    │
└────────────────────────────────────┘

示例: 一个 UTxO 可以表示
  ├─ 10 ADA
  ├─ Datum: { owner: Alice, expires: 2025-12-31 }
  └─ Script: 只有 Alice 能在到期前花费
```

### 3.5 Cardano 的 UTxO 结构

#### 地址类型

Cardano 有多种地址类型：

```haskell
-- 1. 普通支付地址
-- addr1q... (mainnet) 或 addr_test1q... (testnet)
-- 由支付密钥控制

-- 2. 脚本地址
-- addr1w... (mainnet) 或 addr_test1w... (testnet)
-- 由智能合约控制

-- 3. 企业地址
-- addr1v... (无质押权益)

-- 4. 奖励地址
-- stake1... (用于接收质押奖励)
```

#### Value 类型

Cardano 的 Value 可以包含多种资产：

```haskell
data Value = Value
  { lovelace :: Integer           -- ADA (1 ADA = 1,000,000 Lovelace)
  , assets   :: Map PolicyId Assets  -- 其他代币
  }

-- 示例
exampleValue :: Value
exampleValue = Value
  { lovelace = 5000000  -- 5 ADA
  , assets = Map.fromList
      [ (policyId1, Map.fromList [("TokenA", 100)])
      , (policyId2, Map.fromList [("NFT#123", 1)])
      ]
  }
```

### 3.6 实际示例

#### Alice 的 UTxO Set

```json
[
  {
    "txHash": "abc123...",
    "txIndex": 0,
    "address": "addr_test1qz...",
    "value": {
      "lovelace": 10000000
    }
  },
  {
    "txHash": "def456...",
    "txIndex": 1,
    "address": "addr_test1qz...",
    "value": {
      "lovelace": 5000000,
      "assets": {
        "policy1.TokenA": 50
      }
    }
  }
]
```

**Alice 的总余额**：
- 15 ADA (15,000,000 Lovelace)
- 50 TokenA

#### 构建交易

Alice 要给 Bob 发送 8 ADA：

```
输入 (Alice 选择的 UTxO):
  UTxO #1: 10 ADA
  
输出:
  Output #1: Bob 收到 8 ADA
  Output #2: Alice 找零 1.8 ADA
  费用: 0.2 ADA
  
验证: 10 = 8 + 1.8 + 0.2 ✓
```

### 3.7 eUTxO 的好处

#### 1. 并行处理

```
交易 A: 花费 UTxO #1, #2
交易 B: 花费 UTxO #3, #4
  
→ 可以并行验证！（因为没有共享状态）
```

在账户模型中，修改同一账户的交易必须串行。

#### 2. 确定性

```haskell
-- 本地验证交易是否有效
validateTx :: Transaction -> UTxOSet -> Either Error ()
```

在提交前，你就知道交易是否会成功！

#### 3. 隐私性

每个 UTxO 可以有不同的地址，更难追踪所有权。

### 3.8 Haskell 中表示 UTxO

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import Data.Aeson
import qualified Data.Map as Map

-- 交易输出引用
data TxOutRef = TxOutRef
  { txId    :: TxId      -- 交易哈希
  , txIndex :: Integer   -- 输出索引
  } deriving (Show, Eq, Ord, Generic, FromJSON, ToJSON)

-- 交易输出
data TxOut = TxOut
  { address :: Address
  , value   :: Value
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- UTxO 集合
type UTxOSet = Map.Map TxOutRef TxOut

-- 查询地址的 UTxO
utxosAt :: Address -> UTxOSet -> UTxOSet
utxosAt addr = Map.filter (\out -> address out == addr)

-- 计算总余额
totalValue :: UTxOSet -> Value
totalValue = foldl addValue mempty . Map.elems
  where
    addValue (Value l1 a1) (Value l2 a2) = 
      Value (l1 + l2) (Map.unionWith (+) a1 a2)
```

### 💡 关键要点

1. **UTXO 模型**：像现金，不是账户
2. **eUTxO = UTXO + 数据 + 脚本**
3. **Cardano 的 UTxO**：可以包含多种代币
4. **并行处理**：eUTxO 允许并行验证
5. **确定性**：提交前就知道结果

---

## 4. 交易解剖

### 4.1 交易的生命周期

```
1. 构建 (Build)
   ↓
2. 平衡 (Balance)
   ↓
3. 签名 (Sign)
   ↓
4. 提交 (Submit)
   ↓
5. 验证 (Validate)
   ↓
6. 上链 (On-chain)
```

### 4.2 交易结构

一个完整的 Cardano 交易包含：

```haskell
data Transaction = Transaction
  { txBody       :: TxBody         -- 交易主体
  , txWitnesses  :: [Witness]      -- 签名和脚本
  , txMetadata   :: Maybe Metadata -- 可选元数据
  } deriving (Show, Eq)

data TxBody = TxBody
  { txInputs    :: [TxIn]         -- 输入
  , txOutputs   :: [TxOut]        -- 输出
  , txFee       :: Lovelace       -- 费用
  , txTTL       :: Maybe Slot     -- 有效期限
  , txCerts     :: [Certificate]  -- 证书（质押等）
  , txWithdraws :: [(StakeAddress, Lovelace)]  -- 提取奖励
  , txMint      :: Value          -- 铸造代币
  } deriving (Show, Eq)
```

### 4.3 交易输入

交易输入引用之前的 UTxO：

```haskell
data TxIn = TxIn
  { txInId    :: TxId      -- 交易哈希
  , txInIndex :: Word      -- 输出索引
  } deriving (Show, Eq)

-- 示例
exampleInput :: TxIn
exampleInput = TxIn
  { txInId = "a1b2c3d4e5f6..."
  , txInIndex = 0
  }
```

**JSON 表示**：

```json
{
  "txId": "a1b2c3d4e5f6...",
  "txIndex": 0
}
```

### 4.4 交易输出

交易输出创建新的 UTxO：

```haskell
data TxOut = TxOut
  { txOutAddress :: Address
  , txOutValue   :: Value
  , txOutDatum   :: Maybe DatumHash  -- 脚本输出才需要
  } deriving (Show, Eq)

-- 示例：简单支付
simplePayment :: TxOut
simplePayment = TxOut
  { txOutAddress = "addr_test1qz..."
  , txOutValue = Value 5000000 mempty  -- 5 ADA
  , txOutDatum = Nothing
  }
```

**JSON 表示**：

```json
{
  "address": "addr_test1qz...",
  "value": {
    "lovelace": 5000000
  }
}
```

### 4.5 费用计算

Cardano 的费用模型：

```
fee = a + b × size

其中:
  a = 最小费用 (固定值，约 0.155 ADA)
  b = 每字节费用 (约 0.000044 ADA/byte)
  size = 交易大小（字节）
```

**Haskell 实现**：

```haskell
calculateFee :: TxBody -> Lovelace
calculateFee txBody =
  let size = estimateSize txBody
      a = 155381  -- Lovelace (约 0.155 ADA)
      b = 44      -- Lovelace per byte
  in Lovelace (a + b * size)

-- 估算交易大小
estimateSize :: TxBody -> Integer
estimateSize txBody =
  -- 简化：实际需要序列化为 CBOR 后计算
  let inputSize = length (txInputs txBody) * 43
      outputSize = sum $ map outputSize (txOutputs txBody)
      overhead = 10
  in fromIntegral (inputSize + outputSize + overhead)
```

### 4.6 交易平衡

**问题**：`sum(inputs) = sum(outputs) + fee`

构建交易时的步骤：

```haskell
-- 1. 初始交易（费用未知）
initialTx :: TxBody
initialTx = TxBody
  { txInputs = [input1, input2]   -- 选择的输入
  , txOutputs = [payment]          -- 支付输出
  , txFee = Lovelace 0             -- 临时设为 0
  , ...
  }

-- 2. 计算费用
estimatedFee :: Lovelace
estimatedFee = calculateFee initialTx

-- 3. 添加找零输出
balancedTx :: TxBody
balancedTx = 
  let inputSum = sum $ map getValue (txInputs initialTx)
      outputSum = sum $ map getValue (txOutputs initialTx)
      change = inputSum - outputSum - estimatedFee
  in if change > minUtxoValue
       then initialTx 
              { txOutputs = txOutputs initialTx ++ [changeOutput change]
              , txFee = estimatedFee
              }
       else error "Insufficient funds"

-- 4. 重新计算费用（因为添加了输出）
finalFee :: Lovelace
finalFee = calculateFee balancedTx

-- 5. 调整找零
finalTx :: TxBody
finalTx = adjustChange balancedTx finalFee
```

**为什么复杂**？因为费用取决于交易大小，而交易大小又取决于输出数量（找零）！

### 4.7 实际交易示例

#### 简单支付交易

```json
{
  "type": "Tx BabbageEra",
  "description": "Alice 给 Bob 发送 10 ADA",
  "cborHex": "...",
  "body": {
    "inputs": [
      {
        "txId": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2",
        "txIndex": 0
      }
    ],
    "outputs": [
      {
        "address": "addr_test1qr...",
        "value": {
          "lovelace": 10000000
        }
      },
      {
        "address": "addr_test1qz...",
        "value": {
          "lovelace": 39832903
        }
      }
    ],
    "fee": 167097,
    "ttl": 8000000
  },
  "witnesses": {
    "signatures": [
      {
        "publicKey": "...",
        "signature": "..."
      }
    ]
  }
}
```

**解析**：
- 输入：一个 UTxO（50 ADA）
- 输出 1：Bob 收到 10 ADA
- 输出 2：Alice 找零 39.832903 ADA
- 费用：0.167097 ADA
- 验证：50 = 10 + 39.832903 + 0.167097 ✓

### 4.8 用 Haskell 解析交易

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import GHC.Generics

-- 交易类型定义
data Transaction = Transaction
  { txBody      :: TxBody
  , txWitnesses :: Witnesses
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxBody = TxBody
  { inputs  :: [TxInput]
  , outputs :: [TxOutput]
  , fee     :: Integer
  , ttl     :: Maybe Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxInput = TxInput
  { txId    :: String
  , txIndex :: Int
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxOutput = TxOutput
  { address :: String
  , value   :: TxValue
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxValue = TxValue
  { lovelace :: Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

data Witnesses = Witnesses
  { signatures :: [Signature]
  } deriving (Show, Generic, FromJSON, ToJSON)

data Signature = Signature
  { publicKey :: String
  , signature :: String
  } deriving (Show, Generic, FromJSON, ToJSON)

-- 解析交易
parseTx :: FilePath -> IO (Either String Transaction)
parseTx path = do
  content <- BSL.readFile path
  return $ eitherDecode content

-- 提取信息
getTxSummary :: Transaction -> String
getTxSummary tx =
  let body = txBody tx
      inputCount = length $ inputs body
      outputCount = length $ outputs body
      totalOutput = sum $ map (lovelace . value) (outputs body)
      feePaid = fee body
  in unlines
       [ "Transaction Summary:"
       , "  Inputs: " ++ show inputCount
       , "  Outputs: " ++ show outputCount
       , "  Total Output: " ++ show totalOutput ++ " Lovelace"
       , "  Fee: " ++ show feePaid ++ " Lovelace"
       ]

-- 使用示例
main :: IO ()
main = do
  result <- parseTx "transaction.json"
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right tx -> putStrLn $ getTxSummary tx
```

### 4.9 元数据 (Metadata)

交易可以附加任意元数据：

```json
{
  "metadata": {
    "674": {
      "msg": ["Hello", "Cardano!"]
    },
    "1337": {
      "name": "My NFT",
      "image": "ipfs://..."
    }
  }
}
```

**用途**：
- NFT 信息
- 消息
- DApp 数据
- 身份认证

```haskell
data Metadata = Metadata (Map Integer MetadataValue)
  deriving (Show, Eq)

data MetadataValue
  = MetaInt Integer
  | MetaString String
  | MetaList [MetadataValue]
  | MetaMap [(MetadataValue, MetadataValue)]
  deriving (Show, Eq)
```

### 💡 关键要点

1. **交易 = 输入 + 输出 + 费用**
2. **输入引用之前的 UTxO**
3. **输出创建新的 UTxO**
4. **费用取决于交易大小**
5. **平衡交易很重要**：sum(inputs) = sum(outputs) + fee
6. **元数据**：可以附加任意数据

---

## 5. 使用 cardano-api

### 5.1 cardano-api 简介

`cardano-api` 是官方的 Haskell 库，用于：
- 构建交易
- 序列化/反序列化
- 地址操作
- 密钥管理

**安装**（可选，本周主要看类型定义）：

```bash
# cardano-api 是 cardano-node 的一部分
git clone https://github.com/IntersectMBO/cardano-node
cd cardano-node
cabal build cardano-api
```

### 5.2 核心类型

#### Era (时代)

Cardano 有不同的"时代"（协议版本）：

```haskell
data CardanoEra era where
  ByronEra   :: CardanoEra ByronEra
  ShelleyEra :: CardanoEra ShelleyEra
  AllegraEra :: CardanoEra AllegraEra
  MaryEra    :: CardanoEra MaryEra
  AlonzoEra  :: CardanoEra AlonzoEra
  BabbageEra :: CardanoEra BabbageEra  -- 当前时代 (2025)

-- 类型安全：不同时代的交易不能混用
```

#### NetworkId

```haskell
data NetworkId
  = Mainnet                    -- 主网
  | Testnet (NetworkMagic)     -- 测试网

-- 示例
testnetId :: NetworkId
testnetId = Testnet (NetworkMagic 1)  -- Preview testnet
```

#### Address

```haskell
data Address
  = AddressShelley ShelleyAddress
  | AddressByron ByronAddress

-- 从 Bech32 字符串解析
parseAddress :: Text -> Maybe Address
parseAddress "addr_test1q..." = Just ...

-- 转换为字符串
renderAddress :: Address -> Text
```

### 5.3 构建交易

```haskell
{-# LANGUAGE GADTs #-}

import Cardano.Api

-- 构建简单支付交易
buildSimplePayment 
  :: NetworkId
  -> Address        -- 发送方地址
  -> Address        -- 接收方地址
  -> Lovelace       -- 金额
  -> [UTxO]         -- 可用的 UTxO
  -> Either TxBodyError TxBody
buildSimplePayment networkId fromAddr toAddr amount utxos = do
  -- 1. 创建交易输入
  let txIns = map utxoToTxIn (selectUtxos amount utxos)
  
  -- 2. 创建交易输出
  let txOut = TxOut toAddr (lovelaceToValue amount) TxOutDatumNone ReferenceScriptNone
  
  -- 3. 构建交易主体
  makeTransactionBody $
    TxBodyContent
      { txIns = txIns
      , txOuts = [txOut]
      , txFee = TxFeeExplicit (Lovelace 0)  -- 稍后计算
      , txValidityRange = (TxValidityNoLowerBound, TxValidityNoUpperBound)
      , txMetadata = TxMetadataNone
      , txAuxScripts = TxAuxScriptsNone
      , txExtraKeyWits = TxExtraKeyWitnessesNone
      , txProtocolParams = BuildTxWith Nothing
      , txWithdrawals = TxWithdrawalsNone
      , txCertificates = TxCertificatesNone
      , txUpdateProposal = TxUpdateProposalNone
      , txMintValue = TxMintNone
      , txScriptValidity = TxScriptValidityNone
      , txGovernanceActions = TxGovernanceActionsNone
      , txVotes = TxVotesNone
      }
```

### 5.4 序列化

```haskell
-- 序列化为 JSON
serialiseTxBody :: TxBody -> ByteString
serialiseTxBody txBody = 
  encodePretty $ serialiseToJSON txBody

-- 序列化为 CBOR (二进制格式)
serialiseToCBOR :: TxBody -> ByteString
serialiseToCBOR = serialise

-- 从 CBOR 反序列化
deserialiseTxBody :: ByteString -> Either DeserialiseError TxBody
deserialiseTxBody = deserialise
```

### 5.5 地址操作

```haskell
-- 生成支付密钥
generateSigningKey :: IO (SigningKey PaymentKey)
generateSigningKey = generateSigningKey AsPaymentKey

-- 从密钥导出验证密钥
getVerificationKey :: SigningKey PaymentKey -> VerificationKey PaymentKey
getVerificationKey = getVerificationKey

-- 从验证密钥生成地址
makeAddress :: NetworkId -> VerificationKey PaymentKey -> Address
makeAddress networkId vkey =
  makeShelleyAddress networkId (PaymentCredentialByKey (verificationKeyHash vkey)) NoStakeAddress

-- 解析地址
parseAddr :: Text -> Maybe Address
parseAddr = deserialiseAddress AsAddressAny
```

### 5.6 签名交易

```haskell
-- 签名交易
signTransaction 
  :: TxBody
  -> [SigningKey PaymentKey]
  -> Tx
signTransaction txBody signingKeys =
  makeSignedTransaction
    (map (makeShelleyKeyWitness txBody) signingKeys)
    txBody

-- 创建密钥见证
makeShelleyKeyWitness 
  :: TxBody
  -> SigningKey PaymentKey
  -> KeyWitness
```

### 5.7 实际示例（伪代码）

```haskell
-- 完整的交易构建流程
createPaymentTx :: IO ()
createPaymentTx = do
  -- 1. 加载密钥
  skey <- readSigningKey "payment.skey"
  let vkey = getVerificationKey skey
  let fromAddr = makeAddress testnetId vkey
  
  -- 2. 查询 UTxOs（需要节点或 API）
  utxos <- queryUTxOs fromAddr
  
  -- 3. 构建交易
  let toAddr = parseAddress "addr_test1q..."
  let amount = Lovelace 10000000  -- 10 ADA
  
  txBody <- case buildSimplePayment testnetId fromAddr toAddr amount utxos of
    Left err -> error $ show err
    Right body -> return body
  
  -- 4. 签名
  let tx = signTransaction txBody [skey]
  
  -- 5. 序列化
  let txFile = "tx.signed"
  writeFileTextEnvelope txFile Nothing tx
  
  putStrLn $ "Transaction written to " ++ txFile
```

### 5.8 类型安全的好处

```haskell
-- 编译时检查时代
buildTxForAlonzo :: TxBody AlonzoEra -> ...
buildTxForBabbage :: TxBody BabbageEra -> ...

-- 不能混用！
-- buildTxForAlonzo babbageTx  -- 编译错误！

-- 类型确保正确性
verifySignature 
  :: VerificationKey PaymentKey 
  -> TxBody 
  -> Signature
  -> Bool
```

### 💡 关键要点

1. **cardano-api**：官方 Haskell 库
2. **类型安全**：Era、NetworkId 等防止错误
3. **构建交易**：TxBodyContent → TxBody
4. **序列化**：JSON 和 CBOR
5. **密钥管理**：SigningKey、VerificationKey
6. **本周重点**：理解类型，不一定要运行完整节点

---

## 6. 用 Haskell 查询 Cardano

### 6.1 查询方式

有多种方式查询 Cardano 区块链：

| 方式 | 优点 | 缺点 | 难度 |
|------|------|------|------|
| 本地节点 | 完全控制、无依赖 | 需要同步区块链 (~20GB) | ★★★★ |
| cardano-db-sync | SQL 查询、灵活 | 复杂设置 | ★★★★★ |
| Blockfrost API | 简单、免费额度 | 依赖第三方 | ★☆☆☆☆ |
| Koios API | 社区驱动、免费 | 依赖第三方 | ★☆☆☆☆ |

**本周推荐**：Blockfrost API（最简单）

### 6.2 Blockfrost API 简介

Blockfrost 提供 RESTful API 访问 Cardano 数据。

**特点**：
- 免费额度：50,000 请求/天
- 支持主网和测试网
- 完整的 API 文档
- 无需运行节点

**注册**：https://blockfrost.io

### 6.3 API 端点

常用端点：

```
GET /addresses/{address}              # 地址信息
GET /addresses/{address}/utxos        # 地址的 UTxOs
GET /addresses/{address}/transactions # 地址的交易历史
GET /txs/{hash}                       # 交易详情
GET /blocks/latest                    # 最新区块
GET /epochs/latest                    # 当前纪元
```

### 6.4 使用 req 库

```haskell
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T
import GHC.Generics
import Control.Monad.IO.Class (liftIO)

-- API 配置
data BlockfrostConfig = BlockfrostConfig
  { projectId :: T.Text
  , network   :: Network
  }

data Network = Testnet | Mainnet

-- API URL
apiBaseUrl :: Network -> Url 'Https
apiBaseUrl Testnet = https "cardano-testnet.blockfrost.io"
apiBaseUrl Mainnet = https "cardano-mainnet.blockfrost.io"

-- API 请求
blockfrostReq
  :: FromJSON a
  => BlockfrostConfig
  -> T.Text              -- 端点路径
  -> IO (Either String a)
blockfrostReq config path = runReq defaultHttpConfig $ do
  let url = apiBaseUrl (network config) /: "api" /: "v0" /~ path
  response <- req
    GET
    url
    NoReqBody
    jsonResponse
    (header "project_id" (encodeUtf8 $ projectId config))
  
  return $ Right $ responseBody response
```

### 6.5 查询地址信息

```haskell
-- 地址信息数据类型
data AddressInfo = AddressInfo
  { address       :: T.Text
  , amount        :: [Amount]
  , stake_address :: Maybe T.Text
  , type_         :: T.Text
  , script        :: Bool
  } deriving (Show, Generic, FromJSON)

data Amount = Amount
  { unit     :: T.Text      -- "lovelace" 或 PolicyId.AssetName
  , quantity :: T.Text      -- 数量（字符串形式）
  } deriving (Show, Generic, FromJSON)

-- 查询函数
getAddressInfo :: BlockfrostConfig -> T.Text -> IO (Either String AddressInfo)
getAddressInfo config addr = 
  blockfrostReq config ("addresses" <> "/" <> addr)

-- 使用示例
main :: IO ()
main = do
  let config = BlockfrostConfig
        { projectId = "testnetXXXXXXXXXXXXXXXX"  -- 你的 API key
        , network = Testnet
        }
  
  let testAddr = "addr_test1qz..."
  
  result <- getAddressInfo config testAddr
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right info -> do
      putStrLn $ "Address: " ++ T.unpack (address info)
      putStrLn "Balances:"
      forM_ (amount info) $ \amt -> do
        putStrLn $ "  " ++ T.unpack (unit amt) ++ ": " ++ T.unpack (quantity amt)
```

### 6.6 查询 UTxOs

```haskell
-- UTxO 数据类型
data UTxO = UTxO
  { tx_hash   :: T.Text
  , tx_index  :: Int
  , output_index :: Int
  , amount    :: [Amount]
  , block     :: T.Text
  , data_hash :: Maybe T.Text
  } deriving (Show, Generic, FromJSON)

-- 查询函数
getAddressUTxOs :: BlockfrostConfig -> T.Text -> IO (Either String [UTxO])
getAddressUTxOs config addr =
  blockfrostReq config ("addresses" <> "/" <> addr <> "/utxos")

-- 计算总余额
totalBalance :: [UTxO] -> Integer
totalBalance utxos =
  sum [ read (T.unpack $ quantity amt) 
      | utxo <- utxos
      , amt <- amount utxo
      , unit amt == "lovelace"
      ]

-- 使用示例
queryBalance :: T.Text -> IO ()
queryBalance addr = do
  let config = BlockfrostConfig "testnetXXX..." Testnet
  result <- getAddressUTxOs config addr
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right utxos -> do
      let balance = totalBalance utxos
      let ada = fromIntegral balance / 1000000
      putStrLn $ "Total balance: " ++ show ada ++ " ADA"
      putStrLn $ "UTxO count: " ++ show (length utxos)
```

### 6.7 查询交易历史

```haskell
-- 交易记录
data TxHistory = TxHistory
  { tx_hash :: T.Text
  , tx_index :: Int
  , block_height :: Int
  , block_time :: Int
  } deriving (Show, Generic, FromJSON)

-- 查询函数
getAddressTransactions 
  :: BlockfrostConfig
  -> T.Text
  -> IO (Either String [TxHistory])
getAddressTransactions config addr =
  blockfrostReq config ("addresses" <> "/" <> addr <> "/transactions")

-- 格式化显示
displayTxHistory :: [TxHistory] -> IO ()
displayTxHistory txs = do
  putStrLn "Recent transactions:"
  forM_ (take 10 txs) $ \tx -> do
    putStrLn $ "  " ++ T.unpack (tx_hash tx) 
            ++ " (block " ++ show (block_height tx) ++ ")"
```

### 6.8 错误处理

```haskell
{-# LANGUAGE DeriveAnyClass #-}

import Control.Monad.Except
import Data.Typeable

-- 错误类型
data BlockfrostError
  = NetworkError String
  | ParseError String
  | APIError Int String    -- HTTP 状态码 + 消息
  | RateLimitExceeded
  deriving (Show, Typeable, Exception)

-- 使用 ExceptT
type BlockfrostM a = ExceptT BlockfrostError IO a

-- 安全的 API 请求
safeBlockfrostReq
  :: FromJSON a
  => BlockfrostConfig
  -> T.Text
  -> BlockfrostM a
safeBlockfrostReq config path = do
  result <- liftIO $ try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl (network config) /: "api" /: "v0" /~ path
    req GET url NoReqBody jsonResponse 
        (header "project_id" (encodeUtf8 $ projectId config))
  
  case result of
    Left (err :: HttpException) -> 
      throwError $ NetworkError (show err)
    Right response ->
      case responseStatusCode response of
        200 -> return $ responseBody response
        429 -> throwError RateLimitExceeded
        code -> throwError $ APIError code "Request failed"

-- 使用示例
queryAddressSafe :: T.Text -> IO ()
queryAddressSafe addr = do
  let config = BlockfrostConfig "testnetXXX..." Testnet
  result <- runExceptT $ safeBlockfrostReq config ("addresses" <> "/" <> addr)
  case result of
    Left err -> putStrLn $ "Error: " ++ show err
    Right info -> print (info :: AddressInfo)
```

### 6.9 速率限制处理

```haskell
import Control.Concurrent (threadDelay)
import Control.Retry

-- 重试策略
retryPolicy :: RetryPolicy
retryPolicy = exponentialBackoff 1000000 <> limitRetries 3

-- 带重试的请求
requestWithRetry
  :: FromJSON a
  => BlockfrostConfig
  -> T.Text
  -> IO (Either BlockfrostError a)
requestWithRetry config path = runExceptT $
  retrying retryPolicy shouldRetry $ \_ ->
    safeBlockfrostReq config path
  where
    shouldRetry _ (Left RateLimitExceeded) = return True
    shouldRetry _ _ = return False
```

### 6.10 完整示例：余额查询器

```haskell
-- 查询多个地址的余额
queryMultipleAddresses :: [T.Text] -> IO ()
queryMultipleAddresses addrs = do
  let config = BlockfrostConfig "testnetXXX..." Testnet
  
  putStrLn "Querying balances..."
  results <- forM addrs $ \addr -> do
    result <- getAddressUTxOs config addr
    case result of
      Left err -> return (addr, Left err)
      Right utxos -> 
        let balance = totalBalance utxos
        in return (addr, Right balance)
    
    -- 避免速率限制
    threadDelay 100000  -- 100ms
  
  -- 显示结果
  putStrLn "\nResults:"
  forM_ results $ \(addr, result) -> do
    putStr $ T.unpack addr ++ ": "
    case result of
      Left err -> putStrLn $ "Error - " ++ err
      Right balance -> 
        putStrLn $ show (fromIntegral balance / 1000000) ++ " ADA"

-- 主程序
main :: IO ()
main = do
  let addresses = 
        [ "addr_test1qz..."
        , "addr_test1qq..."
        , "addr_test1qp..."
        ]
  queryMultipleAddresses addresses
```

### 💡 关键要点

1. **Blockfrost API**：最简单的查询方式
2. **req 库**：Haskell HTTP 客户端
3. **aeson**：解析 JSON 响应
4. **ExceptT**：错误处理
5. **速率限制**：注意 API 限制
6. **类型安全**：定义数据类型解析响应

---

## 7. 实用模式

### 7.1 组合 aeson + bytestring

处理 JSON 数据的完整流程：

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString as BS
import Data.Text.Encoding (decodeUtf8)

-- 模式 1: 从文件读取 JSON
readJSONFile :: FromJSON a => FilePath -> IO (Either String a)
readJSONFile path = do
  content <- BSL.readFile path
  return $ eitherDecode content

-- 模式 2: 写入 JSON 到文件
writeJSONFile :: ToJSON a => FilePath -> a -> IO ()
writeJSONFile path value = 
  BSL.writeFile path (encode value)

-- 模式 3: 美化输出
writePrettyJSON :: ToJSON a => FilePath -> a -> IO ()
writePrettyJSON path value =
  BSL.writeFile path (encodePretty value)

-- 模式 4: 处理部分解析
data CardanoTx = CardanoTx
  { txId     :: Maybe String
  , txInputs :: Maybe [TxInput]
  } deriving (Show, Generic)

instance FromJSON CardanoTx where
  parseJSON = withObject "CardanoTx" $ \v -> CardanoTx
    <$> v .:? "id"       -- 可选字段
    <$> v .:? "inputs"

-- 模式 5: 自定义解析错误消息
parseTxWithError :: BSL.ByteString -> Either String CardanoTx
parseTxWithError content = case eitherDecode content of
  Left err -> Left $ "解析失败: " ++ err
  Right tx -> case txId tx of
    Nothing -> Left "缺少交易 ID"
    Just _ -> Right tx
```

### 7.2 ExceptT 用于 Cardano API

统一的错误处理：

```haskell
{-# LANGUAGE DeriveAnyClass #-}

import Control.Monad.Except
import Data.Typeable

-- 应用错误类型
data AppError
  = FileError FilePath String
  | ParseError String
  | APIError String
  | ValidationError String
  deriving (Show, Typeable, Exception)

-- 应用 Monad
type App a = ExceptT AppError IO a

-- 模式 1: 读取并解析交易
loadTransaction :: FilePath -> App Transaction
loadTransaction path = do
  -- 读取文件
  content <- liftIO (try $ BSL.readFile path) >>= \case
    Left (err :: IOException) -> 
      throwError $ FileError path (show err)
    Right c -> return c
  
  -- 解析 JSON
  case eitherDecode content of
    Left err -> throwError $ ParseError err
    Right tx -> return tx

-- 模式 2: API 调用
fetchAddressInfo :: T.Text -> App AddressInfo
fetchAddressInfo addr = do
  result <- liftIO $ getAddressInfo config addr
  case result of
    Left err -> throwError $ APIError err
    Right info -> return info

-- 模式 3: 验证
validateTransaction :: Transaction -> App ()
validateTransaction tx = do
  when (null $ inputs $ txBody tx) $
    throwError $ ValidationError "交易没有输入"
  
  let inputSum = sum $ map getValue (inputs $ txBody tx)
  let outputSum = sum $ map getValue (outputs $ txBody tx)
  let fee = txFee $ txBody tx
  
  unless (inputSum == outputSum + fee) $
    throwError $ ValidationError "交易不平衡"

-- 模式 4: 组合操作
processTransaction :: FilePath -> T.Text -> App ()
processTransaction txPath addr = do
  -- 加载交易
  tx <- loadTransaction txPath
  
  -- 验证交易
  validateTransaction tx
  
  -- 获取地址信息
  addrInfo <- fetchAddressInfo addr
  
  -- 显示结果
  liftIO $ putStrLn "交易有效！"
  liftIO $ print addrInfo

-- 运行应用
runApp :: App a -> IO (Either AppError a)
runApp = runExceptT

-- 主函数
main :: IO ()
main = do
  result <- runApp $ processTransaction "tx.json" "addr_test1q..."
  case result of
    Left err -> putStrLn $ "错误: " ++ show err
    Right _ -> putStrLn "成功！"
```

### 7.3 构建 CLI 工具

```haskell
import System.Environment (getArgs)
import System.Exit (exitFailure)

-- 命令类型
data Command
  = QueryBalance Address
  | QueryTx TxHash
  | ParseFile FilePath
  | Help

-- 解析命令行参数
parseCommand :: [String] -> Either String Command
parseCommand ["balance", addr] = Right $ QueryBalance (T.pack addr)
parseCommand ["tx", hash] = Right $ QueryTx (T.pack hash)
parseCommand ["parse", file] = Right $ ParseFile file
parseCommand ["help"] = Right Help
parseCommand _ = Left "无效的命令"

-- 执行命令
executeCommand :: Command -> App ()
executeCommand (QueryBalance addr) = do
  utxos <- liftIO $ getAddressUTxOs config addr
  case utxos of
    Left err -> throwError $ APIError err
    Right us -> liftIO $ do
      let balance = totalBalance us
      putStrLn $ "余额: " ++ show (fromIntegral balance / 1000000) ++ " ADA"

executeCommand (QueryTx hash) = do
  tx <- liftIO $ getTransaction config hash
  case tx of
    Left err -> throwError $ APIError err
    Right t -> liftIO $ print t

executeCommand (ParseFile file) = do
  tx <- loadTransaction file
  liftIO $ putStrLn $ getTxSummary tx

executeCommand Help = liftIO $ do
  putStrLn "用法:"
  putStrLn "  cardano-tool balance <address>"
  putStrLn "  cardano-tool tx <txhash>"
  putStrLn "  cardano-tool parse <file>"

-- 主函数
main :: IO ()
main = do
  args <- getArgs
  case parseCommand args of
    Left err -> do
      putStrLn $ "错误: " ++ err
      exitFailure
    Right cmd -> do
      result <- runApp $ executeCommand cmd
      case result of
        Left err -> do
          putStrLn $ "错误: " ++ show err
          exitFailure
        Right _ -> return ()
```

### 7.4 测试 Cardano 代码

```haskell
import Test.Hspec
import Test.QuickCheck

-- 属性测试：交易平衡
prop_txBalanced :: Transaction -> Bool
prop_txBalanced tx =
  let body = txBody tx
      inputSum = sum $ map getValue (inputs body)
      outputSum = sum $ map getValue (outputs body)
      fee = txFee body
  in inputSum == outputSum + fee

-- 单元测试
spec :: Spec
spec = do
  describe "Transaction parsing" $ do
    it "parses valid transaction" $ do
      tx <- readJSONFile "test-data/tx-valid.json"
      tx `shouldSatisfy` isRight
    
    it "rejects invalid transaction" $ do
      tx <- readJSONFile "test-data/tx-invalid.json"
      tx `shouldSatisfy` isLeft
  
  describe "Address operations" $ do
    it "parses testnet address" $ do
      let addr = "addr_test1qz..."
      parseAddress addr `shouldSatisfy` isJust
    
    it "rejects mainnet address in testnet mode" $ do
      let addr = "addr1q..."
      -- 应该在 testnet 模式下拒绝
      validateAddress Testnet addr `shouldBe` False
  
  describe "UTxO operations" $ do
    it "calculates total balance correctly" $ do
      let utxos = [utxo1, utxo2, utxo3]
      totalBalance utxos `shouldBe` 15000000
  
  describe "Properties" $ do
    it "transaction balance property" $ property $
      prop_txBalanced

-- 运行测试
main :: IO ()
main = hspec spec
```

### 7.5 配置管理

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import Data.Yaml

-- 配置文件结构
data Config = Config
  { blockfrost :: BlockfrostConfig
  , network    :: NetworkConfig
  , logging    :: LogConfig
  } deriving (Show, Generic, FromJSON, ToJSON)

data BlockfrostConfig = BlockfrostConfig
  { apiKey  :: T.Text
  , testnet :: Bool
  } deriving (Show, Generic, FromJSON, ToJSON)

data NetworkConfig = NetworkConfig
  { networkMagic :: Int
  , protocolMagic :: Int
  } deriving (Show, Generic, FromJSON, ToJSON)

data LogConfig = LogConfig
  { logLevel :: String
  , logFile  :: Maybe FilePath
  } deriving (Show, Generic, FromJSON, ToJSON)

-- 加载配置
loadConfig :: FilePath -> IO (Either String Config)
loadConfig path = do
  content <- BS.readFile path
  return $ first show $ decodeEither' content

-- 示例配置文件 (config.yaml)
{-
blockfrost:
  apiKey: "testnetXXXXXXXXXXXXXXXX"
  testnet: true

network:
  networkMagic: 1
  protocolMagic: 764824073

logging:
  logLevel: "info"
  logFile: "app.log"
-}

-- 使用配置
main :: IO ()
main = do
  configResult <- loadConfig "config.yaml"
  case configResult of
    Left err -> putStrLn $ "配置错误: " ++ err
    Right config -> do
      -- 使用配置运行应用
      runApp config
```

### 7.6 缓存和性能

```haskell
import qualified Data.Map as Map
import Data.IORef
import System.IO.Unsafe (unsafePerformIO)

-- 简单的内存缓存
type Cache k v = IORef (Map.Map k v)

newCache :: IO (Cache k v)
newCache = newIORef Map.empty

-- 带缓存的查询
cachedQuery
  :: Ord k
  => Cache k v
  -> k
  -> IO v
  -> IO v
cachedQuery cache key action = do
  cacheMap <- readIORef cache
  case Map.lookup key cacheMap of
    Just value -> return value  -- 缓存命中
    Nothing -> do
      value <- action           -- 执行查询
      modifyIORef cache (Map.insert key value)
      return value

-- 示例：缓存地址查询
{-# NOINLINE addressCache #-}
addressCache :: Cache T.Text AddressInfo
addressCache = unsafePerformIO newCache

getAddressInfoCached :: BlockfrostConfig -> T.Text -> IO AddressInfo
getAddressInfoCached config addr =
  cachedQuery addressCache addr $ do
    result <- getAddressInfo config addr
    case result of
      Left err -> error err
      Right info -> return info
```

### 7.7 日志记录

```haskell
import System.Log.Logger
import System.Log.Handler.Simple
import System.Log.Handler (setFormatter)
import System.Log.Formatter

-- 设置日志
setupLogging :: LogLevel -> Maybe FilePath -> IO ()
setupLogging level maybeFile = do
  -- 设置根日志级别
  updateGlobalLogger rootLoggerName (setLevel level)
  
  -- 添加文件处理器
  case maybeFile of
    Nothing -> return ()
    Just file -> do
      handler <- fileHandler file level
      let formatted = setFormatter handler (simpleLogFormatter "[$time $loggername $prio] $msg")
      updateGlobalLogger rootLoggerName (addHandler formatted)

-- 使用日志
logInfo :: String -> IO ()
logInfo = infoM "App"

logError :: String -> IO ()
logError = errorM "App"

logDebug :: String -> IO ()
logDebug = debugM "App"

-- 在应用中使用
main :: IO ()
main = do
  setupLogging INFO (Just "app.log")
  
  logInfo "应用启动"
  
  result <- try someOperation
  case result of
    Left err -> logError $ "操作失败: " ++ show err
    Right _ -> logInfo "操作成功"
```

### 💡 关键要点

1. **aeson + bytestring**：JSON 处理的标准组合
2. **ExceptT**：统一错误处理
3. **CLI 工具**：用 System.Environment 解析参数
4. **测试**：使用 Hspec 和 QuickCheck
5. **配置**：YAML 文件管理配置
6. **缓存**：提高性能，减少 API 调用
7. **日志**：调试和监控

---

## 总结

本周我们学习了：

1. **为什么 Cardano 使用 Haskell**
   - 函数式编程的安全性
   - 类型系统的正确性保证
   - 适合区块链的特性

2. **Cardano 架构**
   - 节点结构（共识、账本、网络）
   - 链上 vs 链下编程
   - Haskell 在生态中的角色

3. **eUTxO 模型**
   - UTXO vs 账户模型
   - Extended UTXO 的优势
   - 交易的并行处理

4. **交易结构**
   - 输入、输出、费用
   - 交易平衡
   - 元数据

5. **cardano-api**
   - 类型安全的 API
   - 构建和签名交易
   - 序列化

6. **查询 Cardano**
   - Blockfrost API
   - HTTP 请求（req 库）
   - 错误处理

7. **实用模式**
   - JSON 处理
   - 错误处理（ExceptT）
   - CLI 工具
   - 测试和配置

### 下一步

- 完成本周练习
- 构建自己的 Cardano 工具
- 准备 Week 8 结课项目

记住：**本周的重点是用 Haskell 处理 Cardano 数据，而不是智能合约编程**。你学到的技能可以应用于各种区块链相关的工具和应用！

---

**恭喜你完成 Week 7 的学习！现在去完成练习吧！** 🎉

