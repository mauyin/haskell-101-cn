{- |
Week 1 - 练习作业参考答案
================================

这是练习的参考答案。
建议先自己尝试，遇到困难再查看。

注意：很多题目有多种解法，这里只是其中一种！
-}

module Week01Exercises where

-- ============================================================================
-- 练习 1: 基础函数
-- ============================================================================

circleArea :: Double -> Double
circleArea radius = pi * radius * radius


isAdult :: Int -> Bool
isAdult age = age >= 18


absDiff :: Int -> Int -> Int
absDiff x y = abs (x - y)


distance :: Double -> Double -> Double -> Double -> Double
distance x1 y1 x2 y2 = sqrt ((x2 - x1)^2 + (y2 - y1)^2)


fahrenheitToCelsius :: Double -> Double
fahrenheitToCelsius f = (f - 32) * 5 / 9


-- ============================================================================
-- 练习 2: 列表操作
-- ============================================================================

secondElement :: [a] -> a
secondElement xs = head (tail xs)
-- 或者：secondElement (_:x:_) = x


contains :: Eq a => a -> [a] -> Bool
contains x [] = False
contains x (y:ys)
  | x == y    = True
  | otherwise = contains x ys


removeFirstLast :: [a] -> [a]
removeFirstLast xs = tail (init xs)
-- 或者：removeFirstLast (_:xs) = init xs


firstThree :: [a] -> [a]
firstThree xs = take 3 xs


isSingleton :: [a] -> Bool
isSingleton [_] = True
isSingleton _   = False
-- 或者：isSingleton xs = length xs == 1


-- ============================================================================
-- 练习 3: 递归
-- ============================================================================

productList :: [Int] -> Int
productList [] = 1
productList (x:xs) = x * productList xs


replicateN :: Int -> a -> [a]
replicateN 0 x = []
replicateN n x = x : replicateN (n-1) x


takeN :: Int -> [a] -> [a]
takeN 0 _      = []
takeN _ []     = []
takeN n (x:xs) = x : takeN (n-1) xs


dropN :: Int -> [a] -> [a]
dropN 0 xs     = xs
dropN _ []     = []
dropN n (_:xs) = dropN (n-1) xs


intersperse :: a -> [a] -> [a]
intersperse sep []     = []
intersperse sep [x]    = [x]
intersperse sep (x:xs) = x : sep : intersperse sep xs


-- ============================================================================
-- 练习 4: 高阶函数
-- ============================================================================

incrementAll :: [Int] -> [Int]
incrementAll xs = map (+1) xs


onlyPositive :: [Int] -> [Int]
onlyPositive xs = filter (>0) xs


sumOdds :: [Int] -> Int
sumOdds xs = sum (filter odd xs)


totalLength :: [String] -> Int
totalLength xs = sum (map length xs)


evenSquares :: [Int] -> [Int]
evenSquares xs = map (^2) (filter even xs)


-- ============================================================================
-- 练习 5: Lambda 表达式
-- ============================================================================

squareAll :: [Int] -> [Int]
squareAll xs = map (\x -> x^2) xs


longStrings :: [String] -> [String]
longStrings xs = filter (\s -> length s > 3) xs


customTransform :: [Int] -> [Int]
customTransform xs = map (\x -> if even x then x `div` 2 else x * 3) xs


joinWithSpaces :: [String] -> String
joinWithSpaces xs = unwords xs

-- 解释：
-- unwords 是 Prelude 提供的标准函数，专门用于用空格连接字符串列表
-- 它的实现更高效，应该优先使用
--
-- 如果要用 foldr 教学，可以这样实现（但不推荐）：
-- joinWithSpaces [] = ""
-- joinWithSpaces [x] = x
-- joinWithSpaces (x:xs) = x ++ " " ++ joinWithSpaces xs


removeEvens :: [Int] -> [Int]
removeEvens xs = filter (\x -> odd x) xs


-- ============================================================================
-- 测试函数
-- ============================================================================

testAll :: IO ()
testAll = do
  putStrLn "测试练习 1: 基础函数"
  print $ circleArea 2.0                    -- 12.566370614359172
  print $ isAdult 18                        -- True
  print $ absDiff 5 3                       -- 2
  print $ distance 0 0 3 4                  -- 5.0
  print $ fahrenheitToCelsius 32            -- 0.0
  
  putStrLn "\n测试练习 2: 列表操作"
  print $ secondElement [1,2,3]             -- 2
  print $ contains 3 [1,2,3,4]              -- True
  print $ removeFirstLast [1,2,3,4]         -- [2,3]
  print $ firstThree [1,2,3,4,5]            -- [1,2,3]
  print $ isSingleton [1]                   -- True
  
  putStrLn "\n测试练习 3: 递归"
  print $ productList [1,2,3,4]             -- 24
  print $ replicateN 3 'a'                  -- "aaa"
  print $ takeN 3 [1,2,3,4,5]               -- [1,2,3]
  print $ dropN 2 [1,2,3,4,5]               -- [3,4,5]
  print $ intersperse ',' "abc"             -- "a,b,c"
  
  putStrLn "\n测试练习 4: 高阶函数"
  print $ incrementAll [1,2,3]              -- [2,3,4]
  print $ onlyPositive [1,-2,3,-4,5]        -- [1,3,5]
  print $ sumOdds [1,2,3,4,5]               -- 9
  print $ totalLength ["hello", "world"]    -- 10
  print $ evenSquares [1,2,3,4,5]           -- [4,16]
  
  putStrLn "\n测试练习 5: Lambda 表达式"
  print $ squareAll [1,2,3,4]               -- [1,4,9,16]
  print $ longStrings ["hi", "hello", "bye", "world"]  -- ["hello","world"]
  print $ customTransform [1,2,3,4,5]       -- [3,1,9,2,15]
  print $ joinWithSpaces ["Hello", "World"] -- "Hello World"
  print $ removeEvens [1,2,3,4,5,6]         -- [1,3,5]

