# Balance Monitor - 实施任务清单

按顺序完成以下任务，确保每个任务都经过测试再继续下一个。

## Phase 1: 基础结构 (2小时)

### 1.1 完善类型定义 ✅

- [x] 查看 `Monitor/Types.hs`
- [x] 理解所有数据类型
- [x] 确保编译通过

### 1.2 实现配置管理 (30分钟)

**文件**: `Monitor/Config.hs`

- [x] `defaultConfig` 已实现
- [x] `loadConfig` 框架已有
- [x] `saveDefaultConfig` 已实现

**测试**:
```bash
cabal run balance-monitor -- init-config config.yaml
# 检查生成的 config.yaml 文件
```

### 1.3 实现 CLI 参数解析 (30分钟)

**文件**: `Monitor/CLI.hs`

- [x] `parseCommand` 已有框架
- [ ] 测试所有命令的解析
- [x] `showHelp` 已实现

**测试**:
```bash
cabal repl
> :load Monitor.CLI
> parseCommand ["add", "addr_test1q...", "Test"]
> parseCommand ["start", "--interval", "300"]
```

### 1.4 完善 Main (15分钟)

**文件**: `app/Main.hs`

- [x] 基本结构已完成
- [ ] 测试运行：`cabal run balance-monitor -- help`

---

## Phase 2: API 集成 (2小时)

### 2.1 实现余额查询 (1.5小时)

**文件**: `Monitor/Query.hs`

⚠️ **注意**: 参考 wallet-tool 的 API 实现

- [ ] 实现 `queryBalance`
  ```haskell
  1. 调用 Blockfrost API
  2. 解析响应
  3. 返回 Lovelace
  ```

- [ ] 实现 `queryAllBalances`
  ```haskell
  1. 对每个地址调用 queryBalance
  2. 添加延迟避免速率限制
  3. 显示进度
  4. 收集结果
  ```

- [ ] 实现 `formatBalance`
  ```haskell
  1. 转换为 ADA (/ 1000000)
  2. 格式化为 "X.XXXXXX ADA"
  ```

**测试**:
```bash
cabal repl
> :load Monitor.Query
> formatBalance (Lovelace 1000000)
"1.000000 ADA"
```

---

## Phase 3: 监控核心 (2-3小时)

### 3.1 实现数据持久化 (1小时)

**文件**: `Monitor/Storage.hs`

- [x] `defaultState` 已有框架
- [ ] 实现 `saveState`
  ```haskell
  1. 创建数据目录
  2. 备份旧文件
  3. 保存新状态 (encodeFile)
  ```

- [ ] 实现 `loadState`
  ```haskell
  1. 检查文件是否存在
  2. 如果存在，decodeFileStrict
  3. 如果不存在，返回 defaultState
  ```

- [ ] 实现 `exportCSV`
  - 已有框架，测试确保正常工作

**测试**:
```bash
cabal repl
> :load Monitor.Storage
> state <- defaultState
> saveState ".test" state
> loadState ".test"
```

### 3.2 实现监控列表管理命令 (45分钟)

**文件**: `Monitor/CLI.hs`

在 `runCommand` 中实现：

- [ ] `Add` 命令
  ```haskell
  1. 创建 MonitoredAddress
  2. 加载当前 state
  3. 添加到 state
  4. 保存 state
  5. 显示结果
  ```

- [ ] `Remove` 命令
  ```haskell
  1. 加载 state
  2. 过滤掉指定地址
  3. 保存 state
  4. 显示结果
  ```

- [ ] `List` 命令
  ```haskell
  1. 加载 state
  2. 显示所有监控地址
  3. 显示最后余额和检查时间
  ```

- [ ] `Info` 命令
  ```haskell
  1. 加载 state
  2. 查找指定地址
  3. 显示详细信息
  ```

**测试**:
```bash
cabal run balance-monitor -- add addr_test1q... "Test"
cabal run balance-monitor -- list
cabal run balance-monitor -- info addr_test1q...
```

### 3.3 实现变化检测 (45分钟)

**文件**: `Monitor/Tracker.hs`

- [ ] 实现 `detectChanges`
  ```haskell
  算法：
  1. 遍历监控地址列表
  2. 对每个地址：
     a. 查找对应的新余额
     b. 比较 lastBalance
     c. 如果不同，创建 BalanceChange
     d. 更新 MonitoredAddress
  3. 返回 (changes, updatedAddresses)
  ```

- [x] `updateBalances` 已有框架
  - 测试确保正常工作

**测试**:
```bash
cabal repl
> :load Monitor.Tracker
# 创建测试数据进行测试
```

### 3.4 实现通知 (30分钟)

**文件**: `Monitor/Notify.hs`

- [x] `notifyChange` 已实现
- [x] `displayChange` 已实现
- [x] `formatDelta` 已实现

**可选**: 添加颜色输出
- 使用 `ansi-terminal` 库
- 增加为绿色，减少为红色

**测试**:
```bash
cabal repl
> :load Monitor.Notify
# 创建测试 BalanceChange 并显示
```

---

## Phase 4: 监控循环 (2小时)

### 4.1 实现 Start 命令 (1.5小时)

**文件**: `Monitor/CLI.hs`

- [ ] `Start` 命令
  ```haskell
  1. 加载当前 state
  2. 如果监控列表为空，提示并退出
  3. 更新配置中的 interval (如果指定)
  4. 调用 Tracker.monitorLoop
  ```

**文件**: `Monitor/Tracker.hs`

- [x] `monitorLoop` 已有框架
  - 检查逻辑是否完整
  - 确保正确处理 Ctrl+C

**测试**:
```bash
# 添加几个地址
cabal run balance-monitor -- add addr_test1q...abc "Test1"
cabal run balance-monitor -- add addr_test1q...def "Test2"

# 启动监控（短间隔用于测试）
cabal run balance-monitor -- start --interval 60

# 观察输出，按 Ctrl+C 停止
```

### 4.2 实现历史查询 (30分钟)

**文件**: `Monitor/CLI.hs`

- [ ] `History` 命令
  ```haskell
  1. 加载 state
  2. 获取 history
  3. 如果指定地址，过滤
  4. 按时间排序显示
  ```

- [ ] `Export` 命令
  ```haskell
  1. 加载 state
  2. 调用 Storage.exportCSV
  3. 显示成功消息
  ```

**测试**:
```bash
cabal run balance-monitor -- history
cabal run balance-monitor -- history addr_test1q...
cabal run balance-monitor -- export changes.csv
```

---

## Phase 5: 完善 (1-2小时)

### 5.1 错误处理 (30分钟)

- [ ] 检查所有 API 调用的错误处理
- [ ] 添加友好的错误消息
- [ ] 测试网络错误、API错误等情况

### 5.2 用户体验 (30分钟)

- [ ] 改进输出格式
- [ ] 添加进度提示
- [ ] 添加时间戳格式化
- [ ] 添加彩色输出（可选）

### 5.3 测试 (30分钟)

**文件**: `test/MonitorSpec.hs`

- [ ] 完成余额格式化测试
- [ ] 添加变化检测测试
- [ ] 运行所有测试：`cabal test`

### 5.4 文档 (30分钟)

- [ ] 完善 README.md
- [ ] 添加使用示例
- [ ] 记录配置选项
- [ ] 添加截图（可选）

---

## 检查清单

完成后，确保：

### 功能
- [ ] 可以添加和删除地址
- [ ] 可以列出监控地址
- [ ] 可以启动监控
- [ ] 可以检测余额变化
- [ ] 可以显示通知
- [ ] 可以查看历史
- [ ] 可以导出数据
- [ ] 状态可以保存和加载

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
- [ ] 有配置说明
- [ ] 有使用示例

---

## 常见问题

**Q: 如何测试余额变化？**
A: 可以手动修改保存的状态文件中的余额，然后运行监控。

**Q: API 查询太慢？**
A: 确保添加了 threadDelay，避免速率限制导致的失败。

**Q: 如何优雅退出？**
A: 使用 Ctrl+C，程序会捕获信号并保存状态（需要额外实现信号处理）。

---

## 进阶功能（可选）

如果时间允许，可以实现：

- [ ] 并发查询（使用 `async` 库）
- [ ] 条件通知（只通知大于阈值的变化）
- [ ] 统计报告（每日总结）
- [ ] Web 界面（使用 `scotty` 库）

---

## 下一步

完成所有任务后：
1. 完整测试所有功能
2. 准备演示
3. 编写总结

祝你成功！💪

