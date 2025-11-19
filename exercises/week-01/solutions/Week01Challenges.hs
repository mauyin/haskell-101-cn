{- |
Week 1 - 挑战题参考答案
================================

这是挑战题的参考答案。
这些解法可能不是最优的，但力求清晰易懂。
-}

module Week01Challenges where

import Data.Char (toLower)
import Data.List (group)

-- ============================================================================
-- 挑战 1: 快速排序
-- ============================================================================

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (pivot:rest) =
  let smaller = [x | x <- rest, x < pivot]
      larger  = [x | x <- rest, x >= pivot]
  in quicksort smaller ++ [pivot] ++ quicksort larger


-- ============================================================================
-- 挑战 2: 斐波那契数列
-- ============================================================================

fibonacci :: Int -> [Int]
fibonacci n = take n fibs
  where
    fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- 简单递归版本（较慢）
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

-- 更高效的版本
fibFast :: Int -> Int
fibFast n = fibList !! n
  where fibList = 0 : 1 : zipWith (+) fibList (tail fibList)


-- ============================================================================
-- 挑战 3: 回文判断
-- ============================================================================

isPalindrome :: String -> Bool
isPalindrome str = cleaned == reverse cleaned
  where
    cleaned = map toLower (filter (/= ' ') str)


isPalindromeList :: Eq a => [a] -> Bool
isPalindromeList xs = xs == reverse xs


-- ============================================================================
-- 挑战 4: 素数筛选
-- ============================================================================

isPrime :: Int -> Bool
isPrime n
  | n < 2     = False
  | n == 2    = True
  | even n    = False
  | otherwise = null [x | x <- [3,5..isqrt n], n `mod` x == 0]
  where
    isqrt = floor . sqrt . fromIntegral


primes :: Int -> [Int]
primes n = sieve [2..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]


-- ============================================================================
-- 挑战 5: 列表压缩
-- ============================================================================

compress :: Eq a => [a] -> [a]
compress [] = []
compress [x] = [x]
compress (x:y:xs)
  | x == y    = compress (y:xs)
  | otherwise = x : compress (y:xs)

-- 使用 Data.List.group 的版本
compressAlt :: Eq a => [a] -> [a]
compressAlt xs = map head (group xs)


encode :: Eq a => [a] -> [(Int, a)]
encode xs = map (\g -> (length g, head g)) (group xs)


-- ============================================================================
-- 挑战 6: 数字金字塔
-- ============================================================================

pyramid :: Int -> IO ()
pyramid n = putStr (pyramidString n)


pyramidString :: Int -> String
pyramidString n = unlines [spaces i ++ numbers i | i <- [1..n]]
  where
    spaces i = replicate (n - i) ' '
    numbers i = concat [show x | x <- [1..i]] ++ 
                concat [show x | x <- [i-1,i-2..1]]


-- ============================================================================
-- 挑战 7: 最大子数组和
-- ============================================================================

maxSubArraySum :: [Int] -> Int
maxSubArraySum [] = 0
maxSubArraySum xs = maximum $ scanl (\acc x -> max x (acc + x)) 0 xs

-- Kadane's 算法的直接实现
maxSubArraySumKadane :: [Int] -> Int
maxSubArraySumKadane xs = snd $ foldl step (0, head xs) xs
  where
    step (currentMax, globalMax) x =
      let newCurrent = max x (currentMax + x)
          newGlobal = max globalMax newCurrent
      in (newCurrent, newGlobal)


-- ============================================================================
-- 挑战 8: 二分查找
-- ============================================================================

binarySearch :: Ord a => a -> [a] -> Maybe Int
binarySearch x xs = search 0 (length xs - 1)
  where
    search low high
      | low > high = Nothing
      | x < mid_val = search low (mid - 1)
      | x > mid_val = search (mid + 1) high
      | otherwise = Just mid
      where
        mid = (low + high) `div` 2
        mid_val = xs !! mid


-- ============================================================================
-- 测试函数
-- ============================================================================

testChallenges :: IO ()
testChallenges = do
  putStrLn "挑战 1: 快速排序"
  print $ quicksort [3,1,4,1,5,9,2,6]
  -- [1,1,2,3,4,5,6,9]
  
  putStrLn "\n挑战 2: 斐波那契数列"
  print $ fibonacci 10
  -- [0,1,1,2,3,5,8,13,21,34]
  print $ fib 10
  -- 55
  
  putStrLn "\n挑战 3: 回文判断"
  print $ isPalindrome "racecar"
  -- True
  print $ isPalindromeList [1,2,3,2,1]
  -- True
  
  putStrLn "\n挑战 4: 素数筛选"
  print $ isPrime 17
  -- True
  print $ primes 20
  -- [2,3,5,7,11,13,17,19]
  
  putStrLn "\n挑战 5: 列表压缩"
  print $ compress "aaabbbccdaa"
  -- "abcda"
  print $ encode "aaabbbccdaa"
  -- [(3,'a'),(3,'b'),(2,'c'),(1,'d'),(2,'a')]
  
  putStrLn "\n挑战 6: 数字金字塔"
  pyramid 5
  
  putStrLn "\n挑战 7: 最大子数组和"
  print $ maxSubArraySum [-2,1,-3,4,-1,2,1,-5,4]
  -- 6
  
  putStrLn "\n挑战 8: 二分查找"
  print $ binarySearch 5 [1,2,3,4,5,6,7]
  -- Just 4
  print $ binarySearch 8 [1,2,3,4,5,6,7]
  -- Nothing

