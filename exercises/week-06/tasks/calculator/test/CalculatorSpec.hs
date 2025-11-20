{- |
CalculatorSpec - 计算器测试套件
================================

TDD 练习：先写这个文件中的测试，再实现 Calculator.hs

运行测试：
  cabal test
  或
  cabal test --test-show-details=streaming
-}

module Main (main) where

import Test.Hspec
import Test.QuickCheck
import Calculator
import Calculator.Types

-- ============================================================================
-- 主测试入口
-- ============================================================================

main :: IO ()
main = hspec spec

-- ============================================================================
-- 测试规格
-- ============================================================================

spec :: Spec
spec = do
  addSpec
  subtractSpec
  multiplySpec
  divideSpec
  -- 可选功能
  -- powerSpec
  -- sqrtSpec
  
  -- 属性测试
  propertiesSpec


-- ============================================================================
-- 第 1 轮 TDD: 加法测试
-- ============================================================================

addSpec :: Spec
addSpec = describe "add" $ do
  -- TODO: 添加测试用例
  -- 从最简单的开始！
  
  it "adds two positive numbers" $
    pending  -- 先标记为 pending，然后实现
    -- add 2 3 `shouldBe` Right 5
  
  it "adds negative numbers" $
    pending
    -- add (-2) 3 `shouldBe` Right 1
  
  it "adds zero" $
    pending
    -- add 5 0 `shouldBe` Right 5
  
  -- 继续添加更多测试...


-- ============================================================================
-- 第 2 轮 TDD: 减法测试
-- ============================================================================

subtractSpec :: Spec
subtractSpec = describe "subtract" $ do
  it "subtracts two numbers" $
    pending
    -- Calculator.subtract 5 3 `shouldBe` Right 2
  
  it "handles negative results" $
    pending
    -- Calculator.subtract 3 5 `shouldBe` Right (-2)


-- ============================================================================
-- 第 3 轮 TDD: 乘法测试
-- ============================================================================

multiplySpec :: Spec
multiplySpec = describe "multiply" $ do
  it "multiplies two positive numbers" $
    pending
    -- multiply 3 4 `shouldBe` Right 12
  
  it "handles zero" $
    pending
    -- multiply 5 0 `shouldBe` Right 0
  
  it "handles negative numbers" $
    pending
    -- multiply (-2) 3 `shouldBe` Right (-6)


-- ============================================================================
-- 第 4 轮 TDD: 除法测试（重点：错误处理）
-- ============================================================================

divideSpec :: Spec
divideSpec = describe "divide" $ do
  it "divides two numbers" $
    pending
    -- divide 10 2 `shouldBe` Right 5
  
  it "handles decimal results" $
    pending
    -- divide 7 2 `shouldBe` Right 3.5
  
  -- 错误情况测试（重要！）
  it "rejects division by zero" $
    pending
    -- divide 10 0 `shouldBe` Left DivisionByZero
  
  it "handles negative numbers" $
    pending
    -- divide (-10) 2 `shouldBe` Right (-5)


-- ============================================================================
-- 可选：幂运算测试
-- ============================================================================

powerSpec :: Spec
powerSpec = describe "power" $ do
  it "calculates power" $
    pending
    -- power 2 3 `shouldBe` Right 8
  
  it "handles power of zero" $
    pending
    -- power 5 0 `shouldBe` Right 1
  
  it "detects overflow" $
    pending
    -- power 10 1000 `shouldSatisfy` isLeft


-- ============================================================================
-- 可选：平方根测试
-- ============================================================================

sqrtSpec :: Spec
sqrtSpec = describe "sqrt" $ do
  it "calculates square root" $
    pending
    -- Calculator.sqrt 9 `shouldBe` Right 3
  
  it "rejects negative numbers" $
    pending
    -- Calculator.sqrt (-1) `shouldSatisfy` isLeft


-- ============================================================================
-- 属性测试
-- ============================================================================

propertiesSpec :: Spec
propertiesSpec = describe "Properties" $ do
  -- TODO: 添加属性测试
  
  it "add is commutative" $ property $
    \x y -> add x y == add y x
  
  it "add is associative" $ property $
    \x y z -> 
      let Right r1 = add x y >>= \sum1 -> add sum1 z
          Right r2 = add y z >>= \sum2 -> add x sum2
      in r1 == r2
  
  it "multiply by zero gives zero" $ property $
    \x -> multiply x 0 == Right 0
  
  -- 除法属性：(x / y) * y ≈ x (当 y /= 0)
  it "divide and multiply are inverse" $ property $
    \x y -> y /= 0 ==>
      let Right quotient = divide x y
          Right result = multiply quotient y
      in abs (result - x) < 0.0001  -- 浮点数比较


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- 检查是否是 Left
isLeft :: Either a b -> Bool
isLeft (Left _) = True
isLeft _ = False

-- 检查是否是 Right
isRight :: Either a b -> Bool
isRight (Right _) = True
isRight _ = False


{-
TDD 实践步骤：

1. 从最简单的测试开始
   - 移除 pending
   - 运行测试（会失败，因为函数返回 undefined）
   - 实现函数让测试通过

2. 逐步添加测试
   - 每次只添加一个测试
   - 实现代码
   - 确保所有测试通过

3. 重构
   - 在测试的保护下改进代码
   - 运行测试确保没有破坏功能

4. 重复循环

实践顺序建议：
1. 先完成 add 的所有测试
2. 然后 subtract
3. 然后 multiply
4. 最后 divide（最复杂，有错误处理）

运行测试的命令：
$ cabal test
$ cabal test --test-show-details=streaming  # 详细输出

期望的输出（全部完成后）：
Calculator
  add
    ✓ adds two positive numbers
    ✓ adds negative numbers
    ✓ adds zero
  subtract
    ✓ subtracts two numbers
    ✓ handles negative results
  ...

Finished in 0.0234 seconds
15 examples, 0 failures
-}

