# Week 5: 模块与项目管理 - 详细讲义

> 💡 **自学提示**: 本周内容非常实用！模块系统概念简单，但 Cabal 和库的使用需要大量实践。建议边学边做，不要只看不练。遇到 Cabal 错误不要慌，这是学习过程的一部分！

---

## 目录

1. [模块系统基础](#1-模块系统基础)
2. [创建自己的模块](#2-创建自己的模块)
3. [Cabal 项目管理](#3-cabal-项目管理)
4. [常用库深入](#4-常用库深入)
5. [依赖管理](#5-依赖管理)
6. [实战项目](#6-实战项目)

---

## 1. 模块系统基础

### 1.1 什么是模块？

**模块**（Module）是 Haskell 组织代码的基本单位，类似于：
- Java/Python 的 package
- JavaScript 的 module
- C++ 的 namespace

**作用**：
- 组织代码结构
- 控制名称可见性
- 避免命名冲突
- 实现代码复用

### 1.2 模块声明

每个 Haskell 文件都可以定义一个模块：

```haskell
-- MyModule.hs
module MyModule where

-- 模块内容
greet :: String -> String
greet name = "Hello, " ++ name

add :: Int -> Int -> Int
add x y = x + y
```

**规则**：
- 模块名必须以大写字母开头
- 模块名通常与文件名对应（`MyModule.hs` → `module MyModule`）
- 如果不写 module 声明，默认是 `module Main where`

### 1.3 导入模块

#### 基本导入

```haskell
-- 导入整个模块
import Data.List

-- 使用模块中的函数
sorted = sort [3, 1, 2]  -- [1, 2, 3]
```

#### 选择性导入

```haskell
-- 只导入特定函数
import Data.List (sort, nub)

-- 现在只能使用 sort 和 nub
sorted = sort [3, 1, 2]
unique = nub [1, 1, 2, 3, 3]  -- [1, 2, 3]

-- 其他函数不可用
-- grouped = group [1, 1, 2, 3]  -- 错误！group 未导入
```

#### 隐藏导入

```haskell
-- 导入除了指定函数外的所有函数
import Data.List hiding (head, tail)

-- head 和 tail 来自 Prelude，不会被 Data.List 的覆盖
```

#### 限定导入（Qualified Import）

解决命名冲突的最佳方式：

```haskell
-- 必须用模块名前缀
import qualified Data.Map

myMap = Data.Map.empty
inserted = Data.Map.insert "key" "value" myMap
```

#### 限定导入 + 别名

```haskell
-- 使用简短别名
import qualified Data.Map as M

myMap = M.empty
inserted = M.insert "key" "value" myMap
```

#### 混合导入

```haskell
-- 同时使用限定和非限定
import Data.Map (Map)  -- 导入类型
import qualified Data.Map as M  -- 导入函数

myMap :: Map String Int
myMap = M.fromList [("a", 1), ("b", 2)]
```

### 1.4 导入示例对比

```haskell
-- 场景1：没有命名冲突
import Data.List
import Data.Maybe

result = fromMaybe 0 (find (> 5) [1..10])  -- Just 6

-- 场景2：有命名冲突，使用 qualified
import Prelude hiding (lookup)
import qualified Data.Map as M

-- Prelude 的 lookup 被隐藏
value = M.lookup "key" myMap  -- 使用 Data.Map 的 lookup

-- 场景3：只需要几个函数
import Data.List (sort, group)
import Data.Maybe (fromMaybe, isJust)

sorted = sort [3, 1, 2]
hasValue = isJust (Just 5)
```

### 1.5 常用标准库模块

```haskell
-- 列表操作
import Data.List  -- sort, group, nub, intercalate, etc.

-- 映射表
import Data.Map (Map)
import qualified Data.Map as M

-- 集合
import Data.Set (Set)
import qualified Data.Set as S

-- 可选值
import Data.Maybe  -- fromMaybe, isJust, catMaybes

-- 要么值
import Data.Either  -- either, lefts, rights

-- 文本
import Data.Text (Text)
import qualified Data.Text as T

-- 字节串
import Data.ByteString (ByteString)
import qualified Data.ByteString as B

-- 时间
import Data.Time

-- 文件操作
import System.Directory
import System.IO
```

---

## 2. 创建自己的模块

### 2.1 简单模块

创建 `Geometry.hs`：

```haskell
-- Geometry.hs
module Geometry where

-- 计算圆的面积
circleArea :: Double -> Double
circleArea r = pi * r * r

-- 计算矩形面积
rectangleArea :: Double -> Double -> Double
rectangleArea width height = width * height

-- 计算三角形面积
triangleArea :: Double -> Double -> Double
triangleArea base height = base * height / 2
```

使用这个模块：

```haskell
-- Main.hs
import Geometry

main :: IO ()
main = do
  print (circleArea 5.0)       -- 78.53981633974483
  print (rectangleArea 4 6)    -- 24.0
  print (triangleArea 10 8)    -- 40.0
```

### 2.2 控制导出（Export List）

限制模块对外暴露的内容：

```haskell
-- MathUtils.hs
module MathUtils
  ( factorial      -- 导出 factorial 函数
  , fibonacci      -- 导出 fibonacci 函数
  -- 不导出 helper 函数
  ) where

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

fibonacci :: Int -> Int
fibonacci n = fibs !! n
  where
    fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- 这个函数不会被导出（私有）
helper :: Int -> Int
helper x = x * 2  -- 外部无法访问
```

**导出类型和构造器**：

```haskell
module Shape
  ( Shape(..)      -- 导出类型和所有构造器
  , area           -- 导出函数
  ) where

data Shape = Circle Double
           | Rectangle Double Double
           | Triangle Double Double
  deriving (Show)

area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle b h) = b * h / 2
```

**部分导出构造器**：

```haskell
module Person
  ( Person(name, age)  -- 导出类型和部分字段
  , createPerson       -- 导出智能构造器
  ) where

data Person = Person
  { name :: String
  , age :: Int
  , ssn :: String  -- 这个字段不导出（私有）
  } deriving (Show)

-- 智能构造器，验证输入
createPerson :: String -> Int -> Maybe Person
createPerson n a
  | null n = Nothing
  | a < 0 = Nothing
  | otherwise = Just (Person n a "000-00-0000")
```

### 2.3 层次化模块

组织大型项目：

```
MyProject/
├── Data/
│   ├── User.hs        -- module Data.User
│   └── Product.hs     -- module Data.Product
├── Utils/
│   ├── Parser.hs      -- module Utils.Parser
│   └── Formatter.hs   -- module Utils.Formatter
└── Main.hs
```

**Data/User.hs**：

```haskell
module Data.User
  ( User(..)
  , createUser
  , validateEmail
  ) where

data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  } deriving (Show, Eq)

createUser :: Int -> String -> String -> Maybe User
createUser uid name email
  | validateEmail email = Just (User uid name email)
  | otherwise = Nothing

validateEmail :: String -> Bool
validateEmail email = '@' `elem` email  -- 简化版验证
```

**Main.hs** 使用层次化模块：

```haskell
import Data.User
import Utils.Parser
import Utils.Formatter

main :: IO ()
main = do
  case createUser 1 "Alice" "alice@example.com" of
    Just user -> print user
    Nothing -> putStrLn "Invalid user"
```

### 2.4 避免循环依赖

❌ **错误示例**（循环依赖）：

```haskell
-- ModuleA.hs
module ModuleA where
import ModuleB  -- A 导入 B

funcA :: Int -> Int
funcA x = funcB x + 1

-- ModuleB.hs
module ModuleB where
import ModuleA  -- B 导入 A （循环！）

funcB :: Int -> Int
funcB x = funcA x * 2
```

✅ **解决方案1：提取共享代码**：

```haskell
-- Common.hs
module Common where

commonFunc :: Int -> Int
commonFunc x = x + 1

-- ModuleA.hs
module ModuleA where
import Common

funcA :: Int -> Int
funcA = commonFunc

-- ModuleB.hs
module ModuleB where
import Common

funcB :: Int -> Int
funcB x = commonFunc x * 2
```

✅ **解决方案2：重新设计依赖关系**：

让 A 和 B 都依赖底层模块，而不是相互依赖。

---

## 3. Cabal 项目管理

### 3.1 什么是 Cabal？

**Cabal** 是 Haskell 的构建系统和包管理器，类似于：
- npm（Node.js）
- pip（Python）
- cargo（Rust）
- maven（Java）

**功能**：
- 管理项目结构
- 声明依赖
- 构建和编译
- 运行测试
- 发布包

### 3.2 创建新项目

```bash
# 交互式创建项目
cabal init

# 或者指定选项
cabal init --non-interactive \
  --cabal-version=2.4 \
  --license=MIT \
  --package-name=my-project
```

**生成的项目结构**：

```
my-project/
├── app/
│   └── Main.hs          -- 可执行程序入口
├── src/
│   └── MyLib.hs         -- 库代码
├── test/
│   └── MyTest.hs        -- 测试代码
├── CHANGELOG.md
├── my-project.cabal     -- 项目配置文件
└── cabal.project        -- 多包项目配置（可选）
```

### 3.3 理解 .cabal 文件

**my-project.cabal** 示例：

```cabal
cabal-version:      2.4
name:               my-project
version:            0.1.0.0
synopsis:           My awesome Haskell project
license:            MIT
author:             Your Name
maintainer:         your.email@example.com
build-type:         Simple

-- 库部分
library
    exposed-modules:  MyLib
    build-depends:    base ^>=4.18
                    , text ^>=2.0
                    , containers ^>=0.6
    hs-source-dirs:   src
    default-language: Haskell2010

-- 可执行程序部分
executable my-project
    main-is:          Main.hs
    build-depends:    base ^>=4.18
                    , my-project  -- 依赖自己的库
    hs-source-dirs:   app
    default-language: Haskell2010

-- 测试部分
test-suite my-project-test
    type:             exitcode-stdio-1.0
    main-is:          MyTest.hs
    build-depends:    base ^>=4.18
                    , my-project
                    , hspec ^>=2.11
    hs-source-dirs:   test
    default-language: Haskell2010
```

### 3.4 常用 Cabal 命令

```bash
# 更新包索引
cabal update

# 构建项目
cabal build

# 运行可执行程序
cabal run my-project

# 运行测试
cabal test

# 进入 REPL（加载项目）
cabal repl

# 清理构建产物
cabal clean

# 安装依赖
cabal install --only-dependencies

# 冻结依赖版本
cabal freeze

# 查看项目信息
cabal info my-project
```

### 3.5 添加依赖

在 `.cabal` 文件的 `build-depends` 中添加：

```cabal
library
    exposed-modules:  MyLib
    build-depends:    base ^>=4.18
                    , aeson ^>=2.2          -- JSON 库
                    , bytestring ^>=0.11    -- 字节串
                    , req ^>=3.13           -- HTTP 客户端
                    , text ^>=2.0           -- 文本库
                    , containers ^>=0.6     -- 数据结构
    hs-source-dirs:   src
    default-language: Haskell2010
```

**版本约束语法**：

```cabal
base ^>=4.18        -- 兼容版本（~4.18.x）
text >=2.0 && <3    -- 范围
aeson ==2.2.0.0     -- 精确版本
req >=3.0           -- 最小版本
```

### 3.6 项目结构最佳实践

**小型项目**：

```
simple-project/
├── src/
│   └── Main.hs
└── simple-project.cabal
```

**中型项目**：

```
medium-project/
├── app/
│   └── Main.hs              -- 可执行程序
├── src/
│   ├── Lib.hs               -- 主库模块
│   ├── Types.hs             -- 类型定义
│   └── Utils.hs             -- 工具函数
├── test/
│   └── Spec.hs              -- 测试
└── medium-project.cabal
```

**大型项目**：

```
large-project/
├── app/
│   ├── Main.hs
│   └── CLI.hs
├── src/
│   ├── Core/
│   │   ├── Types.hs
│   │   └── Parser.hs
│   ├── Data/
│   │   ├── User.hs
│   │   └── Product.hs
│   └── Utils/
│       ├── HTTP.hs
│       └── JSON.hs
├── test/
│   ├── CoreSpec.hs
│   └── DataSpec.hs
└── large-project.cabal
```

### 3.7 实战：创建完整项目

创建一个简单的问候程序：

```bash
mkdir greeter
cd greeter
cabal init --non-interactive
```

**greeter.cabal**：

```cabal
cabal-version:      2.4
name:               greeter
version:            0.1.0.0
license:            MIT
build-type:         Simple

executable greeter
    main-is:          Main.hs
    build-depends:    base ^>=4.18
    hs-source-dirs:   app
    default-language: Haskell2010
```

**app/Main.hs**：

```haskell
module Main where

main :: IO ()
main = do
  putStrLn "What's your name?"
  name <- getLine
  putStrLn $ "Hello, " ++ name ++ "!"
```

**构建和运行**：

```bash
cabal build
cabal run greeter
```

---

## 4. 常用库深入

### 4.1 ByteString - 高效字符串处理

**为什么需要 ByteString？**

`String` 在 Haskell 中是 `[Char]`（字符列表），效率低：
- 每个字符都是单独的内存分配
- 不适合大文件或网络数据

`ByteString` 是连续内存块，高效得多！

#### 基本使用

```haskell
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

-- 创建 ByteString
bs1 :: B.ByteString
bs1 = "Hello"  -- 使用 OverloadedStrings

bs2 :: B.ByteString
bs2 = BC.pack "World"  -- 从 String 转换

-- 常用操作
len = B.length bs1           -- 长度
combined = B.append bs1 bs2  -- 连接
part = B.take 3 bs1          -- 取前 3 个字节
rest = B.drop 3 bs1          -- 丢弃前 3 个字节

-- 输出
main :: IO ()
main = BC.putStrLn bs1  -- 打印 ByteString
```

#### Strict vs Lazy

```haskell
-- Strict ByteString - 整个内容在内存中
import qualified Data.ByteString as B

readFileStrict :: FilePath -> IO B.ByteString
readFileStrict = B.readFile  -- 一次性读入内存

-- Lazy ByteString - 惰性分块
import qualified Data.ByteString.Lazy as BL

readFileLazy :: FilePath -> IO BL.ByteString
readFileLazy = BL.readFile  -- 按需读取，适合大文件
```

#### 实用示例

```haskell
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Char8 as BC
import Data.ByteString (ByteString)

-- 统计文件中的行数
countLines :: FilePath -> IO Int
countLines path = do
  content <- BC.readFile path
  return $ length $ BC.lines content

-- 查找并替换
replaceBytes :: ByteString -> ByteString -> ByteString -> ByteString
replaceBytes old new = BC.intercalate new . BC.split (BC.head old)

-- 分割 CSV
parseCSV :: ByteString -> [[ByteString]]
parseCSV = map (BC.split ',') . BC.lines
```

### 4.2 aeson - JSON 处理

**aeson** 是 Haskell 最流行的 JSON 库。

#### 基本类型

```haskell
import Data.Aeson (Value(..), encode, decode)
import qualified Data.ByteString.Lazy as BL

-- Value 类型表示任意 JSON
data Value
  = Object Object      -- JSON 对象 {"key": value}
  | Array Array        -- JSON 数组 [value, value]
  | String Text        -- JSON 字符串 "text"
  | Number Scientific  -- JSON 数字 123.45
  | Bool Bool          -- JSON 布尔 true/false
  | Null               -- JSON null
```

#### 解析 JSON

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import qualified Data.ByteString.Lazy as BL

-- 定义数据类型
data Person = Person
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Show)

-- 手动实现 FromJSON
instance FromJSON Person where
  parseJSON = withObject "Person" $ \v -> Person
    <$> v .: "name"
    <*> v .: "age"
    <*> v .: "email"

-- 使用
parsePersonJSON :: BL.ByteString -> Maybe Person
parsePersonJSON = decode

-- 示例
main :: IO ()
main = do
  let jsonData = "{\"name\":\"Alice\",\"age\":30,\"email\":\"alice@example.com\"}"
  case decode jsonData of
    Just person -> print person
    Nothing -> putStrLn "Parse failed"
```

#### 自动派生（推荐）

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import GHC.Generics

-- 使用 Generic 自动派生
data Person = Person
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Show, Generic)

-- 自动生成 FromJSON 和 ToJSON 实例
instance FromJSON Person
instance ToJSON Person

-- 现在可以直接用！
main :: IO ()
main = do
  let person = Person "Alice" 30 "alice@example.com"
  
  -- 编码为 JSON
  let encoded = encode person
  print encoded
  -- {"name":"Alice","age":30,"email":"alice@example.com"}
  
  -- 解码 JSON
  case decode encoded of
    Just p -> print (name p)
    Nothing -> putStrLn "Failed"
```

#### 复杂示例

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as BL

data Address = Address
  { street :: String
  , city :: String
  , zipCode :: String
  } deriving (Show, Generic)

data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  , address :: Address
  , tags :: [String]
  } deriving (Show, Generic)

instance FromJSON Address
instance ToJSON Address
instance FromJSON User
instance ToJSON User

-- 解析嵌套 JSON
exampleJSON :: BL.ByteString
exampleJSON = "{\
  \\"userId\": 1,\
  \\"userName\": \"Alice\",\
  \\"userEmail\": \"alice@example.com\",\
  \\"address\": {\
    \\"street\": \"123 Main St\",\
    \\"city\": \"Beijing\",\
    \\"zipCode\": \"100000\"\
  },\
  \\"tags\": [\"developer\", \"haskell\"]\
  \}"

main :: IO ()
main = do
  case decode exampleJSON of
    Just user -> do
      print user
      putStrLn $ "User lives in: " ++ city (address user)
    Nothing -> putStrLn "Parse failed"
```

#### 处理可选字段

```haskell
{-# LANGUAGE DeriveGeneric #-}
import Data.Aeson
import GHC.Generics

data Config = Config
  { port :: Int
  , host :: String
  , debug :: Maybe Bool  -- 可选字段
  } deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config

-- JSON 中可以省略 debug 字段
-- {"port": 8080, "host": "localhost"}
```

### 4.3 req - HTTP 客户端

**req** 是类型安全的 HTTP 库。

#### 基本 GET 请求

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req

-- 简单 GET 请求
simpleGet :: IO ()
simpleGet = runReq defaultHttpConfig $ do
  response <- req
    GET  -- 方法
    (https "httpbin.org" /: "get")  -- URL
    NoReqBody  -- 请求体
    bsResponse  -- 响应类型
    mempty  -- 查询参数
  liftIO $ print $ responseBody response
```

#### 带查询参数

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req

getWithParams :: IO ()
getWithParams = runReq defaultHttpConfig $ do
  let params = "name" =: ("Alice" :: String)
            <> "age" =: (30 :: Int)
  
  response <- req
    GET
    (https "httpbin.org" /: "get")
    NoReqBody
    jsonResponse  -- 自动解析 JSON
    params
  
  liftIO $ print (responseBody response :: Value)
```

#### POST 请求

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req
import Data.Aeson
import GHC.Generics

data User = User
  { name :: String
  , email :: String
  } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User

postUser :: IO ()
postUser = runReq defaultHttpConfig $ do
  let user = User "Alice" "alice@example.com"
  
  response <- req
    POST
    (https "httpbin.org" /: "post")
    (ReqBodyJson user)  -- JSON 请求体
    jsonResponse
    mempty
  
  liftIO $ print (responseBody response :: Value)
```

#### 错误处理

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req
import Control.Exception (try, SomeException)

safeRequest :: IO ()
safeRequest = do
  result <- try $ runReq defaultHttpConfig $ do
    req
      GET
      (https "invalid-domain-12345.com" /: "test")
      NoReqBody
      bsResponse
      mempty
  
  case result of
    Left (e :: SomeException) -> putStrLn $ "Error: " ++ show e
    Right response -> print response
```

#### 完整示例：获取天气数据

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req
import Data.Aeson
import GHC.Generics
import qualified Data.Text as T

data Weather = Weather
  { description :: T.Text
  , temperature :: Double
  } deriving (Show, Generic)

instance FromJSON Weather

getWeather :: String -> IO ()
getWeather city = runReq defaultHttpConfig $ do
  let params = "q" =: city
            <> "appid" =: ("YOUR_API_KEY" :: String)
            <> "units" =: ("metric" :: String)
  
  response <- req
    GET
    (https "api.openweathermap.org" /: "data" /: "2.5" /: "weather")
    NoReqBody
    jsonResponse
    params
  
  liftIO $ print (responseBody response :: Value)
```

---

## 5. 依赖管理

### 5.1 理解版本号

Haskell 包使用 **PVP**（Package Versioning Policy）：

```
A.B.C.D
│ │ │ └── 补丁版本（bug 修复）
│ │ └──── 次要版本（新功能，向后兼容）
│ └────── 主要版本（破坏性变更）
└──────── 大版本（重大重构）
```

**示例**：
- `1.0.0.0` → `1.0.0.1`: bug 修复
- `1.0.0.0` → `1.0.1.0`: 新功能（兼容）
- `1.0.0.0` → `1.1.0.0`: API 变更（不兼容）

### 5.2 版本约束

```cabal
-- 兼容版本（推荐）
aeson ^>=2.2       -- 等价于 >=2.2 && <2.3

-- 范围
text >=2.0 && <3   -- 2.x 系列

-- 最小版本
req >=3.0

-- 精确版本（不推荐，除非必要）
base ==4.18.0.0
```

### 5.3 Cabal Freeze

锁定依赖版本，确保可重现构建：

```bash
# 生成 cabal.project.freeze 文件
cabal freeze

# 现在所有依赖版本都被锁定
cat cabal.project.freeze
```

**cabal.project.freeze** 示例：

```
constraints: aeson ==2.2.0.0,
             bytestring ==0.11.5.3,
             text ==2.0.2,
             ...
```

### 5.4 常见依赖问题

#### 问题1：依赖冲突

```
Error: [Cabal-7107]
Could not resolve dependencies:
  [__0] trying: my-project-0.1.0.0 (user goal)
  [__1] trying: aeson-2.2.0.0 (dependency of my-project)
  [__2] rejecting: text-2.1 (conflict: aeson => text<2.1)
```

**解决**：
1. 更新包索引：`cabal update`
2. 放宽版本约束
3. 使用 `cabal.project` 指定版本

#### 问题2：构建失败

```bash
# 清理并重新构建
cabal clean
cabal build
```

#### 问题3：缓存问题

```bash
# 清理全局缓存
rm -rf ~/.cabal/store
cabal update
```

### 5.5 使用 Hackage

[Hackage](https://hackage.haskell.org/) 是 Haskell 的中央包仓库。

**查找包**：
1. 访问 https://hackage.haskell.org/
2. 搜索包名
3. 查看文档和示例

**流行的包**：
- `aeson` - JSON
- `req` / `http-conduit` - HTTP
- `text` - 文本处理
- `containers` - 数据结构
- `mtl` - Monad 转换器
- `lens` - 函数式引用
- `optparse-applicative` - 命令行解析

---

## 6. 实战项目

### 6.1 项目一：天气查询工具

完整的命令行天气应用。

#### 项目结构

```bash
weather-cli/
├── app/
│   └── Main.hs
├── src/
│   ├── Weather.hs
│   └── Types.hs
└── weather-cli.cabal
```

#### weather-cli.cabal

```cabal
cabal-version:      2.4
name:               weather-cli
version:            0.1.0.0
license:            MIT
build-type:         Simple

library
    exposed-modules:  Weather, Types
    build-depends:    base ^>=4.18
                    , aeson ^>=2.2
                    , req ^>=3.13
                    , text ^>=2.0
                    , bytestring ^>=0.11
    hs-source-dirs:   src
    default-language: Haskell2010

executable weather-cli
    main-is:          Main.hs
    build-depends:    base ^>=4.18
                    , weather-cli
    hs-source-dirs:   app
    default-language: Haskell2010
```

#### src/Types.hs

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Types where

import Data.Aeson
import GHC.Generics
import qualified Data.Text as T

-- 天气主信息
data WeatherInfo = WeatherInfo
  { main :: T.Text
  , description :: T.Text
  } deriving (Show, Generic)

instance FromJSON WeatherInfo

-- 温度信息
data MainInfo = MainInfo
  { temp :: Double
  , feels_like :: Double
  , humidity :: Int
  } deriving (Show, Generic)

instance FromJSON MainInfo

-- 完整响应
data WeatherResponse = WeatherResponse
  { weather :: [WeatherInfo]
  , mainInfo :: MainInfo
  , name :: T.Text
  } deriving (Show, Generic)

instance FromJSON WeatherResponse where
  parseJSON = withObject "WeatherResponse" $ \v -> WeatherResponse
    <$> v .: "weather"
    <*> v .: "main"
    <*> v .: "name"
```

#### src/Weather.hs

```haskell
{-# LANGUAGE OverloadedStrings #-}
module Weather
  ( getWeather
  , displayWeather
  ) where

import Network.HTTP.Req
import Data.Aeson
import Types
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- 获取天气数据
getWeather :: String -> String -> IO (Maybe WeatherResponse)
getWeather apiKey city = runReq defaultHttpConfig $ do
  let params = "q" =: city
            <> "appid" =: apiKey
            <> "units" =: ("metric" :: String)
            <> "lang" =: ("zh_cn" :: String)
  
  response <- req
    GET
    (https "api.openweathermap.org" /: "data" /: "2.5" /: "weather")
    NoReqBody
    jsonResponse
    params
  
  return $ responseBody response

-- 显示天气信息
displayWeather :: WeatherResponse -> IO ()
displayWeather wr = do
  TIO.putStrLn $ "城市：" <> name wr
  TIO.putStrLn $ "天气：" <> main (head $ weather wr)
  TIO.putStrLn $ "描述：" <> description (head $ weather wr)
  putStrLn $ "温度：" ++ show (temp $ mainInfo wr) ++ "°C"
  putStrLn $ "体感：" ++ show (feels_like $ mainInfo wr) ++ "°C"
  putStrLn $ "湿度：" ++ show (humidity $ mainInfo wr) ++ "%"
```

#### app/Main.hs

```haskell
module Main where

import Weather
import System.Environment (getArgs)
import System.Exit (die)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [apiKey, city] -> do
      result <- getWeather apiKey city
      case result of
        Just weatherData -> displayWeather weatherData
        Nothing -> die "无法获取天气数据"
    _ -> die "用法: weather-cli <API_KEY> <城市>"
```

**使用**：

```bash
cabal build
cabal run weather-cli YOUR_API_KEY Beijing
```

### 6.2 项目二：JSON 配置解析器

读写 JSON 配置文件。

#### 项目结构

```bash
json-config/
├── app/
│   └── Main.hs
├── src/
│   └── Config.hs
└── json-config.cabal
```

#### src/Config.hs

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Config
  ( AppConfig(..)
  , ServerConfig(..)
  , DatabaseConfig(..)
  , loadConfig
  , saveConfig
  , defaultConfig
  ) where

import Data.Aeson
import Data.Aeson.Encode.Pretty (encodePretty)
import GHC.Generics
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T

-- 服务器配置
data ServerConfig = ServerConfig
  { port :: Int
  , host :: T.Text
  , enableSSL :: Bool
  } deriving (Show, Generic)

-- 数据库配置
data DatabaseConfig = DatabaseConfig
  { dbHost :: T.Text
  , dbPort :: Int
  , dbName :: T.Text
  , maxConnections :: Int
  } deriving (Show, Generic)

-- 应用配置
data AppConfig = AppConfig
  { appName :: T.Text
  , version :: T.Text
  , debug :: Bool
  , server :: ServerConfig
  , database :: DatabaseConfig
  } deriving (Show, Generic)

instance FromJSON ServerConfig
instance ToJSON ServerConfig
instance FromJSON DatabaseConfig
instance ToJSON DatabaseConfig
instance FromJSON AppConfig
instance ToJSON AppConfig

-- 默认配置
defaultConfig :: AppConfig
defaultConfig = AppConfig
  { appName = "MyApp"
  , version = "1.0.0"
  , debug = False
  , server = ServerConfig 8080 "localhost" False
  , database = DatabaseConfig "localhost" 5432 "mydb" 10
  }

-- 加载配置
loadConfig :: FilePath -> IO (Either String AppConfig)
loadConfig path = do
  content <- BL.readFile path
  return $ eitherDecode content

-- 保存配置
saveConfig :: FilePath -> AppConfig -> IO ()
saveConfig path config = BL.writeFile path (encodePretty config)
```

#### app/Main.hs

```haskell
module Main where

import Config
import System.Environment (getArgs)
import System.Exit (die)
import qualified Data.Text.IO as TIO

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["init", path] -> do
      saveConfig path defaultConfig
      putStrLn $ "已创建默认配置: " ++ path
    
    ["show", path] -> do
      result <- loadConfig path
      case result of
        Left err -> die $ "解析错误: " ++ err
        Right config -> print config
    
    ["update", path] -> do
      result <- loadConfig path
      case result of
        Left err -> die $ "解析错误: " ++ err
        Right config -> do
          -- 更新某些配置
          let updated = config { debug = True }
          saveConfig path updated
          putStrLn "配置已更新"
    
    _ -> die "用法:\n\
             \  json-config init <文件>   - 创建默认配置\n\
             \  json-config show <文件>   - 显示配置\n\
             \  json-config update <文件> - 更新配置"
```

**使用**：

```bash
cabal run json-config init config.json
cabal run json-config show config.json
cabal run json-config update config.json
```

### 6.3 项目三：简单 REST API 客户端

完整的 API 客户端示例。

```haskell
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module APIClient where

import Network.HTTP.Req
import Data.Aeson
import GHC.Generics
import qualified Data.Text as T

-- 数据模型
data Post = Post
  { postId :: Int
  , userId :: Int
  , title :: T.Text
  , body :: T.Text
  } deriving (Show, Generic)

instance FromJSON Post where
  parseJSON = withObject "Post" $ \v -> Post
    <$> v .: "id"
    <$> v .: "userId"
    <$> v .: "title"
    <$> v .: "body"

instance ToJSON Post where
  toJSON post = object
    [ "id" .= postId post
    , "userId" .= userId post
    , "title" .= title post
    , "body" .= body post
    ]

-- API 客户端
baseUrl = https "jsonplaceholder.typicode.com"

-- 获取所有文章
getPosts :: IO [Post]
getPosts = runReq defaultHttpConfig $ do
  response <- req
    GET
    (baseUrl /: "posts")
    NoReqBody
    jsonResponse
    mempty
  return $ responseBody response

-- 获取单个文章
getPost :: Int -> IO (Maybe Post)
getPost postId = runReq defaultHttpConfig $ do
  response <- req
    GET
    (baseUrl /: "posts" /~ postId)
    NoReqBody
    jsonResponse
    mempty
  return $ responseBody response

-- 创建文章
createPost :: Post -> IO Post
createPost post = runReq defaultHttpConfig $ do
  response <- req
    POST
    (baseUrl /: "posts")
    (ReqBodyJson post)
    jsonResponse
    mempty
  return $ responseBody response

-- 使用示例
main :: IO ()
main = do
  -- 获取所有文章
  posts <- getPosts
  putStrLn $ "共 " ++ show (length posts) ++ " 篇文章"
  
  -- 获取第一篇
  maybePost <- getPost 1
  case maybePost of
    Just post -> putStrLn $ "标题: " ++ T.unpack (title post)
    Nothing -> putStrLn "未找到文章"
  
  -- 创建新文章
  let newPost = Post 0 1 "测试标题" "测试内容"
  created <- createPost newPost
  print created
```

---

## 7. 总结与最佳实践

### 7.1 模块设计原则

1. **单一职责** - 每个模块负责一个功能领域
2. **最小导出** - 只导出必要的函数和类型
3. **避免循环依赖** - 保持依赖关系是有向无环图
4. **命名清晰** - 模块名反映其功能
5. **分层架构** - 底层模块不依赖高层模块

### 7.2 Cabal 最佳实践

1. **使用版本约束** - 用 `^>=` 指定兼容版本
2. **定期更新** - `cabal update` 保持包索引最新
3. **冻结依赖** - 生产环境使用 `cabal freeze`
4. **分离库和可执行程序** - 库代码放 `src/`，程序放 `app/`
5. **编写测试** - 使用 test-suite
6. **文档化** - 在 .cabal 中填写 synopsis 和 description

### 7.3 库使用建议

1. **ByteString vs String**
   - 网络/文件 I/O：用 ByteString
   - 文本处理：用 Text
   - 简单脚本：String 也可以

2. **aeson 技巧**
   - 优先使用 Generic 派生
   - 自定义字段名用 `options` 和 `fieldLabelModifier`
   - 处理错误用 `eitherDecode` 而不是 `decode`

3. **req 技巧**
   - 使用 `jsonResponse` 自动解析
   - 用 `https` 和 `http` 构建 URL
   - 捕获异常处理网络错误

### 7.4 常见错误

```haskell
-- ❌ 忘记添加模块到 .cabal
-- 症状: Module not found
-- 解决: 在 exposed-modules 或 other-modules 中添加

-- ❌ 导入冲突
import Data.Map
import Prelude
-- 解决: 使用 qualified 或 hiding

-- ❌ 版本不兼容
build-depends: aeson ==1.5
-- 解决: 使用范围或 ^>=

-- ❌ String 和 Text 混用
processText :: Text -> String
processText t = t ++ "suffix"  -- 错误！
-- 解决: 用 T.unpack / T.pack 转换
```

### 7.5 下一步学习

完成本周后，你已经掌握项目管理！接下来：

- **Week 6**: 错误处理与测试
- **Week 7**: Cardano 实践
- **Week 8**: 结课项目

继续加油！🚀

---

**练习时间**：前往 [练习作业](exercises.md) 开始实战！

