# Haskell 入门课程（2025 中文版）

> 基于 [haskell-beginners-2022/course-plan](https://github.com/haskell-beginners-2022/course-plan)，全部内容更新至 2025 标准，去除 Plutus，增加温和的 Cardano 实践

## 📚 课程目标

- **零基础学会现代 Haskell** —— 从环境搭建到函数式编程核心概念
- **完全跨平台** —— Windows / macOS / Linux 均可使用
- **真实 Cardano 应用** —— 第 7 周开始接触真实 Cardano 数据，激发学习兴趣
- **动手能力培养** —— 结课能用纯 Haskell 构建/签名 Cardano 交易（off-chain）

## 🎯 适合人群

- 编程初学者，想学习函数式编程思维
- 有其他语言基础，想学习 Haskell
- 对 Cardano 区块链感兴趣，想了解其技术栈
- 想为 Cardano 生态贡献代码的开发者

## 📋 前置要求

- **无需编程经验** —— 课程从零开始
- 能够使用命令行终端
- 有稳定的网络连接（用于安装工具和访问文档）
- 预留每周 4-6 小时学习时间

## 📅 课程大纲

| 周次 | 主题                  | 主要内容                                           | 练习 / 动手任务                                      |
|------|-----------------------|----------------------------------------------------|-----------------------------------------------------|
| [Week 0](week-00-setup/README.md) | 环境搭建              | GHCup、VS Code + Haskell 扩展、GHCi 入门          | 安装验证 + "Hello, Cardano!"                        |
| Week 1 | Haskell 基础语法      | 函数、类型、列表、递归、高阶函数、lambda           | 列表处理（map/filter/foldr）                        |
| Week 2 | 数据类型与模式匹配    | 元组、ADT、记录、case 表达式                       | 自定义 Tree、Result 类型练习                        |
| Week 3 | 类型类                | Eq/Ord/Show/Functor/Applicative/Monad、deriving    | 实现自定义实例 + foldable 实例                       |
| Week 4 | Monad 与 IO           | do 记法、纯函数与副作用、文件/网络 IO              | 猜数字游戏 + 简单命令行 TODO                        |
| Week 5 | 模块与项目管理        | Cabal 项目、常用库（aeson、bytestring、req）      | 天气查询工具 + JSON 解析程序                        |
| Week 6 | 错误处理与测试        | Maybe/Either/ExceptT、QuickCheck                   | 带错误处理程序 + 属性测试                           |
| Week 7 | Cardano 简介 + Haskell 实践 | Cardano 为什么选 Haskell、eUTxO 模型、cardano-api | • 用 aeson 解析真实交易 JSON<br>• 用 cardano-api 构建并签名简单转账交易<br>• 用 req + Blockfrost 查询地址余额 |
| Week 8 | 结课项目              | 综合项目（命令行 Cardano 工具）                    | 独立完成余额监控器或交易构建器并展示                |

## 🛠️ 所需工具（全部免费）

### 必需工具
- **GHCup** - Haskell 工具链管理器
  - 官网：https://www.haskell.org/ghcup/
  - 包含：GHC（编译器）、Cabal（包管理）、HLS（语言服务器）
  
- **VS Code** - 代码编辑器
  - 官网：https://code.visualstudio.com/
  - 安装 Haskell 扩展

### 第 7 周额外工具
- **cardano-node & cardano-cli** - Cardano 官方工具（Week 7 使用 testnet）
- **Blockfrost 免费 API key** - 用于查询区块链数据（可选）
  - 注册：https://blockfrost.io

## 🚀 快速开始

```bash
# 1. 安装 GHCup（会自动安装 GHC、Cabal、HLS）
# Linux/macOS:
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Windows:
# 下载并运行：https://www.haskell.org/ghcup/install.html

# 2. 验证安装
ghc --version      # 应显示 GHC 9.10.x 或更高
cabal --version    # 应显示 Cabal 3.12.x 或更高

# 3. 启动 GHCi（Haskell 交互式解释器）
ghci
> 2 + 2
4
> :quit

# 4. 开始学习
# 继续阅读 Week 0 - 环境搭建章节
```

## 📖 学习建议

1. **按周学习** - 不要跳过任何章节，知识是递进的
2. **动手实践** - 每周至少完成 80% 的练习题
3. **实验代码** - 在 GHCi 中尝试各种变化，观察结果
4. **寻求帮助** - 遇到问题及时在社区提问
5. **小步快跑** - 每天学习 1 小时比周末集中学习 7 小时效果更好

## 💬 社区支持

- **GitHub Issues** - 在本仓库提交问题和建议
- **Cardano 中文社区** - [Cardano Forum 中文板块](https://forum.cardano.org/c/chinese/204)
- **Haskell 学习资源**
  - [Haskell 官方文档](https://www.haskell.org/documentation/)
  - [Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) （英文经典教材）

## 🤝 贡献

欢迎贡献！如果您发现错误、有改进建议或想添加新内容：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的改动 (`git commit -m '添加某个新功能'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

### 贡献指南
- 所有文本内容使用简体中文
- 代码注释适度使用中文（关键概念处）
- 保持代码示例简洁（< 30 行）
- 所有函数必须包含类型签名
- 添加练习时请同时提供参考答案

## 📄 许可证

本课程材料采用 [MIT License](LICENSE)。

## 🙏 致谢

- [haskell-beginners-2022](https://github.com/haskell-beginners-2022/course-plan) - 原始课程框架
- [GHCup 项目](https://www.haskell.org/ghcup/) - 现代 Haskell 工具链
- [Cardano 开发者社区](https://developers.cardano.org/) - Cardano 技术文档
- 所有为 Haskell 和 Cardano 生态做出贡献的开发者

---

**开始学习：** 继续阅读下一章节 →

