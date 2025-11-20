# Week 5: 模块与项目管理

> 构建真实世界的 Haskell 项目

## 📋 本周目标

- ✅ 理解 Haskell 模块系统的设计与使用
- ✅ 掌握 import 和 export 的各种形式
- ✅ 使用 Cabal 创建和管理项目
- ✅ 熟练使用常用库（aeson、bytestring、req）
- ✅ 理解依赖管理和版本控制
- ✅ 构建完整的命令行应用程序

## ⏱️ 预计时长

- **学习时间**：4-5 小时（首次学习）
- **练习时间**：2-3 小时
- **总计**：6-8 小时

> 💡 **建议**：分 3-4 天完成，模块系统概念简单但实践性强，建议边学边动手

## 📚 学习材料

1. **[详细讲义](lecture.md)** - 模块系统 + Cabal + 常用库
2. **[练习作业](exercises.md)** - 20+ 道练习题 + 2 个实战项目

## 🎯 前置知识

- ✅ 已完成 Week 4（Monad 与 IO）
- ✅ 能够编写基本的 IO 程序
- ✅ 理解文件操作和网络请求基础
- ✅ 熟悉命令行操作

## ⚠️ 本周难点

### 你可能会遇到的挑战

1. **Cabal 依赖解析** - "为什么安装这么慢/失败？"
   - 💡 这是正常现象！Cabal 需要解析复杂的依赖树，第一次会很慢

2. **模块导入困惑** - "qualified import 什么时候用？"
   - 💡 当两个模块有同名函数时使用 qualified，避免命名冲突

3. **项目结构** - "app/ 和 src/ 有什么区别？"
   - 💡 src/ 放库代码（可被其他项目使用），app/ 放可执行程序入口

4. **版本冲突** - "依赖版本不兼容怎么办？"
   - 💡 使用 cabal.project 文件指定版本，或等待库更新

5. **aeson 的魔法** - "FromJSON 怎么自动工作的？"
   - 💡 GHC 的泛型编程（Generics）在背后做了类型派生

## 💡 自学建议

### 如果遇到困难

1. **从小项目开始** - 先创建最简单的 Hello World Cabal 项目
2. **不要怕 Cabal 错误** - 错误信息虽然长，但通常会指出问题所在
3. **善用 Hackage** - 每个库的文档都在 hackage.haskell.org
4. **先跑通示例** - 看懂一个完整项目比零散知识更有用
5. **遇到依赖问题** - 先尝试 `cabal update`，然后 `cabal clean`

### 学习节奏建议

- **Day 1**: 模块系统基础 + 自己的模块（2 小时）
- **Day 2**: Cabal 项目管理实战（2-3 小时）
- **Day 3**: 常用库学习（aeson/bytestring/req）（2-3 小时）
- **Day 4**: 完成综合项目（2-3 小时）

### 与其他语言对比

如果你来自：

- **JavaScript/Node.js**: Cabal 类似 npm，.cabal 文件类似 package.json
- **Python**: Cabal 类似 pip + setuptools，但类型安全
- **Rust**: Cabal 类似 Cargo，概念几乎一样！
- **Java**: Cabal 类似 Maven/Gradle
- **Go**: 模块系统类似 Go modules

### 自我检测

学完本周后，你应该能够：

- [ ] 创建多模块 Haskell 项目
- [ ] 正确使用 import 和 export
- [ ] 用 Cabal 初始化、构建、运行项目
- [ ] 添加和使用第三方库依赖
- [ ] 使用 aeson 解析和生成 JSON
- [ ] 使用 req 发起 HTTP 请求
- [ ] 处理 ByteString 高效字符串操作
- [ ] 构建完整的命令行工具

如果这些你都能做到，就可以进入 Week 6 了！

## 🔥 本周重点项目

完成这些项目能帮你真正掌握项目管理：

1. **天气查询工具** - 命令行天气查询（HTTP + JSON）
2. **JSON 配置解析器** - 读写配置文件
3. **多模块计算器** - 实践模块组织

## 💬 社区资源

遇到问题？可以在这些地方寻求帮助：

- **课程 Issues**: [提问和反馈](https://github.com/mauyin/haskell-101-cn/issues)
- **Stack Overflow**: 搜索 `[haskell] cabal` 或 `[haskell] modules`
- **Reddit**: [r/haskell](https://www.reddit.com/r/haskell/)
- **Hackage**: [Haskell 包仓库](https://hackage.haskell.org/)

## 📖 扩展阅读

- [Cabal User Guide](https://cabal.readthedocs.io/) - 官方文档
- [Haskell Module System](https://www.haskell.org/tutorial/modules.html)
- [aeson 教程](https://hackage.haskell.org/package/aeson)
- [req 教程](https://hackage.haskell.org/package/req)
- [School of Haskell - Modules](https://www.schoolofhaskell.com/school/starting-with-haskell/modules-and-cabal)

## 🎯 本周重点

**核心理念**：模块系统让我们**组织大型代码库**，Cabal 让我们**管理依赖和构建**，而掌握常用库能让我们**构建真实应用**！

**学习策略**：
1. 理解模块的 import/export 机制
2. 动手创建 Cabal 项目（必须实践！）
3. 学习三个核心库的基本用法
4. 通过项目整合所有知识

**关键洞察**：
- 模块不只是文件组织，更是抽象边界
- Cabal 虽然有时慢，但保证了类型安全的依赖
- aeson 的自动派生是 Haskell 泛型编程的威力
- ByteString 在处理大量数据时性能远超 String

**常见陷阱**：
- ❌ 忘记在 .cabal 文件中添加新模块
- ❌ import 时出现命名冲突
- ❌ 依赖版本冲突导致构建失败
- ❌ 混淆 String、Text、ByteString

---

**准备好了吗？** 开始学习 [详细讲义](lecture.md) →
