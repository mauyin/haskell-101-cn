# Week 4: Monad 与 IO - 详细讲义

> 💡 **自学提示**: 本周内容是 Haskell 的精髓！Monad 看起来抽象，但其实就是"组合计算"的模式。建议先理解概念，再大量实践。IO 部分多写代码，别光看！

---

## 目录

1. [Monad 深入理解](#1-monad-深入理解)
2. [纯函数与副作用](#2-纯函数与副作用)
3. [IO Monad 基础](#3-io-monad-基础)
4. [文件操作](#4-文件操作)
5. [网络请求基础](#5-网络请求基础)
6. [实战项目](#6-实战项目)

---

## 1. Monad 深入理解

### 1.1 回顾：Monad 解决什么问题？

在 Week 3，我们初步了解了 Monad。现在深入探讨它的本质。

**问题场景**：链接多个可能失败的操作

```haskell
-- 三个可能失败的函数
findUser :: Int -> Maybe User
getUserEmail :: User -> Maybe String
sendEmail :: String -> Maybe ()

-- 不用 Monad：嵌套地狱
processUser :: Int -> Maybe ()
processUser userId =
  case findUser userId of
    Nothing -> Nothing
    Just user ->
      case getUserEmail user of
        Nothing -> Nothing
        Just email ->
          sendEmail email

-- 用 Monad：简洁优雅
processUser :: Int -> Maybe ()
processUser userId = do
  user <- findUser userId
  email <- getUserEmail user
  sendEmail email
```

**Monad 的本质**：提供统一的方式**组合带上下文的计算**

### 1.2 Monad 类型类定义

```haskell
class Applicative m => Monad m where
  return :: a -> m a
  (>>=)  :: m a -> (a -> m b) -> m b  -- bind 运算符
  (>>)   :: m a -> m b -> m b         -- then 运算符
  
  -- 默认实现
  m >> n = m >>= \_ -> n
```

**核心操作**：

- `return` / `pure`: 把纯值包装进 Monad（`return` 是历史遗留，等同于 `pure`）
- `>>=` (bind): 链接两个 Monad 操作，传递值
- `>>` (then): 链接两个 Monad 操作，忽略第一个的结果

### 1.3 >>= (bind) 运算符详解

`>>=` 读作"bind"，是 Monad 的核心：

```haskell
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```

**类型解读**：
- 接受一个 `m a`（包裹的值）
- 接受一个函数 `a -> m b`（接受纯值，返回包裹的新值）
- 返回 `m b`（新的包裹值）

**Maybe 的 >>= 实现**：

```haskell
instance Monad Maybe where
  return = Just
  
  Nothing >>= f  = Nothing
  Just x  >>= f  = f x
```

**示例**：

```haskell
ghci> Just 5 >>= (\x -> Just (x * 2))
Just 10

ghci> Nothing >>= (\x -> Just (x * 2))
Nothing

-- 链式调用
ghci> Just 5 >>= (\x -> Just (x + 1)) >>= (\y -> Just (y * 2))
Just 12
-- 计算过程：5 -> 6 -> 12
```

### 1.4 do-notation 脱糖

`do-notation` 只是 `>>=` 的语法糖：

```haskell
-- do-notation
computation = do
  x <- action1
  y <- action2 x
  action3 x y

-- 等价于：
computation =
  action1 >>= (\x ->
    action2 x >>= (\y ->
      action3 x y))
```

**规则**：
1. `x <- m` 脱糖为 `m >>= (\x -> ...)`
2. 没有 `<-` 的语句用 `>>` 连接
3. 最后一行是整个表达式的结果

**例子**：

```haskell
-- do 版本
example1 :: Maybe Int
example1 = do
  a <- Just 3
  b <- Just 4
  return (a + b)

-- 脱糖后
example1 :: Maybe Int
example1 =
  Just 3 >>= (\a ->
    Just 4 >>= (\b ->
      return (a + b)))

-- 另一个例子：忽略中间值
example2 :: Maybe Int
example2 = do
  Just 10
  Just 20
  Just 30

-- 脱糖为
example2 = Just 10 >> Just 20 >> Just 30
```

### 1.5 Monad 三大定律

Monad 必须满足三个定律，保证行为可预测：

#### 左单位元（Left Identity）

```haskell
return a >>= f  ≡  f a
```

**含义**：`return` 不应该有任何副作用，只是包装值

```haskell
-- 示例
ghci> return 5 >>= (\x -> Just (x * 2))
Just 10

ghci> (\x -> Just (x * 2)) 5
Just 10
-- 两者等价
```

#### 右单位元（Right Identity）

```haskell
m >>= return  ≡  m
```

**含义**：bind 一个 return 不改变原值

```haskell
-- 示例
ghci> Just 5 >>= return
Just 5

ghci> Just 5
Just 5
-- 两者等价
```

#### 结合律（Associativity）

```haskell
(m >>= f) >>= g  ≡  m >>= (\x -> f x >>= g)
```

**含义**：bind 的嵌套方式不影响结果

```haskell
-- 示例
let f x = Just (x + 1)
let g x = Just (x * 2)

-- 方式1：先 bind f，再 bind g
ghci> (Just 5 >>= f) >>= g
Just 12

-- 方式2：嵌套 bind
ghci> Just 5 >>= (\x -> f x >>= g)
Just 12
-- 两者等价
```

**为什么定律重要？**
- 保证代码重构不改变语义
- 让编译器可以优化
- 确保 do-notation 行为一致

### 1.6 常见 Monad 实例

#### Maybe Monad - 处理可选值

```haskell
instance Monad Maybe where
  return = Just
  Nothing >>= f = Nothing
  Just x  >>= f = f x
```

**用途**：短路错误传播

```haskell
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

compute :: Maybe Double
compute = do
  a <- safeDivide 10 2   -- Just 5
  b <- safeDivide a 0    -- Nothing，短路！
  c <- safeDivide b 2    -- 不会执行
  return c
-- 结果：Nothing
```

#### Either Monad - 携带错误信息

```haskell
instance Monad (Either e) where
  return = Right
  Left e  >>= f = Left e
  Right x >>= f = f x
```

**用途**：错误处理并保留错误信息

```haskell
data Error = DivByZero | NegativeNumber deriving Show

safeDivide :: Double -> Double -> Either Error Double
safeDivide _ 0 = Left DivByZero
safeDivide x y = Right (x / y)

safeSqrt :: Double -> Either Error Double
safeSqrt x
  | x < 0     = Left NegativeNumber
  | otherwise = Right (sqrt x)

compute :: Either Error Double
compute = do
  a <- safeDivide 10 2   -- Right 5
  b <- safeSqrt a        -- Right 2.236...
  return b
-- 结果：Right 2.236...

badCompute :: Either Error Double
badCompute = do
  a <- safeDivide 10 0   -- Left DivByZero，短路！
  b <- safeSqrt a        -- 不会执行
  return b
-- 结果：Left DivByZero
```

#### List Monad - 非确定性计算

```haskell
instance Monad [] where
  return x = [x]
  xs >>= f = concat (map f xs)
```

**用途**：表示多个可能的结果

```haskell
-- 所有可能的配对
pairs :: [Int] -> [Int] -> [(Int, Int)]
pairs xs ys = do
  x <- xs
  y <- ys
  return (x, y)

ghci> pairs [1,2] [3,4]
[(1,3), (1,4), (2,3), (2,4)]

-- 骑士移动问题
type Position = (Int, Int)

moveKnight :: Position -> [Position]
moveKnight (x, y) = do
  (dx, dy) <- [(2,1), (2,-1), (-2,1), (-2,-1),
               (1,2), (1,-2), (-1,2), (-1,-2)]
  let newPos = (x + dx, y + dy)
  guard (onBoard newPos)  -- 过滤非法位置
  return newPos

-- 三步能到达的所有位置
in3 :: Position -> [Position]
in3 start = do
  first <- moveKnight start
  second <- moveKnight first
  moveKnight second
```

### 1.7 Monad vs Functor vs Applicative

**对比三者**：

```haskell
-- Functor: 映射纯函数
fmap :: Functor f => (a -> b) -> f a -> f b

-- Applicative: 映射包裹的函数
(<*>) :: Applicative f => f (a -> b) -> f a -> f b

-- Monad: 映射返回包裹值的函数
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```

**能力层级**：`Monad > Applicative > Functor`

```haskell
-- 用 Functor：函数是纯的
ghci> fmap (+1) (Just 5)
Just 6

-- 用 Applicative：函数和参数都可能包裹
ghci> Just (+) <*> Just 3 <*> Just 4
Just 7

-- 用 Monad：可以根据前一步结果决定下一步
ghci> Just 5 >>= (\x -> if x > 3 then Just (x * 2) else Nothing)
Just 10
```

**什么时候用哪个？**
- **Functor**: 简单映射，函数是纯的
- **Applicative**: 多个独立的包裹值需要组合
- **Monad**: 后续操作依赖前面的结果

---

## 2. 纯函数与副作用

### 2.1 什么是纯函数？

**纯函数**满足两个条件：

1. **确定性**：相同输入永远产生相同输出
2. **无副作用**：不修改外部状态，不执行 I/O

```haskell
-- ✅ 纯函数
add :: Int -> Int -> Int
add x y = x + y

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- ❌ 不纯函数（伪代码）
getCurrentTime :: Int  -- 每次调用结果不同
readFile :: String -> String  -- 有 I/O 副作用
globalCounter := globalCounter + 1  -- 修改全局状态
```

### 2.2 引用透明性（Referential Transparency）

**定义**：任何表达式都可以用它的值替换，不改变程序行为

```haskell
-- 纯函数例子
x = 1 + 1
y = x + x
-- 可以替换为：
y = (1 + 1) + (1 + 1)
y = 2 + 2
y = 4
-- 结果相同！

-- 不纯函数例子（伪代码）
x = readLine()
y = x + x
-- 不能替换为：
y = readLine() + readLine()
-- 因为可能读到两个不同的值！
```

**好处**：
- 易于推理和测试
- 编译器可以优化（重排序、并行化）
- 天然支持缓存（memoization）

### 2.3 Haskell 如何处理副作用？

**关键设计**：用类型系统隔离纯与不纯

```haskell
-- 纯函数：类型不包含 IO
add :: Int -> Int -> Int
add x y = x + y

-- 不纯函数：类型包含 IO
getLine :: IO String
putStrLn :: String -> IO ()
readFile :: FilePath -> IO String
```

**IO 类型的含义**：

```haskell
IO a  -- 不是 a，而是"生成 a 的操作说明书"
```

**心智模型**：

- `Int` = 整数值
- `IO Int` = "如何获得整数的配方"（recipe）

```haskell
-- 这不是字符串，是"如何获得字符串的操作"
getUserInput :: IO String
getUserInput = getLine

-- 这不执行任何 I/O，只是组合操作
greet :: IO ()
greet = do
  putStrLn "What's your name?"
  name <- getLine
  putStrLn ("Hello, " ++ name)
-- 只有在 main 中调用才真正执行！
```

### 2.4 为什么不能"逃出" IO？

```haskell
-- ❌ 不存在这样的函数
escapeIO :: IO a -> a  -- 编译器不允许！

-- 为什么？
-- 如果存在，就能写出这样的代码：
pureAdd :: Int -> Int -> Int
pureAdd x y = 
  let input = escapeIO getLine  -- 把 I/O 偷运进纯函数！
  in read input + x + y
-- 这破坏了引用透明性！
```

**设计哲学**：一旦有副作用，类型永远标记它

```haskell
-- 纯函数调用纯函数：OK
pureFunc :: Int -> Int
pureFunc x = pureHelper x

-- 纯函数调用 IO：不可能
-- pureFunc :: Int -> Int
-- pureFunc x = putStrLn "hello"  -- 类型错误！

-- IO 函数调用纯函数：OK
ioFunc :: IO Int
ioFunc = return (pureHelper 5)

-- IO 函数调用 IO 函数：OK
ioFunc2 :: IO ()
ioFunc2 = putStrLn "hello"
```

**类比**：IO 就像"放射性标记" - 一旦沾上，就洗不掉

---

## 3. IO Monad 基础

### 3.1 基本 IO 操作

#### 输出

```haskell
putStrLn :: String -> IO ()  -- 输出字符串并换行
putStr :: String -> IO ()    -- 输出字符串不换行
print :: Show a => a -> IO () -- 输出任何可显示的值

ghci> putStrLn "Hello, World!"
Hello, World!

ghci> putStr "No newline"
No newlineghci>  -- 注意没换行

ghci> print [1,2,3]
[1,2,3]

ghci> print (Just 5)
Just 5
```

#### 输入

```haskell
getLine :: IO String   -- 读取一行输入
getChar :: IO Char     -- 读取一个字符
getContents :: IO String  -- 读取所有输入（惰性）

-- 示例
ghci> name <- getLine
Alice
ghci> name
"Alice"
```

### 3.2 组合 IO 操作

#### 使用 >> 忽略结果

```haskell
(>>) :: IO a -> IO b -> IO b

hello :: IO ()
hello = putStrLn "Hello" >> putStrLn "World"
-- 输出：
-- Hello
-- World
```

#### 使用 >>= 传递结果

```haskell
(>>=) :: IO a -> (a -> IO b) -> IO b

echo :: IO ()
echo = getLine >>= putStrLn
-- 读取输入，然后输出
```

#### 使用 do-notation（推荐）

```haskell
greet :: IO ()
greet = do
  putStrLn "What's your name?"
  name <- getLine
  putStrLn ("Hello, " ++ name ++ "!")

-- 执行：
ghci> greet
What's your name?
Alice
Hello, Alice!
```

### 3.3 return 在 IO 中的作用

`return` 把纯值包装进 IO，**不是返回语句**！

```haskell
-- ❌ 错误理解：return 会退出函数
wrong :: IO ()
wrong = do
  putStrLn "Before return"
  return ()  -- 这不会退出！
  putStrLn "After return"  -- 仍然执行
-- 输出两行

-- ✅ 正确理解：return 只是包装值
getNumber :: IO Int
getNumber = return 42  -- 把 42 包装成 IO Int

readNumber :: IO Int
readNumber = do
  putStrLn "Enter a number:"
  input <- getLine
  return (read input)  -- 把 Int 包装成 IO Int
```

### 3.4 实战：猜数字游戏（简化版）

```haskell
import System.Random (randomRIO)

guessNumber :: IO ()
guessNumber = do
  putStrLn "=== 猜数字游戏 ==="
  secret <- randomRIO (1, 100)  -- 生成随机数
  putStrLn "我想了一个 1 到 100 的数字，猜猜看！"
  guessLoop secret

guessLoop :: Int -> IO ()
guessLoop secret = do
  putStr "你的猜测: "
  input <- getLine
  let guess = read input :: Int
  
  if guess < secret
    then do
      putStrLn "太小了！"
      guessLoop secret  -- 递归
    else if guess > secret
    then do
      putStrLn "太大了！"
      guessLoop secret
    else
      putStrLn "恭喜你猜对了！"

-- 运行：
main :: IO ()
main = guessNumber
```

### 3.5 常用 IO 函数

```haskell
-- 格式化输出
putStrLn :: String -> IO ()
print :: Show a => a -> IO ()

-- 输入
getLine :: IO String
getChar :: IO Char

-- 转换
return :: a -> IO a
fmap :: (a -> b) -> IO a -> IO b

-- 序列操作
sequence :: [IO a] -> IO [a]  -- 执行列表中所有 IO 操作
sequence_ :: [IO a] -> IO ()   -- 同上，但丢弃结果

mapM :: (a -> IO b) -> [a] -> IO [b]  -- map + sequence
mapM_ :: (a -> IO b) -> [a] -> IO ()  -- map + sequence_

-- 示例
ghci> sequence [putStrLn "A", putStrLn "B", putStrLn "C"]
A
B
C
[(),(),()]

ghci> mapM print [1,2,3]
1
2
3
[(),(),()]
```

---

## 4. 文件操作

### 4.1 读取文件

#### readFile - 简单读取

```haskell
readFile :: FilePath -> IO String

-- 读取整个文件
readExample :: IO ()
readExample = do
  content <- readFile "example.txt"
  putStrLn "文件内容："
  putStrLn content

-- 处理文件内容
countLines :: FilePath -> IO Int
countLines path = do
  content <- readFile path
  return (length (lines content))

-- 使用
ghci> countLines "example.txt"
42
```

#### 按行处理

```haskell
processFile :: FilePath -> IO ()
processFile path = do
  content <- readFile path
  let fileLines = lines content
  mapM_ putStrLn fileLines  -- 逐行输出

-- 带行号输出
printWithLineNumbers :: FilePath -> IO ()
printWithLineNumbers path = do
  content <- readFile path
  let numbered = zip [1..] (lines content)
  mapM_ printLine numbered
  where
    printLine (n, line) = putStrLn (show n ++ ": " ++ line)
```

### 4.2 写入文件

```haskell
writeFile :: FilePath -> String -> IO ()  -- 覆盖写入
appendFile :: FilePath -> String -> IO ()  -- 追加写入

-- 创建文件
createFile :: IO ()
createFile = writeFile "output.txt" "Hello, File!"

-- 追加内容
appendLog :: String -> IO ()
appendLog message = appendFile "log.txt" (message ++ "\n")

-- 写入多行
writeLines :: FilePath -> [String] -> IO ()
writeLines path lns = writeFile path (unlines lns)

-- 使用
ghci> writeLines "data.txt" ["Line 1", "Line 2", "Line 3"]
```

### 4.3 文件复制

```haskell
copyFile :: FilePath -> FilePath -> IO ()
copyFile source dest = do
  content <- readFile source
  writeFile dest content

-- 带反馈的复制
copyFileVerbose :: FilePath -> FilePath -> IO ()
copyFileVerbose source dest = do
  putStrLn ("Copying " ++ source ++ " to " ++ dest)
  content <- readFile source
  writeFile dest content
  putStrLn "Done!"
```

### 4.4 文件句柄（Handles）

对于大文件或需要精细控制，使用文件句柄：

```haskell
import System.IO

-- 手动管理文件句柄
handleExample :: IO ()
handleExample = do
  handle <- openFile "example.txt" ReadMode
  content <- hGetContents handle
  putStrLn content
  hClose handle

-- 更安全的方式：withFile
withFileExample :: IO ()
withFileExample =
  withFile "example.txt" ReadMode $ \handle -> do
    content <- hGetContents handle
    putStrLn content
    -- 自动关闭文件

-- 文件模式
data IOMode = ReadMode | WriteMode | AppendMode | ReadWriteMode
```

### 4.5 目录操作

```haskell
import System.Directory

-- 检查文件/目录是否存在
doesFileExist :: FilePath -> IO Bool
doesDirectoryExist :: FilePath -> IO Bool

-- 列出目录内容
listDirectory :: FilePath -> IO [FilePath]

-- 获取当前目录
getCurrentDirectory :: IO FilePath

-- 示例：列出所有 .txt 文件
listTextFiles :: FilePath -> IO [FilePath]
listTextFiles dir = do
  files <- listDirectory dir
  return (filter isTxt files)
  where
    isTxt name = ".txt" `isSuffixOf` name

-- 安全读取文件
safeReadFile :: FilePath -> IO (Maybe String)
safeReadFile path = do
  exists <- doesFileExist path
  if exists
    then do
      content <- readFile path
      return (Just content)
    else return Nothing
```

### 4.6 惰性 IO 的陷阱

Haskell 的 `readFile` 是**惰性**的 - 可能导致问题：

```haskell
-- ❌ 问题代码
badExample :: IO ()
badExample = do
  content <- readFile "input.txt"
  writeFile "input.txt" content  -- 错误！文件还没真正读完
-- 可能导致文件损坏

-- ✅ 解决方案1：强制求值
import Control.DeepSeq (force)
import Control.Exception (evaluate)

goodExample1 :: IO ()
goodExample1 = do
  content <- readFile "input.txt"
  evaluate (force content)  -- 强制读完
  writeFile "input.txt" content

-- ✅ 解决方案2：使用严格 IO
import qualified Data.Text.IO as T

goodExample2 :: IO ()
goodExample2 = do
  content <- T.readFile "input.txt"  -- 严格读取
  T.writeFile "input.txt" content
```

### 4.7 实战：文本文件统计

```haskell
import Data.List (group, sort)

data FileStats = FileStats
  { totalLines :: Int
  , totalWords :: Int
  , totalChars :: Int
  } deriving Show

-- 统计文件
analyzeFile :: FilePath -> IO FileStats
analyzeFile path = do
  content <- readFile path
  let lns = lines content
      wrds = words content
      chars = length content
  return $ FileStats
    { totalLines = length lns
    , totalWords = length wrds
    , totalChars = chars
    }

-- 查找最常见的单词
topWords :: FilePath -> Int -> IO [(String, Int)]
topWords path n = do
  content <- readFile path
  let wrds = words content
      grouped = group (sort wrds)
      counted = map (\ws -> (head ws, length ws)) grouped
      sorted = take n (sortBy (flip compare `on` snd) counted)
  return sorted

-- 使用
main :: IO ()
main = do
  stats <- analyzeFile "example.txt"
  print stats
  
  putStrLn "\nTop 5 words:"
  top <- topWords "example.txt" 5
  mapM_ print top
```

---

## 5. 网络请求基础

### 5.1 HTTP 请求简介

使用 `http-conduit` 或 `req` 库发起 HTTP 请求。

#### 安装依赖

```bash
# 在 .cabal 文件中添加：
# build-depends: http-conduit, aeson
```

#### 简单 GET 请求

```haskell
import Network.HTTP.Simple

-- 最简单的请求
simpleRequest :: IO ()
simpleRequest = do
  response <- httpBS "https://httpbin.org/get"
  putStrLn $ "Status: " ++ show (getResponseStatusCode response)
  putStrLn $ "Body: " ++ show (getResponseBody response)
```

### 5.2 使用 req 库（推荐）

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req

-- GET 请求
getExample :: IO ()
getExample = runReq defaultHttpConfig $ do
  response <- req GET
    (https "httpbin.org" /: "get")
    NoReqBody
    bsResponse
    mempty
  liftIO $ print (responseBody response)

-- 带参数的请求
getWithParams :: IO ()
getWithParams = runReq defaultHttpConfig $ do
  let params = "name" =: ("Alice" :: Text)
            <> "age" =: (25 :: Int)
  response <- req GET
    (https "httpbin.org" /: "get")
    NoReqBody
    jsonResponse
    params
  liftIO $ print (responseBody response :: Value)
```

### 5.3 POST 请求

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req
import Data.Aeson (object, (.=), Value)

postExample :: IO ()
postExample = runReq defaultHttpConfig $ do
  let payload = object
        [ "name" .= ("Alice" :: Text)
        , "age"  .= (25 :: Int)
        ]
  response <- req POST
    (https "httpbin.org" /: "post")
    (ReqBodyJson payload)
    jsonResponse
    mempty
  liftIO $ print (responseBody response :: Value)
```

### 5.4 错误处理

```haskell
import Control.Exception (try, SomeException)

safeRequest :: IO (Either String String)
safeRequest = do
  result <- try (httpBS "https://invalid-url.example") :: IO (Either SomeException (Response ByteString))
  case result of
    Left err -> return $ Left (show err)
    Right response -> return $ Right (show $ getResponseBody response)
```

### 5.5 实战：天气查询工具（简化版）

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T

-- 假设使用某个天气 API
data Weather = Weather
  { temperature :: Double
  , description :: T.Text
  } deriving (Show, Generic)

instance FromJSON Weather

-- 查询天气
getWeather :: String -> IO (Maybe Weather)
getWeather city = runReq defaultHttpConfig $ do
  response <- req GET
    (https "api.weather.com" /: "v1" /: "weather")
    NoReqBody
    jsonResponse
    ("city" =: city)
  return (responseBody response)

-- 主程序
main :: IO ()
main = do
  putStrLn "输入城市名："
  city <- getLine
  weather <- getWeather city
  case weather of
    Nothing -> putStrLn "获取天气失败"
    Just w -> do
      putStrLn $ "温度: " ++ show (temperature w)
      putStrLn $ "描述: " ++ T.unpack (description w)
```

---

## 6. 实战项目

### 6.1 项目一：TODO 清单 CLI

完整的命令行 TODO 应用：

```haskell
import System.IO
import System.Directory (doesFileExist)

type Todo = String

todoFile :: FilePath
todoFile = "todos.txt"

-- 加载 TODO
loadTodos :: IO [Todo]
loadTodos = do
  exists <- doesFileExist todoFile
  if exists
    then do
      content <- readFile todoFile
      return (lines content)
    else return []

-- 保存 TODO
saveTodos :: [Todo] -> IO ()
saveTodos todos = writeFile todoFile (unlines todos)

-- 添加 TODO
addTodo :: Todo -> IO ()
addTodo todo = do
  todos <- loadTodos
  saveTodos (todos ++ [todo])
  putStrLn "已添加！"

-- 列出所有 TODO
listTodos :: IO ()
listTodos = do
  todos <- loadTodos
  if null todos
    then putStrLn "没有任务！"
    else do
      putStrLn "=== 你的任务 ==="
      mapM_ printIndexed (zip [1..] todos)
  where
    printIndexed (i, todo) = putStrLn (show i ++ ". " ++ todo)

-- 删除 TODO
removeTodo :: Int -> IO ()
removeTodo index = do
  todos <- loadTodos
  if index < 1 || index > length todos
    then putStrLn "无效的索引！"
    else do
      let newTodos = take (index - 1) todos ++ drop index todos
      saveTodos newTodos
      putStrLn "已删除！"

-- 主循环
mainLoop :: IO ()
mainLoop = do
  putStrLn "\n=== TODO 清单 ==="
  putStrLn "1. 列出任务"
  putStrLn "2. 添加任务"
  putStrLn "3. 删除任务"
  putStrLn "4. 退出"
  putStr "选择: "
  hFlush stdout
  choice <- getLine
  
  case choice of
    "1" -> listTodos >> mainLoop
    "2" -> do
      putStr "任务内容: "
      hFlush stdout
      todo <- getLine
      addTodo todo
      mainLoop
    "3" -> do
      listTodos
      putStr "要删除的任务编号: "
      hFlush stdout
      index <- readLN
      removeTodo index
      mainLoop
    "4" -> putStrLn "再见！"
    _   -> putStrLn "无效选择！" >> mainLoop

readLN :: Read a => IO a
readLN = fmap read getLine

main :: IO ()
main = mainLoop
```

### 6.2 项目二：文件搜索工具

搜索目录中包含特定文本的文件：

```haskell
import System.Directory
import System.FilePath ((</>), takeExtension)
import Control.Monad (filterM)
import Data.List (isInfixOf)

-- 搜索文件
searchInFile :: String -> FilePath -> IO Bool
searchInFile query path = do
  content <- readFile path
  return (query `isInfixOf` content)

-- 获取所有文件（递归）
getAllFiles :: FilePath -> IO [FilePath]
getAllFiles dir = do
  contents <- listDirectory dir
  let paths = map (dir </>) contents
  files <- filterM doesFileExist paths
  dirs <- filterM doesDirectoryExist paths
  subFiles <- concat <$> mapM getAllFiles dirs
  return (files ++ subFiles)

-- 过滤特定扩展名
filterByExtension :: [String] -> [FilePath] -> [FilePath]
filterByExtension exts = filter (\f -> takeExtension f `elem` exts)

-- 主搜索函数
searchFiles :: FilePath -> String -> [String] -> IO [FilePath]
searchFiles dir query exts = do
  allFiles <- getAllFiles dir
  let targetFiles = filterByExtension exts allFiles
  filterM (searchInFile query) targetFiles

-- 使用
main :: IO ()
main = do
  putStrLn "搜索目录: "
  dir <- getLine
  putStrLn "搜索内容: "
  query <- getLine
  putStrLn "文件类型（如 .txt .md）: "
  extsInput <- getLine
  let exts = words extsInput
  
  putStrLn "搜索中..."
  results <- searchFiles dir query exts
  
  if null results
    then putStrLn "没有找到匹配的文件"
    else do
      putStrLn $ "找到 " ++ show (length results) ++ " 个文件："
      mapM_ putStrLn results
```

### 6.3 项目三：日志分析器

分析日志文件，统计错误类型：

```haskell
import Data.List (isPrefixOf, sortBy)
import Data.Ord (comparing)
import qualified Data.Map as M

-- 日志级别
data LogLevel = INFO | WARN | ERROR | DEBUG
  deriving (Show, Eq, Ord, Read)

-- 解析日志行
parseLine :: String -> Maybe (LogLevel, String)
parseLine line
  | "[INFO]"  `isPrefixOf` line = Just (INFO, drop 6 line)
  | "[WARN]"  `isPrefixOf` line = Just (WARN, drop 6 line)
  | "[ERROR]" `isPrefixOf` line = Just (ERROR, drop 7 line)
  | "[DEBUG]" `isPrefixOf` line = Just (DEBUG, drop 7 line)
  | otherwise = Nothing

-- 分析日志文件
analyzeLog :: FilePath -> IO ()
analyzeLog path = do
  content <- readFile path
  let lns = lines content
      parsed = [p | Just p <- map parseLine lns]
      counts = countLevels parsed
  
  putStrLn "=== 日志分析 ==="
  putStrLn $ "总行数: " ++ show (length lns)
  putStrLn $ "有效日志: " ++ show (length parsed)
  putStrLn "\n各级别统计:"
  mapM_ printCount (M.toList counts)
  
  putStrLn "\n错误信息:"
  let errors = [msg | (ERROR, msg) <- parsed]
  mapM_ (putStrLn . ("  - " ++)) (take 10 errors)

countLevels :: [(LogLevel, String)] -> M.Map LogLevel Int
countLevels = foldr (\(lvl, _) -> M.insertWith (+) lvl 1) M.empty

printCount :: (LogLevel, Int) -> IO ()
printCount (lvl, count) = putStrLn $ "  " ++ show lvl ++ ": " ++ show count

main :: IO ()
main = do
  putStrLn "日志文件路径: "
  path <- getLine
  analyzeLog path
```

---

## 7. 总结与最佳实践

### 7.1 Monad 使用建议

1. **优先使用 do-notation** - 比 `>>=` 更易读
2. **理解脱糖** - 知道 do 如何转换为 `>>=`
3. **验证 Monad laws** - 自定义 Monad 时确保满足三大定律
4. **选择合适的 Monad** - Maybe/Either/List 各有用途

### 7.2 IO 编程建议

1. **最小化 IO 边界** - 尽量将逻辑保持纯函数，只在边界处使用 IO
2. **使用类型引导设计** - 让类型系统帮你避免错误
3. **注意惰性 IO** - 大文件使用严格 IO 或流式处理
4. **正确处理资源** - 使用 `withFile` 等确保资源释放
5. **错误处理** - 使用 `Either`、`Maybe` 或异常机制

### 7.3 常见错误

```haskell
-- ❌ 忘记 <- 提取值
bad1 = do
  name = getLine  -- 错误！name 的类型是 IO String
  putStrLn name

-- ✅ 正确
good1 = do
  name <- getLine  -- name 的类型是 String
  putStrLn name

-- ❌ 混淆 return 和命令式语言的 return
bad2 = do
  putStrLn "Before"
  return ()  -- 不会退出！
  putStrLn "After"  -- 仍然执行

-- ✅ 理解 return 只是包装
good2 = do
  putStrLn "Before"
  putStrLn "After"

-- ❌ 惰性 IO 陷阱
bad3 = do
  content <- readFile "file.txt"
  writeFile "file.txt" content  -- 危险！

-- ✅ 强制求值或使用严格 IO
good3 = do
  content <- readFile "file.txt"
  length content `seq` return ()  -- 强制读完
  writeFile "file.txt" content
```

### 7.4 下一步学习

完成本周后，你已经掌握 Haskell 核心概念！接下来：

- **Week 5**: 模块系统与项目管理
- **Week 6**: 测试与错误处理
- **Week 7**: Cardano 实践
- **Week 8**: 结课项目

继续加油！🚀

---

**练习时间**：前往 [练习作业](exercises.md) 开始实战！

