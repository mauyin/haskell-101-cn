# Balance Checker - Week 7 Project 1

Cardano 地址余额查询工具

## 功能

- 批量查询多个地址
- 格式化显示结果
- 缓存支持（可选）
- 错误处理

## 构建

```bash
cabal build
```

## 运行

```bash
cabal run balance-checker -- addr_test1q...
```

## 任务

完成所有 `src/` 中的 TODO

##  完成标准

- [ ] API.hs - 实现查询函数
- [ ] Display.hs - 实现美化显示
- [ ] Cache.hs - 实现缓存（可选）
- [ ] Main.hs - 实现命令行界面
- [ ] 测试运行成功

