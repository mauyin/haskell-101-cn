# Haskell 入门课程教学指南

> 本指南为课程讲师和助教准备，包含教学建议、常见问题和扩展资源

## 📋 总体教学建议

### 课程节奏
- **总时长**：8 周（不含第 0 周环境搭建）
- **每周建议**：
  - 2 小时讲座/讲解
  - 2-3 小时练习时间（课堂或课后）
  - 1-2 小时自主学习和实验
- **批改作业**：每周至少检查 50% 学生的练习完成度

### 教学原则
1. **REPL 优先** - 始终在 GHCi 中演示，让学生看到即时反馈
2. **类型先行** - 强调类型签名的重要性，培养"类型驱动开发"思维
3. **小步迭代** - 每个概念从最简单版本开始，逐步增加复杂度
4. **对比学习** - 适当与学生熟悉的语言对比（Python/JavaScript/Java）
5. **犯错空间** - 鼓励学生在 GHCi 中尝试错误代码，理解编译器错误信息

### 课堂互动建议
- 每 20 分钟插入一个 5 分钟小练习
- 使用"配对编程"方式让学生互相帮助
- 准备 2-3 个"挑战题"给进度快的学生
- 建立班级 Slack/Discord 频道用于课后答疑

## 📅 分周教学要点

### Week 0: 环境搭建

**教学时长**：1.5 小时

**核心目标**：
- 所有学生成功安装 GHCup、GHC、Cabal、HLS
- 能够启动 GHCi 并执行基本运算
- VS Code 中能看到 Haskell 语法高亮和自动补全

**常见问题**：
1. **Windows 路径空格问题**
   - 症状：GHCup 安装失败或 HLS 无法启动
   - 解决：确保用户名和安装路径无中文和空格
   - 备选方案：使用 WSL2（Windows Subsystem for Linux）

2. **macOS Xcode 命令行工具未安装**
   - 症状：`xcrun: error: invalid active developer path`
   - 解决：运行 `xcode-select --install`

3. **网络问题导致下载失败**
   - 解决：提供国内镜像地址或离线安装包
   - 备选：使用 Stack 代替 Cabal（但推荐 GHCup + Cabal）

**教学重点**：
- 演示 GHCi 的 `:type`、`:info`、`:load` 命令
- 强调 Haskell 是强类型语言，类型错误会在编译期捕获
- 展示 VS Code 中的类型提示功能

**课后作业**：
- 完成 `exercise-01-hello.hs` 和 `exercise-02-ghci.md`
- 在 GHCi 中实验至少 10 个简单表达式

---

### Week 1: Haskell 基础语法

**教学时长**：2-2.5 小时

**核心目标**：
- 理解函数定义和类型签名
- 掌握列表基本操作
- 能写简单递归函数
- 理解高阶函数概念

**常见困难**：
1. **类型签名的"反直觉"**
   - 问题：`Int -> Int -> Int` 看起来不像"两个参数"
   - 策略：先教柯里化概念，强调"函数返回函数"
   - 练习：让学生手动部分应用函数

2. **递归思维障碍**
   - 问题：学生想用循环，不理解递归
   - 策略：从数学归纳法类比，画递归调用树
   - 建议：使用 `resources/recursion-visualizer.html` 演示

3. **模式匹配 vs if-else**
   - 问题：学生过度使用 if 而不用模式匹配
   - 策略：展示模式匹配的简洁性和编译器完备性检查
   - 练习：重构 if-else 代码为模式匹配

**教学技巧**：
- **递归三步法**：
  1. 定义基础情况（base case）
  2. 定义递归情况（recursive case）
  3. 确保每次递归都在向基础情况靠近
  
- **高阶函数教学顺序**：
  ```haskell
  map    -- 最简单，一对一转换
  filter -- 有条件的筛选
  foldr  -- 最抽象，需要多练习
  ```

**扩展阅读**：
- Learn You a Haskell: "Starting Out" 和 "Syntax in Functions"
- Haskell Wiki: Fold 系列文章

**课后作业**：
- `exercise-01-recursion.hs`（5 题）
- `exercise-02-higher-order.hs`（5 题）
- `exercise-03-lists.hs`（5 题）
- 鼓励学生在 GHCi 中测试每个函数

---

### Week 2: 数据类型与模式匹配

**教学时长**：2 小时

**核心目标**：
- 定义自己的数据类型（ADT）
- 熟练使用模式匹配
- 理解 Maybe 和 Either 的用途

**常见困难**：
1. **ADT vs 面向对象**
   - 问题：学生尝试在类型中添加"方法"
   - 策略：强调"数据和函数分离"的函数式哲学
   - 对比：展示如何用模式匹配替代多态

2. **Maybe 的心理抵抗**
   - 问题：学生觉得 `Maybe` 太繁琐，想直接用 null
   - 策略：展示 null pointer exception 的痛苦案例
   - 练习：让学生重构使用 null 的代码为 Maybe

3. **记录语法的冗长**
   - 问题：学生抱怨 Haskell 记录语法不如其他语言简洁
   - 策略：介绍 RecordWildCards 扩展（可选）
   - 说明：现代 Haskell 生态有更好的库（lens、optics）

**教学重点**：
- 用 ADT 建模真实问题（如扑克牌、交通信号灯）
- 强调模式匹配的穷尽性检查（completeness）
- 演示 case 表达式 vs 函数定义的模式匹配

**扩展话题**：
- GADT（可选，提一下存在更强大的类型系统）
- Phantom types（留作"兴趣阅读"）

**课后作业**：
- 定义二叉树类型并实现遍历函数
- 用 Maybe 和 Either 处理错误情况

---

### Week 3: 类型类

**教学时长**：2.5 小时（最难的一周）

**核心目标**：
- 理解类型类 vs 接口 vs trait
- 能为自定义类型实现 Eq、Ord、Show
- 初步理解 Functor、Applicative、Monad

**常见困难**：
1. **Monad 恐惧症**
   - 问题：学生听说 Monad 很难，产生心理障碍
   - 策略：**不要过早解释 Monad 理论**，先看大量例子
   - 方法：从 Maybe、List 等具体 Monad 开始，推迟抽象解释

2. **Functor 法则的"虚无感"**
   - 问题：学生觉得 `fmap id = id` 这些法则没用
   - 策略：展示违反法则的"邪恶" Functor 导致的 bug
   - 练习：让学生写一个不遵守法则的实例，观察后果

3. **类型类约束的语法困惑**
   - 问题：`(Eq a, Show a) => a -> String` 的语法很陌生
   - 策略：用"如果 a 能比较且能显示，那么..."的自然语言解释
   - 练习：让学生翻译类型签名为中文句子

**教学顺序**（重要！）：
1. 先教简单类型类（Eq、Ord、Show）
2. 再教 Functor（用 Maybe、List 示例）
3. 简单提及 Applicative（可以说"下周深入"）
4. **Monad 只讲直觉**，留给 Week 4 深入

**教学技巧**：
- 用"盒子"比喻 Functor：`fmap` 是"不拆盒子的操作"
- 用"组装线"比喻 Applicative
- Monad 用"依赖的计算链"比喻

**扩展阅读**：
- "Typeclassopedia" - 经典文章（留作课后阅读）
- Bartosz Milewski 的 Category Theory 系列（进阶学生）

**课后作业**：
- 为自定义类型实现多个类型类
- 用 fmap/(<$>) 改写重复代码

---

### Week 4: Monad 与 IO

**教学时长**：2.5 小时

**核心目标**：
- 理解纯函数 vs 副作用
- 掌握 do 记法
- 能写基本的 IO 程序

**常见困难**：
1. **"为什么我不能从 IO 里拿出值"**
   - 问题：学生想写 `x = getLine` 而不是 `x <- getLine`
   - 策略：强调"一旦进入 IO，就无法逃离"（IO Monad 是"传染性"的）
   - 比喻：IO 是"潘多拉魔盒"，打开后无法关闭

2. **do 记法的"语法糖"本质**
   - 问题：学生不理解 do 和 >>= 的关系
   - 策略：先只教 do，后面再展示脱糖后的样子
   - 练习：手动将 do 代码转换为 >>= 链

3. **纯函数测试 vs IO 函数测试**
   - 问题：学生在 IO 函数里写太多逻辑
   - 策略：强调"IO 应该薄如纸"，业务逻辑提取为纯函数
   - 示例：展示如何重构 IO 密集代码

**教学重点**：
- 演示 getLine、putStrLn、readFile、writeFile
- 强调 main :: IO () 是程序入口
- 展示如何组合多个 IO 动作

**实用建议**：
- 让学生写小游戏（猜数字、石头剪刀布）
- 鼓励使用 do 记法（不要过早引入 >>= 操作符）
- 讲解 return 的真实含义（不是"返回"而是"包装"）

**课后作业**：
- 猜数字游戏（完整版）
- 命令行 TODO 程序（增删查改）

---

### Week 5: 模块与项目管理

**教学时长**：2 小时

**核心目标**：
- 创建 Cabal 项目
- 理解模块导入导出
- 使用常用库（aeson、bytestring、req）

**常见困难**：
1. **Cabal 配置文件语法**
   - 问题：学生不理解 .cabal 文件的各个字段
   - 策略：提供标准模板，逐行解释
   - 工具：使用 `cabal init` 生成初始项目

2. **依赖版本冲突**
   - 问题：`cabal build` 报版本约束错误
   - 策略：先用宽松约束（如 `aeson >= 2.0`），后续再优化
   - 工具：使用 `cabal build --allow-newer`（临时方案）

3. **JSON 解析的类型复杂度**
   - 问题：aeson 的类型错误信息很长
   - 策略：从最简单的 JSON 开始（单个对象）
   - 练习：逐步增加 JSON 复杂度

**教学重点**：
- 演示 `cabal init`、`cabal build`、`cabal run`
- 展示如何在 Hackage 上查找库
- 讲解模块的 export list

**实用项目**：
- 天气查询工具（调用 API）
- JSON 配置文件解析器

**扩展话题**：
- Stack vs Cabal（简单对比，推荐 Cabal）
- Haskell Language Server 的项目支持

**课后作业**：
- 构建一个完整的 Cabal 项目
- 使用 aeson 解析真实 JSON 数据

---

### Week 6: 错误处理与测试

**教学时长**：2 小时

**核心目标**：
- 使用 Maybe、Either、ExceptT 处理错误
- 写 QuickCheck 属性测试
- 理解测试驱动开发（TDD）在函数式编程中的应用

**常见困难**：
1. **Monad Transformer 的心智负担**
   - 问题：ExceptT 的类型签名很复杂
   - 策略：先只教"怎么用"，不深究内部实现
   - 练习：从 Either 重构到 ExceptT

2. **QuickCheck 属性的"发现"难度**
   - 问题：学生不知道该测试什么属性
   - 策略：给出常见属性模式（幂等性、逆运算、不变量）
   - 示例：`reverse . reverse = id`、`length (xs ++ ys) = length xs + length ys`

3. **Arbitrary 实例的编写**
   - 问题：为复杂类型生成随机值很困难
   - 策略：使用 Generic deriving（DeriveAnyClass）
   - 备选：手写简单的 Arbitrary 实例

**教学重点**：
- 对比异常处理 vs 显式错误类型
- 演示 QuickCheck 如何发现边界情况 bug
- 强调"如果编译通过，通常就是对的"

**测试策略**：
- 纯函数 → QuickCheck 属性测试
- IO 函数 → HUnit 单元测试
- 端到端 → 手动测试或集成测试

**课后作业**：
- 为 Week 2 的树结构写 QuickCheck 测试
- 用 ExceptT 重构带错误处理的程序

---

### Week 7: Cardano 简介 + Haskell 实践

**教学时长**：2.5 小时（可分两次课）

**核心目标**：
- 理解为什么 Cardano 选择 Haskell
- 了解 eUTxO 模型基本概念
- 用 Haskell 解析和构建 Cardano 交易

**重要提示**：
⚠️ **本周不涉及 Plutus 智能合约** - 仅使用纯 Haskell 工具
⚠️ **全部操作在 testnet** - 不使用真实 ADA

**前置准备**（提前一周通知学生）：
1. 安装 cardano-node 和 cardano-cli（可选，也可只用 Blockfrost API）
2. 注册 Blockfrost 免费账号并获取 API key
3. 可选：同步 testnet 区块链（需要时间）

**教学内容**：

#### 第一部分：理论背景（30 分钟）
- **为什么 Cardano 用 Haskell**：
  - 强类型系统减少 bug
  - 纯函数便于验证和审计
  - 形式化验证的基础
  
- **eUTxO vs 账户模型**：
  - UTXO（未花费交易输出）概念
  - Cardano 如何扩展 UTXO（添加 datum/redeemer）
  - 与以太坊账户模型的对比

- **Cardano 技术栈**：
  - cardano-node（核心节点）
  - cardano-cli（命令行工具）
  - cardano-api（Haskell 库）
  - cardano-wallet（后端 API）

#### 第二部分：动手练习（90 分钟）

**练习 1：解析交易 JSON（30 分钟）**
```haskell
-- 使用 aeson 库
-- 目标：从 cardano-cli 输出的 JSON 提取交易信息
-- 难度：★☆☆☆☆
```
- 演示如何用 `cardano-cli query utxo` 获取 JSON
- 教学生定义 Haskell 数据类型对应 JSON 结构
- 使用 `FromJSON` 类型类自动解析

**练习 2：构建简单交易（40 分钟）**
```haskell
-- 使用 cardano-api 库
-- 目标：构建一个简单的 ADA 转账交易（off-chain）
-- 难度：★★☆☆☆
```
- **重点**：不需要真正发送交易，只要能构建并序列化
- 教学生使用 cardano-api 的基本类型
- 演示如何计算 fee 和平衡交易

**练习 3：查询余额（20 分钟）**
```haskell
-- 使用 req 或 http-client 库
-- 目标：通过 Blockfrost API 查询地址余额
-- 难度：★☆☆☆☆
```
- 演示 HTTP GET 请求
- 解析 JSON 响应
- 显示余额（Lovelace 转 ADA）

**常见问题**：
1. **cardano-api 类型复杂**
   - 策略：提供完整的类型签名，学生先"抄代码"理解后再改
   - 重点：解释 `TxBody`、`TxIn`、`TxOut` 等核心类型

2. **CBOR 序列化的陌生感**
   - 策略：只展示结果（16 进制字符串），不深入 CBOR 标准
   - 工具：使用 `cardano-cli` 验证生成的交易

3. **网络请求失败**
   - 备选：提供预先下载的 JSON 文件作为 fallback
   - 检查：确保 API key 正确且有请求额度

**教学技巧**：
- 使用真实的 testnet 地址和交易作为示例
- 展示 CardanoScan（浏览器）验证链上数据
- 强调这些工具都是"纯 Haskell"，没有魔法

**扩展话题**（时间允许）：
- Plutus 脚本的输入输出（简单提及，不展开）
- 如何参与 Cardano 开源项目
- Cardano 生态的 Haskell 库（cardano-addresses、bech32 等）

**课后作业**：
- 完成三个练习的完整版本
- 查询自己的 testnet 地址余额
- （可选）尝试在 testnet 上发送真实交易

**教学资源**：
- 使用 `resources/transaction-anatomy.html` 可视化交易结构
- 使用 `resources/utxo-model.html` 演示 UTXO 流转

---

### Week 8: 结课项目

**教学时长**：项目展示 2 小时 + 个别指导若干小时

**核心目标**：
- 学生独立完成一个综合项目
- 练习代码组织和项目管理
- 准备展示和讲解自己的代码

**项目选择**（二选一）：
1. **命令行钱包工具**
   - 生成地址
   - 查询余额
   - 构建转账交易
   
2. **Cardano 地址余额监控器**
   - 定期查询指定地址
   - 检测余额变化
   - 发送通知（可选）

**评分标准**（参考 `week-08-project/rubric.md`）：
- 代码功能（40%）
- 代码质量（30%）- 类型签名、注释、模块化
- 错误处理（15%）
- 展示和文档（15%）

**教学建议**：
- 第 7 周就布置项目，给学生两周时间
- 提供 office hour 进行一对一指导
- 鼓励学生互相 code review

**展示环节**：
- 每个学生 10 分钟（5 分钟演示 + 5 分钟 Q&A）
- 鼓励提问和互相学习
- 讲师点评亮点和改进空间

---

## 🎓 教学哲学

### Haskell 教学的核心挑战
Haskell 对初学者最大的障碍不是"难"，而是"不同"：
- 无可变变量
- 无循环
- 类型系统主导设计
- 延迟求值（lazy evaluation）

### 我们的应对策略
1. **及早建立直觉** - 用比喻和可视化工具
2. **快速反馈** - REPL 驱动学习
3. **真实项目** - Week 7 的 Cardano 练习提供动力
4. **社区支持** - 建立互助文化

### 避免的陷阱
❌ 过早讲 Category Theory
❌ 用抽象术语解释抽象概念（如"Monad 是自函子范畴上的幺半群"）
❌ 强迫学生记忆类型类法则
❌ 贬低其他编程语言

✅ 从具体例子出发
✅ 用学生熟悉的概念类比
✅ 强调 Haskell 的实用性
✅ 庆祝学生的每一个小进步

---

## 📚 推荐资源

### 初学者友好
- [Learn You a Haskell](http://learnyouahaskell.com/) - 轻松幽默
- [Haskell Programming from First Principles](https://haskellbook.com/) - 系统深入
- [Real World Haskell](http://book.realworldhaskell.org/) - 实战导向

### 进阶材料
- Typeclassopedia
- Parallel and Concurrent Programming in Haskell
- Thinking with Types

### Cardano 特定
- [Cardano Developer Portal](https://developers.cardano.org/)
- [cardano-api 文档](https://github.com/IntersectMBO/cardano-node/tree/master/cardano-api)
- [Blockfrost 文档](https://docs.blockfrost.io/)

### 视频资源
- Computerphile 的 Haskell 系列
- Erik Meijer 的《Functional Programming Fundamentals》

---

## 💡 答疑技巧

### 常见学生问题的应对

**"Haskell 太学术了，能用来做什么？"**
→ 展示 Cardano、Pandoc、ShellCheck、GitHub 的 Semantic 等真实项目

**"为什么不能用 for 循环？"**
→ 解释递归和高阶函数的等价性，强调递归更符合函数式思维

**"类型错误信息太长看不懂"**
→ 教学生从错误信息的第一行和最后一行找关键信息

**"Monad 到底是什么？"**
→ "一种设计模式，用于组合有上下文的计算"（避免范畴论术语）

**"我能用 Haskell 找到工作吗？"**
→ 说明 Haskell 培养的思维方式在任何语言都有价值，并列举 Haskell 岗位（金融、区块链、编译器）

---

## 🔧 工具链提示

### 推荐 VS Code 扩展
- Haskell（官方，包含 HLS）
- Haskell Syntax Highlighting
- Bracket Pair Colorizer（帮助理解嵌套）

### GHCi 实用命令速查
```haskell
:type expr        -- 查看表达式类型
:info Thing       -- 查看类型类或类型信息
:load File.hs     -- 加载文件
:reload           -- 重新加载
:set +s           -- 显示执行时间和内存
:set -XOverloadedStrings  -- 开启语言扩展
:browse Module    -- 查看模块导出内容
```

### 调试技巧
- 使用 `trace` 函数打印调试信息
- GHCi 中使用 `:break` 和 `:step`（高级）
- 利用类型驱动开发减少调试需求

---

## 📝 课程改进建议

### 收集反馈
- 每周末发送匿名问卷（1 分钟完成）
- 中期进行一次详细调查
- 结课后要求学生写"给下一届的建议"

### 常见改进点
- 适当增加练习难度（进度快的班级）
- 添加更多可视化工具（视觉学习者）
- 准备额外的挑战题（水平参差不齐时）

---

**祝教学顺利！如有问题，欢迎在 GitHub Issues 中讨论。**

