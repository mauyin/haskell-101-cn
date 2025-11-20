{- |
Week 6 - 测试练习: QuickCheck 和 Hspec
=======================================

本文件包含测试框架的练习

如何使用：
1. 安装测试库：cabal install --lib QuickCheck hspec
2. 运行测试：runhaskell Week06Tests.hs
3. 或在 GHCi 中：ghci Week06Tests.hs 然后 main
-}

{-# LANGUAGE TemplateHaskell #-}

module Week06Tests where

import Test.QuickCheck
import Test.Hspec
import Data.List (sort)

-- ============================================================================
-- 练习 4: QuickCheck 属性测试 (5 题)
-- ============================================================================

-- 4.1 TODO: 列表反转属性
-- |
-- 属性：反转两次等于原列表
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = undefined
-- 提示: reverse (reverse xs) == xs

-- |
-- 属性：反转不改变长度
prop_reverseLength :: [Int] -> Bool
prop_reverseLength xs = undefined
-- 提示: length (reverse xs) == length xs


-- 4.2 TODO: 排序属性
-- |
-- 属性：排序是幂等的（排序两次和排序一次相同）
prop_sortIdempotent :: [Int] -> Bool
prop_sortIdempotent xs = undefined
-- 提示: sort (sort xs) == sort xs

-- |
-- 属性：排序不改变长度
prop_sortPreservesLength :: [Int] -> Bool
prop_sortPreservesLength xs = undefined


-- 4.3 TODO: Map 操作属性
-- |
-- 属性：map 不改变长度
prop_mapPreservesLength :: [Int] -> Bool
prop_mapPreservesLength xs = undefined
-- 提示: length (map f xs) == length xs

-- |
-- 属性：map 的组合定律
-- map f . map g = map (f . g)
prop_mapComposition :: [Int] -> Property
prop_mapComposition xs = undefined
-- 提示: map (*2) (map (+1) xs) == map ((*2) . (+1)) xs


-- 4.4 TODO: 条件属性
-- |
-- 属性：当除数不为 0 时，除法和模运算满足性质
prop_divideCorrect :: Int -> Int -> Property
prop_divideCorrect x y = undefined
-- 提示: y /= 0 ==> (x `div` y) * y + (x `mod` y) == x


-- 4.5 TODO: 自定义生成器
-- |
-- 只生成正整数的类型
newtype PositiveInt = PositiveInt Int deriving (Show, Eq)

instance Arbitrary PositiveInt where
  arbitrary = undefined
  -- 提示: 使用 abs <$> arbitrary `suchThat` (> 0)
  -- 或 PositiveInt <$> (abs <$> arbitrary `suchThat` (> 0))

-- |
-- 属性：两个正整数的和也是正整数
prop_positiveSum :: PositiveInt -> PositiveInt -> Bool
prop_positiveSum (PositiveInt x) (PositiveInt y) = undefined
-- 提示: x + y > 0


-- ============================================================================
-- 练习 5: Hspec 单元测试 (5 题)
-- ============================================================================

-- 测试的函数实现
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide x y = Just (x `div` y)

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter p (x:xs)
  | p x = x : myFilter p xs
  | otherwise = myFilter p xs


-- 5.1 TODO: 基础函数测试
-- |
-- 为 factorial 函数编写 Hspec 测试
factorialSpec :: Spec
factorialSpec = undefined
{-
提示:
factorialSpec = describe "factorial" $ do
  it "0 的阶乘是 1" $
    factorial 0 `shouldBe` 1
  
  it "5 的阶乘是 120" $
    factorial 5 `shouldBe` 120
  
  it "1 的阶乘是 1" $
    factorial 1 `shouldBe` 1
-}


-- 5.2 TODO: 边界情况测试
-- |
-- 测试 safeHead 函数的各种情况
safeHeadSpec :: Spec
safeHeadSpec = undefined
{-
提示:
safeHeadSpec = describe "safeHead" $ do
  it "returns Just for non-empty list" $
    safeHead [1,2,3] `shouldBe` Just 1
  
  it "returns Nothing for empty list" $
    safeHead [] `shouldBe` (Nothing :: Maybe Int)
-}


-- 5.3 TODO: 错误处理测试
-- |
-- 测试 safeDivide 的成功和失败情况
safeDivideSpec :: Spec
safeDivideSpec = undefined
{-
提示:
safeDivideSpec = describe "safeDivide" $ do
  it "divides normally" $
    safeDivide 10 2 `shouldBe` Just 5
  
  it "returns Nothing for division by zero" $
    safeDivide 10 0 `shouldBe` Nothing
-}


-- 5.4 TODO: 列表操作测试
-- |
-- 测试自定义的 myFilter 函数
myFilterSpec :: Spec
myFilterSpec = undefined
{-
提示:
myFilterSpec = describe "myFilter" $ do
  it "filters even numbers" $
    myFilter even [1,2,3,4] `shouldBe` [2,4]
  
  it "returns empty for empty list" $
    myFilter even [] `shouldBe` []
  
  it "returns empty when no elements match" $
    myFilter (> 10) [1,2,3] `shouldBe` []
-}


-- 5.5 TODO: IO 操作测试
-- |
-- 测试文件读写函数（使用临时文件）
fileOpsSpec :: Spec
fileOpsSpec = undefined
{-
提示:
fileOpsSpec = describe "file operations" $ do
  it "writes and reads file" $ do
    let content = "test content"
    writeFile "test.tmp" content
    result <- readFile "test.tmp"
    result `shouldBe` content
-}


-- ============================================================================
-- 主测试运行器
-- ============================================================================

-- QuickCheck 测试
runQuickCheckTests :: IO ()
runQuickCheckTests = do
  putStrLn "=== QuickCheck 属性测试 ==="
  
  putStrLn "\n4.1 列表反转属性:"
  quickCheck prop_reverseReverse
  quickCheck prop_reverseLength
  
  putStrLn "\n4.2 排序属性:"
  quickCheck prop_sortIdempotent
  quickCheck prop_sortPreservesLength
  
  putStrLn "\n4.3 Map 属性:"
  quickCheck prop_mapPreservesLength
  quickCheck prop_mapComposition
  
  putStrLn "\n4.4 条件属性:"
  quickCheck prop_divideCorrect
  
  putStrLn "\n4.5 自定义生成器:"
  quickCheck prop_positiveSum


-- Hspec 测试
runHspecTests :: IO ()
runHspecTests = hspec $ do
  factorialSpec
  safeHeadSpec
  safeDivideSpec
  myFilterSpec
  fileOpsSpec


-- 运行所有测试
main :: IO ()
main = do
  putStrLn "======================================"
  putStrLn "Week 6 测试练习"
  putStrLn "======================================"
  
  -- QuickCheck 测试
  runQuickCheckTests
  
  putStrLn "\n======================================"
  putStrLn "Hspec 单元测试"
  putStrLn "======================================"
  
  -- Hspec 测试
  runHspecTests
  
  putStrLn "\n所有测试完成！"


-- ============================================================================
-- 额外挑战：为以下函数编写属性测试
-- ============================================================================

-- 挑战 1: append 的性质
-- 属性：(xs ++ ys) ++ zs == xs ++ (ys ++ zs)
prop_appendAssociative :: [Int] -> [Int] -> [Int] -> Bool
prop_appendAssociative xs ys zs = undefined

-- 挑战 2: filter 的性质
-- 属性：filter p (filter q xs) == filter (\x -> p x && q x) xs
prop_filterComposition :: [Int] -> Property
prop_filterComposition xs = undefined

-- 挑战 3: map 和 filter 的关系
-- 属性：length (filter p (map f xs)) <= length xs
prop_mapFilterLength :: [Int] -> Property
prop_mapFilterLength xs = undefined


{-
运行说明：

1. 安装依赖：
   cabal install --lib QuickCheck hspec

2. 运行所有测试：
   runhaskell Week06Tests.hs

3. 在 GHCi 中交互运行：
   ghci Week06Tests.hs
   ghci> main
   
   或单独运行某个测试：
   ghci> quickCheck prop_reverseReverse
   ghci> hspec factorialSpec

4. 查看详细输出：
   ghci> verboseCheck prop_reverseReverse

记得完成所有 TODO！
-}

