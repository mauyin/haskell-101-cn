{- |
QuickCheck Examples
QuickCheck 属性测试示例
-}

module QuickCheckExamples where

import Test.QuickCheck
import Data.List (sort, reverse)

-- ============================================================================
-- 示例 1: 基础属性
-- ============================================================================

-- 属性：反转两次等于原列表
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = reverse (reverse xs) == xs

-- 属性：反转不改变长度
prop_reverseLength :: [Int] -> Bool
prop_reverseLength xs = length (reverse xs) == length xs

-- 属性：排序是幂等的
prop_sortIdempotent :: [Int] -> Bool
prop_sortIdempotent xs = sort (sort xs) == sort xs

-- 运行示例
example1 :: IO ()
example1 = do
  putStrLn "测试 reverse 属性:"
  quickCheck prop_reverseReverse
  quickCheck prop_reverseLength
  
  putStrLn "\n测试 sort 属性:"
  quickCheck prop_sortIdempotent

-- ============================================================================
-- 示例 2: 条件属性
-- ============================================================================

-- 属性：除法运算（仅当除数不为 0）
prop_divideCorrect :: Int -> Int -> Property
prop_divideCorrect x y =
  y /= 0 ==> (x `div` y) * y + (x `mod` y) == x

-- 属性：正数的平方根的平方约等于原数
prop_sqrtSquare :: Positive Double -> Property
prop_sqrtSquare (Positive x) =
  let root = sqrt x
      square = root * root
  in abs (square - x) < 0.0001 ==> True

-- 运行示例
example2 :: IO ()
example2 = do
  putStrLn "测试条件属性:"
  quickCheck prop_divideCorrect
  quickCheck prop_sqrtSquare

-- ============================================================================
-- 示例 3: 自定义生成器
-- ============================================================================

-- 定义只包含正数的列表
newtype PositiveList = PositiveList [Int] deriving Show

instance Arbitrary PositiveList where
  arbitrary = PositiveList <$> listOf (abs <$> arbitrary `suchThat` (> 0))

-- 属性：正数列表的所有元素都是正数
prop_allPositive :: PositiveList -> Bool
prop_allPositive (PositiveList xs) = all (> 0) xs

-- 定义排序的列表
newtype SortedList = SortedList [Int] deriving Show

instance Arbitrary SortedList where
  arbitrary = SortedList . sort <$> arbitrary

-- 属性：排序列表的任意两个相邻元素是有序的
prop_sortedPairs :: SortedList -> Bool
prop_sortedPairs (SortedList xs) =
  all (\(a, b) -> a <= b) (zip xs (drop 1 xs))

-- 定义有效的邮箱地址
newtype Email = Email String deriving Show

instance Arbitrary Email where
  arbitrary = do
    name <- listOf1 (elements ['a'..'z'])
    domain <- listOf1 (elements ['a'..'z'])
    return $ Email (name ++ "@" ++ domain ++ ".com")

-- 属性：邮箱必须包含 @
prop_emailHasAt :: Email -> Bool
prop_emailHasAt (Email s) = '@' `elem` s

-- 运行示例
example3 :: IO ()
example3 = do
  putStrLn "测试自定义生成器:"
  quickCheck prop_allPositive
  quickCheck prop_sortedPairs
  quickCheck prop_emailHasAt

-- ============================================================================
-- 示例 4: 常见属性模式
-- ============================================================================

-- 模式 1: 恒等性 (f . g = id)
prop_encodeDecodeIdentity :: String -> Bool
prop_encodeDecodeIdentity s = decode (encode s) == s
  where
    encode = reverse
    decode = reverse

-- 模式 2: 交换律 (f x y = f y x)
prop_addCommutative :: Int -> Int -> Bool
prop_addCommutative x y = x + y == y + x

-- 模式 3: 结合律 ((x op y) op z = x op (y op z))
prop_addAssociative :: Int -> Int -> Int -> Bool
prop_addAssociative x y z = (x + y) + z == x + (y + z)

-- 模式 4: 不变量 (某个性质始终成立)
prop_sortedIsOrdered :: [Int] -> Bool
prop_sortedIsOrdered xs =
  let sorted = sort xs
  in all (\(a, b) -> a <= b) (zip sorted (drop 1 sorted))

-- 模式 5: 单调性 (f x <= f y when x <= y)
prop_lengthMonotonic :: [Int] -> [Int] -> Property
prop_lengthMonotonic xs ys =
  length xs <= length ys ==> length (xs ++ ys) >= length xs

-- 运行示例
example4 :: IO ()
example4 = do
  putStrLn "测试常见属性模式:"
  quickCheck prop_encodeDecodeIdentity
  quickCheck prop_addCommutative
  quickCheck prop_addAssociative
  quickCheck prop_sortedIsOrdered
  quickCheck prop_lengthMonotonic

-- ============================================================================
-- 示例 5: 调试失败的测试
-- ============================================================================

-- 错误的属性（故意的）
prop_wrongReverse :: [Int] -> Bool
prop_wrongReverse xs = reverse xs == xs  -- 这不总是对的！

-- 使用 verboseCheck 查看反例
example5 :: IO ()
example5 = do
  putStrLn "测试错误的属性（会失败）:"
  quickCheck prop_wrongReverse
  
  putStrLn "\n详细输出:"
  verboseCheck prop_wrongReverse

-- ============================================================================
-- 实用技巧
-- ============================================================================

-- 技巧 1: 收集测试数据统计
prop_collectLength :: [Int] -> Property
prop_collectLength xs = collect (length xs) $ True

-- 技巧 2: 标签化测试
prop_labelSort :: [Int] -> Property
prop_labelSort xs =
  let sorted = sort xs
      label = if null xs then "empty"
              else if length xs == 1 then "single"
              else if xs == sorted then "already sorted"
              else "needs sorting"
  in label xs $ sort xs == sorted

-- 技巧 3: 覆盖率检查
prop_coverageDivide :: Int -> Int -> Property
prop_coverageDivide x y =
  cover 10 (y == 0) "division by zero" $
  cover 80 (y /= 0) "normal division" $
  y /= 0 ==> x `div` y * y + x `mod` y == x

-- ============================================================================
-- 主函数
-- ============================================================================

main :: IO ()
main = do
  putStrLn "=== 示例 1: 基础属性 ==="
  example1
  
  putStrLn "\n=== 示例 2: 条件属性 ==="
  example2
  
  putStrLn "\n=== 示例 3: 自定义生成器 ==="
  example3
  
  putStrLn "\n=== 示例 4: 常见属性模式 ==="
  example4
  
  putStrLn "\n=== 示例 5: 调试 ==="
  example5
  
  putStrLn "\n=== 实用技巧 ==="
  quickCheck prop_collectLength
  quickCheck prop_labelSort
  quickCheck prop_coverageDivide

{-
运行说明：

1. 安装 QuickCheck：
   cabal install --lib QuickCheck

2. 运行：
   runhaskell quickcheck-examples.hs

3. 在 GHCi 中：
   ghci quickcheck-examples.hs
   ghci> quickCheck prop_reverseReverse
   ghci> verboseCheck prop_reverseReverse

学习建议：
- 从简单属性开始
- 思考函数的数学性质
- 用反例学习
- 使用 collect 和 label 理解测试分布
-}

