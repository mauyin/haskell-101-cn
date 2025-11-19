{-
  Week 4: Monad 与 IO 练习 - 参考答案
  
  这是所有练习的完整解答。
  建议先独立完成练习，再查看答案。
-}

module Week04Exercises where

import Control.Monad (guard, when, replicateM_)
import Data.List (isPrefixOf, sortBy, group, sort, isInfixOf)
import Data.Ord (comparing)
import System.IO (hFlush, stdout)
import qualified Data.Map.Strict as M
import Data.Char (ord, chr)
import Data.Bits (xor)

{- ============================================
   练习 1: Monad 基础 (5 题)
   ============================================ -}

-- 1.1 使用 >>= 链接 Maybe 操作
chainOps :: Maybe Int -> Maybe Int
chainOps mx = mx >>= (\x -> Just (x + 10)) >>= (\y -> Just (y * 2))

-- 1.2 do-notation 转 >>=
addThreeBind :: Maybe Int -> Maybe Int
addThreeBind mx = mx >>= (\x -> 
  let y = x + 1 in
  let z = y + 1 in
  return (z + 1))

-- 1.3 实现 sequenceMaybe
sequenceMaybe :: [Maybe a] -> Maybe [a]
sequenceMaybe [] = Just []
sequenceMaybe (Nothing:_) = Nothing
sequenceMaybe (Just x:xs) = do
  rest <- sequenceMaybe xs
  return (x : rest)

-- 或者使用 foldr:
-- sequenceMaybe = foldr (\mx macc -> do
--   x <- mx
--   acc <- macc
--   return (x : acc)) (Just [])

-- 1.4 mapMaybe 实现
mapMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
mapMaybe f xs = sequenceMaybe (map f xs)

-- 1.5 filterMaybe 实现
filterMaybe :: (a -> Maybe Bool) -> [a] -> Maybe [a]
filterMaybe f [] = Just []
filterMaybe f (x:xs) = do
  keep <- f x
  rest <- filterMaybe f xs
  if keep
    then return (x : rest)
    else return rest


{- ============================================
   练习 2: Maybe Monad 实战 (5 题)
   ============================================ -}

-- 2.1 安全的数学运算
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

safeSqrt :: Double -> Maybe Double
safeSqrt x
  | x < 0     = Nothing
  | otherwise = Just (sqrt x)

-- 2.2 组合安全运算
safeCompute :: Double -> Double -> Maybe Double
safeCompute x y = do
  quotient <- safeDivide x y
  safeSqrt quotient

-- 或者用 >>=:
-- safeCompute x y = safeDivide x y >>= safeSqrt

-- 2.3 字典查询
type Dict = [(String, Int)]

lookupAndAdd :: String -> String -> Dict -> Maybe Int
lookupAndAdd key1 key2 dict = do
  val1 <- lookup key1 dict
  val2 <- lookup key2 dict
  return (val1 + val2)

-- 2.4 验证用户输入
data User = User { name :: String, age :: Int }
  deriving (Show, Eq)

validateUser :: String -> String -> Maybe User
validateUser nameStr ageStr = do
  -- 验证姓名不为空
  guard (not (null nameStr))
  
  -- 解析年龄
  ageVal <- parseIntMaybe ageStr
  
  -- 验证年龄非负
  guard (ageVal >= 0)
  
  return (User nameStr ageVal)
  where
    parseIntMaybe :: String -> Maybe Int
    parseIntMaybe s = case reads s of
      [(val, "")] -> Just val
      _ -> Nothing

-- 2.5 链式查询
type NestedDict = [(String, [(String, Int)])]

nestedLookup :: String -> String -> NestedDict -> Maybe Int
nestedLookup user attr dict = do
  userDict <- lookup user dict
  lookup attr userDict


{- ============================================
   练习 3: Either Monad 错误处理 (5 题)
   ============================================ -}

-- 3.1 定义错误类型和安全运算
data MathError = DivByZero | NegativeLog | NegativeSqrt | Overflow
  deriving (Show, Eq)

safeDivideE :: Double -> Double -> Either MathError Double
safeDivideE _ 0 = Left DivByZero
safeDivideE x y = Right (x / y)

safeLogE :: Double -> Either MathError Double
safeLogE x
  | x <= 0    = Left NegativeLog
  | otherwise = Right (log x)

safeSqrtE :: Double -> Either MathError Double
safeSqrtE x
  | x < 0     = Left NegativeSqrt
  | otherwise = Right (sqrt x)

-- 3.2 组合 Either 运算
calculate :: Double -> Double -> Either MathError Double
calculate x y = do
  quotient <- safeDivideE x y
  sqrtVal <- safeSqrtE quotient
  safeLogE sqrtVal

-- 3.3 解析和验证
data ParseError = EmptyString | InvalidFormat | OutOfRange
  deriving (Show, Eq)

parseAge :: String -> Either ParseError Int
parseAge str
  | null str = Left EmptyString
  | otherwise = case reads str of
      [(val, "")] -> 
        if val >= 0 && val <= 150
          then Right val
          else Left OutOfRange
      _ -> Left InvalidFormat

-- 3.4 批量验证
validateAll :: [String] -> Either ParseError [Int]
validateAll [] = Right []
validateAll (s:ss) = do
  val <- parseAge s
  rest <- validateAll ss
  return (val : rest)

-- 或者使用 mapM:
-- validateAll strs = mapM parseAge strs

-- 3.5 Either 转 Maybe
eitherToMaybe :: Either e a -> Maybe a
eitherToMaybe (Left _) = Nothing
eitherToMaybe (Right x) = Just x


{- ============================================
   练习 4: List Monad (4 题)
   ============================================ -}

-- 4.1 所有可能的配对
pairs :: [a] -> [b] -> [(a, b)]
pairs xs ys = do
  x <- xs
  y <- ys
  return (x, y)

-- 或者用列表推导式:
-- pairs xs ys = [(x, y) | x <- xs, y <- ys]

-- 4.2 生成三元组
uniqueTriples :: Eq a => [a] -> [(a, a, a)]
uniqueTriples xs = do
  x <- xs
  y <- xs
  z <- xs
  guard (x /= y && y /= z && x /= z)
  return (x, y, z)

-- 4.3 毕达哥拉斯三元组
pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n = do
  a <- [1..n]
  b <- [a..n]  -- b >= a 避免重复
  c <- [b..n]  -- c >= b
  guard (a*a + b*b == c*c)
  return (a, b, c)

-- 4.4 国际象棋骑士移动
type Position = (Int, Int)

moveKnight :: Position -> [Position]
moveKnight (x, y) = do
  (dx, dy) <- [(2,1), (2,-1), (-2,1), (-2,-1),
               (1,2), (1,-2), (-1,2), (-1,-2)]
  let newPos = (x + dx, y + dy)
  guard (onBoard newPos)
  return newPos
  where
    onBoard (x, y) = x >= 1 && x <= 8 && y >= 1 && y <= 8


{- ============================================
   练习 5: IO 基础 (6 题)
   ============================================ -}

-- 5.1 问候用户
greetUser :: IO ()
greetUser = do
  putStrLn "What's your name?"
  name <- getLine
  putStrLn ("Hello, " ++ name ++ "!")

-- 5.2 简单计算器
simpleCalculator :: IO ()
simpleCalculator = do
  putStrLn "Enter first number:"
  num1 <- readLN :: IO Double
  
  putStrLn "Enter operator (+, -, *, /):"
  op <- getLine
  
  putStrLn "Enter second number:"
  num2 <- readLN :: IO Double
  
  let result = case op of
        "+" -> num1 + num2
        "-" -> num1 - num2
        "*" -> num1 * num2
        "/" -> num1 / num2
        _   -> error "Invalid operator"
  
  putStrLn ("Result: " ++ show result)
  where
    readLN :: Read a => IO a
    readLN = fmap read getLine

-- 5.3 重复操作 n 次
repeatAction :: Int -> IO () -> IO ()
repeatAction 0 _ = return ()
repeatAction n action = do
  action
  repeatAction (n - 1) action

-- 或者使用 replicateM_:
-- repeatAction n action = replicateM_ n action

-- 5.4 读取 n 行输入
readLines :: Int -> IO [String]
readLines 0 = return []
readLines n = do
  line <- getLine
  rest <- readLines (n - 1)
  return (line : rest)

-- 或者使用 replicateM:
-- readLines n = replicateM n getLine

-- 5.5 交互式菜单
showMenu :: [String] -> IO Int
showMenu options = do
  putStrLn "Choose an option:"
  mapM_ printOption (zip [1..] options)
  putStr "Your choice: "
  hFlush stdout
  read <$> getLine
  where
    printOption (i, opt) = putStrLn (show i ++ ". " ++ opt)

-- 5.6 猜数字游戏（简化版）
guessNumber :: Int -> IO ()
guessNumber secret = do
  putStr "Your guess: "
  hFlush stdout
  guess <- read <$> getLine
  
  if guess < secret
    then do
      putStrLn "Too low!"
      guessNumber secret
    else if guess > secret
    then do
      putStrLn "Too high!"
      guessNumber secret
    else
      putStrLn "Correct!"


{- ============================================
   练习 6: 文件操作 (6 题)
   ============================================ -}

-- 6.1 统计文件行数
countFileLines :: FilePath -> IO Int
countFileLines path = do
  content <- readFile path
  return (length (lines content))

-- 6.2 查找并替换
replaceInFile :: FilePath -> String -> String -> IO ()
replaceInFile path old new = do
  content <- readFile path
  let newContent = replaceAll old new content
  -- 强制求值，避免惰性 IO 问题
  length newContent `seq` writeFile path newContent
  where
    replaceAll :: String -> String -> String -> String
    replaceAll old new str
      | old `isPrefixOf` str = new ++ replaceAll old new (drop (length old) str)
      | null str = ""
      | otherwise = head str : replaceAll old new (tail str)

-- 6.3 文件内容反转
reverseFile :: FilePath -> FilePath -> IO ()
reverseFile inputPath outputPath = do
  content <- readFile inputPath
  let reversedLines = reverse (lines content)
  writeFile outputPath (unlines reversedLines)

-- 6.4 合并多个文件
mergeFiles :: [FilePath] -> FilePath -> IO ()
mergeFiles inputs output = do
  contents <- mapM readFile inputs
  writeFile output (concat contents)

-- 6.5 统计单词频率
topWords :: FilePath -> Int -> IO [(String, Int)]
topWords path n = do
  content <- readFile path
  let wrds = words content
      wordCounts = M.fromListWith (+) [(w, 1) | w <- wrds]
      sortedWords = take n $ sortBy (flip (comparing snd)) (M.toList wordCounts)
  return sortedWords

-- 6.6 简单日志系统
appendLog :: FilePath -> String -> IO ()
appendLog logFile message = do
  -- 简化版：不添加真实时间戳，只添加消息
  appendFile logFile (message ++ "\n")


{- ============================================
   练习 7: 综合项目 (3 个小项目)
   ============================================ -}

-- 项目 1: TODO 清单 CLI

data Todo = Todo { task :: String, done :: Bool }
  deriving (Show, Read, Eq)

-- 1.1 加载 TODO 列表
loadTodos :: FilePath -> IO [Todo]
loadTodos path = do
  exists <- doesFileExist path
  if exists
    then do
      content <- readFile path
      return (read content :: [Todo])
    else return []
  where
    -- 简化版：假设文件存在性检查
    doesFileExist :: FilePath -> IO Bool
    doesFileExist _ = return True  -- 实际应使用 System.Directory

-- 1.2 保存 TODO 列表
saveTodos :: FilePath -> [Todo] -> IO ()
saveTodos path todos = writeFile path (show todos)

-- 1.3 添加 TODO
addTodo :: FilePath -> String -> IO ()
addTodo path taskName = do
  todos <- loadTodos path
  let newTodo = Todo taskName False
  saveTodos path (todos ++ [newTodo])
  putStrLn "Task added!"

-- 1.4 列出所有 TODO
listTodos :: FilePath -> IO ()
listTodos path = do
  todos <- loadTodos path
  if null todos
    then putStrLn "No tasks!"
    else do
      putStrLn "=== Your Tasks ==="
      mapM_ printTodo (zip [1..] todos)
  where
    printTodo (i, Todo t d) = 
      putStrLn (show i ++ ". " ++ (if d then "[X] " else "[ ] ") ++ t)

-- 1.5 删除 TODO
removeTodo :: FilePath -> Int -> IO ()
removeTodo path index = do
  todos <- loadTodos path
  if index < 1 || index > length todos
    then putStrLn "Invalid index!"
    else do
      let newTodos = take (index - 1) todos ++ drop index todos
      saveTodos path newTodos
      putStrLn "Task removed!"

-- 1.6 标记完成
toggleTodo :: FilePath -> Int -> IO ()
toggleTodo path index = do
  todos <- loadTodos path
  if index < 1 || index > length todos
    then putStrLn "Invalid index!"
    else do
      let (before, target:after) = splitAt (index - 1) todos
          newTodo = target { done = not (done target) }
          newTodos = before ++ [newTodo] ++ after
      saveTodos path newTodos
      putStrLn "Task toggled!"

-- 1.7 主循环
todoMainLoop :: FilePath -> IO ()
todoMainLoop path = do
  putStrLn "\n=== TODO List ==="
  putStrLn "1. List tasks"
  putStrLn "2. Add task"
  putStrLn "3. Remove task"
  putStrLn "4. Toggle task"
  putStrLn "5. Exit"
  putStr "Choice: "
  hFlush stdout
  choice <- getLine
  
  case choice of
    "1" -> listTodos path >> todoMainLoop path
    "2" -> do
      putStr "Task: "
      hFlush stdout
      taskName <- getLine
      addTodo path taskName
      todoMainLoop path
    "3" -> do
      listTodos path
      putStr "Task number: "
      hFlush stdout
      index <- read <$> getLine
      removeTodo path index
      todoMainLoop path
    "4" -> do
      listTodos path
      putStr "Task number: "
      hFlush stdout
      index <- read <$> getLine
      toggleTodo path index
      todoMainLoop path
    "5" -> putStrLn "Goodbye!"
    _ -> putStrLn "Invalid choice!" >> todoMainLoop path


-- 项目 2: 文本文件分析器

data FileStats = FileStats
  { charCount :: Int
  , wordCount :: Int
  , lineCount :: Int
  , avgWordLength :: Double
  } deriving (Show, Eq)

-- 2.1 分析文件
analyzeFile :: FilePath -> IO FileStats
analyzeFile path = do
  content <- readFile path
  let chars = length content
      wrds = words content
      lns = lines content
      avgLen = if null wrds 
               then 0 
               else fromIntegral (sum (map length wrds)) / fromIntegral (length wrds)
  return $ FileStats
    { charCount = chars
    , wordCount = length wrds
    , lineCount = length lns
    , avgWordLength = avgLen
    }

-- 2.2 显示统计信息
displayStats :: FileStats -> IO ()
displayStats stats = do
  putStrLn "=== File Statistics ==="
  putStrLn $ "Characters: " ++ show (charCount stats)
  putStrLn $ "Words: " ++ show (wordCount stats)
  putStrLn $ "Lines: " ++ show (lineCount stats)
  putStrLn $ "Avg word length: " ++ show (avgWordLength stats)

-- 2.3 比较两个文件
compareFiles :: FilePath -> FilePath -> IO ()
compareFiles path1 path2 = do
  stats1 <- analyzeFile path1
  stats2 <- analyzeFile path2
  
  putStrLn $ "File 1: " ++ path1
  displayStats stats1
  
  putStrLn $ "\nFile 2: " ++ path2
  displayStats stats2
  
  putStrLn "\n=== Comparison ==="
  putStrLn $ "Difference in words: " ++ show (wordCount stats1 - wordCount stats2)
  putStrLn $ "Difference in lines: " ++ show (lineCount stats1 - lineCount stats2)


-- 项目 3: 交互式文件浏览器

-- 3.2 显示文件内容（前 20 行）
showFileContent :: FilePath -> IO ()
showFileContent path = do
  content <- readFile path
  let lns = take 20 (lines content)
  mapM_ putStrLn lns
  when (length (lines content) > 20) $
    putStrLn "... (more lines)"


{- ============================================
   测试辅助函数
   ============================================ -}

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
  testMaybe "addThreeBind (Just 10)" (Just 13) (addThreeBind (Just 10))
  testMaybe "sequenceMaybe [Just 1, Just 2]" (Just [1,2]) (sequenceMaybe [Just 1, Just 2])
  testMaybe "sequenceMaybe [Just 1, Nothing]" Nothing (sequenceMaybe [Just 1, Nothing])
  
  putStrLn "\n--- Maybe Operations ---"
  testMaybe "safeDivide 10 2" (Just 5.0) (safeDivide 10 2)
  testMaybe "safeDivide 10 0" Nothing (safeDivide 10 0)
  testMaybe "safeSqrt 16" (Just 4.0) (safeSqrt 16)
  testMaybe "safeSqrt (-4)" Nothing (safeSqrt (-4))
  testMaybe "safeCompute 16 4" (Just 2.0) (safeCompute 16 4)
  
  let dict = [("a", 10), ("b", 20), ("c", 30)]
  testMaybe "lookupAndAdd" (Just 30) (lookupAndAdd "a" "b" dict)
  
  putStrLn "\n--- Either Operations ---"
  testEither "safeDivideE 10 2" (Right 5.0) (safeDivideE 10 2)
  testEither "safeDivideE 10 0" (Left DivByZero) (safeDivideE 10 0)
  testEither "parseAge \"25\"" (Right 25) (parseAge "25")
  testEither "parseAge \"invalid\"" (Left InvalidFormat) (parseAge "invalid")
  
  putStrLn "\n--- List Monad ---"
  putStrLn "pairs [1,2] [3,4]:"
  print $ pairs [1,2] [3,4]
  putStrLn "pythagorean 15:"
  print $ pythagorean 15
  putStrLn "moveKnight (5,5):"
  print $ moveKnight (5,5)
  
  putStrLn "\nTests complete!"


{-
使用说明：
1. 在 GHCi 中加载：
   ghci> :load Week04Exercises.hs

2. 运行测试：
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

6. 分析文件：
   ghci> stats <- analyzeFile "test.txt"
   ghci> displayStats stats

完整答案，供学习参考！
-}

