# 参考实现

本目录包含两个项目的完整参考实现说明和关键代码片段。

## 📋 概述

参考实现不是完整的可运行项目，而是：
- **关键代码片段**：展示核心功能的实现
- **设计模式**：说明如何组织代码
- **实现技巧**：分享有用的实现方法
- **常见问题解决方案**：如何处理典型问题

## 🎯 使用建议

1. **先自己尝试**：不要直接查看参考实现
2. **遇到困难时参考**：当卡住时，查看相关部分
3. **理解而不是复制**：理解实现思路，用自己的方式实现
4. **比较方法**：完成后，比较你的实现和参考实现

## 📂 文件说明

### wallet-tool-key-implementations.md
钱包工具的关键实现片段：
- API 调用实现
- 交易构建算法
- UTxO 选择策略
- 状态管理模式

### balance-monitor-key-implementations.md
余额监控器的关键实现片段：
- 监控循环实现
- 变化检测算法
- 通知系统
- 并发查询优化

### common-patterns.md
两个项目通用的模式：
- 错误处理策略
- 配置管理
- 数据持久化
- CLI 设计

### design-decisions.md
重要的设计决策说明：
- 为什么选择某种数据结构
- 权衡考虑
- 替代方案
- 性能考量

## 🔍 代码片段索引

### 钱包工具

**基础功能**:
- 地址生成 → `wallet-tool-key-implementations.md#地址生成`
- 余额查询 → `wallet-tool-key-implementations.md#余额查询`
- UTxO 查看 → `wallet-tool-key-implementations.md#utxo-查看`

**高级功能**:
- 交易构建 → `wallet-tool-key-implementations.md#交易构建`
- UTxO 选择 → `wallet-tool-key-implementations.md#utxo-选择`
- 费用计算 → `wallet-tool-key-implementations.md#费用计算`

### 余额监控器

**基础功能**:
- 监控列表管理 → `balance-monitor-key-implementations.md#监控列表`
- 余额查询 → `balance-monitor-key-implementations.md#余额查询`

**核心功能**:
- 监控循环 → `balance-monitor-key-implementations.md#监控循环`
- 变化检测 → `balance-monitor-key-implementations.md#变化检测`
- 通知系统 → `balance-monitor-key-implementations.md#通知系统`

### 通用模式

- ExceptT 错误处理 → `common-patterns.md#exceptt-模式`
- YAML 配置 → `common-patterns.md#配置管理`
- JSON 持久化 → `common-patterns.md#数据持久化`
- API 重试 → `common-patterns.md#api-重试`

## 💡 学习路径

### 初学者
1. 先阅读 `common-patterns.md` 了解基本模式
2. 查看简单功能的实现（如地址生成）
3. 逐步理解复杂功能

### 进阶
1. 比较你的实现和参考实现
2. 理解设计决策背后的原因
3. 探索优化和改进空间

## ⚠️ 重要提示

### 不要直接复制粘贴
参考实现的目的是**学习**，不是复制。直接复制不会帮助你理解，也不利于你的成长。

### 可能有多种实现方式
参考实现展示的是**一种**方式，不是**唯一**方式。你的实现可能与参考不同，但只要正确就是好的。

### 代码可能不完整
某些片段为了清晰起见可能省略了错误处理或边界情况处理。实际项目中需要更完善。

## 🎓 学完后

完成项目并参考实现后，思考：

1. **你的方法和参考方法有何不同？**
2. **哪种方法更好？为什么？**
3. **你学到了什么新技巧？**
4. **如果重新实现，你会怎么做？**

## 📚 相关资源

- [实施指南](../../src/week-08-project/guide.md)
- [评估标准](../../src/week-08-project/evaluation.md)
- [Week 1-7 讲义](../../src/)

## 🤝 贡献

如果你发现参考实现中的问题或有更好的实现方式，欢迎提出！

---

**记住**：最好的学习方式是自己动手实践。参考实现只是辅助工具，真正的学习来自你自己的思考和尝试。

祝你学习愉快！🚀

