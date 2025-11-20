# Calculator - TDD 完整实现说明

## Calculator.hs 完整实现

```haskell
module Calculator
  ( add
  , subtract
  , multiply
  , divide
  , power
  , sqrt
  ) where

import Prelude hiding (subtract, sqrt)
import Calculator.Types

-- 加法
add :: Double -> Double -> CalcResult
add x y = Right (x + y)

-- 减法
subtract :: Double -> Double -> CalcResult
subtract x y = Right (x - y)

-- 乘法
multiply :: Double -> Double -> CalcResult
multiply x y = Right (x * y)

-- 除法（带错误处理）
divide :: Double -> Double -> CalcResult
divide _ 0 = Left DivisionByZero
divide x y = Right (x / y)

-- 幂运算（可选）
power :: Double -> Double -> CalcResult
power x y
  | isOverflow result = Left Overflow
  | otherwise = Right result
  where
    result = x ** y

-- 平方根（可选）
sqrt :: Double -> CalcResult
sqrt x
  | x < 0 = Left InvalidOperation
  | otherwise = Right (Prelude.sqrt x)

-- 辅助函数
isOverflow :: Double -> Bool
isOverflow x = isInfinite x || isNaN x
```

## CalculatorSpec.hs 完整实现

```haskell
module Main (main) where

import Test.Hspec
import Test.QuickCheck
import Calculator
import Calculator.Types

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  addSpec
  subtractSpec
  multiplySpec
  divideSpec
  propertiesSpec

addSpec :: Spec
addSpec = describe "add" $ do
  it "adds two positive numbers" $
    add 2 3 `shouldBe` Right 5
  
  it "adds negative numbers" $
    add (-2) 3 `shouldBe` Right 1
  
  it "adds zero" $
    add 5 0 `shouldBe` Right 5

subtractSpec :: Spec
subtractSpec = describe "subtract" $ do
  it "subtracts two numbers" $
    Calculator.subtract 5 3 `shouldBe` Right 2
  
  it "handles negative results" $
    Calculator.subtract 3 5 `shouldBe` Right (-2)

multiplySpec :: Spec
multiplySpec = describe "multiply" $ do
  it "multiplies two positive numbers" $
    multiply 3 4 `shouldBe` Right 12
  
  it "handles zero" $
    multiply 5 0 `shouldBe` Right 0
  
  it "handles negative numbers" $
    multiply (-2) 3 `shouldBe` Right (-6)

divideSpec :: Spec
divideSpec = describe "divide" $ do
  it "divides two numbers" $
    divide 10 2 `shouldBe` Right 5
  
  it "handles decimal results" $
    divide 7 2 `shouldBe` Right 3.5
  
  it "rejects division by zero" $
    divide 10 0 `shouldBe` Left DivisionByZero
  
  it "handles negative numbers" $
    divide (-10) 2 `shouldBe` Right (-5)

propertiesSpec :: Spec
propertiesSpec = describe "Properties" $ do
  it "add is commutative" $ property $
    \x y -> add x y == add y x
  
  it "multiply by zero gives zero" $ property $
    \x -> multiply x 0 == Right 0
  
  it "divide and multiply are inverse" $ property $
    \x y -> y /= 0 ==>
      let Right quotient = divide x y
          Right result = multiply quotient y
      in abs (result - x) < 0.0001
```

## TDD 开发过程记录

### 第 1 轮：加法

**Red** - 写测试：
```haskell
it "adds two positive numbers" $
  add 2 3 `shouldBe` Right 5
```

**Green** - 最简实现：
```haskell
add _ _ = Right 5  -- 硬编码
```

**添加更多测试** - 失败：
```haskell
it "adds negative numbers" $
  add (-2) 3 `shouldBe` Right 1  -- 失败！
```

**Green** - 正确实现：
```haskell
add x y = Right (x + y)  -- 所有测试通过
```

**Refactor** - 在这个简单例子中不需要

### 第 2-3 轮：减法和乘法

重复相同的 TDD 循环

### 第 4 轮：除法（带错误处理）

**Red** - 写测试：
```haskell
it "divides two numbers" $
  divide 10 2 `shouldBe` Right 5

it "rejects division by zero" $
  divide 10 0 `shouldBe` Left DivisionByZero
```

**Green** - 实现：
```haskell
divide _ 0 = Left DivisionByZero
divide x y = Right (x / y)
```

**所有测试通过！**

## 运行结果

```
$ cabal test

Calculator
  add
    ✓ adds two positive numbers
    ✓ adds negative numbers
    ✓ adds zero
  subtract
    ✓ subtracts two numbers
    ✓ handles negative results
  multiply
    ✓ multiplies two positive numbers
    ✓ handles zero
    ✓ handles negative numbers
  divide
    ✓ divides two numbers
    ✓ handles decimal results
    ✓ rejects division by zero
    ✓ handles negative numbers
  Properties
    ✓ add is commutative
    ✓ multiply by zero gives zero
    ✓ divide and multiply are inverse

Finished in 0.0234 seconds
15 examples, 0 failures
```

## 学到的经验

1. **从简单开始**：第一个测试用例应该是最简单的
2. **小步迭代**：每次只添加一个测试
3. **硬编码没问题**：让第一个测试通过后再泛化
4. **错误处理很重要**：要测试失败情况
5. **属性测试强大**：能发现意外的边界情况

## 下一步

尝试添加更多功能：
- 幂运算
- 平方根
- 三角函数
- 表达式解析

记住：**测试先行！**

