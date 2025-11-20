{- |
Week 6 - 练习答案: 错误处理与测试
==================================

这是 Week06Exercises.hs 的完整参考答案
-}

{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Week06Exercises where

import Control.Monad.Except
import Control.Exception
import Data.Typeable
import qualified Data.Map as M
import Data.Map (Map)
import GHC.Generics
import System.IO
import System.Directory (doesFileExist)

-- ============================================================================
-- 练习 1: Maybe 与 Either (5 题)
-- ============================================================================

-- 1.1 安全的列表索引
safeIndex :: [a] -> Int -> Maybe a
safeIndex [] _ = Nothing
safeIndex (x:_) 0 = Just x
safeIndex (_:xs) n
  | n < 0 = Nothing
  | otherwise = safeIndex xs (n - 1)

-- 1.2 安全的除法
data DivError = DivByZero | Overflow deriving (Show, Eq)

safeDivide :: Int -> Int -> Either DivError Int
safeDivide _ 0 = Left DivByZero
safeDivide x y
  | y < 0 && x == minBound = Left Overflow
  | otherwise = Right (x `div` y)

-- 1.3 链式查询
data User = User { userId :: Int, userName :: String } deriving (Show, Eq)

getUserEmail :: Int -> Map Int User -> Map String String -> Maybe String
getUserEmail uid userDB emailDB = do
  user <- M.lookup uid userDB
  M.lookup (userName user) emailDB

-- 1.4 解析并验证年龄
parseAge :: String -> Either String Int
parseAge s = do
  age <- case reads s of
    [(n, "")] -> Right n
    _ -> Left "无效的数字"
  
  if age < 0
    then Left "年龄不能为负数"
    else if age > 150
      then Left "年龄超出范围"
      else Right age

-- 1.5 组合 Either 计算
calculateTotal :: String -> String -> Either String Double
calculateTotal priceStr qtyStr = do
  price <- parseDouble priceStr
  qty <- parseDouble qtyStr
  
  if price < 0
    then Left "价格不能为负数"
    else if qty < 0
      then Left "数量不能为负数"
      else Right (price * qty)

-- ============================================================================
-- 练习 2: ExceptT Transformer (5 题)
-- ============================================================================

data FileError 
  = FileNotFound FilePath
  | ParseError String
  | EmptyFile
  deriving (Show, Eq)

-- 2.1 读取文件（使用 ExceptT）
readFileE :: FilePath -> ExceptT FileError IO String
readFileE path = do
  exists <- liftIO $ doesFileExist path
  if exists
    then liftIO $ readFile path
    else throwError $ FileNotFound path

-- 2.2 解析文件内容
parseNumbers :: String -> ExceptT FileError IO [Int]
parseNumbers content =
  case mapM parseInt (lines content) of
    Nothing -> throwError $ ParseError "包含无效数字"
    Just nums -> return nums
  where
    parseInt s = case reads s of
      [(n, "")] -> Just n
      _ -> Nothing

-- 2.3 处理文件流水线
processNumbersFile :: FilePath -> ExceptT FileError IO Int
processNumbersFile path = do
  content <- readFileE path
  nums <- parseNumbers content
  return $ sum nums

-- 2.4 错误恢复
processWithFallback :: FilePath -> FilePath -> ExceptT FileError IO [Int]
processWithFallback primary fallback = do
  processNumbersFile primary >>= (return . (\x -> [x]))
    `catchError` \_ -> do
      content <- readFileE fallback
      parseNumbers content

-- 2.5 批量处理
processMultipleFiles :: [FilePath] -> ExceptT FileError IO [[Int]]
processMultipleFiles paths = do
  results <- forM paths $ \path ->
    (processNumbersFile path >>= return . Right)
      `catchError` \err -> return $ Left err
  
  return [nums | Right nums <- map (\r -> case r of
                                       Right n -> Right [n]
                                       Left _ -> Left ()) results]

-- ============================================================================
-- 练习 3: 异常处理 (5 题)
-- ============================================================================

-- 3.1 捕获特定异常
safeReadFile :: FilePath -> IO (Either IOException String)
safeReadFile = try . readFile

-- 3.2 带超时的操作（简化版）
withTimeout :: Int -> IO a -> IO (Maybe a)
withTimeout _seconds action = do
  result <- try action
  case result of
    Left (_ :: SomeException) -> return Nothing
    Right val -> return $ Just val

-- 3.3 资源安全操作
withFileHandle :: FilePath -> (Handle -> IO a) -> IO a
withFileHandle path = bracket
  (openFile path ReadMode)
  hClose

-- 3.4 重试机制
retryOnError :: Int -> IO a -> IO (Either SomeException a)
retryOnError 0 action = try action
retryOnError n action = do
  result <- try action
  case result of
    Left (_ :: SomeException) -> retryOnError (n - 1) action
    Right val -> return $ Right val

-- 3.5 自定义异常
data AppException 
  = NetworkError String 
  | DataError String
  deriving (Show, Typeable)

instance Exception AppException

throwNetworkError :: String -> IO a
throwNetworkError = throwIO . NetworkError

catchAppException :: IO a -> (AppException -> IO a) -> IO a
catchAppException = catch

-- ============================================================================
-- 辅助函数
-- ============================================================================

parseInt :: String -> Either String Int
parseInt s = case reads s of
  [(n, "")] -> Right n
  _ -> Left $ "无效的数字: " ++ s

parseDouble :: String -> Either String Double
parseDouble s = case reads s of
  [(n, "")] -> Right n
  _ -> Left $ "无效的数字: " ++ s

-- 测试数据
sampleUserDB :: Map Int User
sampleUserDB = M.fromList
  [ (1, User 1 "alice")
  , (2, User 2 "bob")
  , (3, User 3 "charlie")
  ]

sampleEmailDB :: Map String String
sampleEmailDB = M.fromList
  [ ("alice", "alice@example.com")
  , ("bob", "bob@example.com")
  ]

-- 测试函数
runExercise1Tests :: IO ()
runExercise1Tests = do
  putStrLn "=== 练习 1 测试 ==="
  
  putStrLn "\n1.1 safeIndex:"
  print $ safeIndex [1,2,3] 1
  print $ safeIndex [1,2,3] 5
  
  putStrLn "\n1.2 safeDivide:"
  print $ safeDivide 10 2
  print $ safeDivide 10 0
  
  putStrLn "\n1.3 getUserEmail:"
  print $ getUserEmail 1 sampleUserDB sampleEmailDB
  print $ getUserEmail 3 sampleUserDB sampleEmailDB
  
  putStrLn "\n1.4 parseAge:"
  print $ parseAge "25"
  print $ parseAge "abc"
  print $ parseAge "200"
  
  putStrLn "\n1.5 calculateTotal:"
  print $ calculateTotal "10.5" "3"
  print $ calculateTotal "abc" "3"

runAllTests :: IO ()
runAllTests = do
  runExercise1Tests
  putStrLn "\n所有测试完成！"

