{- |
Week 4 - 练习作业: Monad 与 IO
================================

本文件包含 34 道练习题，涵盖 Monad 深入、IO 操作、文件处理。

如何使用：
1. 完成每个标记为 TODO 的函数
2. 在 GHCi 中测试：ghci> :load Week04Exercises.hs
3. 对于 IO 函数，在 GHCi 中直接运行
4. 完成后对照 solutions/ 中的参考答案

提示：
- Monad 练习先理解类型签名
- IO 练习在 GHCi 中实际运行测试
- 文件操作注意创建测试文件
- 综合项目可以分步实现
-}

module Week04Exercises where

import Control.Monad (guard, when)
import Data.List (isPrefixOf, sortBy, group, sort)
import Data.Ord (comparing)
import System.IO (hFlush, stdout)
import qualified Data.Map as M

-- ============================================================================
-- 练习 1: Monad 基础（5 题）
-- ============================================================================

{- | 1.1 使用 >>= 链接 Maybe 操作

实现一个函数，接受 Maybe Int，给它加 10，再乘以 2，最后检查是否大于 30。
使用 >>= 运算符，不要用 do-notation。

示例：
  chainOps (Just 5)  应该返回 Just 30   -- (5+10)*2 = 30
  chainOps (Just 20) 应该返回 Just 60   -- (20+10)*2 = 60
  chainOps Nothing   应该返回 Nothing
-}
chainOps :: Maybe Int -> Maybe Int
chainOps mx = undefined  -- TODO


{- | 1.2 do-notation 转 >>= 

将下面的 do-notation 代码转换为使用 >>= 的版本：

addThree :: Maybe Int -> Maybe Int
addThree mx = do
  x <- mx
  let y = x + 1
  let z = y + 1
  return (z + 1)

实现等价的 addThreeBind 函数。
-}
addThreeBind :: Maybe Int -> Maybe Int
addThreeBind mx = undefined  -- TODO


{- | 1.3 实现 sequenceMaybe

将一个 [Maybe a] 转换为 Maybe [a]。
如果列表中有任何 Nothing，结果为 Nothing；
否则提取所有 Just 的值，返回 Just [values]。

示例：
  sequenceMaybe [Just 1, Just 2, Just 3] 应该返回 Just [1,2,3]
  sequenceMaybe [Just 1, Nothing, Just 3] 应该返回 Nothing
  sequenceMaybe [] 应该返回 Just []
-}
sequenceMaybe :: [Maybe a] -> Maybe [a]
sequenceMaybe = undefined  -- TODO


{- | 1.4 mapMaybe 实现

类似 map，但函数返回 Maybe。
使用 sequenceMaybe 和 map 实现。

示例：
  mapMaybe (\x -> if x > 0 then Just (x*2) else Nothing) [1,2,3]
    应该返回 Just [2,4,6]
  mapMaybe (\x -> if x > 0 then Just (x*2) else Nothing) [1,-2,3]
    应该返回 Nothing
-}
mapMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
mapMaybe f xs = undefined  -- TODO


{- | 1.5 filterMaybe 实现

过滤列表，但条件函数返回 Maybe Bool。
Nothing 和 Just False 都表示过滤掉，只有 Just True 保留。

示例：
  filterMaybe (\x -> Just (x > 0)) [1,-2,3,-4]
    应该返回 Just [1,3]
  filterMaybe (\x -> if x /= 0 then Just (x > 0) else Nothing) [1,-2,0,3]
    应该返回 Nothing
-}
filterMaybe :: (a -> Maybe Bool) -> [a] -> Maybe [a]
filterMaybe f xs = undefined  -- TODO


{- | 1.6 验证 Monad 左单位元定律

Monad 左单位元定律: return a >>= f  ≡  f a

定义一个简单的包装类型 Identity 和它的 Monad 实例，
然后编写函数验证左单位元定律。

示例：
  let f x = Identity (x * 2)
  verifyLeftIdentity 5 f 应该返回 True
-}
data Identity a = Identity a
  deriving (Show, Eq)

instance Functor Identity where
  fmap f (Identity x) = Identity (f x)

instance Applicative Identity where
  pure = Identity
  Identity f <*> Identity x = Identity (f x)

instance Monad Identity where
  return = Identity
  Identity x >>= f = f x

-- 验证左单位元定律
verifyLeftIdentity :: (Eq b, Show b) => a -> (a -> Identity b) -> Bool
verifyLeftIdentity a f = undefined  -- TODO
-- 提示：比较 (return a >>= f) 和 (f a) 是否相等


{- | 1.7 验证 Monad 右单位元定律

Monad 右单位元定律: m >>= return  ≡  m

编写函数验证右单位元定律。

示例：
  verifyRightIdentity (Identity 42) 应该返回 True
-}
verifyRightIdentity :: Eq a => Identity a -> Bool
verifyRightIdentity m = undefined  -- TODO
-- 提示：比较 (m >>= return) 和 m 是否相等


{- | 1.8 验证 Monad 结合律

Monad 结合律: (m >>= f) >>= g  ≡  m >>= (\x -> f x >>= g)

编写函数验证结合律。

示例：
  let f x = Identity (x + 1)
      g x = Identity (x * 2)
  verifyAssociativity (Identity 5) f g 应该返回 True
-}
verifyAssociativity :: (Eq c, Show c) 
                    => Identity a 
                    -> (a -> Identity b) 
                    -> (b -> Identity c) 
                    -> Bool
verifyAssociativity m f g = undefined  -- TODO
-- 提示：比较 ((m >>= f) >>= g) 和 (m >>= (\x -> f x >>= g)) 是否相等


-- ============================================================================
-- 练习 2: Maybe Monad 实战（5 题）
-- ============================================================================

{- | 2.1 安全的数学运算

实现安全的除法和平方根：
- safeDivide: 除数为 0 返回 Nothing
- safeSqrt: 负数返回 Nothing
-}
safeDivide :: Double -> Double -> Maybe Double
safeDivide x y = undefined  -- TODO

safeSqrt :: Double -> Maybe Double
safeSqrt x = undefined  -- TODO

{- | 2.2 组合安全运算

计算 sqrt(x / y)，使用 safeDivide 和 safeSqrt。

示例：
  safeCompute 16 4 应该返回 Just 2.0    -- sqrt(16/4) = sqrt(4) = 2
  safeCompute 9 0  应该返回 Nothing     -- 除以零
  safeCompute (-4) 2 应该返回 Nothing   -- 负数平方根
-}
safeCompute :: Double -> Double -> Maybe Double
safeCompute x y = undefined  -- TODO


{- | 2.3 字典查询

从字典（关联列表）中查询两个键，返回它们的和。

示例：
  let dict = [("a", 10), ("b", 20), ("c", 30)]
  lookupAndAdd "a" "b" dict 应该返回 Just 30
  lookupAndAdd "a" "x" dict 应该返回 Nothing
-}
type Dict = [(String, Int)]

lookupAndAdd :: String -> String -> Dict -> Maybe Int
lookupAndAdd key1 key2 dict = undefined  -- TODO


{- | 2.4 验证用户输入

解析姓名和年龄，创建 User 对象。
- 姓名不能为空
- 年龄必须是有效数字且 >= 0

示例：
  validateUser "Alice" "25" 应该返回 Just (User "Alice" 25)
  validateUser "" "25" 应该返回 Nothing
  validateUser "Bob" "invalid" 应该返回 Nothing
  validateUser "Charlie" "-5" 应该返回 Nothing
-}
data User = User { name :: String, age :: Int }
  deriving (Show, Eq)

validateUser :: String -> String -> Maybe User
validateUser nameStr ageStr = undefined  -- TODO


{- | 2.5 链式查询

在嵌套字典中查询值。
第一层字典：用户名 -> 用户信息字典
第二层字典：属性名 -> 属性值

示例：
  let users = [("alice", [("age", 25), ("score", 100)])]
  nestedLookup "alice" "age" users 应该返回 Just 25
  nestedLookup "bob" "age" users 应该返回 Nothing
-}
type NestedDict = [(String, [(String, Int)])]

nestedLookup :: String -> String -> NestedDict -> Maybe Int
nestedLookup user attr dict = undefined  -- TODO


-- ============================================================================
-- 练习 3: Either Monad 错误处理（5 题）
-- ============================================================================

{- | 3.1 定义错误类型和安全运算

定义 MathError 类型表示数学错误。
实现带错误信息的安全运算。
-}
data MathError = DivByZero | NegativeLog | NegativeSqrt | Overflow
  deriving (Show, Eq)

safeDivideE :: Double -> Double -> Either MathError Double
safeDivideE x y = undefined  -- TODO

safeLogE :: Double -> Either MathError Double
safeLogE x = undefined  -- TODO

safeSqrtE :: Double -> Either MathError Double
safeSqrtE x = undefined  -- TODO


{- | 3.2 组合 Either 运算

计算 log(sqrt(x / y))

示例：
  calculate 100 4 应该返回 Right 1.609...  -- log(sqrt(25)) = log(5)
  calculate 16 0  应该返回 Left DivByZero
  calculate (-4) 2 应该返回 Left NegativeSqrt
  calculate 4 16  应该返回 Left NegativeLog  -- sqrt(0.25) < 1
-}
calculate :: Double -> Double -> Either MathError Double
calculate x y = undefined  -- TODO


{- | 3.3 解析和验证

解析字符串为年龄（整数），并验证范围。
-}
data ParseError = EmptyString | InvalidFormat | OutOfRange
  deriving (Show, Eq)

parseAge :: String -> Either ParseError Int
parseAge str = undefined  -- TODO: 0-150 有效


{- | 3.4 批量验证

验证一组用户输入，返回所有错误或所有成功的值。

示例：
  validateAll ["25", "30", "40"] 应该返回 Right [25,30,40]
  validateAll ["25", "invalid", "40"] 应该返回 Left InvalidFormat
-}
validateAll :: [String] -> Either ParseError [Int]
validateAll strs = undefined  -- TODO


{- | 3.5 Either 转 Maybe

将 Either 转换为 Maybe，丢弃错误信息。
-}
eitherToMaybe :: Either e a -> Maybe a
eitherToMaybe = undefined  -- TODO


-- ============================================================================
-- 练习 4: List Monad（4 题）
-- ============================================================================

{- | 4.1 所有可能的配对

使用 do-notation 生成所有可能的配对。

示例：
  pairs [1,2] [3,4] 应该返回 [(1,3),(1,4),(2,3),(2,4)]
-}
pairs :: [a] -> [b] -> [(a, b)]
pairs xs ys = undefined  -- TODO


{- | 4.2 生成三元组

生成所有可能的三元组，但过滤掉有重复元素的。

示例：
  uniqueTriples [1,2,3] 应该包含 (1,2,3), (1,3,2), (2,1,3) 等
  不应该包含 (1,1,2), (2,2,3) 等
-}
uniqueTriples :: Eq a => [a] -> [(a, a, a)]
uniqueTriples xs = undefined  -- TODO


{- | 4.3 毕达哥拉斯三元组

找出所有满足 a^2 + b^2 = c^2 的三元组，其中 a, b, c <= n。

示例：
  pythagorean 15 应该包含 (3,4,5), (5,12,13), (6,8,10) 等
-}
pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n = undefined  -- TODO


{- | 4.4 国际象棋骑士移动

给定骑士的位置，返回所有有效的下一步位置（在 8x8 棋盘内）。
骑士走"日"字：横竖各 2+1 或 1+2。

示例：
  moveKnight (5,5) 应该返回 8 个位置
  moveKnight (1,1) 应该返回 2 个位置（边角位置）
-}
type Position = (Int, Int)

moveKnight :: Position -> [Position]
moveKnight (x, y) = undefined  -- TODO


-- ============================================================================
-- 练习 5: IO 基础（6 题）
-- ============================================================================

{- | 5.1 问候用户

询问用户姓名并问候。
提示：使用 putStrLn, getLine
-}
greetUser :: IO ()
greetUser = undefined  -- TODO


{- | 5.2 简单计算器

读取两个数字和一个运算符（+, -, *, /），计算并输出结果。
-}
simpleCalculator :: IO ()
simpleCalculator = undefined  -- TODO


{- | 5.3 重复操作 n 次

执行一个 IO 操作 n 次。
提示：可以用递归或 replicateM_
-}
repeatAction :: Int -> IO () -> IO ()
repeatAction n action = undefined  -- TODO


{- | 5.4 读取 n 行输入

读取 n 行用户输入，返回字符串列表。
-}
readLines :: Int -> IO [String]
readLines n = undefined  -- TODO


{- | 5.5 交互式菜单

显示选项列表，让用户选择，返回选择的索引（从 1 开始）。
-}
showMenu :: [String] -> IO Int
showMenu options = undefined  -- TODO


{- | 5.6 猜数字游戏（简化版）

给定一个秘密数字，让用户猜测，提示"太大"或"太小"，直到猜对。
提示：可以使用递归
-}
guessNumber :: Int -> IO ()
guessNumber secret = undefined  -- TODO


-- ============================================================================
-- 练习 6: 文件操作（6 题）
-- ============================================================================

{- | 6.1 统计文件行数

读取文件并返回行数。
-}
countFileLines :: FilePath -> IO Int
countFileLines path = undefined  -- TODO


{- | 6.2 查找并替换

读取文件，将所有 old 字符串替换为 new，写入原文件。
注意：要先读完整个文件再写入！
-}
replaceInFile :: FilePath -> String -> String -> IO ()
replaceInFile path old new = undefined  -- TODO


{- | 6.3 文件内容反转

读取文件的所有行，反转顺序，写入新文件。

示例：
  input.txt:   output.txt:
    Line 1       Line 3
    Line 2       Line 2
    Line 3       Line 1
-}
reverseFile :: FilePath -> FilePath -> IO ()
reverseFile inputPath outputPath = undefined  -- TODO


{- | 6.4 合并多个文件

将多个文件的内容合并到一个文件中。
-}
mergeFiles :: [FilePath] -> FilePath -> IO ()
mergeFiles inputs output = undefined  -- TODO


{- | 6.5 统计单词频率

读取文件，统计每个单词出现的次数，输出前 n 个最常见的单词。
提示：使用 Map 统计
-}
topWords :: FilePath -> Int -> IO [(String, Int)]
topWords path n = undefined  -- TODO


{- | 6.6 简单日志系统

向日志文件追加一条消息（带时间戳）。
注意：使用 appendFile
提示：可以简化为只加日期，不需要真实时间戳
-}
appendLog :: FilePath -> String -> IO ()
appendLog logFile message = undefined  -- TODO


-- ============================================================================
-- 练习 7: 综合项目（3 个小项目）
-- ============================================================================

{- | 项目 1: TODO 清单 CLI

实现一个命令行 TODO 应用，支持以下功能：
1. 列出所有 TODO
2. 添加 TODO
3. 删除 TODO（按索引）
4. 标记完成
5. 退出

数据结构：
-}
data Todo = Todo { task :: String, done :: Bool }
  deriving (Show, Read, Eq)

-- 1.1 加载 TODO 列表
loadTodos :: FilePath -> IO [Todo]
loadTodos path = undefined  -- TODO
{- 提示：
1. 使用 readFile 读取文件内容
2. 使用 read 将字符串解析为 [Todo]
3. 如果文件不存在，返回空列表

⚠️ 注意：
简化版可以假设文件总是存在（或使用空文件）。
完整版需要检查文件存在性：
  - 使用 System.Directory.doesFileExist
  - 或使用 Control.Exception.try 处理 IOException
-}

-- 1.2 保存 TODO 列表
saveTodos :: FilePath -> [Todo] -> IO ()
saveTodos path todos = undefined  -- TODO

-- 1.3 添加 TODO
addTodo :: FilePath -> String -> IO ()
addTodo path taskName = undefined  -- TODO

-- 1.4 列出所有 TODO
listTodos :: FilePath -> IO ()
listTodos path = undefined  -- TODO

-- 1.5 删除 TODO
removeTodo :: FilePath -> Int -> IO ()
removeTodo path index = undefined  -- TODO

-- 1.6 标记完成
toggleTodo :: FilePath -> Int -> IO ()
toggleTodo path index = undefined  -- TODO

-- 1.7 主循环
todoMainLoop :: FilePath -> IO ()
todoMainLoop path = undefined  -- TODO


{- | 项目 2: 文本文件分析器

分析文本文件，输出统计信息。
-}
data FileStats = FileStats
  { charCount :: Int
  , wordCount :: Int
  , lineCount :: Int
  , avgWordLength :: Double
  } deriving (Show, Eq)

-- 2.1 分析文件
analyzeFile :: FilePath -> IO FileStats
analyzeFile path = undefined  -- TODO

-- 2.2 显示统计信息
displayStats :: FileStats -> IO ()
displayStats stats = undefined  -- TODO

-- 2.3 比较两个文件
compareFiles :: FilePath -> FilePath -> IO ()
compareFiles path1 path2 = undefined  -- TODO


{- | 项目 3: 交互式文件浏览器

简单的文件浏览器。
提示：需要 System.Directory 模块
-}

-- 3.1 列出目录内容
-- browseDirectory :: FilePath -> IO ()
-- browseDirectory path = undefined  -- TODO

-- 3.2 显示文件内容（前 20 行）
showFileContent :: FilePath -> IO ()
showFileContent path = undefined  -- TODO

-- 3.3 在目录中搜索文件名
-- searchFiles :: FilePath -> String -> IO [FilePath]
-- searchFiles dir pattern = undefined  -- TODO


-- ============================================================================
-- 测试辅助函数
-- ============================================================================

-- 测试 Maybe 函数
testMaybe :: (Show a, Eq a) => String -> Maybe a -> Maybe a -> IO ()
testMaybe name expected actual =
  if expected == actual
    then putStrLn $ "✓ " ++ name
    else putStrLn $ "✗ " ++ name ++ ": expected " ++ show expected 
                    ++ ", got " ++ show actual

-- 测试 Either 函数
testEither :: (Show a, Eq a, Show e, Eq e) 
           => String -> Either e a -> Either e a -> IO ()
testEither name expected actual =
  if expected == actual
    then putStrLn $ "✓ " ++ name
    else putStrLn $ "✗ " ++ name ++ ": expected " ++ show expected 
                    ++ ", got " ++ show actual

-- 运行所有测试
runTests :: IO ()
runTests = do
  putStrLn "=== Running Tests ==="
  putStrLn "\n--- Monad Basics ---"
  testMaybe "chainOps (Just 5)" (Just 30) (chainOps (Just 5))
  testMaybe "chainOps Nothing" Nothing (chainOps Nothing)
  
  putStrLn "\n--- Maybe Operations ---"
  testMaybe "safeDivide 10 2" (Just 5.0) (safeDivide 10 2)
  testMaybe "safeDivide 10 0" Nothing (safeDivide 10 0)
  testMaybe "safeSqrt 16" (Just 4.0) (safeSqrt 16)
  testMaybe "safeSqrt (-4)" Nothing (safeSqrt (-4))
  
  putStrLn "\n--- Either Operations ---"
  testEither "safeDivideE 10 2" (Right 5.0) (safeDivideE 10 2)
  testEither "safeDivideE 10 0" (Left DivByZero) (safeDivideE 10 0)
  
  putStrLn "\n--- List Monad ---"
  print $ pairs [1,2] [3,4]
  print $ pythagorean 15
  
  putStrLn "\nTests complete!"


{-
使用说明：
1. 完成函数后，在 GHCi 中加载：
   ghci> :load Week04Exercises.hs

2. 测试 Monad/Maybe/Either 函数：
   ghci> runTests

3. 测试 IO 函数：
   ghci> greetUser
   ghci> simpleCalculator

4. 测试文件操作（先创建测试文件）：
   ghci> writeFile "test.txt" "Line 1\nLine 2\nLine 3"
   ghci> countFileLines "test.txt"
   ghci> reverseFile "test.txt" "reversed.txt"

5. 运行 TODO 应用：
   ghci> todoMainLoop "todos.txt"

祝学习愉快！
-}

