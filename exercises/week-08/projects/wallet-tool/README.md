# Cardano Wallet Tool 💼

命令行 Cardano 钱包工具 - Week 8 结课项目

## 项目简介

这是一个命令行钱包工具，支持：
- 地址生成和管理
- 余额查询（Blockfrost API）
- UTxO 查看
- 交易构建（模拟）
- 状态持久化

## 快速开始

### 构建项目

```bash
cabal build
```

### 运行

```bash
cabal run wallet-tool -- help
```

## 功能

### 必需功能

- [x] 地址管理
  - [ ] 生成地址
  - [ ] 列出地址
  - [ ] 添加标签
  - [ ] 删除地址

- [x] 余额查询
  - [ ] 查询单个地址
  - [ ] 查询所有地址
  - [ ] 格式化显示

- [x] UTxO 查看
  - [ ] 显示 UTxO 列表
  - [ ] 计算总额

- [x] 交易构建
  - [ ] 选择 UTxO
  - [ ] 计算费用
  - [ ] 构建交易
  - [ ] 保存为 JSON

- [x] 状态持久化
  - [ ] 保存地址列表
  - [ ] 加载状态
  - [ ] 自动备份

- [x] CLI 界面
  - [x] 帮助信息
  - [ ] 所有命令实现

### 可选功能

- [ ] 交易历史查询
- [ ] 多钱包支持
- [ ] CSV 导出
- [ ] 配置文件

## 使用方法

### 生成地址

```bash
wallet-tool generate "My Wallet"
```

### 查询余额

```bash
wallet-tool balance addr_test1q...
```

### 查看 UTxOs

```bash
wallet-tool utxos addr_test1q...
```

### 构建交易

```bash
wallet-tool send addr_from addr_to 10.5
```

## 项目结构

```
wallet-tool/
├── src/
│   ├── Wallet/
│   │   ├── Types.hs          -- 数据类型定义
│   │   ├── Address.hs        -- 地址操作
│   │   ├── Balance.hs        -- 余额查询
│   │   ├── Transaction.hs    -- 交易构建
│   │   ├── Storage.hs        -- 状态持久化
│   │   ├── API.hs            -- API 调用
│   │   └── CLI.hs            -- 命令行接口
│   └── Wallet.hs             -- 主模块
├── app/
│   └── Main.hs               -- 程序入口
├── test/
│   └── WalletSpec.hs         -- 测试
└── wallet-tool.cabal         -- 项目配置
```

## 实施步骤

查看 `TASKS.md` 获取详细的实施清单。

### Phase 1: 基础结构 (2小时)
- 完成类型定义
- 实现 CLI 参数解析
- 实现帮助信息

### Phase 2: API 集成 (2小时)
- 实现 Blockfrost API 调用
- 解析 API 响应
- 错误处理

### Phase 3: 核心功能 (2-3小时)
- 地址生成和管理
- 余额查询
- UTxO 查看
- 状态保存/加载

### Phase 4: 交易构建 (2小时)
- UTxO 选择
- 费用计算
- 交易构建
- 验证

### Phase 5: 完善 (1-2小时)
- 测试
- 文档
- 用户体验优化

## 配置

在 `app/Main.hs` 中修改配置：

```haskell
let config = Config
      { cfgApiKey = "你的 Blockfrost API Key"
      , cfgApiEndpoint = "https://cardano-testnet.blockfrost.io"
      , cfgDataDir = ".cardano-wallet"
      }
```

或者从配置文件加载（可选功能）。

## 测试

运行测试：

```bash
cabal test
```

## 调试

使用 GHCi 进行调试：

```bash
cabal repl
> :load Wallet.Address
> generateAddress
```

## 常见问题

**Q: 如何获取 Blockfrost API Key？**  
A: 访问 https://blockfrost.io 注册并创建测试网项目。

**Q: 地址生成是否加密安全？**  
A: 不是。这只是模拟项目，使用随机字符串。

**Q: 可以提交交易到区块链吗？**  
A: 不可以。这只是构建和验证交易结构。

## 参考资源

- [Week 7 讲义](../../../src/week-07-cardano/lecture.md)
- [实施指南](../../../src/week-08-project/guide.md)
- [项目规格](../../../src/week-08-project/project-1-wallet.md)
- [评估标准](../../../src/week-08-project/evaluation.md)

## 作者

[你的名字] - Week 8 结课项目

## 许可证

MIT

