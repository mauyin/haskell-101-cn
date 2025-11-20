# Week 7 Examples

Week 7 实践示例代码

## 文件说明

### parse-tx-example.hs
完整的交易解析示例，演示如何：
- 定义交易数据类型
- 实现 FromJSON 实例
- 解析 JSON 文件
- 提取交易信息
- 美化显示结果

**运行**:
```bash
runhaskell parse-tx-example.hs ../tasks/sample-data/transaction.json
```

### blockfrost-client.hs  
简单的 Blockfrost API 客户端，演示如何：
- 配置 API
- 发送 HTTP 请求
- 解析响应
- 错误处理
- 使用示例

**运行** (需要 API Key):
```bash
# 设置 API Key
export BLOCKFROST_KEY="testnetXXXXXXXXXXXX"
runhaskell blockfrost-client.hs addr_test1q...
```

### address-tools.hs
地址工具集合，演示如何：
- 验证地址格式
- 识别地址类型
- 提取地址信息
- 格式化显示

**运行**:
```bash
runhaskell address-tools.hs addr_test1q...
```

### cardano-types.hs
常用 Cardano 类型定义，包括：
- 交易类型
- UTxO 类型
- 地址类型
- 金额类型
- JSON 实例

可以作为你的项目的基础类型定义。

## 学习建议

### 1. 从简单开始
先运行 `address-tools.hs`，理解基本的地址操作。

### 2. 学习解析
阅读 `parse-tx-example.hs`，掌握 JSON 解析技巧。

### 3. 理解 API
学习 `blockfrost-client.hs`，了解 API 调用模式。

### 4. 复用类型
使用 `cardano-types.hs` 中的类型定义作为起点。

## 代码风格

所有示例都遵循以下原则：
- 清晰的类型签名
- 详细的注释
- 错误处理
- 模块化设计
- 可运行的代码

## 扩展练习

基于这些示例，你可以：
1. 添加更多字段到类型定义
2. 实现更复杂的查询
3. 添加缓存机制
4. 实现命令行工具
5. 添加测试用例

祝编码愉快！🎉

