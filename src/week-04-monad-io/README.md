# Week 4: Monad 与 IO

> 掌握副作用处理，连接 Haskell 与真实世界

## 📋 本周目标

- ✅ 深入理解 Monad 的本质和三大定律
- ✅ 熟练使用 do-notation 和 >>= 运算符
- ✅ 理解纯函数与副作用的区别
- ✅ 掌握 IO Monad 进行输入输出
- ✅ 实现文件读写和目录操作
- ✅ 进行基础网络请求（HTTP）

## ⏱️ 预计时长

- **学习时间**：5-6 小时（首次学习）
- **练习时间**：4-5 小时
- **总计**：9-11 小时

> 💡 **建议**：分 3-4 天完成，Monad 和 IO 是 Haskell 的核心，需要充分实践

## 📚 学习材料

1. **[详细讲义](lecture.md)** - Monad 深入 + IO 实战
2. **[练习作业](exercises.md)** - 30+ 道练习题 + 实战项目

## 🎯 前置知识

- ✅ 已完成 Week 3（类型类和 Functor/Applicative/Monad 入门）
- ✅ 理解 Functor 的 fmap 和 Applicative 的 <*>
- ✅ 熟悉 Maybe 和 Either 的基本用法
- ✅ 了解 Monad 的 >>= 和 return

## ⚠️ 本周难点

### 你可能会遇到的挑战

1. **Monad Laws 的抽象性** - "这些定律有什么用？"
   - 💡 定律保证代码行为可预测，就像数学公式的结合律一样

2. **IO 的"污染性"** - "为什么不能从 IO 中逃出？"
   - 💡 这是设计哲学：一旦有副作用，类型系统永远追踪它！

3. **do-notation 脱糖** - "do 语句到底怎么转换的？"
   - 💡 每个 `<-` 都是 `>>=`，最后一行是最终结果

4. **懒惰 IO vs 严格 IO** - "为什么文件没写完？"
   - 💡 Haskell 默认惰性求值，需要强制求值才能保证副作用执行

5. **纯函数与副作用的心智模型** - "IO 到底是什么？"
   - 💡 IO a 是"生成 a 的操作说明书"，不是 a 本身！

## 💡 自学建议

### 如果遇到困难

1. **先掌握实践，后理解理论** - 先会用 do-notation，再深究 Monad laws
2. **把 IO 想象成"操作蓝图"** - IO Int 不是整数，是"如何获得整数的说明"
3. **在 GHCi 中大量实验** - `:type getLine`, `:type (>>=)` 帮助理解
4. **从小程序开始** - 先写 Hello World，再写文件操作，最后网络请求
5. **别被 Monad 吓倒** - 本质就是"链接操作"，像流水线一样

### 学习节奏建议

- **Day 1**: Monad 深入理解 + do-notation（2-3 小时）
- **Day 2**: IO 基础 + 交互式程序（2-3 小时）
- **Day 3**: 文件操作 + 错误处理（2-3 小时）
- **Day 4**: 网络请求 + 综合项目（2-3 小时）

### 与其他语言对比

如果你来自：

- **JavaScript/Python**: IO Monad 类似 Promise/async-await，但更严格
- **Java**: IO 类似受检异常，类型系统强制你处理副作用
- **Rust**: IO 概念类似，但 Haskell 更激进地分离纯与不纯
- **Go**: defer 和错误处理需要显式，IO Monad 更进一步

### 自我检测

学完本周后，你应该能够：

- [ ] 解释 Monad 三大定律并验证自定义 Monad 实例
- [ ] 流畅使用 do-notation 编写 IO 代码
- [ ] 理解 `>>=` 和 `>>` 的区别和使用场景
- [ ] 编写交互式命令行程序（如猜数字游戏）
- [ ] 进行文件的读取、写入、追加操作
- [ ] 处理 IO 中的错误和异常
- [ ] 发起简单的 HTTP 请求并解析响应

如果这些你都能做到，就可以进入 Week 5 了！

## 🔥 本周重点项目

完成这些项目能帮你真正掌握 IO：

1. **猜数字游戏** - 交互式输入输出
2. **TODO 清单 CLI** - 文件读写 + 命令解析
3. **文本文件统计器** - 读取文件 + 数据处理
4. **简易天气查询工具** - HTTP 请求 + JSON 解析（可选）

## 💬 社区资源

遇到问题？可以在这些地方寻求帮助：

- **课程 Issues**: [提问和反馈](https://github.com/mauyin/haskell-101-cn/issues)
- **Stack Overflow**: 搜索 `[haskell] monad` 或 `[haskell] io`
- **Reddit**: [r/haskell](https://www.reddit.com/r/haskell/)
- **Haskell Wiki**: [IO inside](https://wiki.haskell.org/IO_inside)

## 📖 扩展阅读

- [Learn You a Haskell - Input and Output](http://learnyouahaskell.com/input-and-output)
- [Real World Haskell - I/O](http://book.realworldhaskell.org/read/io.html)
- [All About Monads](https://wiki.haskell.org/All_About_Monads) - 经典教程
- [Monads for functional programming](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf) - Philip Wadler 原论文（进阶）

## 🎯 本周重点

**核心理念**：Monad 是 Haskell 中**组合带上下文的计算**的统一方式，而 IO Monad 让我们能在保持纯函数式的同时**安全地处理副作用**！

**学习策略**：
1. 理解 Monad 是什么（组合模式）
2. 掌握 do-notation（语法糖）
3. 大量练习 IO（实战为王）
4. 理解纯与不纯的边界（类型系统）

**关键洞察**：
- `IO a` 不是 `a`，是"如何获得 `a` 的配方"
- 一旦进入 IO，就无法"逃出"（这是好事！）
- do-notation 只是 `>>=` 的语法糖
- Monad laws 保证代码重构不改变语义

---

**准备好了吗？** 开始学习 [详细讲义](lecture.md) →
