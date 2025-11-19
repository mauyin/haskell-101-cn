{- |
Week 1 - 练习作业: Haskell 基础语法
================================

本文件包含 25 道练习题，涵盖本周所学的核心概念。

如何使用：
1. 完成每个标记为 TODO 的函数
2. 在 GHCi 中测试：ghci> :load Week01Exercises.hs
3. 运行测试函数验证答案
4. 完成后对照 solutions/ 中的参考答案

提示：
- 所有函数都已提供类型签名
- undefined 表示需要你实现的部分
- 建议按顺序完成，从简单到复杂
-}

module Week01Exercises where

-- ============================================================================
-- 练习 1: 基础函数（5 题）
-- ============================================================================

{- | 1.1 计算圆的面积
给定半径，计算圆的面积（π * r²）
提示：使用 pi 常量

示例：
  circleArea 1.0  应该返回 3.141592653589793
  circleArea 2.0  应该返回 12.566370614359172
-}
circleArea :: Double -> Double
circleArea radius = undefined  -- TODO


{- | 1.2 判断是否为成年人
给定年龄，判断是否 >= 18 岁

示例：
  isAdult 18  应该返回 True
  isAdult 17  应该返回 False
-}
isAdult :: Int -> Bool
isAdult age = undefined  -- TODO


{- | 1.3 计算绝对值差
计算两个数字的绝对值差

示例：
  absDiff 5 3   应该返回 2
  absDiff 3 5   应该返回 2
  absDiff (-2) 3 应该返回 5
-}
absDiff :: Int -> Int -> Int
absDiff x y = undefined  -- TODO


{- | 1.4 计算两点之间的距离
使用距离公式：sqrt((x2-x1)² + (y2-y1)²)

示例：
  distance 0 0 3 4  应该返回 5.0
  distance 1 1 4 5  应该返回 5.0
-}
distance :: Double -> Double -> Double -> Double -> Double
distance x1 y1 x2 y2 = undefined  -- TODO


{- | 1.5 温度转换（华氏到摄氏）
公式：C = (F - 32) * 5/9

示例：
  fahrenheitToCelsius 32   应该返回 0.0
  fahrenheitToCelsius 212  应该返回 100.0
-}
fahrenheitToCelsius :: Double -> Double
fahrenheitToCelsius f = undefined  -- TODO


-- ============================================================================
-- 练习 2: 列表操作（5 题）
-- ============================================================================

{- | 2.1 获取列表的第二个元素
假设列表至少有 2 个元素

示例：
  secondElement [1,2,3]    应该返回 2
  secondElement "Hello"    应该返回 'e'
-}
secondElement :: [a] -> a
secondElement xs = undefined  -- TODO


{- | 2.2 检查列表是否包含某个元素
使用递归实现

示例：
  contains 3 [1,2,3,4]  应该返回 True
  contains 5 [1,2,3,4]  应该返回 False
-}
contains :: Eq a => a -> [a] -> Bool
contains x xs = undefined  -- TODO


{- | 2.3 移除列表的第一个和最后一个元素
假设列表至少有 2 个元素

示例：
  removeFirstLast [1,2,3,4]  应该返回 [2,3]
  removeFirstLast "Hello"    应该返回 "ell"
-}
removeFirstLast :: [a] -> [a]
removeFirstLast xs = undefined  -- TODO


{- | 2.4 获取列表的前 3 个元素
如果列表不足 3 个元素，返回整个列表

示例：
  firstThree [1,2,3,4,5]  应该返回 [1,2,3]
  firstThree [1,2]        应该返回 [1,2]
-}
firstThree :: [a] -> [a]
firstThree xs = undefined  -- TODO


{- | 2.5 判断列表是否为单元素列表

示例：
  isSingleton [1]    应该返回 True
  isSingleton [1,2]  应该返回 False
  isSingleton []     应该返回 False
-}
isSingleton :: [a] -> Bool
isSingleton xs = undefined  -- TODO


-- ============================================================================
-- 练习 3: 递归（5 题）
-- ============================================================================

{- | 3.1 计算列表中所有元素的乘积
空列表的乘积为 1

示例：
  productList [1,2,3,4]  应该返回 24
  productList []         应该返回 1
-}
productList :: [Int] -> Int
productList xs = undefined  -- TODO


{- | 3.2 复制元素 n 次
生成包含 n 个相同元素的列表

示例：
  replicateN 3 'a'  应该返回 "aaa"
  replicateN 5 0    应该返回 [0,0,0,0,0]
-}
replicateN :: Int -> a -> [a]
replicateN n x = undefined  -- TODO


{- | 3.3 取列表的前 n 个元素
手动实现 take 函数

示例：
  takeN 3 [1,2,3,4,5]  应该返回 [1,2,3]
  takeN 10 [1,2,3]     应该返回 [1,2,3]
-}
takeN :: Int -> [a] -> [a]
takeN n xs = undefined  -- TODO


{- | 3.4 丢弃列表的前 n 个元素
手动实现 drop 函数

示例：
  dropN 2 [1,2,3,4,5]  应该返回 [3,4,5]
  dropN 10 [1,2,3]     应该返回 []
-}
dropN :: Int -> [a] -> [a]
dropN n xs = undefined  -- TODO


{- | 3.5 在列表的每个元素之间插入分隔符

示例：
  intersperse ',' "abc"   应该返回 "a,b,c"
  intersperse 0 [1,2,3]   应该返回 [1,0,2,0,3]
-}
intersperse :: a -> [a] -> [a]
intersperse sep xs = undefined  -- TODO


-- ============================================================================
-- 练习 4: 高阶函数（5 题）
-- ============================================================================

{- | 4.1 将列表中所有数字加 1
使用 map

示例：
  incrementAll [1,2,3]  应该返回 [2,3,4]
-}
incrementAll :: [Int] -> [Int]
incrementAll xs = undefined  -- TODO: 使用 map


{- | 4.2 保留所有正数
使用 filter

示例：
  onlyPositive [1,-2,3,-4,5]  应该返回 [1,3,5]
-}
onlyPositive :: [Int] -> [Int]
onlyPositive xs = undefined  -- TODO: 使用 filter


{- | 4.3 计算所有奇数的和
使用 filter 和 sum

示例：
  sumOdds [1,2,3,4,5]  应该返回 9
-}
sumOdds :: [Int] -> Int
sumOdds xs = undefined  -- TODO


{- | 4.4 计算列表中所有字符串的总长度
使用 map 和 sum

示例：
  totalLength ["hello", "world"]  应该返回 10
-}
totalLength :: [String] -> Int
totalLength xs = undefined  -- TODO


{- | 4.5 获取所有偶数的平方
组合使用 filter 和 map

示例：
  evenSquares [1,2,3,4,5]  应该返回 [4,16]
-}
evenSquares :: [Int] -> [Int]
evenSquares xs = undefined  -- TODO


-- ============================================================================
-- 练习 5: Lambda 表达式（5 题）
-- ============================================================================

{- | 5.1 使用 lambda 将列表中所有数字平方

示例：
  squareAll [1,2,3,4]  应该返回 [1,4,9,16]
-}
squareAll :: [Int] -> [Int]
squareAll xs = undefined  -- TODO: 使用 map 和 lambda


{- | 5.2 使用 lambda 过滤长度大于 3 的字符串

示例：
  longStrings ["hi", "hello", "bye", "world"]  应该返回 ["hello", "world"]
-}
longStrings :: [String] -> [String]
longStrings xs = undefined  -- TODO: 使用 filter 和 lambda


{- | 5.3 使用 lambda 对列表中的数字进行自定义转换
如果数字是偶数，除以 2；否则乘以 3

示例：
  customTransform [1,2,3,4,5]  应该返回 [3,1,9,2,15]
-}
customTransform :: [Int] -> [Int]
customTransform xs = undefined  -- TODO: 使用 map 和 lambda


{- | 5.4 使用 lambda 和 foldr 连接字符串列表
在每个字符串之间添加空格

示例：
  joinWithSpaces ["Hello", "World"]  应该返回 "Hello World"
-}
joinWithSpaces :: [String] -> String
joinWithSpaces xs = undefined  -- TODO: 使用 foldr 和 lambda


{- | 5.5 使用 lambda 和 filter 移除列表中的所有偶数

示例：
  removeEvens [1,2,3,4,5,6]  应该返回 [1,3,5]
-}
removeEvens :: [Int] -> [Int]
removeEvens xs = undefined  -- TODO: 使用 filter 和 lambda


-- ============================================================================
-- 测试函数
-- ============================================================================

-- 测试所有练习
testAll :: IO ()
testAll = do
  putStrLn "测试练习 1: 基础函数"
  print $ circleArea 2.0
  print $ isAdult 18
  print $ absDiff 5 3
  print $ distance 0 0 3 4
  print $ fahrenheitToCelsius 32
  
  putStrLn "\n测试练习 2: 列表操作"
  print $ secondElement [1,2,3]
  print $ contains 3 [1,2,3,4]
  print $ removeFirstLast [1,2,3,4]
  print $ firstThree [1,2,3,4,5]
  print $ isSingleton [1]
  
  putStrLn "\n测试练习 3: 递归"
  print $ productList [1,2,3,4]
  print $ replicateN 3 'a'
  print $ takeN 3 [1,2,3,4,5]
  print $ dropN 2 [1,2,3,4,5]
  print $ intersperse ',' "abc"
  
  putStrLn "\n测试练习 4: 高阶函数"
  print $ incrementAll [1,2,3]
  print $ onlyPositive [1,-2,3,-4,5]
  print $ sumOdds [1,2,3,4,5]
  print $ totalLength ["hello", "world"]
  print $ evenSquares [1,2,3,4,5]
  
  putStrLn "\n测试练习 5: Lambda 表达式"
  print $ squareAll [1,2,3,4]
  print $ longStrings ["hi", "hello", "bye", "world"]
  print $ customTransform [1,2,3,4,5]
  print $ joinWithSpaces ["Hello", "World"]
  print $ removeEvens [1,2,3,4,5,6]

