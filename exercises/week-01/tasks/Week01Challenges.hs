{- |
Week 1 - 挑战题: Haskell 进阶练习
================================

这些题目更有挑战性，适合学有余力的同学。

难度：⭐⭐⭐⭐☆

⚠️ **重要提示**：
- 某些题目使用了 Week 2 及以后才会学习的概念（如 Maybe、IO）
- 如果遇到不熟悉的类型，可以先跳过，等学完相应章节再回来做
- 建议顺序：先做挑战 1-5，挑战 6-8 可以等学完 Week 2/4 再做

学习建议：
- 不要急着看答案，多思考
- 可以先用递归实现，再尝试高阶函数
- 测试边界情况（空列表、负数等）
- 在 GHCi 中逐步测试你的想法
-}

module Week01Challenges where

-- ============================================================================
-- 挑战 1: 快速排序
-- ============================================================================

{- | 快速排序
使用 Haskell 实现经典的快速排序算法

算法思路：
1. 选择一个基准元素（通常是第一个）
2. 将小于基准的元素放左边
3. 将大于等于基准的元素放右边
4. 递归排序左右两部分

示例：
  quicksort [3,1,4,1,5,9,2,6]  应该返回 [1,1,2,3,4,5,6,9]
  quicksort [5,4,3,2,1]        应该返回 [1,2,3,4,5]
-}
quicksort :: Ord a => [a] -> [a]
quicksort xs = undefined  -- TODO


-- ============================================================================
-- 挑战 2: 斐波那契数列
-- ============================================================================

{- | 生成前 n 个斐波那契数
斐波那契数列：0, 1, 1, 2, 3, 5, 8, 13, ...
规则：F(n) = F(n-1) + F(n-2)，F(0) = 0, F(1) = 1

示例：
  fibonacci 10  应该返回 [0,1,1,2,3,5,8,13,21,34]
  fibonacci 5   应该返回 [0,1,1,2,3]
-}
fibonacci :: Int -> [Int]
fibonacci n = undefined  -- TODO


{- | 计算第 n 个斐波那契数
更高效的版本（可选）

示例：
  fib 10  应该返回 55
  fib 20  应该返回 6765
-}
fib :: Int -> Int
fib n = undefined  -- TODO


-- ============================================================================
-- 挑战 3: 回文判断
-- ============================================================================

{- | 判断字符串是否为回文
回文：正读和反读都一样的字符串

示例：
  isPalindrome "racecar"  应该返回 True
  isPalindrome "hello"    应该返回 False
  isPalindrome "A man a plan a canal Panama"  -- 忽略空格和大小写
-}
isPalindrome :: String -> Bool
isPalindrome str = undefined  -- TODO


{- | 判断列表是否为回文

示例：
  isPalindromeList [1,2,3,2,1]  应该返回 True
  isPalindromeList [1,2,3,4,5]  应该返回 False
-}
isPalindromeList :: Eq a => [a] -> Bool
isPalindromeList xs = undefined  -- TODO


-- ============================================================================
-- 挑战 4: 素数筛选
-- ============================================================================

{- | 判断一个数是否为素数
素数：只能被 1 和自身整除的数（大于 1）

示例：
  isPrime 2   应该返回 True
  isPrime 17  应该返回 True
  isPrime 4   应该返回 False
-}
isPrime :: Int -> Bool
isPrime n = undefined  -- TODO


{- | 找出范围内的所有素数
使用埃拉托斯特尼筛法（Sieve of Eratosthenes）

示例：
  primes 20  应该返回 [2,3,5,7,11,13,17,19]
  primes 10  应该返回 [2,3,5,7]
-}
primes :: Int -> [Int]
primes n = undefined  -- TODO


-- ============================================================================
-- 挑战 5: 列表压缩
-- ============================================================================

{- | 压缩连续重复的元素
将连续相同的元素压缩成一个

示例：
  compress "aaabbbccdaa"  应该返回 "abcda"
  compress [1,1,1,2,2,3,3,3,3]  应该返回 [1,2,3]
-}
compress :: Eq a => [a] -> [a]
compress xs = undefined  -- TODO


{- | 编码连续重复的元素
记录每个元素及其重复次数

示例：
  encode "aaabbbccdaa"  应该返回 [(3,'a'),(3,'b'),(2,'c'),(1,'d'),(2,'a')]
-}
encode :: Eq a => [a] -> [(Int, a)]
encode xs = undefined  -- TODO


-- ============================================================================
-- 挑战 6: 数字金字塔
-- ============================================================================

{- | 生成数字金字塔
打印一个数字金字塔

⚠️ **Week 4 内容**：这题使用 IO 类型（Week 4 才会学习）
建议先做 pyramidString，或者等学完 Week 4 再回来做这题。

示例：
  pyramid 5 应该打印：
      1
     121
    12321
   1234321
  123454321
-}
pyramid :: Int -> IO ()
pyramid n = undefined  -- TODO
-- 提示：可以先实现 pyramidString，然后用 putStrLn 打印


{- | 生成数字金字塔字符串（不打印）
返回金字塔的字符串表示

示例：
  pyramidString 3  应该返回 "  1\n 121\n12321"
-}
pyramidString :: Int -> String
pyramidString n = undefined  -- TODO


-- ============================================================================
-- 挑战 7: 最大子数组和
-- ============================================================================

{- | 找出数组中和最大的连续子数组
使用 Kadane 算法

示例：
  maxSubArraySum [-2,1,-3,4,-1,2,1,-5,4]  应该返回 6  -- [4,-1,2,1]
  maxSubArraySum [-1,-2,-3,-4]            应该返回 -1
-}
maxSubArraySum :: [Int] -> Int
maxSubArraySum xs = undefined  -- TODO


-- ============================================================================
-- 挑战 8: 二分查找
-- ============================================================================

{- | 在有序列表中进行二分查找
返回 Just index 如果找到，否则返回 Nothing

⚠️ **Week 2 内容**：这题使用 Maybe 类型（Week 2 才会学习）

Week 1 友好版本：可以先实现这个简化版：
  binarySearchBool :: Ord a => a -> [a] -> Bool
  binarySearchBool x xs = undefined
  -- 返回 True 如果找到，False 否则

示例（Maybe 版本）：
  binarySearch 5 [1,2,3,4,5,6,7]  应该返回 Just 4
  binarySearch 8 [1,2,3,4,5,6,7]  应该返回 Nothing
-}
binarySearch :: Ord a => a -> [a] -> Maybe Int
binarySearch x xs = undefined  -- TODO
-- 提示：二分查找需要比较中间元素
-- 如果相等，找到了；如果小于，搜索左半部分；如果大于，搜索右半部分


-- ============================================================================
-- 测试函数
-- ============================================================================

testChallenges :: IO ()
testChallenges = do
  putStrLn "挑战 1: 快速排序"
  print $ quicksort [3,1,4,1,5,9,2,6]
  
  putStrLn "\n挑战 2: 斐波那契数列"
  print $ fibonacci 10
  print $ fib 10
  
  putStrLn "\n挑战 3: 回文判断"
  print $ isPalindrome "racecar"
  print $ isPalindromeList [1,2,3,2,1]
  
  putStrLn "\n挑战 4: 素数筛选"
  print $ isPrime 17
  print $ primes 20
  
  putStrLn "\n挑战 5: 列表压缩"
  print $ compress "aaabbbccdaa"
  print $ encode "aaabbbccdaa"
  
  putStrLn "\n挑战 6: 数字金字塔"
  pyramid 5
  
  putStrLn "\n挑战 7: 最大子数组和"
  print $ maxSubArraySum [-2,1,-3,4,-1,2,1,-5,4]
  
  putStrLn "\n挑战 8: 二分查找"
  print $ binarySearch 5 [1,2,3,4,5,6,7]

