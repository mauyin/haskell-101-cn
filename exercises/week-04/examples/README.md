# Week 4 Examples - Monad 与 IO 示例程序

本目录包含三个完整的示例程序，展示本周学习的核心概念。

## 📋 示例列表

### 1. SimpleCalculator.hs - 简单计算器
**学习目标**: IO 基础、错误处理、用户交互

一个交互式计算器，演示：
- 基本 IO 操作 (getLine, putStrLn)
- Either Monad 错误处理
- do-notation 使用
- 用户输入验证

**运行方式**:
```bash
ghci SimpleCalculator.hs
> main
```

---

### 2. FileCounter.hs - 文件统计工具
**学习目标**: 文件操作、Maybe Monad、纯函数分离

统计文件的行数、单词数、字符数，演示：
- 文件读取 (readFile)
- 纯函数与 IO 分离
- Maybe Monad 处理可选值
- 命令行参数处理

**运行方式**:
```bash
# 方式 1: 在 GHCi 中
ghci FileCounter.hs
> analyzeAndDisplay "yourfile.txt"

# 方式 2: 编译运行
ghc FileCounter.hs
./FileCounter yourfile.txt
```

---

### 3. TodoMini.hs - 迷你 TODO 应用
**学习目标**: 综合应用、文件持久化、完整程序结构

一个简化的 TODO 清单应用，演示：
- 完整的 CRUD 操作
- 文件持久化
- 交互式循环
- 数据类型设计
- IO 与纯函数组合

**运行方式**:
```bash
ghci TodoMini.hs
> main
```

---

## 🎯 学习路径建议

1. **先学后看**: 完成相关练习后再查看示例
2. **对比学习**: 将示例与练习题解答对比，理解不同实现方式
3. **修改实验**: 尝试修改示例，添加新功能
4. **独立编写**: 参考示例结构，编写自己的小程序

## 💡 常见问题

### Q: 为什么有些函数在 where 子句中？
A: 这是 Haskell 的模块化方式。辅助函数放在 where 子句中，保持主函数清晰。

### Q: 可以用这些示例作为项目起点吗？
A: 当然！这些示例设计为可扩展的。你可以添加更多功能。

### Q: 示例用到了哪些我还没学的库？
A: 这些示例只用标准库 (Prelude)。不需要额外安装包。

## 📚 相关资源

- **讲义**: `src/week-04-monad-io/lecture.md`
- **练习**: `exercises/week-04/tasks/Week04Exercises.hs`
- **答案**: `exercises/week-04/solutions/Week04Exercises.hs`

---

**提示**: 在 GHCi 中使用 `:reload` (或 `:r`) 重新加载修改后的文件。



