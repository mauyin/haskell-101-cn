# Cardano Balance Monitor 📊

自动化 Cardano 地址余额监控工具 - Week 8 结课项目

## 项目简介

这是一个自动化监控工具，支持：
- 监控多个 Cardano 地址
- 定期自动余额检查
- 余额变化检测和通知
- 历史数据记录
- 数据导出

## 快速开始

### 构建项目

```bash
cabal build
```

### 初始化配置

```bash
cabal run balance-monitor -- init-config config.yaml
# 然后编辑 config.yaml 添加你的 API Key
```

### 运行

```bash
cabal run balance-monitor -- help
```

## 功能

### 必需功能

- [x] 监控列表管理
  - [ ] 添加地址
  - [ ] 删除地址
  - [ ] 列出所有地址
  - [ ] 查看地址信息

- [x] 定期检查
  - [ ] 自动循环检查
  - [ ] 可配置间隔
  - [ ] 错误重试

- [x] 变化检测
  - [ ] 检测余额变化
  - [ ] 计算变化金额
  - [ ] 记录变化历史

- [x] 控制台通知
  - [ ] 即时通知
  - [ ] 格式化显示
  - [ ] 颜色输出（可选）

- [x] 数据持久化
  - [ ] 保存监控列表
  - [ ] 保存变化历史
  - [ ] 自动备份

- [x] 配置管理
  - [x] YAML 配置文件
  - [x] 默认配置生成
  - [ ] 配置加载

### 可选功能

- [ ] 统计报告
- [ ] 条件通知（阈值）
- [ ] 邮件通知
- [ ] 并发查询优化

## 使用方法

### 添加监控地址

```bash
balance-monitor add addr_test1q... "My Wallet"
balance-monitor add addr_test1q... "Exchange"
```

### 查看监控列表

```bash
balance-monitor list
```

### 启动监控

```bash
balance-monitor start
# 或指定间隔（秒）
balance-monitor start --interval 300
```

### 查看历史

```bash
# 所有变化
balance-monitor history

# 特定地址
balance-monitor history addr_test1q...

# 导出为 CSV
balance-monitor export history.csv
```

## 项目结构

```
balance-monitor/
├── src/
│   ├── Monitor/
│   │   ├── Types.hs          -- 数据类型
│   │   ├── Query.hs          -- 余额查询
│   │   ├── Tracker.hs        -- 变化追踪
│   │   ├── Notify.hs         -- 通知系统
│   │   ├── Storage.hs        -- 数据持久化
│   │   ├── Config.hs         -- 配置管理
│   │   └── CLI.hs            -- 命令行接口
│   └── Monitor.hs            -- 主模块
├── app/
│   └── Main.hs               -- 程序入口
├── test/
│   └── MonitorSpec.hs        -- 测试
└── balance-monitor.cabal     -- 项目配置
```

## 配置文件

配置文件 `config.yaml`:

```yaml
api:
  key: testnetXXXXXXXXXXXX        # Blockfrost API Key
  endpoint: https://cardano-testnet.blockfrost.io

monitor:
  interval: 300                    # 检查间隔（秒）
  retry_count: 3                   # 重试次数
  retry_delay: 5                   # 重试延迟（秒）

storage:
  data_dir: .cardano-monitor       # 数据目录
  backup_count: 5                  # 备份文件数

notification:
  console: true                    # 控制台通知
  color: true                      # 彩色输出
  sound: false                     # 声音提示
```

## 实施步骤

查看 `TASKS.md` 获取详细的实施清单。

### Phase 1: 基础结构 (2小时)
- 完成类型定义
- 实现配置加载
- 实现 CLI 参数解析

### Phase 2: API 集成 (2小时)
- 实现 Blockfrost API 调用
- 实现余额查询
- 错误处理

### Phase 3: 监控核心 (2-3小时)
- 实现监控列表管理
- 实现定期检查循环
- 实现变化检测
- 实现通知

### Phase 4: 数据持久化 (1-2小时)
- 实现状态保存/加载
- 实现历史记录
- 实现数据导出

### Phase 5: 完善 (1-2小时)
- 测试
- 文档
- 用户体验优化

## 测试

运行测试：

```bash
cabal test
```

## 调试

使用 GHCi 进行调试：

```bash
cabal repl
> :load Monitor.Query
> formatBalance (Lovelace 1000000)
```

## 常见问题

**Q: 检查间隔最短多少？**  
A: 建议不少于 60 秒，避免触发 API 速率限制。

**Q: 可以后台运行吗？**  
A: 可以使用 `nohup` 或 `screen`。

**Q: 如何停止监控？**  
A: 按 Ctrl+C 优雅退出，状态会自动保存。

## 参考资源

- [Week 7 讲义](../../../src/week-07-cardano/lecture.md)
- [实施指南](../../../src/week-08-project/guide.md)
- [项目规格](../../../src/week-08-project/project-2-monitor.md)
- [评估标准](../../../src/week-08-project/evaluation.md)

## 作者

[你的名字] - Week 8 结课项目

## 许可证

MIT

