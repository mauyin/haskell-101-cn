# 天气查询工具 (Weather Tool)

Week 5 练习项目 - 使用 Haskell 构建命令行天气查询工具

## 项目概述

这是一个命令行天气查询工具，使用 OpenWeatherMap API 获取实时天气数据。

## 功能特性

- ✅ 查询任意城市的实时天气
- ✅ 显示温度、体感温度、湿度
- ✅ 支持中文天气描述
- ✅ 错误处理（网络错误、API 错误等）
- ✅ 模块化设计

## 技术栈

- **req**: HTTP 客户端
- **aeson**: JSON 解析
- **text**: 文本处理
- **bytestring**: 高效字符串操作

## 项目结构

```
weather-tool/
├── app/
│   └── Main.hs           # 命令行入口
├── src/
│   ├── Weather.hs        # API 客户端
│   ├── Types.hs          # 数据类型
│   └── Display.hs        # 显示逻辑
├── weather-tool.cabal    # 项目配置
└── README.md             # 本文件
```

## 快速开始

### 1. 获取 API 密钥

访问 [OpenWeatherMap](https://openweathermap.org/api) 注册免费账号，获取 API key。

### 2. 构建项目

```bash
cd weather-tool
cabal build
```

### 3. 运行程序

```bash
cabal run weather-tool YOUR_API_KEY Beijing
```

## 使用示例

```bash
# 查询北京天气
cabal run weather-tool abc123def456 Beijing

# 查询上海天气
cabal run weather-tool abc123def456 Shanghai

# 查询纽约天气
cabal run weather-tool abc123def456 "New York"
```

## 预期输出

```
城市：北京
天气：晴
描述：万里无云
温度：25.5°C
体感：27.0°C
湿度：60%
```

## 开发任务

### 必做任务

- [ ] 完成 `Types.hs` 中的数据类型定义
- [ ] 实现 `Weather.hs` 中的 API 调用
- [ ] 实现 `Display.hs` 中的显示逻辑
- [ ] 实现 `Main.hs` 中的命令行解析

### 可选扩展

- [ ] 添加风速显示
- [ ] 支持多城市对比
- [ ] 保存历史查询记录
- [ ] 美化输出（带边框）
- [ ] 支持配置文件（保存 API key）

## 测试

```bash
# 测试不同城市
cabal run weather-tool YOUR_KEY Beijing
cabal run weather-tool YOUR_KEY Shanghai
cabal run weather-tool YOUR_KEY Tokyo

# 测试错误处理
cabal run weather-tool INVALID_KEY Beijing    # 无效 API key
cabal run weather-tool YOUR_KEY InvalidCity   # 不存在的城市
```

## API 文档

OpenWeatherMap API 文档：https://openweathermap.org/current

## 常见问题

### API key 无效

确保从 OpenWeatherMap 官网获取的 key 正确，新注册的 key 可能需要几分钟才能激活。

### 城市名不识别

使用英文或拼音城市名，如：
- Beijing（北京）
- Shanghai（上海）
- Guangzhou（广州）

### 构建失败

```bash
# 更新包索引
cabal update

# 清理并重新构建
cabal clean
cabal build
```

## 学习目标

完成本项目后，你应该能够：

- ✅ 使用 Cabal 管理多模块项目
- ✅ 使用 req 发起 HTTP 请求
- ✅ 使用 aeson 解析 JSON 数据
- ✅ 处理 IO 和错误
- ✅ 设计模块化的应用程序

## 参考资源

- [req 文档](https://hackage.haskell.org/package/req)
- [aeson 文档](https://hackage.haskell.org/package/aeson)
- [OpenWeatherMap API](https://openweathermap.org/api)

