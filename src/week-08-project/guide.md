# Week 8: 项目实施指南

本指南提供实用的建议和技巧，帮助你成功完成结课项目。

---

## 1. 项目规划

### 1.1 理解需求

在开始编码前，确保你清楚理解项目要求：

**清单**：
- [ ] 阅读完整的项目规格书
- [ ] 理解所有必需功能
- [ ] 了解可选功能（如果时间允许）
- [ ] 明确技术限制和约束

**技巧**：
- 用自己的话复述每个功能需求
- 画出用户交互流程图
- 列出功能的优先级

### 1.2 分解任务

将大项目分解为小任务：

**示例（钱包工具）**：
```
Phase 1: 基础结构（2小时）
├─ 设置 Cabal 项目
├─ 定义核心数据类型
└─ 实现基础 CLI 框架

Phase 2: 核心功能（3-4小时）
├─ 地址生成（模拟）
├─ Blockfrost API 集成
├─ 余额查询
└─ UTxO 显示

Phase 3: 高级功能（2小时）
├─ 交易构建（模拟）
├─ 状态持久化
└─ 错误处理完善

Phase 4: 完善（1-2小时）
├─ 测试
├─ 文档
└─ 用户体验优化
```

**使用 TASKS.md**：
项目目录中的 `TASKS.md` 提供了详细的任务清单，照着做即可。

### 1.3 设计模块结构

好的模块结构是成功的一半：

**原则**：
- **单一职责**：每个模块做一件事
- **清晰命名**：模块名反映其功能
- **依赖管理**：避免循环依赖

**典型结构（钱包工具）**：
```
Wallet/
├── Types.hs          -- 数据类型定义
├── Address.hs        -- 地址相关操作
├── Balance.hs        -- 余额查询
├── Transaction.hs    -- 交易构建
└── CLI.hs            -- 用户界面
```

**模块间关系**：
```
       Types  (被所有模块使用)
         ↑
    ┌────┼────┐
    ↓    ↓    ↓
Address Balance Transaction  (核心逻辑)
    └────┼────┘
         ↓
        CLI  (用户接口)
```

### 1.4 规划错误处理

提前设计错误处理策略：

**定义错误类型**：
```haskell
data WalletError
  = APIError String
  | FileError IOException
  | ValidationError String
  | NetworkError String
  deriving (Show)

type WalletM = ExceptT WalletError IO
```

**错误处理模式**：
- **IO 错误**：使用 `try` 捕获
- **API 错误**：解析 HTTP 状态码
- **验证错误**：返回 `Either` 或 `Maybe`
- **组合错误**：使用 `ExceptT`

### 1.5 测试策略

**测试层次**：
1. **单元测试**：测试单个函数
2. **集成测试**：测试模块间交互
3. **手动测试**：测试用户流程

**What to test**：
- 数据解析和序列化
- 错误处理逻辑
- 业务规则验证
- 边界情况

---

## 2. 实施技巧

### 2.1 Weeks 1-7 知识复习

**Week 1-2: 基础语法**
```haskell
-- 使用高阶函数简化代码
processAddresses = map formatAddress . filter isValid

-- 模式匹配处理不同情况
handleCommand :: Command -> IO ()
handleCommand (AddAddress addr) = addAddress addr
handleCommand (CheckBalance addr) = checkBalance addr
handleCommand Help = showHelp
```

**Week 3: 类型类**
```haskell
-- 利用 FromJSON/ToJSON 自动派生
data Config = Config
  { apiKey :: String
  , addresses :: [String]
  } deriving (Generic, FromJSON, ToJSON)
```

**Week 4: Monad 和 IO**
```haskell
-- 使用 do-notation 组织 IO 操作
processAddresses :: [Address] -> IO ()
processAddresses addrs = do
  putStrLn "Querying balances..."
  balances <- mapM queryBalance addrs
  mapM_ printBalance balances
```

**Week 5: 模块和库**
```haskell
-- 使用 aeson 解析 JSON
parseConfig :: FilePath -> IO (Either String Config)
parseConfig path = eitherDecode <$> BSL.readFile path

-- 使用 req 调用 API
queryAPI endpoint = runReq defaultHttpConfig $ do
  req GET url NoReqBody jsonResponse headers
```

**Week 6: 错误处理**
```haskell
-- 使用 ExceptT 组合错误
loadAndProcess :: FilePath -> ExceptT AppError IO Result
loadAndProcess path = do
  config <- loadConfig path
  data' <- fetchData (apiKey config)
  processData data'
```

**Week 7: Cardano**
```haskell
-- 解析 Cardano 交易
parseTx :: Value -> Either String Transaction
-- 查询地址余额
queryBalance :: Address -> IO (Either Error Integer)
-- 构建交易
buildTx :: [UTxO] -> Address -> Lovelace -> Either Error TxBody
```

### 2.2 Cardano 最佳实践

**API 调用**：
```haskell
-- 添加重试逻辑
requestWithRetry :: Int -> IO (Either Error a) -> IO (Either Error a)
requestWithRetry 0 action = action
requestWithRetry n action = do
  result <- action
  case result of
    Left err -> do
      threadDelay 1000000  -- 等待1秒
      requestWithRetry (n-1) action
    Right val -> return $ Right val

-- 缓存 API 响应
type Cache = Map Address BalanceInfo
queryWithCache :: Cache -> Address -> IO (Either Error BalanceInfo)
```

**数据验证**：
```haskell
-- 验证地址格式
validateAddress :: String -> Either String Address
validateAddress addr
  | "addr_test1" `isPrefixOf` addr = Right (Address addr)
  | "addr1" `isPrefixOf` addr = Left "请使用测试网地址"
  | otherwise = Left "无效的地址格式"

-- 验证金额
validateAmount :: Integer -> Either String Lovelace
validateAmount n
  | n <= 0 = Left "金额必须大于0"
  | n > maxLovelace = Left "金额超出限制"
  | otherwise = Right (Lovelace n)
```

**性能优化**：
```haskell
-- 批量查询
queryMultiple :: [Address] -> IO [Either Error Balance]
queryMultiple addrs = do
  forM addrs $ \addr -> do
    queryBalance addr
    threadDelay 100000  -- 避免速率限制

-- 并发查询（高级）
import Control.Concurrent.Async
queryConcurrent :: [Address] -> IO [Balance]
queryConcurrent addrs = 
  mapConcurrently queryBalance addrs
```

### 2.3 代码组织

**文件结构**：
```
src/
├── Wallet/
│   ├── Types.hs          -- 导出所有类型
│   ├── Address.hs        -- 地址操作
│   ├── Balance.hs        -- 余额查询
│   ├── Transaction.hs    -- 交易构建
│   ├── Storage.hs        -- 数据持久化
│   └── CLI.hs            -- 命令行界面
└── Wallet.hs             -- 主模块，重导出
```

**模块导出**：
```haskell
-- Types.hs: 导出所有类型
module Wallet.Types
  ( Address(..)
  , Balance(..)
  , Transaction(..)
  , WalletError(..)
  ) where

-- Balance.hs: 只导出公共接口
module Wallet.Balance
  ( queryBalance
  , formatBalance
  ) where

-- 不导出内部函数
parseBalanceResponse :: Value -> Either String Balance
parseBalanceResponse = ...  -- 内部使用
```

**配置管理**：
```haskell
-- 使用 YAML 配置文件
data Config = Config
  { cfgApiKey :: String
  , cfgNetwork :: Network
  , cfgTimeout :: Int
  } deriving (Generic, FromJSON, ToJSON)

loadConfig :: FilePath -> IO (Either String Config)
loadConfig = decodeFileEither
```

### 2.4 性能考虑

**常见性能问题**：

1. **重复 API 调用**
   ```haskell
   -- 不好：每次都查询
   showBalance addr = do
     balance <- queryAPI addr
     print balance
   
   -- 好：使用缓存
   showBalance cache addr = do
     balance <- case Map.lookup addr cache of
       Just b -> return b
       Nothing -> queryAPI addr
     print balance
   ```

2. **大量小的 IO 操作**
   ```haskell
   -- 不好：逐个写入
   saveAddresses addrs = mapM_ (\a -> appendFile "addrs.txt" (a ++ "\n")) addrs
   
   -- 好：批量写入
   saveAddresses addrs = writeFile "addrs.txt" (unlines addrs)
   ```

3. **内存泄漏**
   ```haskell
   -- 注意：使用 strict ByteString
   import qualified Data.ByteString.Lazy as BSL  -- lazy
   import qualified Data.ByteString as BS        -- strict
   
   -- 对于大文件，使用 lazy
   processLargeFile = BSL.readFile "large.json"
   -- 对于小数据，使用 strict
   processSmallData = BS.readFile "config.txt"
   ```

---

## 3. 调试和测试

### 3.1 使用 GHCi 调试

**基本调试**：
```haskell
-- 加载模块
ghci> :load src/Wallet/Balance.hs

-- 测试函数
ghci> queryBalance "addr_test1q..."

-- 检查类型
ghci> :type formatBalance
formatBalance :: Integer -> String

-- 查看信息
ghci> :info Balance
```

**高级调试**：
```haskell
-- 使用 Debug.Trace
import Debug.Trace

queryBalance addr = do
  traceM $ "Querying: " ++ addr
  result <- apiCall addr
  traceM $ "Result: " ++ show result
  return result

-- 条件断点（用 error）
validateAmount n
  | n < 0 = error $ "Debug: negative amount " ++ show n
  | otherwise = return n
```

### 3.2 编写测试

**单元测试（Hspec）**：
```haskell
spec :: Spec
spec = do
  describe "Address validation" $ do
    it "accepts testnet addresses" $ do
      validateAddress "addr_test1q..." `shouldSatisfy` isRight
    
    it "rejects mainnet addresses" $ do
      validateAddress "addr1q..." `shouldSatisfy` isLeft
  
  describe "Balance formatting" $ do
    it "formats lovelace to ADA" $ do
      formatBalance 1000000 `shouldBe` "1.000000 ADA"
```

**属性测试（QuickCheck）**：
```haskell
prop_balanceNonNegative :: Integer -> Property
prop_balanceNonNegative n = n >= 0 ==>
  parseBalance n >= Lovelace 0

prop_formatParse :: Integer -> Property
prop_formatParse n = n >= 0 ==>
  parseAmount (formatBalance n) == Right n
```

**手动测试清单**：
```markdown
## 功能测试
- [ ] 地址生成：生成10个地址，验证格式
- [ ] 余额查询：查询已知地址，验证结果
- [ ] 交易构建：构建交易，验证结构
- [ ] 错误处理：测试无效输入

## 边界测试
- [ ] 空输入
- [ ] 超大数值
- [ ] 无效格式
- [ ] 网络错误

## 用户体验
- [ ] 帮助信息清晰
- [ ] 错误提示友好
- [ ] 加载时有提示
```

### 3.3 常见问题

**问题 1: 解析 JSON 失败**
```haskell
-- 调试: 查看原始 JSON
result <- eitherDecode content
case result of
  Left err -> do
    putStrLn "JSON parse error:"
    putStrLn err
    BSL.putStr content  -- 打印原始内容
  Right val -> process val
```

**问题 2: API 调用超时**
```haskell
-- 添加超时处理
import System.Timeout

queryWithTimeout :: Int -> IO a -> IO (Maybe a)
queryWithTimeout seconds action =
  timeout (seconds * 1000000) action
```

**问题 3: 文件读写权限**
```haskell
-- 检查文件权限
import System.Directory

saveData path data' = do
  writable <- writable <$> getPermissions path
  if writable
    then writeFile path data'
    else putStrLn "Error: No write permission"
```

### 3.4 故障排除

**编译错误**：
1. 检查类型签名
2. 确保所有导入都存在
3. 查看 Cabal 依赖是否正确

**运行时错误**：
1. 添加 `trace` 语句定位问题
2. 使用 `try` 捕获异常
3. 检查输入数据格式

**逻辑错误**：
1. 单步测试每个函数
2. 使用小数据集测试
3. 对照预期结果

---

## 4. 完善和展示

### 4.1 用户体验改进

**清晰的帮助信息**：
```haskell
showHelp :: IO ()
showHelp = putStrLn $ unlines
  [ "Cardano Wallet Tool - 命令行钱包"
  , ""
  , "用法:"
  , "  wallet generate          生成新地址"
  , "  wallet balance <addr>    查询余额"
  , "  wallet list              列出所有地址"
  , "  wallet help              显示帮助"
  , ""
  , "示例:"
  , "  wallet balance addr_test1q..."
  ]
```

**友好的错误消息**：
```haskell
-- 不好
error "Parse error"

-- 好
case parseAddress input of
  Left err -> putStrLn $ unlines
    [ "错误：无法解析地址"
    , "输入：" ++ input
    , "原因：" ++ err
    , ""
    , "提示：地址应以 'addr_test1' 开头"
    ]
  Right addr -> process addr
```

**进度提示**：
```haskell
queryMultipleAddresses addrs = do
  putStrLn $ "查询 " ++ show (length addrs) ++ " 个地址..."
  results <- forM (zip [1..] addrs) $ \(i, addr) -> do
    putStr $ "\r进度: " ++ show i ++ "/" ++ show (length addrs)
    hFlush stdout
    queryBalance addr
  putStrLn "\n完成！"
  return results
```

### 4.2 文档编写

**README.md 模板**：
```markdown
# [项目名称]

[一句话描述]

## 功能

- 功能 1
- 功能 2
- ...

## 安装

\`\`\`bash
cabal build
\`\`\`

## 使用

\`\`\`bash
# 示例命令
cabal run project -- command args
\`\`\`

## 配置

说明配置文件格式...

## 已知问题

列出已知的限制...

## 开发者

[你的名字]
```

**代码注释**：
```haskell
-- | 查询地址余额
--
-- 使用 Blockfrost API 查询指定地址的 ADA 余额
--
-- 示例:
-- >>> queryBalance "addr_test1q..."
-- Right (Balance 10000000)
--
-- 错误:
-- - 网络错误：无法连接API
-- - 解析错误：响应格式不正确
queryBalance :: Address -> IO (Either Error Balance)
```

### 4.3 演示准备

**演示结构（5分钟）**：
```
1. 介绍（30秒）
   - 项目名称和目的
   - 解决什么问题

2. 架构说明（1分钟）
   - 模块结构图
   - 技术栈

3. 功能演示（2分钟）
   - 核心功能展示
   - 实际操作

4. 代码讲解（1分钟）
   - 1-2个有趣的代码片段
   - 设计亮点

5. 总结（30秒）
   - 学到什么
   - 遇到的挑战
```

**演示技巧**：
- 提前准备好测试数据
- 确保所有命令都能运行
- 准备 Plan B（以防网络问题）
- 练习几遍，控制时间

### 4.4 代码质量检查

**自查清单**：
```markdown
## 功能性
- [ ] 所有必需功能都实现
- [ ] 所有功能都正常工作
- [ ] 错误情况都有处理

## 代码质量
- [ ] 所有函数都有类型签名
- [ ] 命名清晰、一致
- [ ] 模块组织合理
- [ ] 没有未使用的导入
- [ ] 没有警告

## 文档
- [ ] README 完整
- [ ] 主要函数有注释
- [ ] 配置文件有说明
- [ ] 使用方法清晰

## 测试
- [ ] 有测试用例
- [ ] 手动测试过主要流程
- [ ] 边界情况都考虑了
```

**代码审查要点**：
1. **可读性**：代码容易理解吗？
2. **健壮性**：错误处理充分吗？
3. **效率**：有明显的性能问题吗？
4. **可维护性**：未来容易修改吗？

---

## 总结

### 关键原则

1. **先计划，后编码**
2. **小步前进，频繁测试**
3. **注重代码质量，不只是功能**
4. **用户体验很重要**
5. **文档和代码同样重要**

### 时间分配建议

- **规划**：10%（1小时）
- **核心功能**：50%（4-5小时）
- **测试调试**：20%（2小时）
- **完善优化**：15%（1-2小时）
- **文档展示**：5%（30分钟）

### 最后的建议

- **不要追求完美**：先完成，再完美
- **保持简单**：KISS 原则
- **及时求助**：遇到问题查阅讲义
- **享受过程**：这是创造的乐趣！

**准备好了吗？开始你的项目！** 🚀

---

**参考资源**：
- [评估标准](evaluation.md)
- [展示指南](showcase.md)
- [项目 1 规格](project-1-wallet.md)
- [项目 2 规格](project-2-monitor.md)

