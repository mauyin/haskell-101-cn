# 通用工具库

这个目录包含两个项目都可以使用的通用代码和工具。

## 包含的文件

### CardanoAPI.hs
Blockfrost API 调用的辅助函数。

**功能**:
- HTTP 请求封装
- 错误处理
- 重试逻辑
- 响应解析

**使用方法**:
复制到你的项目 `src/` 目录，或者作为参考实现自己的版本。

### Config.hs
配置管理的通用模式。

**功能**:
- YAML 配置加载
- 环境变量读取
- 默认配置

### Display.hs
格式化输出的辅助函数。

**功能**:
- 表格输出
- 进度条
- 颜色输出（可选）
- 时间格式化

### TestData.hs
测试用的示例数据。

**功能**:
- 示例地址
- 示例交易
- Mock API 响应

## 如何使用

### 方法 1: 复制到项目

```bash
# 对于 wallet-tool
cp common/CardanoAPI.hs projects/wallet-tool/src/Wallet/

# 对于 balance-monitor
cp common/Display.hs projects/balance-monitor/src/Monitor/
```

### 方法 2: 作为参考

阅读代码，理解实现模式，然后在自己的项目中实现类似的功能。

## 注意事项

1. 这些是辅助工具，不是必需的
2. 可以根据需要修改
3. 主要目的是提供实现思路
4. 不要直接依赖这些文件，因为它们不在 Cabal 项目中

## 推荐使用场景

- **CardanoAPI.hs**: 如果你在实现 API 调用时遇到困难
- **Config.hs**: 如果你想实现配置文件管理
- **Display.hs**: 如果你想改进输出格式
- **TestData.hs**: 如果你想在没有 API 的情况下测试

## 示例

### 使用 CardanoAPI.hs

```haskell
import CardanoAPI

config = APIConfig "your-api-key" "https://cardano-testnet.blockfrost.io"
result <- callBlockfrost config "/addresses/addr_test1q..."
```

### 使用 Display.hs

```haskell
import Display

displayTable
  [ ("Address", "Balance", "Status")
  , ("addr1...", "100 ADA", "✓")
  , ("addr2...", "50 ADA", "✓")
  ]
```

## 资源

这些工具基于 Week 5-7 的知识构建。如果遇到不理解的部分，请回顾相关讲义。

