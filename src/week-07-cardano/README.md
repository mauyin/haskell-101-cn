# Week 7: Cardano 简介 + Haskell 实践

欢迎来到 Week 7！本周我们将学习 Cardano 区块链以及如何用 Haskell 与之交互。

## 📋 本周概览

本周我们将学习：
- 为什么 Cardano 使用 Haskell
- eUTxO 模型基础
- Cardano 交易结构
- 使用 Haskell 解析 Cardano 数据
- 通过 Blockfrost API 查询区块链
- 构建实用的 Cardano 工具

**重要说明**：本周聚焦于 **链下 (off-chain)** 的 Haskell 应用，不涉及智能合约编程。我们将使用前几周学到的 Haskell 知识（模块、错误处理、JSON 解析、HTTP 请求）来处理真实的 Cardano 数据。

## 🎯 学习目标

完成本周学习后，你将能够：

1. **理解** Cardano 选择 Haskell 的原因
2. **掌握** eUTxO 模型的基本概念
3. **解析** Cardano 交易的 JSON 数据
4. **使用** Blockfrost API 查询地址余额和交易历史
5. **构建** 简单的 Cardano 命令行工具
6. **应用** Week 5-6 学到的错误处理和测试技能

## ⏱️ 时间估计

- **讲义学习**：4-5 小时
  - Cardano 基础概念：1.5 小时
  - eUTxO 模型：1 小时
  - 交易结构和 API：1.5-2 小时
  
- **练习实践**：2-3 小时
  - JSON 解析练习：30 分钟
  - API 查询练习：30 分钟
  - 项目 1（余额查询工具）：1 小时
  - 项目 2（交易浏览器）：1 小时

**总计**：6-8 小时

## 📚 前置要求

在开始本周学习前，请确保你已完成：

- ✅ Week 1-4：Haskell 基础语法、类型、Monad、IO
- ✅ **Week 5**：模块系统、aeson、bytestring、req 库
- ✅ **Week 6**：错误处理（Maybe/Either/ExceptT）、测试

**特别重要**：Week 5 的 `aeson`（JSON 解析）和 `req`（HTTP 请求）是本周的核心工具。

## ⚠️ 难度提示

### 适合人群

本周内容适合：
- 已完成 Week 1-6 的学习者
- 对区块链技术感兴趣的 Haskell 学习者
- 想要将 Haskell 应用于实际项目的同学

### 可能的挑战

1. **新概念较多**：区块链、UTXO、交易结构等概念可能是第一次接触
   - 💡 不用担心！我们会循序渐进地解释
   
2. **可选的 Cardano 环境设置**：
   - **简单路径**：使用提供的示例数据，无需安装任何 Cardano 工具
   - **进阶路径**：注册 Blockfrost 免费 API
   - **高级路径**：安装 cardano-node 测试网（可选）
   
3. **综合应用**：需要综合运用前几周的知识
   - 💡 这正是最好的复习机会！

## 🗺️ 学习路径

### 推荐学习顺序

1. **阅读讲义** → [详细讲义](lecture.md)
   - 先理解为什么 Cardano 使用 Haskell
   - 学习 eUTxO 模型
   - 了解交易结构

2. **设置环境** → 参考 `exercises/week-07/tasks/SETUP-GUIDE.md`
   - 选择你的路径（示例数据 / API / 测试网）
   - 初学者建议从示例数据开始

3. **完成练习** → [练习作业](exercises.md)
   - 从 JSON 解析开始
   - 逐步过渡到 API 调用
   - 完成两个实战项目

4. **参考示例** → `exercises/week-07/examples/`
   - 学习完整的解析示例
   - 参考 Blockfrost 客户端实现

## 💡 自学建议

### 对于区块链新手

- **不要被术语吓到**：UTXO、eUTxO、Lovelace 等术语会逐一解释
- **类比学习**：我们会将 Cardano 概念类比到熟悉的事物
- **动手实践**：运行示例代码，观察输出，建立直觉
- **循序渐进**：先用示例数据，理解后再尝试真实 API

### 对于 Haskell 学习者

- **复习 Week 5**：`aeson` 和 `req` 是本周的核心
- **应用 Week 6**：Cardano API 调用需要良好的错误处理
- **看类型签名**：Cardano API 的类型能告诉你很多信息
- **测试驱动**：为你的 Cardano 工具编写测试

### 常见困惑

**Q: 我需要懂区块链才能学这周吗？**  
A: 不需要！讲义会从零开始介绍必要的区块链概念。

**Q: 我需要安装 Cardano 节点吗？**  
A: 不需要！所有练习都可以用示例数据完成。Blockfrost API 和本地节点都是可选的。

**Q: 这周会涉及智能合约吗？**  
A: 不会！本周完全聚焦于链下的 Haskell 应用，不涉及 Plutus 或智能合约编程。

**Q: 我能用学到的知识做什么？**  
A: 你将能够构建 Cardano 相关的工具，如地址监控器、交易浏览器、余额查询工具等。

## 📖 学习资源

### 官方文档

- [Cardano 开发者门户](https://developers.cardano.org/)
- [Cardano 文档](https://docs.cardano.org/)
- [Blockfrost API 文档](https://docs.blockfrost.io/)

### 社区资源

- [Cardano 中文社区](https://forum.cardano.org/)
- [Cardano Stack Exchange](https://cardano.stackexchange.com/)
- [IOG 技术博客](https://iohk.io/en/blog/)

### 推荐阅读（可选）

- [UTXO vs Account Model](https://docs.cardano.org/learn/eutxo-explainer)
- [Understanding EUTXO](https://www.essentialcardano.io/article/the-eutxo-handbook)

## 📝 本周内容

- [详细讲义](lecture.md) - 全面讲解 Cardano 概念和 Haskell 实践
- [练习作业](exercises.md) - 20+ 道练习 + 2 个实战项目

## 🎯 完成标准

完成以下任务即可进入 Week 8：

### 必做
- [ ] 阅读完讲义，理解 eUTxO 模型
- [ ] 完成 JSON 解析练习（5 题）
- [ ] 完成至少一个实战项目
- [ ] 能够解释 Cardano 选择 Haskell 的原因

### 推荐
- [ ] 完成所有练习
- [ ] 完成两个实战项目
- [ ] 尝试使用 Blockfrost API
- [ ] 为你的工具编写测试

### 挑战（可选）
- [ ] 设置 cardano-node 测试网
- [ ] 构建并提交真实交易
- [ ] 扩展项目添加新功能

## 🚀 准备好了吗？

开始学习前：
1. 确保完成了 Week 1-6
2. 复习 Week 5 的 `aeson` 和 `req`
3. 准备好编写实用的 Cardano 工具

让我们开始探索 Cardano 与 Haskell 的结合！

---

**下一步**：[开始学习讲义](lecture.md) 或 [直接进入练习](exercises.md)
