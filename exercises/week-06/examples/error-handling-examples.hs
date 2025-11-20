{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

{- |
Error Handling Examples
错误处理模式示例集合
-}

module ErrorHandlingExamples where

import Control.Monad (when)
import Control.Monad.Except
import Control.Monad.IO.Class (liftIO)
import Control.Exception
import Data.Typeable
import GHC.Generics

-- ============================================================================
-- 示例 1: Maybe 模式
-- ============================================================================

-- 安全的头部
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

-- 安全的尾部
safeTail :: [a] -> Maybe [a]
safeTail [] = Nothing
safeTail (_:xs) = Just xs

-- 链式 Maybe 操作
processFirst :: [Int] -> Maybe Int
processFirst xs = do
  first <- safeHead xs
  rest <- safeTail xs
  second <- safeHead rest
  return (first + second)

-- 使用示例
example1 :: IO ()
example1 = do
  print $ processFirst [1, 2, 3]  -- Just 3
  print $ processFirst [1]         -- Nothing
  print $ processFirst []          -- Nothing

-- ============================================================================
-- 示例 2: Either 模式
-- ============================================================================

data ParseError
  = EmptyString
  | InvalidFormat String
  | OutOfRange Int
  deriving (Show, Eq)

-- 解析用户年龄
parseUserAge :: String -> Either ParseError Int
parseUserAge "" = Left EmptyString
parseUserAge s = case reads s of
  [(age, "")] ->
    if age < 0 || age > 150
      then Left $ OutOfRange age
      else Right age
  _ -> Left $ InvalidFormat s

-- 组合 Either 操作
data User = User { name :: String, age :: Int } deriving Show

createUser :: String -> String -> Either ParseError User
createUser nameStr ageStr = do
  when (null nameStr) $ Left EmptyString
  age <- parseUserAge ageStr
  return $ User nameStr age

-- 使用示例
example2 :: IO ()
example2 = do
  print $ createUser "Alice" "30"    -- Right (User "Alice" 30)
  print $ createUser "" "30"         -- Left EmptyString
  print $ createUser "Bob" "200"     -- Left (OutOfRange 200)

-- ============================================================================
-- 示例 3: ExceptT 模式
-- ============================================================================

data AppError
  = FileError String
  | NetworkError String
  | DatabaseError String
  deriving (Show, Eq)

-- 模拟文件操作
readConfig :: FilePath -> ExceptT AppError IO String
readConfig path = do
  liftIO $ putStrLn $ "Reading " ++ path
  if path == "config.txt"
    then return "port=8080"
    else throwError $ FileError "File not found"

-- 模拟网络操作
fetchData :: String -> ExceptT AppError IO String
fetchData url = do
  liftIO $ putStrLn $ "Fetching " ++ url
  if url == "valid"
    then return "data"
    else throwError $ NetworkError "Connection failed"

-- 组合操作
processData :: ExceptT AppError IO String
processData = do
  config <- readConfig "config.txt"
  data' <- fetchData "valid"
  return $ config ++ ", " ++ data'

-- 错误恢复
processDataWithFallback :: ExceptT AppError IO String
processDataWithFallback =
  readConfig "missing.txt"
    `catchError` \_ ->
      readConfig "config.txt"

-- 使用示例
example3 :: IO ()
example3 = do
  result1 <- runExceptT processData
  print result1  -- Right "port=8080, data"
  
  result2 <- runExceptT $ readConfig "missing.txt"
  print result2  -- Left (FileError "File not found")
  
  result3 <- runExceptT processDataWithFallback
  print result3  -- Right "port=8080"

-- ============================================================================
-- 示例 4: 异常处理
-- ============================================================================

-- 自定义异常
data MyException = MyException String deriving (Show, Typeable)
instance Exception MyException

-- 安全的除法（使用异常）
divideIO :: Int -> Int -> IO Int
divideIO _ 0 = throwIO $ MyException "Division by zero"
divideIO x y = return (x `div` y)

-- 捕获异常
safeDivideIO :: Int -> Int -> IO (Either MyException Int)
safeDivideIO x y = try $ divideIO x y

-- 使用 bracket 确保资源释放
withResource :: String -> (String -> IO a) -> IO a
withResource name action = bracket
  (do putStrLn $ "Acquiring " ++ name
      return name)
  (\n -> putStrLn $ "Releasing " ++ n)
  action

-- 使用示例
example4 :: IO ()
example4 = do
  -- 正常操作
  result1 <- safeDivideIO 10 2
  print result1  -- Right 5
  
  -- 异常情况
  result2 <- safeDivideIO 10 0
  print result2  -- Left (MyException "Division by zero")
  
  -- 资源管理
  withResource "database" $ \res -> do
    putStrLn $ "Using " ++ res
    return ()

-- ============================================================================
-- 示例 5: 错误转换
-- ============================================================================

-- 将 Maybe 转换为 Either
maybeToEither :: e -> Maybe a -> Either e a
maybeToEither err Nothing = Left err
maybeToEither _ (Just x) = Right x

-- 将 Either 转换为 Maybe
eitherToMaybe :: Either e a -> Maybe a
eitherToMaybe (Left _) = Nothing
eitherToMaybe (Right x) = Just x

-- 将 ExceptT 转换为 IO Either
exceptTToIO :: ExceptT e IO a -> IO (Either e a)
exceptTToIO = runExceptT

-- 使用示例
example5 :: IO ()
example5 = do
  let m1 = Just 42 :: Maybe Int
  let m2 = Nothing :: Maybe Int
  
  print $ maybeToEither "error" m1  -- Right 42
  print $ maybeToEither "error" m2  -- Left "error"
  
  let e1 = Right 42 :: Either String Int
  let e2 = Left "error" :: Either String Int
  
  print $ eitherToMaybe e1  -- Just 42
  print $ eitherToMaybe e2  -- Nothing

-- ============================================================================
-- 主函数
-- ============================================================================

main :: IO ()
main = do
  putStrLn "=== 示例 1: Maybe 模式 ==="
  example1
  
  putStrLn "\n=== 示例 2: Either 模式 ==="
  example2
  
  putStrLn "\n=== 示例 3: ExceptT 模式 ==="
  example3
  
  putStrLn "\n=== 示例 4: 异常处理 ==="
  example4
  
  putStrLn "\n=== 示例 5: 错误转换 ==="
  example5

{-
运行说明：

1. 编译运行：
   ghc error-handling-examples.hs
   ./error-handling-examples

2. 或使用 runhaskell：
   runhaskell error-handling-examples.hs

3. 在 GHCi 中交互：
   ghci error-handling-examples.hs
   ghci> example1
   ghci> example2
-}

