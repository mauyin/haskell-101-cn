# Wallet Tool - 实施任务清单

按顺序完成以下任务，确保每个任务都经过测试再继续下一个。

## Phase 1: 基础结构 (2小时)

### 1.1 完善类型定义 ✅

- [x] 查看 `Wallet/Types.hs`
- [x] 理解所有数据类型
- [x] 确保编译通过

### 1.2 实现地址辅助函数 (30分钟)

**文件**: `Wallet/Address.hs`

- [ ] 实现 `generateAddress`
  - 生成 50 个随机字符
  - 添加 "addr_test1q" 前缀
  - 使用 `replicateM` 和 `randomChar`
  
- [ ] 实现 `validateAddress`
  - 检查前缀是否为 "addr_test1"
  - 返回适当的错误消息

- [ ] 实现 `formatAddress`
  - 显示前 12 个字符
  - 显示 "..."
  - 显示最后 6 个字符

- [ ] 实现 `addAddress`, `removeAddress`, `findAddress`
  - 使用列表操作函数

**测试**:
```bash
cabal repl
> :load Wallet.Address
> generateAddress
> validateAddress "addr_test1q..."
> formatAddress (Address "addr_test1q...abc123")
```

### 1.3 实现CLI 参数解析 (30分钟)

**文件**: `Wallet/CLI.hs`

- [x] `parseCommand` 已有框架
- [ ] 测试所有命令的解析
- [x] `showHelp` 已实现

**测试**:
```bash
cabal repl
> :load Wallet.CLI
> parseCommand ["generate"]
> parseCommand ["balance", "addr_test1q..."]
```

### 1.4 完善 Main (15分钟)

**文件**: `app/Main.hs`

- [x] 基本结构已完成
- [ ] 测试运行：`cabal run wallet-tool -- help`

---

## Phase 2: API 集成 (2小时)

### 2.1 实现 Blockfrost API 调用 (1.5小时)

**文件**: `Wallet/API.hs`

⚠️ **注意**: 这是最具挑战的部分！

- [ ] 导入 `req` 库
  - `import Network.HTTP.Req`
  
- [ ] 实现 `queryAddressInfo`
  ```haskell
  -- 伪代码：
  -- 1. 构建 URL: endpoint/api/v0/addresses/{address}
  -- 2. 添加 header: project_id: api_key
  -- 3. 发送 GET 请求
  -- 4. 返回 JSON response
  ```

- [ ] 实现 `parseBalanceResponse`
  - 从 JSON 中提取 lovelace 数量
  - 使用 aeson 的 (.:) 操作符

- [ ] 实现 `queryUTxOs`
  - 类似 `queryAddressInfo`
  - 解析 UTxO 数组

**参考**: Week 7 的 API 示例

**测试**:
```bash
# 在 cabal repl 中测试
> :load Wallet.API
> runExceptT $ queryAddressInfo config (Address "addr_test1q...")
```

### 2.2 实现余额查询 (30分钟)

**文件**: `Wallet/Balance.hs`

- [ ] 实现 `queryBalance`
  - 调用 `queryAddressInfo`
  - 解析余额

- [ ] 实现 `lovelaceToAda`
  - 除以 1,000,000

- [ ] 实现 `formatBalance`
  - 格式化为 "X.XXXXXX ADA"

**测试**:
```bash
cabal repl
> :load Wallet.Balance
> formatBalance (Lovelace 1000000)
"1.000000 ADA"
```

---

## Phase 3: 核心功能 (2-3小时)

### 3.1 实现状态持久化 (1小时)

**文件**: `Wallet/Storage.hs`

- [ ] 实现 `ensureDataDir`
  - 使用 `createDirectoryIfMissing True`

- [ ] 实现 `saveState`
  ```haskell
  1. 确保目录存在
  2. 备份旧文件（如果存在）
  3. 使用 encodeFile 保存
  ```

- [ ] 实现 `loadState`
  ```haskell
  1. 检查文件是否存在
  2. 如果存在，decodeFileStrict
  3. 如果不存在，返回 defaultState
  ```

**测试**:
```bash
cabal repl
> :load Wallet.Storage
> state <- defaultState
> saveState ".test" state
> loadState ".test"
```

### 3.2 实现地址管理命令 (30分钟)

**文件**: `Wallet/CLI.hs`

在 `runCommand` 中实现：

- [ ] `Generate` 命令
  ```haskell
  1. 生成地址
  2. 获取当前时间
  3. 创建 AddressInfo
  4. 加载当前 state
  5. 添加到 state
  6. 保存 state
  7. 显示结果
  ```

- [ ] `List` 命令
  ```haskell
  1. 加载 state
  2. 遍历地址列表
  3. 格式化显示
  ```

**测试**:
```bash
cabal run wallet-tool -- generate "Test"
cabal run wallet-tool -- list
```

### 3.3 实现余额查询命令 (30分钟)

**文件**: `Wallet/CLI.hs`

- [ ] `Balance` 命令
  ```haskell
  1. 验证地址
  2. 查询 API
  3. 显示结果
  4. 处理错误
  ```

**测试**:
```bash
cabal run wallet-tool -- balance addr_test1q...
```

### 3.4 实现 UTxO 查看命令 (30分钟)

**文件**: `Wallet/CLI.hs`

- [ ] `UTxOs` 命令
  ```haskell
  1. 查询 UTxOs
  2. 显示列表
  3. 计算总额
  ```

---

## Phase 4: 交易构建 (2小时)

### 4.1 实现 UTxO 选择 (45分钟)

**文件**: `Wallet/Transaction.hs`

- [ ] 实现 `selectInputs`
  ```haskell
  算法：
  1. 计算所需总额 = amount + fee
  2. 从 UTxOs 中选择，直到总额 >= 所需
  3. 如果不够，返回 InsufficientFunds
  ```

**测试**:
```bash
cabal repl
> :load Wallet.Transaction
> let utxos = [UTxO ... 50000000, UTxO ... 30000000]
> selectInputs (Lovelace 60000000) utxos
```

### 4.2 实现交易构建 (45分钟)

**文件**: `Wallet/Transaction.hs`

- [ ] 实现 `buildTransaction`
  ```haskell
  1. 选择输入
  2. 计算费用
  3. 计算找零
  4. 验证找零 >= 0
  5. 创建输出 (to + change)
  6. 返回 Transaction
  ```

- [x] 实现 `validateTransaction` (已有框架)

**测试**:
```bash
cabal repl
> let tx = buildTransaction from to (Lovelace 10000000) utxos
> validateTransaction tx
```

### 4.3 实现交易保存 (30分钟)

**文件**: `Wallet/Transaction.hs`

- [ ] 实现 `saveTransaction`
  ```haskell
  1. 获取当前时间
  2. 生成文件名: tx_YYYYMMDD_HHMMSS.json
  3. 使用 encodeFile 保存
  4. 返回文件名
  ```

### 4.4 实现 Send 命令 (15分钟)

**文件**: `Wallet/CLI.hs`

- [ ] `Send` 命令
  ```haskell
  1. 查询 from 地址的 UTxOs
  2. 将 ADA 转换为 Lovelace
  3. 调用 buildTransaction
  4. 显示交易详情
  5. 保存到文件
  ```

**测试**:
```bash
cabal run wallet-tool -- send addr1 addr2 10.5
```

---

## Phase 5: 完善 (1-2小时)

### 5.1 错误处理 (30分钟)

- [ ] 检查所有 API 调用的错误处理
- [ ] 添加友好的错误消息
- [ ] 测试各种错误情况

### 5.2 用户体验 (30分钟)

- [ ] 添加加载提示
- [ ] 改进输出格式
- [ ] 添加颜色（可选）

### 5.3 测试 (30分钟)

**文件**: `test/WalletSpec.hs`

- [ ] 完成地址验证测试
- [ ] 完成余额格式化测试
- [ ] 添加交易构建测试
- [ ] 运行所有测试：`cabal test`

### 5.4 文档 (30分钟)

- [ ] 完善 README.md
- [ ] 添加使用示例
- [ ] 记录已知问题
- [ ] 添加截图（可选）

---

## 检查清单

完成后，确保：

### 功能
- [ ] 所有必需功能都工作
- [ ] 能够生成和列出地址
- [ ] 能够查询余额
- [ ] 能够查看 UTxOs
- [ ] 能够构建交易
- [ ] 状态能够保存和加载

### 代码质量
- [ ] 所有导出函数有类型签名
- [ ] 代码有适当的注释
- [ ] 模块组织清晰
- [ ] 无编译警告

### 测试
- [ ] 至少 3-5 个测试
- [ ] 所有测试通过
- [ ] 有手动测试记录

### 文档
- [ ] README 完整
- [ ] 有使用示例
- [ ] 配置说明清楚

---

## 常见问题

**Q: 无法编译？**
- 检查所有 import
- 确保 cabal 文件正确
- 运行 `cabal clean && cabal build`

**Q: API 调用失败？**
- 检查 API Key
- 检查网络连接
- 查看 API 错误消息

**Q: 测试失败？**
- 检查测试逻辑
- 使用 GHCi 调试
- 添加 print 语句

---

## 下一步

完成所有任务后：
1. 完整测试所有功能
2. 准备演示
3. 编写总结

祝你成功！💪

