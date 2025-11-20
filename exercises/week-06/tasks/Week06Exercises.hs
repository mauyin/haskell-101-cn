{- |
Week 6 - 练习: 错误处理与测试
================================

本练习涵盖：
- Maybe 和 Either 错误处理
- ExceptT Monad Transformer
- 异常处理
- 测试基础

如何使用：
1. 完成每个 TODO
2. 在 GHCi 中测试：ghci> :load Week06Exercises.hs
3. 对照 solutions/ 中的参考答案
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

-- ============================================================================
-- 练习 1: Maybe 与 Either (5 题)
-- ============================================================================

-- 1.1 TODO: 安全的列表索引
-- |
-- 返回列表中指定索引的元素，如果索引越界返回 Nothing
--
-- 示例:
--   safeIndex [1,2,3] 1 == Just 2
--   safeIndex [1,2,3] 5 == Nothing
safeIndex :: [a] -> Int -> Maybe a
safeIndex = undefined
-- 提示: 使用模式匹配和递归


-- 1.2 TODO: 安全的除法（返回 Either）
-- |
-- 定义错误类型并实现安全除法
data DivError = DivByZero | DivOverflow deriving (Show, Eq)

safeDivide :: Int -> Int -> Either DivError Int
safeDivide = undefined
-- 提示: 检查除数是否为 0，以及是否可能溢出


-- 1.3 TODO: 链式查询（Maybe Monad）
-- |
-- 查询用户的邮箱地址
-- 1. 根据用户 ID 查找用户名
-- 2. 根据用户名查找邮箱
data User = User { userId :: Int, userName :: String } deriving (Show, Eq)

getUserEmail :: Int -> Map Int User -> Map String String -> Maybe String
getUserEmail uid userDB emailDB = undefined
-- 提示: 使用 do-notation 或 >>= 链接查询


-- 1.4 TODO: 解析并验证年龄
-- |
-- 解析字符串为年龄，验证范围 0-150
--
-- 示例:
--   parseAge "25" == Right 25
--   parseAge "abc" == Left "无效的数字"
--   parseAge "200" == Left "年龄超出范围"
parseAge :: String -> Either String Int
parseAge = undefined
-- 提示: 使用 reads 解析，然后验证范围


-- 1.5 TODO: 组合 Either 计算
-- |
-- 解析价格和数量，计算总价
--
-- 示例:
--   calculateTotal "10.5" "3" == Right 31.5
--   calculateTotal "abc" "3" == Left "无效的价格"
calculateTotal :: String -> String -> Either String Double
calculateTotal priceStr qtyStr = undefined
-- 提示: 解析两个字符串，然后相乘


-- ============================================================================
-- 练习 2: ExceptT Transformer (5 题)
-- ============================================================================

data FileError 
  = FileNotFound FilePath
  | ParseError String
  | EmptyFile
  deriving (Show, Eq)

-- 2.1 TODO: 读取文件（使用 ExceptT）
-- |
-- 检查文件是否存在，然后读取
-- 如果文件不存在，抛出 FileNotFound 错误
readFileE :: FilePath -> ExceptT FileError IO String
readFileE path = undefined
-- 提示: 使用 liftIO 提升 IO 操作，使用 throwError 抛出错误


-- 2.2 TODO: 解析文件内容
-- |
-- 将文件内容每行解析为整数
-- 如果有任何行无法解析，抛出 ParseError
parseNumbers :: String -> ExceptT FileError IO [Int]
parseNumbers content = undefined
-- 提示: 使用 lines 分割，mapM 解析每行


-- 2.3 TODO: 处理文件流水线
-- |
-- 读取文件 -> 解析为数字 -> 计算总和
processNumbersFile :: FilePath -> ExceptT FileError IO Int
processNumbersFile path = undefined
-- 提示: 使用 do-notation 组合 readFileE 和 parseNumbers


-- 2.4 TODO: 错误恢复
-- |
-- 尝试读取主文件，失败则读取备用文件
processWithFallback :: FilePath -> FilePath -> ExceptT FileError IO [Int]
processWithFallback primary fallback = undefined
-- 提示: 使用 catchError


-- 2.5 TODO: 批量处理
-- |
-- 处理多个文件，收集所有成功的结果
-- 遇到错误继续处理其他文件
processMultipleFiles :: [FilePath] -> ExceptT FileError IO [[Int]]
processMultipleFiles paths = undefined
-- 提示: 使用 mapM 或 forM，对每个文件用 catchError


-- ============================================================================
-- 练习 3: 异常处理 (5 题)
-- ============================================================================

-- 3.1 TODO: 捕获特定异常
-- |
-- 安全地读取文件，捕获 IOException
safeReadFile :: FilePath -> IO (Either IOException String)
safeReadFile path = undefined
-- 提示: 使用 Control.Exception.try


-- 3.2 TODO: 带超时的操作
-- |
-- 在指定秒数内完成操作，否则返回 Nothing
-- 
-- 注意: 这题较难，可以先返回 undefined 跳过
withTimeout :: Int -> IO a -> IO (Maybe a)
withTimeout seconds action = undefined
-- 提示: 可以使用 System.Timeout.timeout


-- 3.3 TODO: 资源安全操作
-- |
-- 使用 bracket 确保文件句柄被正确关闭
withFileHandle :: FilePath -> (Handle -> IO a) -> IO a
withFileHandle path action = undefined
-- 提示: 使用 bracket openFile hClose


-- 3.4 TODO: 重试机制
-- |
-- 尝试执行操作，失败则重试，最多重试 maxRetries 次
retryOnError :: Int -> IO a -> IO (Either SomeException a)
retryOnError maxRetries action = undefined
-- 提示: 递归调用，捕获异常


-- 3.5 TODO: 自定义异常
-- |
-- 定义并使用自定义异常类型
data AppException 
  = NetworkError String 
  | DataError String
  deriving (Show, Typeable)

instance Exception AppException

-- 抛出网络错误
throwNetworkError :: String -> IO a
throwNetworkError msg = undefined
-- 提示: 使用 throwIO

-- 捕获应用异常
catchAppException :: IO a -> (AppException -> IO a) -> IO a
catchAppException = undefined
-- 提示: 使用 Control.Exception.catch


-- ============================================================================
-- 辅助函数和测试数据
-- ============================================================================

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

-- 辅助：解析整数
parseInt :: String -> Either String Int
parseInt s = case reads s of
  [(n, "")] -> Right n
  _ -> Left $ "无效的数字: " ++ s

-- 辅助：解析浮点数
parseDouble :: String -> Either String Double
parseDouble s = case reads s of
  [(n, "")] -> Right n
  _ -> Left $ "无效的数字: " ++ s

-- 测试函数
runExercise1Tests :: IO ()
runExercise1Tests = do
  putStrLn "=== 练习 1 测试 ==="
  
  -- 测试 1.1
  putStrLn "\n1.1 safeIndex:"
  print $ safeIndex [1,2,3] 1  -- 应该是 Just 2
  print $ safeIndex [1,2,3] 5  -- 应该是 Nothing
  
  -- 测试 1.2
  putStrLn "\n1.2 safeDivide:"
  print $ safeDivide 10 2   -- 应该是 Right 5
  print $ safeDivide 10 0   -- 应该是 Left DivByZero
  
  -- 测试 1.3
  putStrLn "\n1.3 getUserEmail:"
  print $ getUserEmail 1 sampleUserDB sampleEmailDB  -- 应该是 Just "alice@example.com"
  print $ getUserEmail 3 sampleUserDB sampleEmailDB  -- 应该是 Nothing
  
  -- 测试 1.4
  putStrLn "\n1.4 parseAge:"
  print $ parseAge "25"   -- 应该是 Right 25
  print $ parseAge "abc"  -- 应该是 Left ...
  print $ parseAge "200"  -- 应该是 Left ...
  
  -- 测试 1.5
  putStrLn "\n1.5 calculateTotal:"
  print $ calculateTotal "10.5" "3"  -- 应该是 Right 31.5
  print $ calculateTotal "abc" "3"   -- 应该是 Left ...

runExercise2Tests :: IO ()
runExercise2Tests = do
  putStrLn "\n=== 练习 2 测试 ==="
  putStrLn "注意：这些测试需要实际文件"
  putStrLn "创建 numbers.txt 文件，内容如下："
  putStrLn "1"
  putStrLn "2"
  putStrLn "3"
  putStrLn ""
  putStrLn "然后运行："
  putStrLn "runExceptT $ processNumbersFile \"numbers.txt\""

runAllTests :: IO ()
runAllTests = do
  runExercise1Tests
  runExercise2Tests
  putStrLn "\n所有测试完成！"

{-
在 GHCi 中测试：

ghci> :load Week06Exercises.hs
ghci> runAllTests

单独测试某个函数：
ghci> safeIndex [1,2,3] 1
ghci> safeDivide 10 2
ghci> parseAge "25"

测试 ExceptT：
ghci> result <- runExceptT $ processNumbersFile "numbers.txt"
ghci> print result

记得完成所有 TODO！
-}

