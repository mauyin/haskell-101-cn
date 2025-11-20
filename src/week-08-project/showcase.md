# Week 8: 项目展示指南

本指南帮助你准备和展示结课项目。

---

## 展示概览

### 时间安排

- **准备时间**: 30-60分钟
- **展示时长**: 5-10分钟
- **问答时间**: 2-3分钟（可选）

### 展示形式

选择其中一种：
1. **现场演示** - 实时运行程序
2. **录制视频** - 提前录制好
3. **幻灯片 + 演示** - 结合使用

---

## 展示结构

### 推荐结构（5分钟版本）

```
1. 介绍 (30秒)
   - 项目名称
   - 解决什么问题
   - 使用的技术

2. 功能演示 (2分钟)
   - 展示3-4个核心功能
   - 实际操作

3. 架构说明 (1分钟)
   - 模块结构图
   - 关键设计决策

4. 代码亮点 (1分钟)
   - 1-2个有趣的代码片段
   - 技术难点和解决方案

5. 总结 (30秒)
   - 学到什么
   - 遇到的挑战
   - 未来改进方向
```

### 扩展版本（10分钟）

在5分钟版本基础上：
- 功能演示：3-4分钟（展示更多功能）
- 架构说明：2分钟（更详细）
- 代码讲解：2分钟（2-3个代码片段）

---

## 第 1 部分：介绍 (30秒)

### 要包含的内容

1. **项目名称**
2. **一句话描述**
3. **目标用户**
4. **主要价值**

### 示例脚本

**钱包工具**:
```
大家好！我的项目是"Cardano CLI Wallet"，一个命令行钱包工具。

它可以帮助 Cardano 开发者和用户快速管理地址、查询余额、
构建交易，无需运行完整节点。

主要使用 Haskell + Blockfrost API 实现，
包含地址管理、余额查询、UTxO 查看、交易构建等功能。

让我来演示一下...
```

**余额监控器**:
```
大家好！我的项目是"Cardano Balance Monitor"，
一个自动化余额监控工具。

它可以定期检查多个 Cardano 地址的余额变化，
并在发现变化时立即通知用户。

适合需要监控多个地址的用户、DApp 开发者等。
使用 Haskell + Blockfrost API 实现。

接下来演示主要功能...
```

### 技巧

- ✅ **简洁明了**：不要讲太多背景
- ✅ **突出价值**：说明为什么有用
- ✅ **自信从容**：练习几遍

---

## 第 2 部分：功能演示 (2-3分钟)

### 演示原则

1. **先准备好数据**：测试地址、API配置等
2. **选择核心功能**：不是所有功能都要演示
3. **流畅操作**：提前练习，确保没有错误
4. **边做边讲**：解释你在做什么

### 钱包工具演示脚本

```bash
# 1. 生成地址 (20秒)
$ wallet generate "Demo Wallet"
✓ Generated: addr_test1q...abc123
  Label: Demo Wallet

"首先生成一个新地址，可以看到地址格式正确，
并且可以添加标签方便管理。"

# 2. 查询余额 (30秒)
$ wallet balance addr_test1q...abc123
Querying balance...
✓ Address: addr_test1q...abc123
  Balance: 100.000000 ADA

"查询余额功能调用 Blockfrost API，
可以看到清晰的格式化输出。"

# 3. 查看 UTxOs (30秒)
$ wallet utxos addr_test1q...abc123
UTxO List:
  abc...#0 -> 50.000000 ADA
  def...#1 -> 50.000000 ADA
Total: 100.000000 ADA

"UTxO 列表显示了地址的所有未花费输出，
这对于构建交易很重要。"

# 4. 构建交易 (40秒)
$ wallet send addr_test1q...abc123 addr_test1q...xyz789 10.0
Building transaction...
✓ Transaction built successfully
  From: addr...abc123
  To: addr...xyz789
  Amount: 10.000000 ADA
  Fee: 0.170000 ADA
  Change: 39.830000 ADA
  Saved to: tx_20250120_153045.json

"交易构建功能自动选择 UTxO、计算费用和找零，
并将交易保存为 JSON 文件。"
```

### 余额监控器演示脚本

```bash
# 1. 添加地址 (20秒)
$ monitor add addr_test1q...abc123 "Test Wallet"
✓ Added: addr_test1q...abc123
  Label: Test Wallet

$ monitor add addr_test1q...def456 "Exchange"
✓ Added: addr_test1q...def456
  Label: Exchange

"首先添加要监控的地址，可以添加多个。"

# 2. 查看列表 (30秒)
$ monitor list
Monitoring 2 addresses:

1. addr...abc123  [Test Wallet]
   Balance: 100.000000 ADA
   Last checked: Never
   
2. addr...def456  [Exchange]
   Balance: 50.000000 ADA
   Last checked: Never

"列表显示所有监控地址及其状态。"

# 3. 启动监控 (90秒 - 展示一次循环)
$ monitor start --interval 60
Starting monitor (interval: 1 minute)...

[15:30:00] Checking 2 addresses...
[15:30:02] All balances checked. No changes.

[15:31:00] Checking 2 addresses...
═══ Balance Change Detected ═══
Address: addr...abc123
Change:  ↑ 10.000000 ADA
Old:     100.000000 ADA
New:     110.000000 ADA
════════════════════════════════

^C Stopping...

"程序每分钟自动检查所有地址，
发现变化时立即显示通知。
我这里模拟了一个余额增加的情况。"

# 4. 查看历史 (20秒)
$ monitor history
Balance Change History:

2025-01-20 15:31:00
  addr...abc123 [Test Wallet]
  ↑ 10.000000 ADA

"所有变化都被记录，可以随时查看历史。"
```

### 演示技巧

- ✅ **准备 Plan B**：如果网络有问题，使用 mock 数据
- ✅ **控制节奏**：不要太快，给观众理解的时间
- ✅ **突出重点**：指出关键功能和设计
- ❌ **避免冗长**：不要演示所有功能

---

## 第 3 部分：架构说明 (1分钟)

### 要展示的内容

1. **模块结构图**
2. **数据流**
3. **关键设计决策**

### 钱包工具架构示例

```
架构图：

┌─────────────────────────────────────┐
│          CLI Interface              │
│         (Wallet/CLI.hs)             │
└─────────────┬───────────────────────┘
              │
       ┌──────┴──────┐
       │             │
┌──────▼──────┐ ┌───▼────────────┐
│   Address   │ │    Balance     │
│   Manager   │ │    Query       │
└──────┬──────┘ └───┬────────────┘
       │            │
       │      ┌─────▼──────┐
       │      │  Blockfrost│
       │      │    API     │
       │      └────────────┘
       │
┌──────▼──────┐
│   Storage   │
│  (JSON)     │
└─────────────┘

关键设计：
1. 模块职责清晰分离
2. 使用 ExceptT 统一错误处理
3. API 调用有重试机制
4. 状态持久化到 JSON 文件
```

### 余额监控器架构示例

```
架构图：

┌─────────────────────────────────────┐
│        Monitor Loop                 │
│      (定期检查)                      │
└──────┬────────────────┬─────────────┘
       │                │
┌──────▼──────┐  ┌──────▼──────────┐
│   Query     │  │    Tracker      │
│   Module    │  │  (变化检测)      │
└──────┬──────┘  └──────┬──────────┘
       │                │
       │         ┌──────▼──────────┐
       │         │   Notification  │
       │         │    System       │
       │         └─────────────────┘
┌──────▼──────┐
│  Blockfrost │
│    API      │
└──────┬──────┘
       │
┌──────▼──────┐
│   Storage   │
│  (历史记录)  │
└─────────────┘

关键设计：
1. 主循环 + 定时器实现自动监控
2. 变化检测基于前后余额对比
3. 即时通知 + 历史记录
4. YAML 配置 + JSON 存储
```

### 讲解技巧

- ✅ **使用图示**：视觉化架构
- ✅ **突出亮点**：说明关键设计决策
- ✅ **简洁明了**：不要讲太多细节

---

## 第 4 部分：代码亮点 (1-2分钟)

### 选择展示什么

选择 1-2 个有趣或有挑战的代码片段：

1. **优雅的错误处理**
2. **复杂的数据解析**
3. **巧妙的算法**
4. **函数式编程技巧**

### 示例 1: 错误处理（钱包工具）

```haskell
-- 展示 ExceptT 的使用
buildTransaction 
  :: Address      -- From
  -> Address      -- To
  -> Lovelace     -- Amount
  -> ExceptT WalletError IO Transaction
buildTransaction from to amount = do
  -- 1. 查询 UTxOs
  utxos <- queryUTxOs from
  
  -- 2. 选择输入
  inputs <- selectInputs utxos amount
    `orThrow` InsufficientFunds
  
  -- 3. 计算费用
  let fee = estimateFee inputs
  
  -- 4. 计算找零
  let change = sum inputs - amount - fee
  when (change < 0) $
    throwError NegativeChange
  
  -- 5. 构建交易
  return $ Transaction inputs [TxOut to amount, TxOut from change] fee
```

**讲解**:
"这是交易构建的核心函数。使用 ExceptT 可以优雅地组合多个
可能失败的操作，每一步都可能返回不同的错误。
这让错误处理既清晰又类型安全。"

### 示例 2: 变化检测（监控器）

```haskell
-- 智能的变化检测
detectChanges 
  :: [MonitoredAddress]  -- 监控列表
  -> [Lovelace]          -- 新余额
  -> ([BalanceChange], [MonitoredAddress])
detectChanges addrs newBalances =
  let pairs = zip addrs newBalances
      (changes, updated) = unzip $ map checkOne pairs
  in (catMaybes changes, updated)
  where
    checkOne (monitored, newBal) =
      case lastBalance monitored of
        Nothing -> 
          -- 首次查询，只更新
          (Nothing, monitored { lastBalance = Just newBal })
        Just oldBal | oldBal /= newBal ->
          -- 发现变化
          let change = BalanceChange
                { changeAddress = address monitored
                , oldBalance = oldBal
                , newBalance = newBal
                , changeDelta = getLovelace newBal - getLovelace oldBal
                }
          in (Just change, monitored { lastBalance = Just newBal })
        _ -> 
          -- 无变化
          (Nothing, monitored)
```

**讲解**:
"这个函数同时完成变化检测和状态更新。
使用 zip 将地址和余额配对，map 遍历检查，
unzip 分离结果。这种函数式风格简洁且不易出错。"

### 示例 3: API 重试（通用）

```haskell
-- 带重试的 API 调用
requestWithRetry :: Int -> IO (Either Error a) -> IO (Either Error a)
requestWithRetry 0 action = action
requestWithRetry n action = do
  result <- action
  case result of
    Left (NetworkError _) -> do
      putStrLn $ "Retrying... (" ++ show n ++ " attempts left)"
      threadDelay 1000000  -- 等待1秒
      requestWithRetry (n-1) action
    _ -> return result
```

**讲解**:
"这是一个简单但实用的重试机制。
只对网络错误重试，其他错误立即返回。
递归实现很自然，类型安全，容易理解。"

### 代码展示技巧

- ✅ **选择典型代码**：展示你的技能
- ✅ **解释关键点**：不要逐行读代码
- ✅ **联系课程内容**：指出使用了哪些技术
- ❌ **避免太长**：不超过 20 行
- ❌ **避免太复杂**：观众能理解的代码

---

## 第 5 部分：总结 (30秒)

### 要包含的内容

1. **主要收获**
2. **遇到的挑战**
3. **未来改进方向**
4. **致谢（可选）**

### 示例脚本

```
总结：

通过这个项目，我深入理解了：
- Monad 和 ExceptT 的实际应用
- 如何组织大型 Haskell 项目
- API 集成和错误处理的最佳实践

最大的挑战是处理 API 限流和网络错误，
通过添加重试机制和缓存解决了。

未来可以改进的地方：
- 添加更多测试
- 实现并发查询提高性能
- 支持更多 Cardano 功能

感谢这门课程，让我掌握了 Haskell 和 Cardano 开发的基础！
```

---

## 展示准备清单

### 技术准备

- [ ] 程序编译无错误
- [ ] 所有功能都测试过
- [ ] 准备好测试数据
- [ ] API Key 配置正确
- [ ] 准备好 Plan B（如网络问题）

### 内容准备

- [ ] 准备好演示脚本
- [ ] 选择好要展示的功能
- [ ] 准备好架构图
- [ ] 选择好代码片段
- [ ] 写好总结

### 演示准备

- [ ] 练习几遍（3-5次）
- [ ] 计时，确保在时间内
- [ ] 准备好问答（可能被问到什么）
- [ ] 录屏（如果是视频演示）

---

## 常见问题应对

### Q: 演示时出错怎么办？

**应对策略**:
1. **保持冷静**：这很正常
2. **解释原因**：如"这是网络延迟"
3. **使用备选**：切换到 mock 数据
4. **继续前进**：不要纠结太久

### Q: 忘词了怎么办？

**应对策略**:
1. **看笔记**：准备提示卡
2. **重新开始**："让我重新解释一下"
3. **边做边说**：操作可以帮助你想起来

### Q: 时间不够怎么办？

**应对策略**:
1. **跳过细节**：直接到总结
2. **加快节奏**：简化说明
3. **下次改进**：练习时控制好时间

### Q: 被问到不会的问题怎么办？

**应对策略**:
1. **诚实回答**："这个我还没深入研究"
2. **表示兴趣**："这是个好问题，我会去了解"
3. **不要编造**：诚实比装懂好

---

## 录制视频建议

如果选择录制视频：

### 录制工具

- **macOS**: QuickTime Screen Recording
- **Windows**: OBS Studio
- **Linux**: SimpleScreenRecorder

### 录制技巧

1. **准备好脚本**：避免太多"嗯"、"啊"
2. **分段录制**：出错可以重录某一段
3. **剪辑**：使用简单工具（iMovie, Windows Movie Maker）
4. **添加字幕**：（可选）帮助理解

### 视频质量

- **分辨率**: 1080p
- **格式**: MP4
- **时长**: 5-10分钟
- **文件大小**: < 100MB

---

## 示例视频结构

```
00:00 - 00:30   标题 + 介绍
00:30 - 02:30   功能演示
02:30 - 03:30   架构说明
03:30 - 04:30   代码讲解
04:30 - 05:00   总结
```

---

## 展示评估

好的展示应该：

✅ **清晰**: 观众能理解你做了什么  
✅ **完整**: 涵盖功能、架构、代码  
✅ **简洁**: 不拖沓，在时间内  
✅ **专业**: 准备充分，操作流畅  
✅ **自信**: 展现你的成果

---

## 最后建议

1. **享受过程**: 这是展示你努力的机会
2. **不要紧张**: 每个人都会紧张，这很正常
3. **多练习**: 练习是最好的准备
4. **讲故事**: 把项目当作一个故事来讲
5. **保持热情**: 你的热情会感染观众

---

**准备好展示你的精彩作品了吗？** 🎤

使用这个指南准备，相信你一定能做出精彩的展示！加油！💪

