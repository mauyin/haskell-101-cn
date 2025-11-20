# Week 5: 练习作业

> 模块系统与项目管理实战

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week05Exercises.hs](../../exercises/week-05/tasks/Week05Exercises.hs)** - 主练习文件（20 道题）
- **[模块示例: MyModule.hs](../../exercises/week-05/tasks/MyModule.hs)** - 模块练习
- **[天气工具项目](../../exercises/week-05/tasks/weather-tool/)** - 天气查询工具骨架
- **[JSON 解析器项目](../../exercises/week-05/tasks/json-parser/)** - 配置解析器骨架
- **[参考答案](../../exercises/week-05/solutions/)** - 完成后查看
- **[示例代码](../../exercises/week-05/examples/)** - 额外学习材料

### 如何使用

```bash
# 1. 进入练习目录
cd exercises/week-05/tasks

# 2. 对于普通练习文件
ghci Week05Exercises.hs
# 完成 TODO 标记的函数

# 3. 对于 Cabal 项目
cd weather-tool
cabal build
cabal run

# 4. 运行测试
cabal test
```

---

## 练习 1: 模块基础（5 题）

**文件**: `Week05Exercises.hs` + `MyModule.hs`  
**难度**: ⭐⭐☆☆☆

### 目标

- 理解模块声明和导出列表
- 掌握各种 import 形式
- 使用 qualified import
- 组织多模块代码

### 内容预览

```haskell
-- 1.1 创建带导出列表的模块
module MathUtils
  ( square
  , cube
  -- 不导出 helper
  ) where

square :: Int -> Int
square = undefined  -- TODO

cube :: Int -> Int
cube = undefined  -- TODO

helper :: Int -> Int
helper = undefined  -- 私有函数

-- 1.2 使用 qualified import
-- 在 Main.hs 中导入 Data.Map
import qualified Data.Map as M

useMap :: M.Map String Int
useMap = undefined  -- TODO

-- 1.3 选择性导入
-- 只导入 sort 和 nub
import Data.List (sort, nub)

processData :: [Int] -> [Int]
processData = undefined  -- TODO: 使用 sort 和 nub

-- 1.4 hiding import
-- 导入 Prelude 但隐藏 head 和 tail
import Prelude hiding (head, tail)

safeHead :: [a] -> Maybe a
safeHead = undefined  -- TODO

-- 1.5 组织层次化模块
-- 创建 Data.User 模块并使用
```

---

## 练习 2: Cabal 项目（5 题）

**难度**: ⭐⭐⭐☆☆

### 目标

- 初始化 Cabal 项目
- 配置 .cabal 文件
- 添加依赖
- 构建和运行项目

### 2.1 创建基本项目

```bash
# TODO: 按以下步骤完成
# 1. 创建名为 calculator 的项目
# 2. 添加 Main.hs 实现简单计算器
# 3. 构建并运行
```

**要求**：
- 支持加减乘除
- 命令行参数输入
- 处理除零错误

### 2.2 添加库模块

```bash
# TODO: 在 calculator 项目中
# 1. 在 src/ 创建 Calculator.hs 模块
# 2. 在 .cabal 中添加 library 部分
# 3. Main.hs 导入并使用这个库
```

### 2.3 添加依赖

```cabal
-- TODO: 在 .cabal 文件中添加以下依赖
-- 1. text - 文本处理
-- 2. containers - Map/Set
-- 3. 构建项目验证依赖正确
```

### 2.4 多模块项目

```bash
# TODO: 创建多模块项目
# my-app/
# ├── src/
# │   ├── Types.hs
# │   ├── Parser.hs
# │   └── Formatter.hs
# └── app/
#     └── Main.hs
```

### 2.5 创建并运行测试

```cabal
-- TODO: 添加 test-suite 到 .cabal
-- 编写简单测试验证 Calculator 模块
```

---

## 练习 3: ByteString 操作（2 题）

**文件**: `Week05Exercises.hs` (第 6-7 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 ByteString 高效处理数据
- 理解 strict vs lazy
- 文件 I/O 操作

### 内容预览

```haskell
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

-- 3.1 统计文件字节数
countBytes :: FilePath -> IO Int
countBytes = undefined  -- TODO

-- 3.2 查找并替换
replaceBytes :: B.ByteString -> B.ByteString -> B.ByteString -> B.ByteString
replaceBytes old new content = undefined  -- TODO

-- 3.3 按行处理大文件
processLargeFile :: FilePath -> (BC.ByteString -> BC.ByteString) -> FilePath -> IO ()
processLargeFile inputPath transform outputPath = undefined  -- TODO

-- 3.4 简单 CSV 解析
parseCSV :: BC.ByteString -> [[BC.ByteString]]
parseCSV = undefined  -- TODO
```

---

## 练习 4: aeson JSON 处理（3 题）

**文件**: `Week05Exercises.hs` (第 8-10 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 解析 JSON 数据
- 生成 JSON 数据
- 使用 Generic 派生
- 处理嵌套 JSON

### 内容预览

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import GHC.Generics

-- 4.1 定义并解析简单 JSON
data Person = Person
  { name :: String
  , age :: Int
  } deriving (Show, Generic)

instance FromJSON Person
instance ToJSON Person

-- TODO: 实现函数
parsePerson :: ByteString -> Maybe Person
parsePerson = undefined

-- 4.2 处理嵌套 JSON
data Company = Company
  { companyName :: String
  , employees :: [Person]
  , founded :: Int
  } deriving (Show, Generic)

instance FromJSON Company
instance ToJSON Company

-- TODO: 解析公司 JSON
parseCompany :: ByteString -> Maybe Company
parseCompany = undefined

-- 4.3 处理可选字段
data Config = Config
  { host :: String
  , port :: Int
  , debug :: Maybe Bool  -- 可选
  , maxConnections :: Maybe Int  -- 可选，默认 100
  } deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config

-- TODO: 解析配置并应用默认值
parseConfigWithDefaults :: ByteString -> Maybe Config
parseConfigWithDefaults = undefined

-- 4.4 自定义字段名
-- JSON 使用 snake_case，Haskell 使用 camelCase
data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  } deriving (Show, Generic)

-- TODO: 实现自定义 FromJSON 实例
-- JSON: {"user_id": 1, "user_name": "Alice", "user_email": "alice@example.com"}
```

---

## 练习 5: req HTTP 请求（3 题）

**文件**: `Week05Exercises.hs` (第 11-13 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 发起 GET 请求
- 发起 POST 请求
- 处理查询参数
- 错误处理

### 内容预览

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req

-- 5.1 简单 GET 请求
-- 获取 https://httpbin.org/get 并打印响应
simpleGet :: IO ()
simpleGet = undefined  -- TODO

-- 5.2 带参数的 GET 请求
-- 请求 https://httpbin.org/get?name=Alice&age=30
getWithParams :: IO ()
getWithParams = undefined  -- TODO

-- 5.3 POST JSON 数据
postJSON :: IO ()
postJSON = undefined  -- TODO
-- POST https://httpbin.org/post
-- Body: {"message": "Hello", "count": 42}

-- 5.4 错误处理
safeRequest :: String -> IO (Either String String)
safeRequest url = undefined  -- TODO
-- 捕获网络错误并返回 Left
```

---

## 练习 6: 综合练习（2 题）

**难度**: ⭐⭐⭐⭐☆

### 6.1 简单爬虫

```haskell
-- TODO: 实现网页内容抓取器
-- 1. 接受 URL 列表
-- 2. 获取每个 URL 的内容
-- 3. 提取标题（查找 <title> 标签）
-- 4. 保存到文件

type URL = String

fetchPage :: URL -> IO (Maybe ByteString)
fetchPage = undefined

extractTitle :: ByteString -> Maybe String
extractTitle = undefined

crawl :: [URL] -> FilePath -> IO ()
crawl urls outputFile = undefined
```

### 6.2 API 数据聚合器

```haskell
-- TODO: 从多个 API 获取数据并合并
-- 1. 并发请求多个 API
-- 2. 解析 JSON 响应
-- 3. 合并结果
-- 4. 生成报告

data APIResponse = APIResponse
  { source :: String
  , data :: Value
  } deriving (Show, Generic)

fetchFromAPIs :: [URL] -> IO [APIResponse]
fetchFromAPIs = undefined

aggregateData :: [APIResponse] -> Value
aggregateData = undefined
```

---

## 项目 1: 天气查询工具（必做）

**目录**: `exercises/week-05/tasks/weather-tool/`  
**难度**: ⭐⭐⭐⭐☆

### 项目描述

构建一个命令行天气查询工具，能够查询任意城市的当前天气。

### 功能要求

1. **命令行接口**
   ```bash
   weather-cli <API_KEY> <城市名>
   ```

2. **天气信息显示**
   - 城市名称
   - 天气状况（晴/雨/雪等）
   - 温度（摄氏度）
   - 体感温度
   - 湿度
   - 风速（可选）

3. **错误处理**
   - 无效的 API key
   - 城市不存在
   - 网络错误
   - JSON 解析错误

### 技术要求

- 使用 `req` 库发起 HTTP 请求
- 使用 `aeson` 解析 JSON 响应
- 使用 `text` 处理文本
- 错误处理使用 `Either` 或异常
- 模块化设计（至少 3 个模块）

### 项目结构

```
weather-tool/
├── app/
│   └── Main.hs           -- 命令行入口
├── src/
│   ├── Weather.hs        -- 天气 API 客户端
│   ├── Types.hs          -- 数据类型定义
│   └── Display.hs        -- 格式化输出
├── test/
│   └── WeatherSpec.hs    -- 测试（可选）
└── weather-tool.cabal
```

### 实现步骤

1. **定义数据类型** (`Types.hs`)
   ```haskell
   data WeatherInfo = WeatherInfo
     { city :: Text
     , condition :: Text
     , temperature :: Double
     , feelsLike :: Double
     , humidity :: Int
     }
   ```

2. **实现 API 客户端** (`Weather.hs`)
   ```haskell
   getWeather :: String -> String -> IO (Either String WeatherInfo)
   ```

3. **实现显示逻辑** (`Display.hs`)
   ```haskell
   displayWeather :: WeatherInfo -> IO ()
   ```

4. **实现主程序** (`Main.hs`)
   - 解析命令行参数
   - 调用 API
   - 显示结果或错误

### 测试

```bash
cd weather-tool
cabal build
cabal run weather-tool YOUR_API_KEY Beijing
```

**预期输出**：
```
城市：北京
天气：晴
温度：25.5°C
体感：27.0°C
湿度：60%
```

### API 选择

可以使用以下免费 API：

1. **OpenWeatherMap** (推荐)
   - 注册: https://openweathermap.org/api
   - 免费额度: 60 calls/minute
   - 文档: https://openweathermap.org/current

2. **WeatherAPI**
   - 注册: https://www.weatherapi.com/
   - 免费额度: 1M calls/month

### 提示

```haskell
-- API URL 示例
baseUrl = https "api.openweathermap.org" /: "data" /: "2.5" /: "weather"

-- 查询参数
params = "q" =: city
      <> "appid" =: apiKey
      <> "units" =: ("metric" :: String)
      <> "lang" =: ("zh_cn" :: String)

-- 解析响应
instance FromJSON WeatherInfo where
  parseJSON = withObject "WeatherInfo" $ \v -> do
    name <- v .: "name"
    main <- v .: "main"
    weather <- v .: "weather"
    -- ...
```

---

## 项目 2: JSON 配置解析器（必做）

**目录**: `exercises/week-05/tasks/json-parser/`  
**难度**: ⭐⭐⭐⭐☆

### 项目描述

创建一个通用的 JSON 配置文件管理工具。

### 功能要求

1. **读取配置**
   ```bash
   json-config show <文件>
   ```

2. **创建默认配置**
   ```bash
   json-config init <文件>
   ```

3. **更新配置**
   ```bash
   json-config set <文件> <键> <值>
   ```

4. **验证配置**
   ```bash
   json-config validate <文件>
   ```

### 配置文件格式

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
    "host": "localhost",
    "port": 5432,
    "name": "mydb",
    "maxConnections": 10
  },
  "logging": {
    "level": "info",
    "file": "app.log"
  }
}
```

### 技术要求

- 使用 `aeson` 解析和生成 JSON
- 使用 Generic 派生
- 美化 JSON 输出（`encodePretty`）
- 验证必填字段
- 提供默认值

### 项目结构

```
json-parser/
├── app/
│   └── Main.hs
├── src/
│   ├── Config.hs         -- 配置类型和操作
│   ├── Validation.hs     -- 配置验证
│   └── CLI.hs            -- 命令行解析
└── json-parser.cabal
```

### 实现步骤

1. **定义配置类型**
   ```haskell
   data AppConfig = AppConfig
     { appName :: Text
     , version :: Text
     , server :: ServerConfig
     , database :: DatabaseConfig
     , logging :: LoggingConfig
     } deriving (Generic)
   ```

2. **实现加载/保存**
   ```haskell
   loadConfig :: FilePath -> IO (Either String AppConfig)
   saveConfig :: FilePath -> AppConfig -> IO ()
   ```

3. **实现验证**
   ```haskell
   validateConfig :: AppConfig -> [ValidationError]
   ```

4. **实现命令行**
   ```haskell
   data Command
     = Init FilePath
     | Show FilePath
     | Set FilePath String String
     | Validate FilePath
   
   parseCommand :: [String] -> Either String Command
   ```

### 测试

```bash
cd json-parser
cabal build

# 创建默认配置
cabal run json-parser init config.json

# 查看配置
cabal run json-parser show config.json

# 验证配置
cabal run json-parser validate config.json
```

### 挑战扩展（可选）

1. **支持环境变量替换**
   ```json
   {"port": "${PORT:8080}"}
   ```

2. **配置合并**
   ```bash
   json-config merge base.json override.json output.json
   ```

3. **JSON Schema 验证**
   - 定义 schema
   - 验证配置符合 schema

---

## 挑战题：扩展项目（选做）

### 挑战 1: 多城市天气比较 ⭐⭐⭐⭐☆

扩展天气工具，支持同时查询多个城市并比较：

```bash
weather-cli compare Beijing Shanghai Guangzhou
```

**要求**：
- 并发请求多个 API
- 表格形式显示对比
- 高亮最高/最低温度

### 挑战 2: 配置文件热重载 ⭐⭐⭐⭐⭐

实现配置文件监控和热重载：

```bash
json-config watch config.json
```

**要求**：
- 监控文件变化
- 自动重新加载
- 验证新配置
- 通知配置更新

### 挑战 3: RESTful API 客户端生成器 ⭐⭐⭐⭐⭐

根据 API 文档自动生成客户端代码：

```bash
api-gen swagger.json --output APIClient.hs
```

**要求**：
- 解析 OpenAPI/Swagger 规范
- 生成类型定义
- 生成 API 函数
- 包含错误处理

---

## 学习建议

### 完成顺序

1. **先理解概念** - 阅读 [lecture.md](lecture.md) 的模块和 Cabal 部分
2. **练习模块** - 完成练习 1-2（模块和 Cabal）
3. **掌握库** - 完成练习 3-5（ByteString/aeson/req）
4. **综合应用** - 完成两个项目
5. **挑战自己** - 尝试挑战题

### 调试技巧

```bash
# Cabal 构建错误
cabal clean
cabal build -v  # 详细输出

# 依赖问题
cabal update
cabal freeze

# 查看包信息
cabal info aeson
cabal list --installed

# REPL 调试
cabal repl
> :load src/Weather.hs
> :type getWeather
```

### 常见错误

1. **模块未找到**
```haskell
-- ❌ 忘记在 .cabal 中声明
exposed-modules: MyModule  -- 需要添加

-- ✅ 正确声明
library
    exposed-modules: MyModule, OtherModule
```

2. **依赖版本冲突**
```bash
# ❌ 版本过于严格
aeson ==2.2.0.0

# ✅ 使用范围
aeson ^>=2.2
```

3. **导入冲突**
```haskell
-- ❌ 两个模块都有 lookup
import Data.Map
import Prelude

-- ✅ 使用 qualified
import qualified Data.Map as M
```

---

## 完成标准

完成本周练习后，你应该能够：

- [ ] 创建和组织多模块 Haskell 项目
- [ ] 熟练使用 Cabal 管理项目
- [ ] 添加和使用第三方库
- [ ] 使用 ByteString 高效处理数据
- [ ] 解析和生成 JSON 数据
- [ ] 发起 HTTP 请求并处理响应
- [ ] 构建完整的命令行工具
- [ ] 处理各种错误场景

**全部完成？** 恭喜！你已经掌握了 Haskell 项目管理的核心技能！

继续前进：[Week 6: 错误处理与测试](../../week-06-testing/README.md) →

---

## 📚 参考答案

完成练习后，可以查看参考答案：

- [Week05Exercises.hs 答案](../../exercises/week-05/solutions/Week05Exercises.hs)
- [天气工具完整实现](../../exercises/week-05/solutions/weather-tool/)
- [JSON 解析器完整实现](../../exercises/week-05/solutions/json-parser/)

**重要**：先独立完成练习，再查看答案！只有自己动手写代码才能真正掌握。

有问题？查看 [README](README.md) 中的社区资源，或在 [Issues](https://github.com/mauyin/haskell-101-cn/issues) 提问。

