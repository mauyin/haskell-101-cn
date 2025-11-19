{- |
Week 0 - 练习 1: Hello Haskell
================================

这是你的第一个 Haskell 练习！完成以下函数定义。

如何使用这个文件：
1. 在每个 TODO 注释下方编写函数实现
2. 在 GHCi 中加载文件：ghci> :load exercise-01-hello.hs
3. 测试你的函数
4. 如果遇到困难，查看 solutions/ 目录中的参考答案

提示：不要删除类型签名！它们是 Haskell 代码的重要组成部分。
-}

module Exercise01 where

-- ============================================================================
-- 练习 1.1: 问候函数
-- ============================================================================

{- | 
编写一个函数 'sayHello'，它接受一个名字（字符串），返回问候语。

示例：
  sayHello "小明" 应该返回 "你好，小明！"
  sayHello "Haskell" 应该返回 "你好，Haskell！"
-}

sayHello :: String -> String
sayHello name = undefined  -- TODO: 替换 undefined 为你的实现


-- ============================================================================
-- 练习 1.2: 简单算术
-- ============================================================================

{- |
编写一个函数 'addTwo'，它接受一个整数，返回这个整数加 2 的结果。

示例：
  addTwo 5 应该返回 7
  addTwo 0 应该返回 2
-}

addTwo :: Int -> Int
addTwo n = undefined  -- TODO: 实现这个函数


{- |
编写一个函数 'double'，它接受一个整数，返回这个整数的两倍。

示例：
  double 3 应该返回 6
  double 10 应该返回 20
-}

double :: Int -> Int
double n = undefined  -- TODO: 实现这个函数


{- |
编写一个函数 'square'，它接受一个整数，返回这个整数的平方。

示例：
  square 4 应该返回 16
  square 5 应该返回 25
-}

square :: Int -> Int
square n = undefined  -- TODO: 实现这个函数


-- ============================================================================
-- 练习 1.3: 布尔逻辑
-- ============================================================================

{- |
编写一个函数 'isPositive'，它接受一个整数，如果是正数返回 True，否则返回 False。

示例：
  isPositive 5 应该返回 True
  isPositive 0 应该返回 False
  isPositive (-3) 应该返回 False

注意：0 不是正数
-}

isPositive :: Int -> Bool
isPositive n = undefined  -- TODO: 实现这个函数


{- |
编写一个函数 'isEven'，它接受一个整数，如果是偶数返回 True，否则返回 False。

示例：
  isEven 4 应该返回 True
  isEven 7 应该返回 False
  isEven 0 应该返回 True

提示：使用 mod 函数或 `mod` 运算符
-}

isEven :: Int -> Bool
isEven n = undefined  -- TODO: 实现这个函数


-- ============================================================================
-- 练习 1.4: 字符串操作
-- ============================================================================

{- |
编写一个函数 'firstChar'，它接受一个字符串，返回第一个字符。

示例：
  firstChar "Haskell" 应该返回 'H'
  firstChar "你好" 应该返回 '你'

提示：使用 head 函数
警告：这个函数对空字符串会报错，这在真实项目中需要处理，但现在我们先假设输入总是非空的
-}

firstChar :: String -> Char
firstChar s = undefined  -- TODO: 实现这个函数


{- |
编写一个函数 'stringLength'，它接受一个字符串，返回它的长度。

示例：
  stringLength "Hello" 应该返回 5
  stringLength "" 应该返回 0

提示：使用 length 函数
-}

stringLength :: String -> Int
stringLength s = undefined  -- TODO: 实现这个函数


-- ============================================================================
-- 练习 1.5: 组合函数（挑战题）
-- ============================================================================

{- |
编写一个函数 'addThenDouble'，它接受一个整数，先加 2，然后乘以 2。

示例：
  addThenDouble 3 应该返回 10  -- (3 + 2) * 2 = 10
  addThenDouble 5 应该返回 14  -- (5 + 2) * 2 = 14

提示：你可以使用前面定义的 addTwo 和 double 函数
-}

addThenDouble :: Int -> Int
addThenDouble n = undefined  -- TODO: 实现这个函数


-- ============================================================================
-- 测试你的代码
-- ============================================================================

{- |
在 GHCi 中运行以下命令来测试你的函数：

ghci> :load exercise-01-hello.hs
ghci> sayHello "小明"
"你好，小明！"

ghci> addTwo 5
7

ghci> isEven 4
True

ghci> firstChar "Haskell"
'H'

ghci> addThenDouble 3
10

如果输出与预期不符，检查你的实现并修改。
-}

-- ============================================================================
-- 完成后
-- ============================================================================

{- |
恭喜你完成了第一个 Haskell 练习！

下一步：
1. 对照 solutions/exercise-01-hello.hs 检查你的答案
2. 尝试在 GHCi 中实验其他表达式
3. 继续 exercise-02-ghci.md

记住：编程最好的学习方式是动手实践！
-}

