# JSON 配置解析器 (JSON Parser)

Week 5 练习项目 - 通用 JSON 配置文件管理工具

## 项目概述

这是一个命令行工具，用于管理 JSON 格式的应用配置文件。

## 功能特性

- ✅ 创建默认配置文件
- ✅ 读取和显示配置
- ✅ 验证配置合法性
- ✅ 美化 JSON 输出
- ✅ 详细的错误提示

## 技术栈

- **aeson**: JSON 编码/解码
- **aeson-pretty**: 美化 JSON 输出
- **text**: 文本处理
- **bytestring**: 文件 I/O

## 项目结构

```
json-parser/
├── app/
│   └── Main.hs           # 命令行入口
├── src/
│   ├── Config.hs         # 配置类型和操作
│   ├── Validation.hs     # 配置验证
│   └── CLI.hs            # 命令行解析
├── json-parser.cabal     # 项目配置
└── README.md             # 本文件
```

## 快速开始

### 1. 构建项目

```bash
cd json-parser
cabal build
```

### 2. 创建配置文件

```bash
cabal run json-parser init config.json
```

### 3. 查看配置

```bash
cabal run json-parser show config.json
```

### 4. 验证配置

```bash
cabal run json-parser validate config.json
```

## 命令详解

### init - 创建默认配置

```bash
cabal run json-parser init <文件路径>
```

创建一个包含合理默认值的配置文件。

### show - 显示配置

```bash
cabal run json-parser show <文件路径>
```

读取并显示配置文件内容。

### validate - 验证配置

```bash
cabal run json-parser validate <文件路径>
```

检查配置文件是否有效，显示所有验证错误。

### help - 显示帮助

```bash
cabal run json-parser help
```

显示使用说明。

## 配置文件格式

```json
{
  "appName": "MyApp",
  "version": "1.0.0",
  "server": {
    "port": 8080,
    "host": "localhost",
    "enableSSL": false
  },
  "database": {
    "dbHost": "localhost",
    "dbPort": 5432,
    "dbName": "mydb",
    "maxConnections": 10
  },
  "logging": {
    "level": "info",
    "file": "app.log"
  }
}
```

## 验证规则

- **端口号**: 1-65535
- **主机名**: 非空字符串
- **日志级别**: debug, info, warn, error
- **版本号**: x.y.z 格式
- **应用名**: 非空字符串
- **数据库名**: 非空字符串

## 开发任务

### 必做任务

- [ ] 完成 `Config.hs` 中的类型定义
- [ ] 实现配置的加载和保存
- [ ] 完成 `Validation.hs` 中的验证逻辑
- [ ] 实现 `CLI.hs` 中的命令解析
- [ ] 实现 `Main.hs` 中的主程序

### 可选扩展

- [ ] 添加 `set` 命令修改配置项
- [ ] 支持环境变量替换 `${VAR}`
- [ ] 配置文件合并功能
- [ ] 支持 YAML 格式
- [ ] 配置模板系统

## 使用示例

```bash
# 创建新配置
cabal run json-parser init my-app.json

# 查看配置
cabal run json-parser show my-app.json

# 手动编辑配置文件
vim my-app.json

# 验证修改后的配置
cabal run json-parser validate my-app.json
```

## 测试场景

### 测试 1: 正常流程

```bash
# 1. 创建配置
cabal run json-parser init test.json

# 2. 验证（应该通过）
cabal run json-parser validate test.json
# 输出: 配置有效！

# 3. 查看配置
cabal run json-parser show test.json
```

### 测试 2: 验证错误

手动编辑 `test.json`，设置无效端口：

```json
{
  "server": {
    "port": 99999,  // 无效！
    ...
  }
}
```

然后验证：

```bash
cabal run json-parser validate test.json
# 输出: InvalidPort 99999
```

### 测试 3: 解析错误

创建格式错误的 JSON：

```json
{
  "appName": "Test",
  "invalid json
}
```

验证：

```bash
cabal run json-parser show test.json
# 输出: 加载错误: 解析失败...
```

## 学习目标

完成本项目后，你应该能够：

- ✅ 使用 aeson 处理复杂 JSON
- ✅ 实现数据验证逻辑
- ✅ 设计命令行接口
- ✅ 组织模块化代码
- ✅ 处理文件 I/O 和错误

## 常见问题

### 构建失败

```bash
cabal update
cabal clean
cabal build
```

### 配置文件损坏

删除并重新创建：

```bash
rm config.json
cabal run json-parser init config.json
```

## 参考资源

- [aeson 文档](https://hackage.haskell.org/package/aeson)
- [aeson-pretty](https://hackage.haskell.org/package/aeson-pretty)
- [JSON 格式规范](https://www.json.org/)

