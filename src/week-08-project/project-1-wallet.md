# 项目 1: 命令行钱包工具 💼

## 项目概述

构建一个命令行 Cardano 钱包工具，支持地址管理、余额查询和交易构建（模拟）。

### 目标用户

- Cardano 开发者
- 学习区块链的学生
- 需要快速查询工具的用户

### 关键特性

- 🔑 地址生成和管理
- 💰 余额查询（通过 Blockfrost API）
- 📊 UTxO 查看
- 📝 交易构建（模拟）
- 💾 钱包状态持久化
- 🖥️ 友好的命令行界面

### 技术栈

- **语言**: Haskell
- **库**: aeson, req, bytestring, mtl, containers
- **API**: Blockfrost (测试网)
- **构建**: Cabal

---

## 功能需求

### 必需功能 (Must-Have)

#### 1. 地址管理 (20%)

**功能描述**:
- 生成新地址（模拟，使用随机字符串）
- 列出所有保存的地址
- 为地址添加标签/备注
- 删除地址

**命令**:
```bash
wallet generate [label]        # 生成新地址
wallet list                     # 列出所有地址
wallet label <addr> <label>    # 添加标签
wallet delete <addr>            # 删除地址
```

**验收标准**:
- [ ] 可以生成至少 10 个地址
- [ ] 地址格式符合 `addr_test1...` 模式
- [ ] 地址列表清晰显示（地址 + 标签）
- [ ] 删除操作有确认提示

**实现提示**:
```haskell
-- 模拟地址生成（不是真实的加密）
generateAddress :: IO Address
generateAddress = do
  randomPart <- replicateM 50 randomChar
  return $ Address $ "addr_test1q" ++ randomPart

-- 地址数据结构
data AddressInfo = AddressInfo
  { address :: Address
  , label   :: Maybe String
  , created :: UTCTime
  } deriving (Generic, ToJSON, FromJSON)
```

#### 2. 余额查询 (25%)

**功能描述**:
- 查询单个地址余额
- 查询所有地址总余额
- 显示 ADA 和 Lovelace
- 支持刷新（重新查询）

**命令**:
```bash
wallet balance <addr>          # 查询特定地址
wallet balance --all           # 查询所有地址
wallet refresh                 # 刷新所有余额
```

**验收标准**:
- [ ] 正确查询 Blockfrost API
- [ ] 显示格式友好（如 "10.523000 ADA"）
- [ ] 处理 API 错误（网络、限流等）
- [ ] 有加载提示

**实现提示**:
```haskell
-- API 查询
queryBalance :: Config -> Address -> IO (Either Error Lovelace)
queryBalance config addr = runExceptT $ do
  response <- liftIO $ callBlockfrost config addr
  parseBalance response

-- 格式化显示
displayBalance :: Address -> Lovelace -> IO ()
displayBalance addr lovelace = do
  let ada = lovelaceToAda lovelace
  putStrLn $ formatAddress addr ++ ": " ++ show ada ++ " ADA"
```

#### 3. UTxO 查看 (15%)

**功能描述**:
- 查询地址的所有 UTxOs
- 显示每个 UTxO 的详情
- 计算总金额

**命令**:
```bash
wallet utxos <addr>            # 查看 UTxOs
wallet utxos <addr> --detailed # 详细信息
```

**验收标准**:
- [ ] 显示 UTxO 列表（TxHash#Index）
- [ ] 显示每个 UTxO 的金额
- [ ] 计算并显示总额
- [ ] 格式清晰易读

**实现提示**:
```haskell
data UTxO = UTxO
  { utxoRef    :: TxOutRef      -- TxHash + Index
  , utxoAmount :: Lovelace
  , utxoAddr   :: Address
  } deriving (Show, Generic, FromJSON)

displayUTxOs :: [UTxO] -> IO ()
displayUTxOs utxos = do
  putStrLn "UTxO List:"
  forM_ utxos $ \utxo -> do
    putStrLn $ "  " ++ show (utxoRef utxo) 
            ++ " -> " ++ show (utxoAmount utxo)
  putStrLn $ "Total: " ++ show (sum $ map utxoAmount utxos)
```

#### 4. 交易构建 (模拟) (20%)

**功能描述**:
- 构建简单支付交易
- 显示交易详情（输入、输出、费用）
- 保存交易到文件（JSON 格式）
- **注意**: 这是模拟，不提交到区块链

**命令**:
```bash
wallet send <from> <to> <amount>     # 构建交易
wallet tx-info <file>                # 查看交易详情
```

**验收标准**:
- [ ] 选择合适的 UTxOs 作为输入
- [ ] 计算正确的找零
- [ ] 估算交易费用
- [ ] 验证交易平衡
- [ ] 保存为 JSON 文件

**实现提示**:
```haskell
buildTransaction 
  :: Address      -- From
  -> Address      -- To
  -> Lovelace     -- Amount
  -> [UTxO]       -- Available UTxOs
  -> Either Error Transaction

-- 验证交易
validateTransaction :: Transaction -> Either Error ()
validateTransaction tx =
  let inputs = sum $ map utxoAmount (txInputs tx)
      outputs = sum $ map txOutAmount (txOutputs tx)
      fee = txFee tx
  in if inputs == outputs + fee
       then Right ()
       else Left $ BalanceError "Transaction not balanced"
```

#### 5. 状态持久化 (10%)

**功能描述**:
- 保存地址列表到文件
- 保存余额缓存
- 加载已保存的状态

**命令**:
```bash
wallet save                    # 保存当前状态
wallet load                    # 加载状态（自动）
```

**验收标准**:
- [ ] 使用 JSON 格式保存
- [ ] 程序启动时自动加载
- [ ] 处理文件不存在的情况
- [ ] 备份旧文件

**实现提示**:
```haskell
data WalletState = WalletState
  { addresses :: [AddressInfo]
  , cache     :: Map Address BalanceInfo
  , lastUpdate :: UTCTime
  } deriving (Generic, ToJSON, FromJSON)

saveState :: FilePath -> WalletState -> IO ()
saveState path state = 
  BSL.writeFile path (encodePretty state)

loadState :: FilePath -> IO (Either String WalletState)
loadState path = eitherDecode <$> BSL.readFile path
```

#### 6. CLI 界面 (10%)

**功能描述**:
- 清晰的命令行参数解析
- 帮助信息
- 错误提示
- 进度反馈

**命令**:
```bash
wallet help                    # 显示帮助
wallet version                 # 显示版本
```

**验收标准**:
- [ ] 所有命令有帮助文本
- [ ] 无效命令有提示
- [ ] 操作有确认（如删除）
- [ ] 长时间操作有进度提示

**实现提示**:
```haskell
parseCommand :: [String] -> Either String Command
parseCommand ["generate"] = Right Generate
parseCommand ["generate", label] = Right $ GenerateLabeled label
parseCommand ["balance", addr] = Right $ QueryBalance (Address addr)
parseCommand _ = Left "Unknown command"

showHelp :: IO ()
showHelp = putStrLn $ unlines
  [ "Cardano Wallet Tool"
  , ""
  , "Commands:"
  , "  generate [label]           Generate new address"
  , "  list                       List all addresses"
  , "  balance <addr>             Query balance"
  , "  ..."
  ]
```

### 可选功能 (Optional)

#### 1. 交易历史 (Extra 5%)
- 查询地址的交易历史
- 显示最近 N 笔交易
- 按时间排序

#### 2. 多钱包支持 (Extra 5%)
- 创建多个钱包
- 切换当前钱包
- 每个钱包独立状态

#### 3. 导出功能 (Extra 5%)
- 导出地址列表为 CSV
- 导出交易记录
- 导出余额报告

#### 4. 配置文件 (Extra 5%)
- YAML 配置文件
- 自定义 API endpoint
- 自定义数据目录

---

## 技术要求

### 依赖库

```cabal
build-depends:
    base ^>=4.18
  , aeson ^>=2.1
  , text ^>=2.0
  , bytestring ^>=0.11
  , req ^>=3.13
  , mtl ^>=2.3
  , containers ^>=0.6
  , time ^>=1.12
  , random ^>=1.2
```

### 模块结构

```
src/
├── Wallet/
│   ├── Types.hs          -- 数据类型
│   ├── Address.hs        -- 地址操作
│   ├── Balance.hs        -- 余额查询
│   ├── Transaction.hs    -- 交易构建
│   ├── Storage.hs        -- 状态持久化
│   ├── API.hs            -- Blockfrost API
│   └── CLI.hs            -- 命令行解析
└── Wallet.hs             -- 主模块
```

### 配置需求

**config.yaml**:
```yaml
api:
  endpoint: https://cardano-testnet.blockfrost.io
  key: testnetXXXXXXXXXXXX  # 你的 API Key
  
wallet:
  data_dir: ~/.cardano-wallet
  cache_ttl: 300  # 缓存5分钟
```

### 错误处理

```haskell
data WalletError
  = APIError String
  | FileError IOException
  | ValidationError String
  | NetworkError String
  | ParseError String
  deriving (Show, Typeable)

instance Exception WalletError

type WalletM = ExceptT WalletError IO
```

---

## 实施路线图

### Phase 1: 基础结构 (2小时)

**任务**:
1. 设置 Cabal 项目
2. 定义核心数据类型
3. 实现 CLI 参数解析
4. 创建基本的 help 命令

**检查点**:
- [ ] `cabal build` 成功
- [ ] `wallet help` 显示帮助
- [ ] 所有类型定义完成

### Phase 2: API 集成 (2小时)

**任务**:
1. 实现 Blockfrost API 调用
2. 解析 API 响应
3. 错误处理
4. 测试 API 查询

**检查点**:
- [ ] 能够查询测试地址余额
- [ ] 能够获取 UTxO 列表
- [ ] API 错误被正确处理

### Phase 3: 核心功能 (2-3小时)

**任务**:
1. 实现地址生成
2. 实现余额查询
3. 实现 UTxO 查看
4. 实现状态保存/加载

**检查点**:
- [ ] 所有必需功能正常工作
- [ ] 数据能够持久化
- [ ] 错误处理到位

### Phase 4: 交易构建 (2小时)

**任务**:
1. 实现 UTxO 选择算法
2. 计算费用
3. 构建交易结构
4. 验证交易
5. 保存交易文件

**检查点**:
- [ ] 能够构建简单支付交易
- [ ] 交易验证通过
- [ ] 交易保存为 JSON

### Phase 5: 完善 (1-2小时)

**任务**:
1. 改进用户界面
2. 添加进度提示
3. 完善错误消息
4. 编写文档
5. 测试边界情况

**检查点**:
- [ ] 用户体验流畅
- [ ] 所有功能测试通过
- [ ] README 完整

---

## 评估标准

### 功能完整性 (60分)

| 功能 | 分值 | 评分标准 |
|------|------|----------|
| 地址管理 | 12 | 生成、列表、标签、删除都正常工作 |
| 余额查询 | 15 | API 调用成功，显示正确，错误处理 |
| UTxO 查看 | 9 | 显示清晰，计算正确 |
| 交易构建 | 12 | 构建逻辑正确，验证通过 |
| 状态持久化 | 6 | 保存/加载正常 |
| CLI 界面 | 6 | 帮助清晰，错误友好 |

### 代码质量 (20分)

- **模块组织** (8分): 结构清晰，职责分明
- **命名** (4分): 变量、函数名清晰
- **类型签名** (4分): 所有导出函数有签名
- **注释** (4分): 关键部分有说明

### 测试 (10分)

- **单元测试** (5分): 至少 3-5 个测试
- **手动测试** (5分): 测试文档或演示

### 用户体验 (10分)

- **帮助信息** (3分): 清晰完整
- **错误消息** (3分): 友好易懂
- **操作反馈** (2分): 进度提示
- **文档** (2分): README 完整

---

## 起步代码

起步代码位于：`exercises/week-08/projects/wallet-tool/`

包含：
- 完整的 Cabal 配置
- 所有模块的框架
- 数据类型定义
- TODO 标记的实现位置
- 示例测试

**开始步骤**:
```bash
cd exercises/week-08/projects/wallet-tool
cabal build
cabal run wallet-tool -- help
```

查看 `TASKS.md` 获取详细的任务清单。

---

## 示例用法

### 基本流程

```bash
# 1. 生成地址
$ wallet generate "My First Address"
Generated: addr_test1q...abc123
Label: My First Address

# 2. 查看所有地址
$ wallet list
1. addr_test1q...abc123  [My First Address]
2. addr_test1q...def456  [Testing]

# 3. 查询余额
$ wallet balance addr_test1q...abc123
Querying balance...
Address: addr_test1q...abc123
Balance: 100.000000 ADA (100000000 Lovelace)

# 4. 查看 UTxOs
$ wallet utxos addr_test1q...abc123
UTxO List:
  abc...#0 -> 50.000000 ADA
  def...#1 -> 50.000000 ADA
Total: 100.000000 ADA

# 5. 构建交易
$ wallet send addr_test1q...abc123 addr_test1q...xyz789 10.0
Building transaction...
From: addr_test1q...abc123
To: addr_test1q...xyz789
Amount: 10.000000 ADA
Fee: 0.170000 ADA
Change: 39.830000 ADA
Transaction saved to: tx_20250120_153045.json

# 6. 保存状态
$ wallet save
State saved successfully
```

---

## 常见问题

**Q: 必须使用真实的 Blockfrost API 吗？**  
A: 建议使用，但也可以用 mock 数据测试基本功能。

**Q: 地址生成必须是加密安全的吗？**  
A: 不需要，这是模拟项目。使用随机字符串即可。

**Q: 交易会提交到区块链吗？**  
A: 不会！这只是构建和验证交易结构，不会提交。

**Q: 需要实现所有可选功能吗？**  
A: 不需要。完成必需功能即可获得满分。

---

## 资源链接

- [Implementation Guide](guide.md)
- [Evaluation Criteria](evaluation.md)
- [Showcase Guide](showcase.md)
- [Week 7 Blockfrost Examples](../week-07-cardano/exercises.md)

---

**准备好开始了吗？** 📝

1. 阅读 [Implementation Guide](guide.md)
2. 进入 `exercises/week-08/projects/wallet-tool/`
3. 查看 `TASKS.md`
4. 开始编码！

祝你成功！💪

