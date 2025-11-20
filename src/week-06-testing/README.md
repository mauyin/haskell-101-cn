# Week 6: 错误处理与测试

> 写出健壮、可靠的 Haskell 代码

## 📋 本周目标

- ✅ 掌握 Haskell 的错误处理模式（Maybe、Either、ExceptT）
- ✅ 理解异常系统及其最佳实践
- ✅ 使用 QuickCheck 编写属性测试
- ✅ 使用 Hspec/HUnit 编写单元测试
- ✅ 实践测试驱动开发（TDD）
- ✅ 学习调试和性能分析技巧

## ⏱️ 预计时长

- **学习时间**：5-6 小时（首次学习）
- **练习时间**：3-4 小时
- **总计**：8-10 小时

> 💡 **建议**：分 3-4 天完成，错误处理和测试是工程实践的核心，需要充分实践

## 📚 学习材料

1. **[详细讲义](lecture.md)** - 错误处理 + 测试框架
2. **[练习作业](exercises.md)** - 25+ 道练习题 + TDD 项目

## 🎯 前置知识

- ✅ 已完成 Week 5（模块与项目管理）
- ✅ 能够使用 Cabal 管理项目
- ✅ 理解 Monad 和 do-notation
- ✅ 熟悉 Maybe 和 Either 基础

## ⚠️ 本周难点

### 你可能会遇到的挑战

1. **ExceptT 的概念** - "Monad Transformer 是什么？"
   - 💡 把它想象成"堆叠"多个 Monad 的能力，ExceptT 在 IO 上加了错误处理

2. **属性测试的思维** - "怎么想出好的属性？"
   - 💡 思考函数的不变量：`reverse . reverse = id`，`length (xs ++ ys) = length xs + length ys`

3. **异常 vs Either** - "什么时候用哪个？"
   - 💡 纯函数用 Either，IO 操作两者都可以，但 Either 更明确

4. **测试的粒度** - "要测试到什么程度？"
   - 💡 关键逻辑必须测试，简单的 getter/setter 可以不测

## 💡 自学建议

### 如果遇到困难

1. **从 Maybe/Either 开始** - 这些你已经熟悉了，只是更系统地学习
2. **先写测试再写代码** - TDD 让你更理解需求
3. **QuickCheck 从简单开始** - 先测试数学函数，再测试复杂逻辑
4. **异常不要怕** - Haskell 的异常比其他语言简单

### 学习节奏建议

- **Day 1**: Maybe/Either/ExceptT 模式（2-3 小时）
- **Day 2**: 异常处理和实践（2 小时）
- **Day 3**: QuickCheck 属性测试（2-3 小时）
- **Day 4**: Hspec 单元测试 + TDD 项目（2-3 小时）

### 与其他语言对比

如果你来自：

- **Java/C#**: Either 类似 Result<T, E>，异常概念相同但更轻量
- **Rust**: Either 就是 Result<T, E>！概念完全一样
- **Python**: try/except 对应异常，Either 是函数式替代
- **Go**: Either 类似 `(value, error)` 返回模式
- **JavaScript**: Either 类似 Promise 的 reject，但在纯函数中

### 自我检测

学完本周后，你应该能够：

- [ ] 使用 Maybe 和 Either 处理可能失败的函数
- [ ] 使用 ExceptT 组合多个可能失败的 IO 操作
- [ ] 理解何时使用异常、何时使用 Either
- [ ] 编写 QuickCheck 属性测试
- [ ] 编写 Hspec 单元测试
- [ ] 实践测试驱动开发
- [ ] 使用 GHCi 调试器调试代码

如果这些你都能做到，就可以进入 Week 7 了！

## 🔥 本周重点项目

完成这些项目能帮你真正掌握错误处理和测试：

1. **计算器 with 错误处理** - 安全的表达式求值器
2. **带测试的数据验证器** - TDD 开发输入验证
3. **文件处理器 with 异常** - 健壮的文件操作

## 💬 社区资源

遇到问题？可以在这些地方寻求帮助：

- **课程 Issues**: [提问和反馈](https://github.com/mauyin/haskell-101-cn/issues)
- **Stack Overflow**: 搜索 `[haskell] error-handling` 或 `[haskell] quickcheck`
- **Reddit**: [r/haskell](https://www.reddit.com/r/haskell/)
- **QuickCheck 文档**: [Hackage](https://hackage.haskell.org/package/QuickCheck)

## 📖 扩展阅读

- [Error Handling in Haskell](https://wiki.haskell.org/Error_handling)
- [QuickCheck Manual](http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html)
- [Hspec User Guide](https://hspec.github.io/)
- [Real World Haskell - Testing](http://book.realworldhaskell.org/read/testing-and-quality-assurance.html)
- [Property Testing with QuickCheck](https://begriffs.com/posts/2017-01-14-design-use-quickcheck.html)

## 🎯 本周重点

**核心理念**：Haskell 通过**类型系统追踪错误**，让错误处理变成编译时检查。配合**自动化测试**，我们能写出极其可靠的代码！

**学习策略**：
1. 掌握 Maybe/Either/ExceptT 错误处理模式
2. 理解纯函数错误 vs IO 异常的区别
3. 学会用 QuickCheck 验证代码属性
4. 实践测试驱动开发

**关键洞察**：
- 类型是最好的文档：`Either Error Result` 告诉你可能失败
- 属性测试覆盖边界情况：比手写测试用例更全面
- ExceptT 让错误处理像同步代码一样简单
- 测试不是负担，是自信的来源

**常见陷阱**：
- ❌ 过度使用异常：纯函数应该返回 Maybe/Either
- ❌ 忽略错误：总是处理 Maybe 的 Nothing 和 Either 的 Left
- ❌ 测试太少：关键业务逻辑必须有测试
- ❌ 只写正向测试：也要测试错误情况

---

**准备好了吗？** 开始学习 [详细讲义](lecture.md) →
