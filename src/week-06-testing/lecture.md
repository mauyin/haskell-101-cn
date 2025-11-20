# Week 6: 错误处理与测试 - 详细讲义

> 💡 **自学提示**: 本周内容非常实用！错误处理决定了代码的健壮性，测试保证代码的正确性。建议多写代码、多写测试，光看不练是学不会的！

---

## 目录

1. [Maybe 与 Either 深入](#1-maybe-与-either-深入)
2. [ExceptT Monad Transformer](#2-exceptt-monad-transformer)
3. [异常系统](#3-异常系统)
4. [QuickCheck 属性测试](#4-quickcheck-属性测试)
5. [Hspec 单元测试](#5-hspec-单元测试)
6. [测试驱动开发 (TDD)](#6-测试驱动开发-tdd)
7. [调试技巧](#7-调试技巧)

---

## 1. Maybe 与 Either 深入

### 1.1 回顾：为什么需要 Maybe 和 Either？

**问题**：如何表示可能失败的计算？

```haskell
-- ❌ 不好的方式：使用魔法值
divide :: Int -> Int -> Int
divide x 0 = -999999  -- 魔法值表示错误
divide x y = x `div` y
-- 问题：-999999 可能是合法结果！

-- ✅ 好的方式：使用 Maybe
divide :: Int -> Int -> Maybe Int
divide _ 0 = Nothing
divide x y = Just (x `div` y)
```

### 1.2 Maybe 模式

**定义**：

```haskell
data Maybe a = Nothing | Just a
```

**常用函数**：

```haskell
-- 从 Maybe 中提取值（提供默认值）
fromMaybe :: a -> Maybe a -> a
fromMaybe def Nothing  = def
fromMaybe _   (Just x) = x

-- 示例
ghci> fromMaybe 0 Nothing
0
ghci> fromMaybe 0 (Just 42)
42

-- 将 Maybe 应用函数
maybe :: b -> (a -> b) -> Maybe a -> b
maybe def f Nothing  = def
maybe def f (Just x) = f x

-- 示例
ghci> maybe "Empty" show (Just 42)
"42"
ghci> maybe "Empty" show Nothing
"Empty"

-- 链接多个 Maybe 计算
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
Nothing >>= f  = Nothing
Just x  >>= f  = f x
```

**实战示例**：安全的字典查询

```haskell
import qualified Data.Map as M

type UserDB = M.Map Int String

-- 查询用户名
lookupUserName :: Int -> UserDB -> Maybe String
lookupUserName = M.lookup

-- 查询并处理
processUser :: Int -> UserDB -> String
processUser userId db =
  case lookupUserName userId db of
    Nothing -> "用户不存在"
    Just name -> "欢迎, " ++ name

-- 使用 maybe
processUser' :: Int -> UserDB -> String
processUser' userId db =
  maybe "用户不存在" (\name -> "欢迎, " ++ name) (lookupUserName userId db)

-- 链式查询
type EmailDB = M.Map String String

getUserEmail :: Int -> UserDB -> EmailDB -> Maybe String
getUserEmail userId userDB emailDB = do
  name <- M.lookup userId userDB  -- Maybe String
  email <- M.lookup name emailDB  -- Maybe String
  return email
```

### 1.3 Either 模式

**定义**：携带错误信息

```haskell
data Either e a = Left e | Right a
  -- Left 表示错误（携带错误信息）
  -- Right 表示成功（携带结果）
```

**为什么需要 Either？**

```haskell
-- Maybe 只能说"失败了"
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing  -- 为什么失败？不知道
safeDivide x y = Just (x `div` y)

-- Either 可以说"为什么失败"
data DivError = DivByZero | Overflow deriving Show

safeDivide' :: Int -> Int -> Either DivError Int
safeDivide' _ 0 = Left DivByZero
safeDivide' x y 
  | tooBig = Left Overflow
  | otherwise = Right (x `div` y)
  where
    tooBig = abs y < 1 && abs x > maxBound `div` abs y
```

**Either 作为 Monad**：

```haskell
-- Either e 是 Monad
instance Monad (Either e) where
  return = Right
  Left e  >>= _ = Left e
  Right x >>= f = f x

-- 链式计算
compute :: Int -> Int -> Either String Int
compute x y = do
  a <- safeDivide x y    -- 可能失败
  b <- safeDivide a 2    -- 可能失败
  return (b + 10)        -- 成功
  where
    safeDivide :: Int -> Int -> Either String Int
    safeDivide _ 0 = Left "除零错误"
    safeDivide x y = Right (x `div` y)

ghci> compute 10 2
Right 12
ghci> compute 10 0
Left "除零错误"
```

**实战示例**：配置文件解析

```haskell
data ParseError 
  = InvalidFormat String
  | MissingField String
  | InvalidValue String
  deriving Show

type Config = Map String String

-- 解析配置
parseConfig :: String -> Either ParseError Config
parseConfig input = do
  lines <- parseLines input
  pairs <- mapM parsePair lines
  return $ M.fromList pairs
  where
    parseLines :: String -> Either ParseError [String]
    parseLines s = Right (lines s)
    
    parsePair :: String -> Either ParseError (String, String)
    parsePair line =
      case break (== '=') line of
        (key, '=':value) -> Right (trim key, trim value)
        _ -> Left $ InvalidFormat line
    
    trim = reverse . dropWhile (== ' ') . reverse . dropWhile (== ' ')

-- 获取配置项
getConfigValue :: String -> Config -> Either ParseError String
getConfigValue key cfg =
  case M.lookup key cfg of
    Nothing -> Left $ MissingField key
    Just val -> Right val

-- 解析整数
parseInt :: String -> Either ParseError Int
parseInt s =
  case reads s of
    [(n, "")] -> Right n
    _ -> Left $ InvalidValue s

-- 组合使用
getPort :: Config -> Either ParseError Int
getPort cfg = do
  portStr <- getConfigValue "port" cfg
  port <- parseInt portStr
  if port >= 1 && port <= 65535
    then return port
    else Left $ InvalidValue ("端口超出范围: " ++ show port)
```

### 1.4 Either vs Maybe 选择

| 场景 | 使用 Maybe | 使用 Either |
|------|-----------|------------|
| 失败原因显而易见 | ✅ | ❌ |
| 需要详细错误信息 | ❌ | ✅ |
| 简单的空值检查 | ✅ | ❌ |
| 多种失败类型 | ❌ | ✅ |
| 链式错误传播 | 部分 | ✅ |

**经验法则**：
- 快速原型、内部函数：Maybe
- 公开 API、用户输入验证：Either

---

## 2. ExceptT Monad Transformer

### 2.1 问题：IO 中的错误处理

```haskell
-- 文件操作可能失败
readFile :: FilePath -> IO String
parseData :: String -> Either Error Data

-- 如何组合？
processFile :: FilePath -> IO (Either Error Data)
processFile path = do
  content <- readFile path  -- IO String
  return $ parseData content  -- Either Error Data
-- 嵌套的 IO (Either ...)，不方便！
```

### 2.2 ExceptT 解决方案

**定义**：

```haskell
newtype ExceptT e m a = ExceptT { runExceptT :: m (Either e a) }
```

**作用**：在 IO 中添加 Either 的错误处理能力

```haskell
import Control.Monad.Except

-- 使用 ExceptT
processFile :: FilePath -> ExceptT Error IO Data
processFile path = do
  content <- liftIO $ readFile path  -- 提升 IO 到 ExceptT
  ExceptT $ return $ parseData content  -- 包装 Either
  
-- 或者更简洁
processFile' :: FilePath -> ExceptT Error IO Data
processFile' path = do
  content <- liftIO $ readFile path
  case parseData content of
    Left err -> throwError err
    Right dat -> return dat
```

### 2.3 ExceptT 常用操作

```haskell
import Control.Monad.Except

-- 抛出错误
throwError :: Monad m => e -> ExceptT e m a

-- 捕获错误
catchError :: Monad m => ExceptT e m a -> (e -> ExceptT e m a) -> ExceptT e m a

-- 提升 IO
liftIO :: IO a -> ExceptT e IO a

-- 运行 ExceptT
runExceptT :: ExceptT e m a -> m (Either e a)
```

**完整示例**：

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Control.Monad.Except
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

data AppError
  = FileNotFound FilePath
  | ParseError String
  | ValidationError String
  deriving Show

-- 读取文件
readFileE :: FilePath -> ExceptT AppError IO T.Text
readFileE path = do
  exists <- liftIO $ doesFileExist path
  if exists
    then liftIO $ TIO.readFile path
    else throwError $ FileNotFound path

-- 解析数据
parseData :: T.Text -> ExceptT AppError IO [Int]
parseData text =
  case mapM (readMaybe . T.unpack) (T.lines text) of
    Nothing -> throwError $ ParseError "包含非数字行"
    Just nums -> return nums

-- 验证数据
validateData :: [Int] -> ExceptT AppError IO [Int]
validateData nums
  | null nums = throwError $ ValidationError "数据为空"
  | any (< 0) nums = throwError $ ValidationError "包含负数"
  | otherwise = return nums

-- 主流程
processFile :: FilePath -> ExceptT AppError IO [Int]
processFile path = do
  content <- readFileE path
  nums <- parseData content
  validateData nums

-- 运行
main :: IO ()
main = do
  result <- runExceptT $ processFile "data.txt"
  case result of
    Left err -> putStrLn $ "错误: " ++ show err
    Right nums -> putStrLn $ "成功: " ++ show nums
```

### 2.4 错误恢复

```haskell
-- 提供默认值
processFileWithDefault :: FilePath -> ExceptT AppError IO [Int]
processFileWithDefault path =
  processFile path `catchError` \err -> do
    liftIO $ putStrLn $ "警告: " ++ show err ++ ", 使用默认值"
    return []

-- 尝试多个文件
tryFiles :: [FilePath] -> ExceptT AppError IO [Int]
tryFiles [] = throwError $ FileNotFound "所有文件都不存在"
tryFiles (p:ps) =
  processFile p `catchError` \_ -> tryFiles ps

-- 转换错误类型
handleParseError :: ExceptT AppError IO a -> ExceptT String IO a
handleParseError action = do
  result <- liftIO $ runExceptT action
  case result of
    Left err -> throwError $ "应用错误: " ++ show err
    Right val -> return val
```

---

## 3. 异常系统

### 3.1 Haskell 的异常

Haskell 有异常系统，主要用于 IO：

```haskell
import Control.Exception

-- 抛出异常
throw :: Exception e => e -> a
throwIO :: Exception e => e -> IO a

-- 捕获异常
catch :: Exception e => IO a -> (e -> IO a) -> IO a
try :: Exception e => IO a -> IO (Either e a)

-- finally（无论是否异常都执行）
finally :: IO a -> IO b -> IO a
```

### 3.2 自定义异常类型

```haskell
{-# LANGUAGE DeriveAnyClass #-}
import Control.Exception
import Data.Typeable

data MyException 
  = NetworkError String
  | DatabaseError String
  | InvalidInput String
  deriving (Show, Typeable)

instance Exception MyException

-- 使用
connectDatabase :: IO Connection
connectDatabase = do
  result <- tryConnect
  case result of
    Nothing -> throwIO $ DatabaseError "连接失败"
    Just conn -> return conn
```

### 3.3 异常处理示例

```haskell
import Control.Exception
import System.IO.Error

-- 安全读取文件
safeReadFile :: FilePath -> IO (Either IOError String)
safeReadFile path = try $ readFile path

-- 使用
main :: IO ()
main = do
  result <- safeReadFile "config.txt"
  case result of
    Left err -> putStrLn $ "读取失败: " ++ show err
    Right content -> putStrLn content

-- 捕获特定异常
readFileWithDefault :: FilePath -> IO String
readFileWithDefault path =
  readFile path `catch` \e ->
    if isDoesNotExistError e
      then return ""
      else throwIO e  -- 重新抛出其他错误

-- finally 确保资源释放
processFileWithCleanup :: FilePath -> IO ()
processFileWithCleanup path = do
  handle <- openFile path ReadMode
  processContent handle
    `finally` hClose handle  -- 确保关闭文件
```

### 3.4 异常 vs Either

**何时使用异常？**

✅ **适合异常的场景**：
- IO 操作（文件、网络）
- 不可恢复的错误
- 跨越多个函数调用的错误

❌ **不适合异常的场景**：
- 纯函数中
- 可预期的错误（如解析失败）
- 业务逻辑错误

**示例对比**：

```haskell
-- ❌ 纯函数中用异常（不好）
parseNumber :: String -> Int
parseNumber s = case reads s of
  [(n, "")] -> n
  _ -> error "解析失败"  -- 不好！

-- ✅ 纯函数中用 Either（好）
parseNumber :: String -> Either String Int
parseNumber s = case reads s of
  [(n, "")] -> Right n
  _ -> Left "解析失败"

-- ✅ IO 中可以用异常
connectServer :: String -> Int -> IO Socket
connectServer host port = do
  sock <- socket AF_INET Stream 0
  connect sock (SockAddrInet port (tupleToHostAddress (127,0,0,1)))
    `catch` \(e :: IOException) -> do
      close sock
      throwIO $ NetworkError $ "连接失败: " ++ show e
  return sock
```

---

## 4. QuickCheck 属性测试

### 4.1 什么是属性测试？

**传统单元测试**：

```haskell
-- 手写测试用例
testReverse :: Bool
testReverse =
  reverse [1,2,3] == [3,2,1] &&
  reverse [] == [] &&
  reverse [1] == [1]
-- 只测试了 3 个用例！
```

**属性测试**：

```haskell
import Test.QuickCheck

-- 定义属性
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = reverse (reverse xs) == xs

-- QuickCheck 自动生成 100 个测试用例
ghci> quickCheck prop_reverseReverse
+++ OK, passed 100 tests.
```

### 4.2 QuickCheck 基础

```haskell
import Test.QuickCheck

-- 属性：函数签名以 prop_ 开头
prop_addCommutative :: Int -> Int -> Bool
prop_addCommutative x y = x + y == y + x

-- 运行测试
ghci> quickCheck prop_addCommutative
+++ OK, passed 100 tests.

-- 属性：列表长度
prop_lengthAppend :: [Int] -> [Int] -> Bool
prop_lengthAppend xs ys = length (xs ++ ys) == length xs + length ys

-- 属性：map 不改变长度
prop_mapLength :: [Int] -> Bool
prop_mapLength xs = length (map (*2) xs) == length xs
```

### 4.3 常见属性模式

#### 模式 1: 恒等性

```haskell
-- f . g = id
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = reverse (reverse xs) == xs

prop_encodeDecodeText :: String -> Bool
prop_encodeDecodeText s = decodeUtf8 (encodeUtf8 s) == s
```

#### 模式 2: 不变量

```haskell
-- 排序后依然包含所有元素
prop_sortPreservesElements :: [Int] -> Bool
prop_sortPreservesElements xs = sort xs `sameElements` xs
  where
    sameElements as bs = sort as == sort bs

-- 过滤后元素减少或不变
prop_filterLength :: [Int] -> Bool
prop_filterLength xs = length (filter even xs) <= length xs
```

#### 模式 3: 交换律/结合律

```haskell
-- 交换律
prop_addCommutative :: Int -> Int -> Bool
prop_addCommutative x y = x + y == y + x

-- 结合律
prop_addAssociative :: Int -> Int -> Int -> Bool
prop_addAssociative x y z = (x + y) + z == x + (y + z)

-- 分配律
prop_mulDistributive :: Int -> Int -> Int -> Bool
prop_mulDistributive x y z = x * (y + z) == x * y + x * z
```

#### 模式 4: 幂等性

```haskell
-- f . f = f
prop_sortIdempotent :: [Int] -> Bool
prop_sortIdempotent xs = sort (sort xs) == sort xs

prop_absIdempotent :: Int -> Bool
prop_absIdempotent x = abs (abs x) == abs x
```

### 4.4 条件属性

```haskell
-- 只在满足条件时测试
prop_dividePositive :: Int -> Int -> Property
prop_dividePositive x y =
  y > 0 ==> (x `div` y) * y + (x `mod` y) == x

-- 多个条件
prop_safeDivide :: Int -> Int -> Property
prop_safeDivide x y =
  y /= 0 && x /= minBound ==> x `div` y * y + x `mod` y == x

ghci> quickCheck prop_dividePositive
+++ OK, passed 100 tests; 162 discarded.
```

### 4.5 自定义生成器

```haskell
import Test.QuickCheck

-- 生成正整数
positiveInt :: Gen Int
positiveInt = abs <$> arbitrary `suchThat` (> 0)

-- 生成有效邮箱
newtype Email = Email String deriving Show

instance Arbitrary Email where
  arbitrary = do
    name <- listOf1 (elements ['a'..'z'])
    domain <- listOf1 (elements ['a'..'z'])
    return $ Email (name ++ "@" ++ domain ++ ".com")

-- 使用自定义类型
prop_emailHasAt :: Email -> Bool
prop_emailHasAt (Email s) = '@' `elem` s
```

### 4.6 完整测试示例

```haskell
{-# LANGUAGE TemplateHaskell #-}
import Test.QuickCheck

-- 被测试的代码
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)

-- 属性测试
prop_safeDivNonZero :: Int -> NonZero Int -> Bool
prop_safeDivNonZero x (NonZero y) =
  case safeDiv x y of
    Nothing -> False  -- 非零除数不应返回 Nothing
    Just result -> result * y + (x `mod` y) == x

prop_safeDivZero :: Int -> Bool
prop_safeDivZero x = safeDiv x 0 == Nothing

prop_safeDivPositive :: Positive Int -> Positive Int -> Bool
prop_safeDivPositive (Positive x) (Positive y) =
  case safeDiv x y of
    Nothing -> False
    Just result -> result >= 0

-- 运行所有测试
main :: IO ()
main = do
  quickCheck prop_safeDivNonZero
  quickCheck prop_safeDivZero
  quickCheck prop_safeDivPositive
```

---

## 5. Hspec 单元测试

### 5.1 Hspec 简介

Hspec 是 BDD 风格的测试框架：

```haskell
import Test.Hspec

-- 被测试函数
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- 测试
main :: IO ()
main = hspec $ do
  describe "factorial" $ do
    it "0 的阶乘是 1" $
      factorial 0 `shouldBe` 1
    
    it "5 的阶乘是 120" $
      factorial 5 `shouldBe` 120
    
    it "负数应该报错" $
      evaluate (factorial (-1)) `shouldThrow` anyException
```

### 5.2 Hspec 断言

```haskell
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "各种断言" $ do
    it "相等断言" $
      2 + 2 `shouldBe` 4
    
    it "不等断言" $
      2 + 2 `shouldNotBe` 5
    
    it "列表包含" $
      [1,2,3] `shouldContain` [2]
    
    it "以...开始" $
      "hello world" `shouldStartWith` "hello"
    
    it "以...结束" $
      "hello world" `shouldEndWith` "world"
    
    it "满足条件" $
      10 `shouldSatisfy` (> 5)
    
    it "抛出异常" $
      error "boom" `shouldThrow` anyException
```

### 5.3 组织测试

```haskell
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Stack" $ do
    describe "push" $ do
      it "increases size" $ do
        let stack = push 1 empty
        size stack `shouldBe` 1
      
      it "adds element to top" $ do
        let stack = push 1 empty
        top stack `shouldBe` Just 1
    
    describe "pop" $ do
      it "decreases size" $ do
        let stack = pop (push 1 empty)
        size stack `shouldBe` 0
      
      it "returns Nothing for empty stack" $ do
        pop empty `shouldBe` Nothing
```

### 5.4 测试 IO 代码

```haskell
import Test.Hspec
import System.IO.Temp (withSystemTempFile)
import System.IO

-- 被测试函数
writeAndCount :: FilePath -> String -> IO Int
writeAndCount path content = do
  writeFile path content
  contents <- readFile path
  return $ length $ lines contents

-- 测试
main :: IO ()
main = hspec $ do
  describe "writeAndCount" $ do
    it "writes and counts lines" $ do
      withSystemTempFile "test.txt" $ \path handle -> do
        hClose handle
        count <- writeAndCount path "line1\nline2\nline3"
        count `shouldBe` 3
```

### 5.5 结合 QuickCheck

```haskell
import Test.Hspec
import Test.QuickCheck

main :: IO ()
main = hspec $ do
  describe "reverse" $ do
    it "reverses a list" $
      reverse [1,2,3] `shouldBe` [3,2,1]
    
    it "reverse . reverse = id" $ property $
      \xs -> reverse (reverse xs) == (xs :: [Int])
    
    it "preserves length" $ property $
      \xs -> length (reverse xs) == length (xs :: [Int])
```

---

## 6. 测试驱动开发 (TDD)

### 6.1 TDD 循环

```
1. 🔴 Red: 写失败的测试
2. 🟢 Green: 写最少代码让测试通过
3. 🔵 Refactor: 重构代码
4. 重复
```

### 6.2 TDD 实战示例：计算器

```haskell
-- Step 1: 写测试（先失败）
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Calculator" $ do
    it "adds two numbers" $
      add 2 3 `shouldBe` 5  -- 编译错误！add 未定义

-- Step 2: 最简实现（让测试通过）
add :: Int -> Int -> Int
add x y = 5  -- 硬编码！但测试通过了

-- Step 3: 添加更多测试
main = hspec $ do
  describe "Calculator" $ do
    it "adds 2 and 3" $
      add 2 3 `shouldBe` 5
    
    it "adds 10 and 20" $
      add 10 20 `shouldBe` 30  -- 失败！

-- Step 4: 正确实现
add :: Int -> Int -> Int
add x y = x + y  -- 现在所有测试都通过

-- Step 5: 添加更多功能
main = hspec $ do
  describe "Calculator" $ do
    describe "add" $ do
      it "adds positive numbers" $
        add 2 3 `shouldBe` 5
      
      it "adds negative numbers" $
        add (-2) (-3) `shouldBe` (-5)
    
    describe "multiply" $ do
      it "multiplies two numbers" $
        multiply 3 4 `shouldBe` 12  -- 开始下一个循环

-- 继续 TDD 循环...
multiply :: Int -> Int -> Int
multiply x y = x * y
```

### 6.3 TDD 完整示例：Stack

```haskell
{-# LANGUAGE InstanceSigs #-}
import Test.Hspec

-- 第 1 轮：定义类型和测试
data Stack a = Stack [a] deriving (Show, Eq)

empty :: Stack a
empty = undefined  -- 先不实现

push :: a -> Stack a -> Stack a
push = undefined

pop :: Stack a -> Maybe (a, Stack a)
pop = undefined

tests :: Spec
tests = do
  describe "Stack" $ do
    describe "empty" $ do
      it "creates empty stack" $
        empty `shouldBe` Stack ([] :: [Int])

-- 第 2 轮：实现 empty
empty :: Stack a
empty = Stack []

-- 测试通过！继续...

-- 第 3 轮：添加 push 测试和实现
tests = do
  describe "Stack" $ do
    describe "push" $ do
      it "adds element" $
        push 1 empty `shouldBe` Stack [1]
      
      it "maintains order" $ do
        let stack = push 2 (push 1 empty)
        stack `shouldBe` Stack [2, 1]

push :: a -> Stack a -> Stack a
push x (Stack xs) = Stack (x:xs)

-- 第 4 轮：添加 pop 测试和实现
tests = do
  describe "Stack" $ do
    describe "pop" $ do
      it "returns Nothing for empty" $
        pop empty `shouldBe` (Nothing :: Maybe (Int, Stack Int))
      
      it "returns top element" $ do
        let stack = push 1 empty
        pop stack `shouldBe` Just (1, empty)
      
      it "maintains remaining stack" $ do
        let stack = push 2 (push 1 empty)
        pop stack `shouldBe` Just (2, Stack [1])

pop :: Stack a -> Maybe (a, Stack a)
pop (Stack []) = Nothing
pop (Stack (x:xs)) = Just (x, Stack xs)

-- 完整实现和测试！
```

---

## 7. 调试技巧

### 7.1 使用 trace

```haskell
import Debug.Trace

-- 打印调试信息
factorial :: Int -> Int
factorial 0 = 1
factorial n = trace ("factorial " ++ show n) $ n * factorial (n - 1)

ghci> factorial 3
factorial 3
factorial 2
factorial 1
6

-- trace 变体
traceShow :: Show a => a -> b -> b  -- 打印任何可 Show 的值
traceShowId :: Show a => a -> a     -- 打印并返回值
traceM :: Applicative f => String -> f ()  -- Monad 中使用
```

### 7.2 GHCi 调试器

```haskell
-- 在 GHCi 中加载代码
ghci> :load MyModule.hs

-- 设置断点
ghci> :break functionName

-- 运行函数
ghci> functionName arg

-- 调试命令
:step      -- 单步执行
:continue  -- 继续执行
:list      -- 显示当前代码
:print var -- 显示变量值
:back      -- 回到上一步
:forward   -- 前进一步
:delete    -- 删除断点
```

### 7.3 类型驱动开发

```haskell
-- 用类型洞（Typed Holes）辅助开发
processData :: [Int] -> IO ()
processData xs = do
  let sorted = _  -- 类型洞
  print sorted

{-
GHC 会告诉你：
  Found hole: _ :: [Int]
  Relevant bindings:
    xs :: [Int]
-}

-- 填充类型洞
processData xs = do
  let sorted = sort xs
  print sorted
```

### 7.4 assert 和 error

```haskell
import Control.Exception (assert)

-- assert：在开发时检查不变量
safeDivide :: Int -> Int -> Int
safeDivide x y = assert (y /= 0) (x `div` y)

-- error：不应该发生的情况
head' :: [a] -> a
head' [] = error "head': empty list"  -- 文档化不应调用的情况
head' (x:_) = x

-- undefined：标记未实现的代码
factorial :: Int -> Int
factorial = undefined  -- 编译通过，运行时报错
```

---

## 8. 实战项目示例

### 8.1 项目：带错误处理的计算器

```haskell
{-# LANGUAGE DeriveAnyClass #-}
import Control.Monad.Except
import Data.Typeable

data CalcError
  = DivisionByZero
  | InvalidOperation String
  | StackUnderflow
  deriving (Show, Typeable, Exception)

type CalcM = ExceptT CalcError IO

evaluate :: String -> CalcM Int
evaluate expr = case words expr of
  [x, "+", y] -> do
    a <- parseInt x
    b <- parseInt y
    return (a + b)
  
  [x, "/", y] -> do
    a <- parseInt x
    b <- parseInt y
    when (b == 0) $ throwError DivisionByZero
    return (a `div` b)
  
  _ -> throwError $ InvalidOperation expr
  where
    parseInt s = case reads s of
      [(n, "")] -> return n
      _ -> throwError $ InvalidOperation s

main :: IO ()
main = do
  result <- runExceptT $ evaluate "10 / 2"
  case result of
    Left err -> putStrLn $ "Error: " ++ show err
    Right val -> putStrLn $ "Result: " ++ show val
```

### 8.2 完整的测试套件

```haskell
import Test.Hspec
import Test.QuickCheck

main :: IO ()
main = hspec $ do
  describe "Calculator" $ do
    describe "addition" $ do
      it "adds positive numbers" $
        evaluate "2 + 3" `shouldReturn` Right 5
      
      it "handles large numbers" $ property $
        \(Positive x) (Positive y) ->
          runExceptT (evaluate (show x ++ " + " ++ show y))
            `shouldReturn` Right (x + y)
    
    describe "division" $ do
      it "divides normally" $
        evaluate "10 / 2" `shouldReturn` Right 5
      
      it "rejects division by zero" $ do
        result <- runExceptT $ evaluate "10 / 0"
        result `shouldBe` Left DivisionByZero
```

---

## 9. 总结与最佳实践

### 9.1 错误处理最佳实践

1. **纯函数用 Either，IO 可用异常**
2. **明确错误类型**：定义清晰的错误类型
3. **尽早验证**：在边界处验证输入
4. **传播错误**：使用 Monad 自动传播
5. **提供上下文**：错误信息要详细

### 9.2 测试最佳实践

1. **测试金字塔**：
   - 大量单元测试
   - 适量集成测试
   - 少量端到端测试

2. **属性优于示例**：
   - QuickCheck 属性测试覆盖更广
   - 手写测试用例作为补充

3. **TDD 工作流**：
   - 先写测试
   - 小步迭代
   - 持续重构

4. **测试覆盖**：
   - 正常情况
   - 边界情况
   - 错误情况

### 9.3 常见错误

```haskell
-- ❌ 忽略错误
getUser id = fromJust $ lookup id db  -- 可能崩溃！

-- ✅ 处理错误
getUser id = case lookup id db of
  Nothing -> Left "User not found"
  Just user -> Right user

-- ❌ 过度使用异常
parseInt s = read s  -- 输入错误会崩溃

-- ✅ 返回 Maybe/Either
parseInt s = case reads s of
  [(n, "")] -> Just n
  _ -> Nothing
```

### 9.4 下一步

完成本周后，你已经掌握错误处理和测试！接下来：

- **Week 7**: Cardano 实践
- **Week 8**: 结课项目

继续加油！🚀

---

**练习时间**：前往 [练习作业](exercises.md) 开始实战！

