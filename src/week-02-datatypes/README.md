# Week 2: 数据类型与模式匹配

> 用类型系统建模真实世界

## 📋 本周目标

- ✅ 理解和使用元组 (Tuples)
- ✅ 定义自己的数据类型 (ADT - Algebraic Data Types)
- ✅ 掌握记录语法 (Record Syntax)
- ✅ 深入模式匹配 (Pattern Matching)
- ✅ 使用 Maybe 和 Either 处理可选值和错误
- ✅ 构建和操作树结构

## ⏱️ 预计时长

- **学习时间**：3-4 小时（首次学习）
- **练习时间**：2-3 小时
- **总计**：5-7 小时

> 💡 **建议**：分 2-3 天完成，ADT 概念需要时间消化

## 📚 学习材料

1. **[详细讲义](lecture.md)** - 数据类型深度解析
2. **[练习作业](exercises.md)** - 20+ 道练习题

## 🎯 前置知识

- ✅ 已完成 Week 1（函数、列表、递归）
- ✅ 理解基本的模式匹配
- ✅ 熟悉类型签名

## ⚠️ 本周难点

### 你可能会遇到的挑战

1. **ADT 与面向对象的区别** - "为什么没有方法？"
   - 💡 Haskell 分离数据和行为，这是设计哲学

2. **Maybe 类型的"繁琐感"** - "为什么不能用 null？"
   - 💡 Maybe 强制你处理缺失情况，避免运行时错误

3. **模式匹配的穷尽性** - 编译器警告所有情况都要覆盖
   - 💡 这是好事！帮你避免遗漏边界情况

4. **递归数据类型** - 类型定义中引用自己
   - 💡 像列表和树这样的结构都是递归定义的

## 💡 自学建议

### 如果遇到困难

1. **先看简单例子** - 从扑克牌、交通灯这样的简单类型开始
2. **画图理解** - 画出数据结构的形状，特别是树
3. **对比其他语言** - 想想 enum、union、struct 的概念
4. **不要急于理解所有细节** - 先会用，再深究原理

### 学习节奏建议

- **Day 1**: 元组 + 简单 ADT + Maybe（2-3 小时）
- **Day 2**: 记录语法 + Either + case 表达式（2-3 小时）
- **Day 3**: 树结构 + 综合练习（2-3 小时）

### 与其他语言对比

如果你来自：

- **Python/JavaScript**: ADT 类似 dataclass/object，但数据和方法分离
- **Java/C#**: ADT 类似 sealed class/enum，但更强大
- **Rust**: ADT 就是 Rust 的 enum！概念几乎一样
- **C/C++**: ADT 类似 union + struct，但类型安全

### 自我检测

学完本周后，你应该能够：

- [ ] 定义自己的数据类型（如 Card、Shape、Tree）
- [ ] 用模式匹配处理不同的构造器
- [ ] 使用 Maybe 代替 null/None
- [ ] 使用 Either 表示成功或失败
- [ ] 实现二叉树的基本操作
- [ ] 理解记录语法的优缺点

如果这些你都能做到，就可以进入 Week 3 了！

## 💬 社区资源

遇到问题？可以在这些地方寻求帮助：

- **课程 Issues**: [提问和反馈](https://github.com/mauyin/haskell-101-cn/issues)
- **Stack Overflow**: 搜索 `[haskell] algebraic-data-types`
- **Reddit**: [r/haskell](https://www.reddit.com/r/haskell/)
- **Haskell Wiki**: [ADT 详解](https://wiki.haskell.org/Algebraic_data_type)

## 📖 扩展阅读

- [Learn You a Haskell - Making Our Own Types](http://learnyouahaskell.com/making-our-own-types-and-typeclasses)
- [Real World Haskell - Defining Types](http://book.realworldhaskell.org/read/defining-types-streamlining-functions.html)
- [Haskell Wiki - Maybe](https://wiki.haskell.org/Maybe)

## 🎯 本周重点

**核心理念**：在 Haskell 中，我们用**类型来建模问题域**。好的类型设计能让很多错误在编译时就被发现！

---

**准备好了吗？** 开始学习 [详细讲义](lecture.md) →
