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
-- 提示：使用 abs 函数
-- abs 函数计算一个数的绝对值：abs (-3) = 3


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
-- 提示 1：使用递归和模式匹配
-- 提示 2：基础情况 - 空列表包含任何元素吗？
-- 提示 3：如果第一个元素 == x，返回什么？
-- 提示 4：否则，检查剩余的列表


{- | 2.3 移除列表的第一个和最后一个元素
假设列表至少有 2 个元素

示例：
  removeFirstLast [1,2,3,4]  应该返回 [2,3]
  removeFirstLast "Hello"    应该返回 "ell"
-}
removeFirstLast :: [a] -> [a]
removeFirstLast xs = undefined  -- TODO
-- 提示 1：使用 tail 移除第一个元素
-- 提示 2：使用 init 移除最后一个元素
-- 提示 3：组合使用这两个函数


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
-- 提示 1：使用递归和模式匹配
-- 提示 2：基础情况 - 空列表的乘积是 1（为什么不是 0？）
-- 提示 3：递归情况 - 第一个元素 * 剩余元素的乘积
-- 类比：这和 sum 函数很像，只是把 + 换成 *，把 0 换成 1


{- | 3.2 复制元素 n 次
生成包含 n 个相同元素的列表

示例：
  replicateN 3 'a'  应该返回 "aaa"
  replicateN 5 0    应该返回 [0,0,0,0,0]
-}
replicateN :: Int -> a -> [a]
replicateN n x = undefined  -- TODO
-- 提示 1：基础情况 - 复制 0 次返回什么？
-- 提示 2：递归情况 - 把 x 加到"复制 n-1 次"的结果前面
-- 提示 3：使用 : (cons) 运算符构造列表


{- | 3.3 取列表的前 n 个元素
手动实现 take 函数

示例：
  takeN 3 [1,2,3,4,5]  应该返回 [1,2,3]
  takeN 10 [1,2,3]     应该返回 [1,2,3]
-}
takeN :: Int -> [a] -> [a]
takeN n xs = undefined  -- TODO
-- 提示 1：需要两个基础情况！
--   - n == 0 时返回什么？
--   - xs == [] 时返回什么？
-- 提示 2：递归情况 - 取第一个元素，然后取剩余列表的 n-1 个元素
-- 提示 3：模式匹配可以这样写：takeN n (x:xs) = ...


{- | 3.4 丢弃列表的前 n 个元素
手动实现 drop 函数

示例：
  dropN 2 [1,2,3,4,5]  应该返回 [3,4,5]
  dropN 10 [1,2,3]     应该返回 []
-}
dropN :: Int -> [a] -> [a]
dropN n xs = undefined  -- TODO
-- 提示 1：基础情况 - 当 n == 0 时，返回整个列表
-- 提示 2：基础情况 - 当列表为空时，返回空列表
-- 提示 3：递归情况 - 丢弃第一个元素，继续丢弃剩余列表的 n-1 个元素
-- 注意：dropN 不保留第一个元素，只是跳过它！


{- | 3.5 在列表的每个元素之间插入分隔符
⚠️ 这题有一定难度！如果卡住了 10 分钟，可以先跳过。

示例：
  intersperse ',' "abc"   应该返回 "a,b,c"
  intersperse 0 [1,2,3]   应该返回 [1,0,2,0,3]
-}
intersperse :: a -> [a] -> [a]
intersperse sep xs = undefined  -- TODO
-- 提示 1：需要三个模式匹配！
--   - 空列表 [] 返回什么？
--   - 单个元素 [x] 返回什么？（不需要分隔符！）
--   - 多个元素 (x:xs) 时怎么处理？
-- 提示 2：多个元素时，返回：x : sep : intersperse sep xs
-- 提示 3：试试小例子理解：intersperse ',' "ab"
--   - 不是单个元素，所以用第三个模式
--   - 'a' : ',' : intersperse ',' "b"
--   - 'a' : ',' : "b"  （因为 "b" 是单个元素）
--   - "a,b"


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
-- 提示 1：先用 filter odd 找出所有奇数
-- 提示 2：然后用 sum 求和
-- 提示 3：组合：sum (filter odd xs)


{- | 4.4 计算列表中所有字符串的总长度
使用 map 和 sum

示例：
  totalLength ["hello", "world"]  应该返回 10
-}
totalLength :: [String] -> Int
totalLength xs = undefined  -- TODO
-- 提示 1：先用 map length 把每个字符串转换成它的长度
--   例如：["hello", "world"] 变成 [5, 5]
-- 提示 2：然后用 sum 把所有长度加起来
-- 提示 3：组合：sum (map length xs)


{- | 4.5 获取所有偶数的平方
组合使用 filter 和 map

示例：
  evenSquares [1,2,3,4,5]  应该返回 [4,16]
-}
evenSquares :: [Int] -> [Int]
evenSquares xs = undefined  -- TODO
-- 提示 1：第一步 - 用 filter even 找出所有偶数
--   [1,2,3,4,5] -> [2,4]
-- 提示 2：第二步 - 用 map (^2) 对每个数平方
--   [2,4] -> [4,16]
-- 提示 3：组合：map (^2) (filter even xs)
-- 注意顺序：先 filter，再 map


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
-- 提示 1：使用 map 和 lambda：map (\x -> ...) xs
-- 提示 2：lambda 里需要 if-then-else
--   if even x then x `div` 2 else x * 3
-- 提示 3：完整形式：map (\x -> if even x then x `div` 2 else x * 3) xs


{- | 5.4 使用 lambda 和 foldr 连接字符串列表
在每个字符串之间添加空格
⚠️ 这题较难，可以先跳过！

示例：
  joinWithSpaces ["Hello", "World"]  应该返回 "Hello World"
-}
joinWithSpaces :: [String] -> String
joinWithSpaces xs = undefined  -- TODO: 使用 foldr 和 lambda
-- 提示 1：简单方法 - 使用 unwords 函数（如果允许的话）
-- 提示 2：使用 foldr 的方法比较复杂，需要特殊处理
-- 提示 3：可以先试试用 foldr (++) "" 连接，然后思考如何加空格
-- 高级提示：foldr 需要一个函数 \s acc -> ...，在 s 和 acc 之间加空格


{- | 5.5 使用 lambda 和 filter 移除列表中的所有偶数

示例：
  removeEvens [1,2,3,4,5,6]  应该返回 [1,3,5]
-}
removeEvens :: [Int] -> [Int]
removeEvens xs = undefined  -- TODO: 使用 filter 和 lambda


-- ============================================================================
-- 测试函数
-- ============================================================================

{- 使用方法：
1. 在 GHCi 中加载：ghci> :load Week01Exercises.hs
2. 运行测试：ghci> testAll
3. 对比输出和预期结果
4. 或者运行自动测试：ghci> runTests（会显示通过/失败）
-}

-- 测试所有练习（显示实际输出）
testAll :: IO ()
testAll = do
  putStrLn "=== 测试练习 1: 基础函数 ==="
  putStrLn "circleArea 2.0 (期望 ~12.57):"
  print $ circleArea 2.0
  
  putStrLn "\nisAdult 18 (期望 True):"
  print $ isAdult 18
  
  putStrLn "isAdult 17 (期望 False):"
  print $ isAdult 17
  
  putStrLn "\nabsDiff 5 3 (期望 2):"
  print $ absDiff 5 3
  
  putStrLn "absDiff 3 5 (期望 2):"
  print $ absDiff 3 5
  
  putStrLn "\ndistance 0 0 3 4 (期望 5.0):"
  print $ distance 0 0 3 4
  
  putStrLn "\nfahrenheitToCelsius 32 (期望 0.0):"
  print $ fahrenheitToCelsius 32
  
  putStrLn "\n=== 测试练习 2: 列表操作 ==="
  putStrLn "secondElement [1,2,3] (期望 2):"
  print $ secondElement [1,2,3]
  
  putStrLn "\ncontains 3 [1,2,3,4] (期望 True):"
  print $ contains 3 [1,2,3,4]
  
  putStrLn "contains 5 [1,2,3,4] (期望 False):"
  print $ contains 5 [1,2,3,4]
  
  putStrLn "\nremoveFirstLast [1,2,3,4] (期望 [2,3]):"
  print $ removeFirstLast [1,2,3,4]
  
  putStrLn "\nfirstThree [1,2,3,4,5] (期望 [1,2,3]):"
  print $ firstThree [1,2,3,4,5]
  
  putStrLn "\nisSingleton [1] (期望 True):"
  print $ isSingleton [1]
  
  putStrLn "isSingleton [1,2] (期望 False):"
  print $ isSingleton [1,2]
  
  putStrLn "\n=== 测试练习 3: 递归 ==="
  putStrLn "productList [1,2,3,4] (期望 24):"
  print $ productList [1,2,3,4]
  
  putStrLn "\nreplicateN 3 'a' (期望 \"aaa\"):"
  print $ replicateN 3 'a'
  
  putStrLn "\ntakeN 3 [1,2,3,4,5] (期望 [1,2,3]):"
  print $ takeN 3 [1,2,3,4,5]
  
  putStrLn "\ndropN 2 [1,2,3,4,5] (期望 [3,4,5]):"
  print $ dropN 2 [1,2,3,4,5]
  
  putStrLn "\nintersperse ',' \"abc\" (期望 \"a,b,c\"):"
  print $ intersperse ',' "abc"
  
  putStrLn "\n=== 测试练习 4: 高阶函数 ==="
  putStrLn "incrementAll [1,2,3] (期望 [2,3,4]):"
  print $ incrementAll [1,2,3]
  
  putStrLn "\nonlyPositive [1,-2,3,-4,5] (期望 [1,3,5]):"
  print $ onlyPositive [1,-2,3,-4,5]
  
  putStrLn "\nsumOdds [1,2,3,4,5] (期望 9):"
  print $ sumOdds [1,2,3,4,5]
  
  putStrLn "\ntotalLength [\"hello\", \"world\"] (期望 10):"
  print $ totalLength ["hello", "world"]
  
  putStrLn "\nevenSquares [1,2,3,4,5] (期望 [4,16]):"
  print $ evenSquares [1,2,3,4,5]
  
  putStrLn "\n=== 测试练习 5: Lambda 表达式 ==="
  putStrLn "squareAll [1,2,3,4] (期望 [1,4,9,16]):"
  print $ squareAll [1,2,3,4]
  
  putStrLn "\nlongStrings [\"hi\", \"hello\", \"bye\", \"world\"] (期望 [\"hello\",\"world\"]):"
  print $ longStrings ["hi", "hello", "bye", "world"]
  
  putStrLn "\ncustomTransform [1,2,3,4,5] (期望 [3,1,9,2,15]):"
  print $ customTransform [1,2,3,4,5]
  
  putStrLn "\njoinWithSpaces [\"Hello\", \"World\"] (期望 \"Hello World\"):"
  print $ joinWithSpaces ["Hello", "World"]
  
  putStrLn "\nremoveEvens [1,2,3,4,5,6] (期望 [1,3,5]):"
  print $ removeEvens [1,2,3,4,5,6]
  
  putStrLn "\n=== 完成！==="
  putStrLn "对比你的输出和期望的结果。"
  putStrLn "如果有不匹配的，检查你的实现。"


-- 自动测试（显示通过/失败）
runTests :: IO ()
runTests = do
  putStrLn "=== 运行自动测试 ==="
  
  -- 练习 1
  test "1.1 circleArea" (abs (circleArea 2.0 - 12.566370614359172) < 0.001)
  test "1.2 isAdult (True)" (isAdult 18 == True)
  test "1.2 isAdult (False)" (isAdult 17 == False)
  test "1.3 absDiff" (absDiff 5 3 == 2 && absDiff 3 5 == 2)
  test "1.4 distance" (abs (distance 0 0 3 4 - 5.0) < 0.001)
  test "1.5 fahrenheitToCelsius" (abs (fahrenheitToCelsius 32 - 0.0) < 0.001)
  
  -- 练习 2
  test "2.1 secondElement" (secondElement [1,2,3] == 2)
  test "2.2 contains (True)" (contains 3 [1,2,3,4] == True)
  test "2.2 contains (False)" (contains 5 [1,2,3,4] == False)
  test "2.3 removeFirstLast" (removeFirstLast [1,2,3,4] == [2,3])
  test "2.4 firstThree" (firstThree [1,2,3,4,5] == [1,2,3])
  test "2.5 isSingleton (True)" (isSingleton [1] == True)
  test "2.5 isSingleton (False)" (isSingleton [1,2] == False)
  
  -- 练习 3
  test "3.1 productList" (productList [1,2,3,4] == 24)
  test "3.2 replicateN" (replicateN 3 'a' == "aaa")
  test "3.3 takeN" (takeN 3 [1,2,3,4,5] == [1,2,3])
  test "3.4 dropN" (dropN 2 [1,2,3,4,5] == [3,4,5])
  test "3.5 intersperse" (intersperse ',' "abc" == "a,b,c")
  
  -- 练习 4
  test "4.1 incrementAll" (incrementAll [1,2,3] == [2,3,4])
  test "4.2 onlyPositive" (onlyPositive [1,-2,3,-4,5] == [1,3,5])
  test "4.3 sumOdds" (sumOdds [1,2,3,4,5] == 9)
  test "4.4 totalLength" (totalLength ["hello", "world"] == 10)
  test "4.5 evenSquares" (evenSquares [1,2,3,4,5] == [4,16])
  
  -- 练习 5
  test "5.1 squareAll" (squareAll [1,2,3,4] == [1,4,9,16])
  test "5.2 longStrings" (longStrings ["hi", "hello", "bye", "world"] == ["hello", "world"])
  test "5.3 customTransform" (customTransform [1,2,3,4,5] == [3,1,9,2,15])
  test "5.4 joinWithSpaces" (joinWithSpaces ["Hello", "World"] == "Hello World")
  test "5.5 removeEvens" (removeEvens [1,2,3,4,5,6] == [1,3,5])
  
  putStrLn "\n=== 测试完成 ==="

-- 辅助函数：测试单个条件
test :: String -> Bool -> IO ()
test name condition = 
  if condition
    then putStrLn $ "✓ " ++ name
    else putStrLn $ "✗ " ++ name ++ " - 失败"

