# 设计决策说明

本文档解释项目中的关键设计决策、权衡考虑和替代方案。

---

## 📋 目录

1. [错误处理策略](#错误处理策略)
2. [类型设计](#类型设计)
3. [数据持久化](#数据持久化)
4. [API 设计](#api-设计)
5. [模块组织](#模块组织)
6. [并发策略](#并发策略)
7. [配置管理](#配置管理)
8. [测试策略](#测试策略)
9. [性能考虑](#性能考虑)
10. [安全性](#安全性)

---

## 错误处理策略

### 决策：使用 ExceptT 而不是异常

**选择**: `ExceptT Error IO` monad

**理由**:
1. **类型安全**: 错误在类型系统中明确表示
2. **可组合性**: 易于链式操作和错误传播
3. **控制流**: 显式的错误处理，避免意外异常
4. **测试友好**: 更容易测试错误情况

**替代方案**:

#### 方案 A: 直接使用 IO 异常
```haskell
-- ❌ 不推荐
readConfig :: FilePath -> IO Config
readConfig path = do
  content <- readFile path  -- 可能抛出异常
  parseConfig content       -- 可能抛出异常
```

**缺点**:
- 异常类型不在签名中
- 容易遗漏异常处理
- 测试困难

#### 方案 B: 嵌套的 Either
```haskell
-- ❌ 不推荐
readConfig :: FilePath -> IO (Either Error Config)
readConfig path = do
  contentResult <- try $ readFile path
  case contentResult of
    Left err -> return $ Left (FileError err)
    Right content -> do
      parseResult <- parseConfig content
      case parseResult of
        Left err -> return $ Left (ParseError err)
        Right config -> return $ Right config
```

**缺点**:
- 嵌套层次深
- 样板代码多
- 可读性差

#### 方案 C: ExceptT（推荐）
```haskell
-- ✅ 推荐
readConfig :: FilePath -> ExceptT Error IO Config
readConfig path = do
  content <- liftIO $ readFile path
  parseConfig content
```

**优点**:
- 清晰的控制流
- 自动错误传播
- 类型安全

### 何时使用异常

某些情况下，IO 异常是合适的：

```haskell
-- ✅ 系统级错误可以使用异常
withFile :: FilePath -> (Handle -> IO a) -> IO a
withFile path action = bracket
  (openFile path ReadMode)  -- 可能抛出 IOException
  hClose
  action
```

**适用场景**:
- 系统资源分配失败（文件、网络、内存）
- 不可恢复的错误
- 使用已有的标准库（如 `bracket`）

---

## 类型设计

### 决策：使用 newtype 包装原始类型

**选择**: `newtype Address = Address { getAddress :: String }`

**理由**:
1. **类型安全**: 防止混用不同概念的字符串
2. **零成本**: newtype 在运行时没有开销
3. **可扩展性**: 易于添加验证和约束

**示例**:

```haskell
-- ✅ 推荐
newtype Address = Address { getAddress :: String }
newtype TxHash = TxHash { getTxHash :: String }
newtype Lovelace = Lovelace { getLovelace :: Integer }

-- 这会报类型错误（好事！）
mixup :: Address -> TxHash -> Bool
mixup addr hash = addr == hash  -- 类型错误！
```

**对比**:

```haskell
-- ❌ 不推荐
type Address = String
type TxHash = String

-- 这不会报错（坏事！）
mixup :: Address -> TxHash -> Bool
mixup addr hash = addr == hash  -- 不会报错，但逻辑错误
```

### 决策：使用 data 而不是多个 newtype

**何时使用 data**:

```haskell
-- ✅ 推荐：多个字段
data Transaction = Transaction
  { txInputs :: [UTxO]
  , txOutputs :: [TxOut]
  , txFee :: Lovelace
  }

-- ❌ 不推荐：元组
type Transaction = ([UTxO], [TxOut], Lovelace)
```

**理由**:
- 命名字段更清晰
- 易于扩展（添加字段）
- 更好的错误消息

### 决策：deriving Generic for JSON

**选择**: 使用 `Generic` 自动派生 JSON 实例

```haskell
{-# LANGUAGE DeriveGeneric #-}

data Config = Config
  { cfgAPI :: APIConfig
  , cfgDatabase :: DatabaseConfig
  } deriving (Generic, Show)

instance FromJSON Config
instance ToJSON Config
```

**理由**:
1. 减少样板代码
2. 自动处理字段名映射
3. 保持一致性

**何时手动实现**:

```haskell
-- 需要自定义字段名或复杂逻辑
instance FromJSON Config where
  parseJSON = withObject "Config" $ \obj -> do
    -- 自定义解析逻辑
    apiKey <- obj .: "api_key"  -- 下划线分隔
    return $ Config apiKey
```

---

## 数据持久化

### 决策：JSON vs YAML vs SQLite

| 格式 | 使用场景 | 优点 | 缺点 |
|------|----------|------|------|
| **JSON** | 应用状态 | 简单、快速、标准 | 不易人工编辑 |
| **YAML** | 配置文件 | 人类可读、支持注释 | 解析较慢 |
| **SQLite** | 大量数据、查询 | 强大查询、事务 | 复杂、二进制 |

**决策**:
- ✅ 应用状态 → JSON
- ✅ 配置文件 → YAML
- ❌ 不使用 SQLite（简化项目）

### 决策：自动备份策略

**选择**: 保存时自动创建备份

```haskell
saveState :: FilePath -> State -> IO ()
saveState path state = do
  -- 1. 备份旧文件
  exists <- doesFileExist path
  when exists $ do
    now <- getCurrentTime
    let backup = path ++ ".backup." ++ formatTime now
    copyFile path backup
  
  -- 2. 保存新文件
  encodeFile path state
  
  -- 3. 清理旧备份（保留最近 5 个）
  cleanOldBackups path 5
```

**理由**:
- 防止数据丢失
- 无需用户干预
- 磁盘占用可控

**替代方案**:

#### 方案 A: 不备份
- ❌ 风险太高

#### 方案 B: 用户手动备份
- ❌ 容易忘记

#### 方案 C: Git 式版本控制
- ❌ 过于复杂

---

## API 设计

### 决策：使用 req 库而不是 http-conduit

**选择**: `req` 库

**理由**:
1. **类型安全**: URL 类型安全
2. **简单**: 更少的样板代码
3. **现代**: 默认 HTTPS

**对比**:

```haskell
-- ✅ req (推荐)
response <- req GET
  (https "api.blockfrost.io" /: "api" /: "v0" /: "addresses" /: addr)
  NoReqBody
  jsonResponse
  (header "project_id" apiKey)

-- ❌ http-conduit（更复杂）
request <- parseRequest $ "https://api.blockfrost.io/api/v0/addresses/" ++ addr
let request' = request
      { requestHeaders = [("project_id", apiKey)]
      }
response <- httpJSON request'
```

### 决策：API 重试策略

**选择**: 指数退避 + 最大重试次数

```haskell
retryConfig :: RetryConfig
retryConfig = RetryConfig
  { maxRetries = 3
  , initialDelay = 1000000  -- 1s
  , backoffFactor = 2.0     -- 1s, 2s, 4s
  , maxDelay = 30000000     -- 30s
  }
```

**理由**:
- 处理临时网络问题
- 避免 API 限流（429）
- 防止服务器过载

**权衡**:
- ✅ 提高可靠性
- ⚠️ 增加延迟
- ⚠️ 可能掩盖真正的问题

---

## 模块组织

### 决策：按功能分模块

**选择**: 功能导向的模块结构

```
Wallet/
├── Types.hs       -- 所有类型定义
├── Address.hs     -- 地址相关
├── Balance.hs     -- 余额查询
├── Transaction.hs -- 交易构建
├── API.hs         -- API 调用
├── Storage.hs     -- 持久化
└── CLI.hs         -- 命令行
```

**理由**:
- 清晰的职责划分
- 易于查找代码
- 避免循环依赖

**替代方案**:

#### 方案 A: 按层分模块
```
Wallet/
├── Domain/       -- 领域模型
├── Infrastructure/  -- 基础设施
└── Application/  -- 应用逻辑
```
- ❌ 对小项目过于复杂

#### 方案 B: 单文件
```
Wallet.hs  -- 所有代码
```
- ❌ 难以维护

### 模块依赖原则

```
Types  ←  所有模块都依赖
  ↑
  │
Address, Balance, Transaction  ←  业务逻辑（相互独立）
  ↑
  │
API  ←  外部依赖
  ↑
  │
CLI  ←  用户接口（依赖所有模块）
```

**规则**:
1. ✅ Types 不依赖其他模块
2. ✅ 业务逻辑模块相互独立
3. ✅ CLI 位于最上层
4. ❌ 避免循环依赖

---

## 并发策略

### 决策：监控器使用串行查询

**选择**: 串行查询 + 短延迟

```haskell
queryAllBalances :: [Address] -> IO [(Address, Balance)]
queryAllBalances addrs = forM addrs $ \addr -> do
  balance <- queryBalance addr
  threadDelay 100000  -- 100ms 延迟
  return (addr, balance)
```

**理由**:
- 简单实现
- 避免 API 限流
- 足够快（每地址 100ms）

**替代方案**:

#### 方案 A: 完全并发
```haskell
queryAllBalances addrs = mapConcurrently queryBalance addrs
```
- ❌ 容易触发 API 限流
- ❌ 可能被 ban

#### 方案 B: 有限并发
```haskell
queryAllBalances addrs = pooledMapConcurrently 5 queryBalance addrs
```
- ✅ 可选的高级功能
- ⚠️ 增加复杂度

### 决策：使用 async 而不是 forkIO

**选择**: `async` 库

```haskell
results <- mapConcurrently queryBalance addrs
```

**理由**:
- 自动异常传播
- 结果收集简单
- 取消和超时支持

---

## 配置管理

### 决策：YAML + 环境变量

**选择**: 分层配置

```haskell
loadConfig :: FilePath -> IO Config
loadConfig path = do
  -- 1. 加载文件配置
  fileConfig <- decodeFileEither path
  
  -- 2. 环境变量覆盖
  apiKey <- lookupEnv "API_KEY"
  
  -- 3. 合并配置
  return $ mergeConfig fileConfig apiKey
```

**优先级**: 环境变量 > 配置文件 > 默认值

**理由**:
- 环境变量适合敏感信息（API key）
- 配置文件适合复杂配置
- 默认值提供开箱即用体验

### 决策：配置验证时机

**选择**: 启动时验证

```haskell
main :: IO ()
main = do
  config <- loadConfig "config.yaml"
  case validateConfig config of
    Left err -> do
      putStrLn $ "Config error: " ++ err
      exitFailure
    Right validConfig -> 
      runApp validConfig
```

**理由**:
- 快速失败原则
- 避免运行时错误
- 清晰的错误消息

---

## 测试策略

### 决策：单元测试 + 集成测试

**选择**: Hspec + QuickCheck

```haskell
spec :: Spec
spec = do
  describe "单元测试" $ do
    describe "UTxO selection" $ do
      it "selects sufficient UTxOs" $ property $
        \(Positive amount) utxos ->
          let result = selectInputs amount utxos
          in isRight result ==> sum (map utxoAmount result) >= amount
  
  describe "集成测试" $ do
    it "can query real API" $ do
      -- 使用测试 API key
      result <- queryBalance testConfig testAddress
      result `shouldSatisfy` isRight
```

**测试金字塔**:
```
        /\
       /  \  集成测试（少量）
      /    \
     /      \
    /________\ 单元测试（大量）
```

### 决策：模拟 vs 真实 API

**选择**: 两者都用

```haskell
-- 开发时：模拟数据
testWithMock :: Spec
testWithMock = do
  it "handles mock response" $ do
    let mockResponse = "{\"balance\": 1000000}"
    result <- parseBalance mockResponse
    result `shouldBe` Lovelace 1000000

-- CI/CD：真实 API（有限）
testWithRealAPI :: Spec
testWithRealAPI = do
  it "queries real API" $ do
    apiKey <- getEnv "TEST_API_KEY"
    result <- queryBalance testConfig testAddress
    result `shouldSatisfy` isRight
```

---

## 性能考虑

### 决策：不过早优化

**原则**: 先正确，后快速

**优化顺序**:
1. ✅ 算法复杂度（O(n) vs O(n²)）
2. ✅ 数据结构选择（List vs Map）
3. ⚠️ 并发优化（需要时）
4. ❌ 微优化（不必要）

### 何时使用 Map

```haskell
-- ✅ 频繁查找 → Map
type AddressCache = Map Address Balance

-- ✅ 顺序遍历 → List
type MonitoredAddresses = [MonitoredAddress]
```

### 决策：懒惰 vs 严格

**选择**: 默认懒惰，必要时严格

```haskell
-- ✅ 懒惰：适合大文件
processLines :: FilePath -> IO ()
processLines path = do
  content <- readFile path
  mapM_ processLine (lines content)

-- ✅ 严格：避免空间泄漏
sumList :: [Integer] -> Integer
sumList = foldl' (+) 0  -- 使用 foldl'，不是 foldl
```

---

## 安全性

### 决策：不在代码中硬编码 API Key

**选择**: 环境变量或配置文件

```haskell
-- ❌ 不要这样
apiKey = "project123abc..."  -- 硬编码

-- ✅ 推荐
apiKey <- lookupEnv "BLOCKFROST_API_KEY"
```

### 决策：地址验证

**选择**: 总是验证用户输入

```haskell
validateAddress :: String -> Either Error Address
validateAddress addr
  | "addr_test1" `isPrefixOf` addr = Right (Address addr)
  | "addr1" `isPrefixOf` addr = Left MainnetNotSupported
  | otherwise = Left InvalidAddressFormat
```

### 决策：不存储私钥

**原则**: 这些项目不处理私钥

**理由**:
- 教学项目
- 降低安全风险
- 简化实现

---

## 📊 决策矩阵示例

### API 库选择

| 标准 | req | http-conduit | wreq | 得分 |
|------|-----|--------------|------|------|
| 易用性 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | req 胜 |
| 类型安全 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | req 胜 |
| 性能 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 持平 |
| 文档 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | req 胜 |
| 社区 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 持平 |

**结论**: 选择 `req`（易用性和类型安全优先）

---

## 💡 经验教训

### 已证明的好决策

1. ✅ **使用 ExceptT**: 大大简化了错误处理
2. ✅ **newtype 包装**: 捕获了很多类型错误
3. ✅ **自动备份**: 拯救了多次数据
4. ✅ **配置验证**: 早期发现配置错误

### 需要改进的决策

1. ⚠️ **串行 API 查询**: 可以优化为有限并发
2. ⚠️ **内存缓存**: 可以添加缓存层
3. ⚠️ **日志**: 应该更结构化

### 避免的陷阱

1. ❌ 过早优化
2. ❌ 过度抽象
3. ❌ 忽略错误处理
4. ❌ 不写测试

---

## 🎓 学习建议

### 对于初学者

1. **先理解为什么**: 不要只复制代码
2. **实验不同方案**: 尝试替代设计
3. **从简单开始**: 先让它工作，再优化
4. **阅读错误消息**: Haskell 编译器很友好

### 对于进阶者

1. **考虑权衡**: 没有完美的设计
2. **测量性能**: 不要猜测瓶颈
3. **重构代码**: 设计会演进
4. **学习模式**: 识别常见模式

---

**记住**: 这些决策基于教学目的和项目规模。生产环境可能需要不同的权衡。

