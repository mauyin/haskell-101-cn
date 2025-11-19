{- |
Week 2 - 练习作业: 数据类型与模式匹配
================================

本文件包含 25 道练习题，涵盖 ADT、Maybe、Either、记录和树。

如何使用：
1. 完成每个标记为 TODO 的函数/类型
2. 在 GHCi 中测试：ghci> :load Week02Exercises.hs
3. 运行测试函数验证答案
4. 完成后对照 solutions/ 中的参考答案

提示：
- 有些题目需要你先定义类型
- 模式匹配要覆盖所有情况
- 优先使用 Maybe/Either 处理错误
-}

module Week02Exercises where

-- ============================================================================
-- 练习 1: 元组操作（4 题）
-- ============================================================================

{- | 1.1 创建坐标点
给定 x 和 y 坐标，返回一个点（二元组）

示例：
  makePoint 3 4  应该返回 (3, 4)
-}
makePoint :: Int -> Int -> (Int, Int)
makePoint x y = undefined  -- TODO


{- | 1.2 计算两点的中点

示例：
  midpoint (0, 0) (4, 4)  应该返回 (2.0, 2.0)
  midpoint (1, 2) (3, 6)  应该返回 (2.0, 4.0)
-}
midpoint :: (Double, Double) -> (Double, Double) -> (Double, Double)
midpoint p1 p2 = undefined  -- TODO


{- | 1.3 提取三元组的第三个元素

示例：
  thirdElement (1, 2, 3)  应该返回 3
  thirdElement ("a", "b", "c")  应该返回 "c"
-}
thirdElement :: (a, b, c) -> c
thirdElement triple = undefined  -- TODO


{- | 1.4 创建三维点并计算到原点的距离

示例：
  distanceFromOrigin (3, 4, 0)  应该返回 5.0
  distanceFromOrigin (1, 1, 1)  应该返回 1.732...
-}
distanceFromOrigin :: (Double, Double, Double) -> Double
distanceFromOrigin point = undefined  -- TODO


-- ============================================================================
-- 练习 2: 简单 ADT（5 题）
-- ============================================================================

{- | 2.1 定义星期枚举并判断是否为工作日

定义 Weekday 类型，包含一周七天
实现 isWeekday 函数，判断是否为工作日（周一到周五）

示例：
  isWeekday Monday   应该返回 True
  isWeekday Saturday 应该返回 False
-}
data Weekday = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
  deriving (Show, Eq)

isWeekday :: Weekday -> Bool
isWeekday day = undefined  -- TODO


{- | 2.2 定义温度类型并实现转换

定义 Temperature 类型，可以表示摄氏度或华氏度
实现 toCelsius 函数，统一转换为摄氏度

示例：
  toCelsius (Celsius 100)     应该返回 100.0
  toCelsius (Fahrenheit 212)  应该返回 100.0
-}
data Temperature = Celsius Double | Fahrenheit Double
  deriving (Show)

toCelsius :: Temperature -> Double
toCelsius temp = undefined  -- TODO


{- | 2.3 定义形状类型并计算周长

定义 Shape 类型：圆形（半径）、矩形（宽、高）、三角形（三边）
实现 perimeter 函数计算周长

示例：
  perimeter (Circle 5)          应该返回 31.4159...
  perimeter (Rectangle 3 4)     应该返回 14.0
  perimeter (Triangle 3 4 5)    应该返回 12.0
-}
data Shape = Circle Double
           | Rectangle Double Double
           | Triangle Double Double Double
  deriving (Show)

perimeter :: Shape -> Double
perimeter shape = undefined  -- TODO


{- | 2.4 定义交通信号灯并返回下一个状态

示例：
  nextLight Red    应该返回 Green
  nextLight Green  应该返回 Yellow
  nextLight Yellow 应该返回 Red
-}
data TrafficLight = Red | Yellow | Green
  deriving (Show, Eq)

nextLight :: TrafficLight -> TrafficLight
nextLight light = undefined  -- TODO


{- | 2.5 定义结果类型（成功或失败）

定义 Result 类型，类似 Either 但使用 Success 和 Failure
实现 isSuccess 判断是否成功

示例：
  isSuccess (Success 42)       应该返回 True
  isSuccess (Failure "error")  应该返回 False
-}
data Result e a = Success a | Failure e
  deriving (Show, Eq)

isSuccess :: Result e a -> Bool
isSuccess result = undefined  -- TODO


-- ============================================================================
-- 练习 3: Maybe 类型（5 题）
-- ============================================================================

{- | 3.1 安全的列表最后一个元素

示例：
  safeLast [1,2,3]  应该返回 Just 3
  safeLast []       应该返回 Nothing
-}
safeLast :: [a] -> Maybe a
safeLast xs = undefined  -- TODO


{- | 3.2 安全的列表索引访问

示例：
  safeIndex 0 [1,2,3]  应该返回 Just 1
  safeIndex 5 [1,2,3]  应该返回 Nothing
-}
safeIndex :: Int -> [a] -> Maybe a
safeIndex n xs = undefined  -- TODO


{- | 3.3 安全的查找（在键值对列表中）

示例：
  safeLookup "age" [("name", "Alice"), ("age", "25")]  应该返回 Just "25"
  safeLookup "city" [("name", "Alice")]                应该返回 Nothing
-}
safeLookup :: Eq a => a -> [(a, b)] -> Maybe b
safeLookup key pairs = undefined  -- TODO


{- | 3.4 组合两个 Maybe 值（都存在时相加）

示例：
  combineMaybe (Just 3) (Just 5)  应该返回 Just 8
  combineMaybe (Just 3) Nothing   应该返回 Nothing
  combineMaybe Nothing (Just 5)   应该返回 Nothing
-}
combineMaybe :: Maybe Int -> Maybe Int -> Maybe Int
combineMaybe mx my = undefined  -- TODO


{- | 3.5 从 Maybe 中提取值，提供默认值

示例：
  getOrDefault 0 (Just 42)  应该返回 42
  getOrDefault 0 Nothing    应该返回 0
-}
getOrDefault :: a -> Maybe a -> a
getOrDefault def mx = undefined  -- TODO


-- ============================================================================
-- 练习 4: Either 类型（4 题）
-- ============================================================================

{- | 4.1 安全除法（返回错误信息）

示例：
  divideWithError 10 2  应该返回 Right 5
  divideWithError 10 0  应该返回 Left "Division by zero"
-}
divideWithError :: Int -> Int -> Either String Int
divideWithError x y = undefined  -- TODO


{- | 4.2 解析整数（带错误信息）

提示：使用 reads :: Read a => String -> [(a, String)]
如果解析成功，reads 返回 [(value, remaining)]

示例：
  parseInt "42"   应该返回 Right 42
  parseInt "abc"  应该返回 Left "Not a number: abc"
  parseInt ""     应该返回 Left "Empty string"
-}
parseInt :: String -> Either String Int
parseInt str = undefined  -- TODO


{- | 4.3 验证年龄（返回具体错误）

年龄必须在 0-150 之间

示例：
  validateAge 25    应该返回 Right 25
  validateAge (-5)  应该返回 Left "Age cannot be negative"
  validateAge 200   应该返回 Left "Age too large (maximum: 150)"
-}
validateAge :: Int -> Either String Int
validateAge age = undefined  -- TODO


{- | 4.4 验证邮箱格式（简化版）

简单规则：必须包含 '@' 且不为空

示例：
  validateEmail "user@example.com"  应该返回 Right "user@example.com"
  validateEmail "invalid"           应该返回 Left "Email must contain @"
  validateEmail ""                  应该返回 Left "Email cannot be empty"
-}
validateEmail :: String -> Either String String
validateEmail email = undefined  -- TODO


-- ============================================================================
-- 练习 5: 记录语法（2 题）
-- ============================================================================

{- | 5.1 定义学生记录并更新成绩

定义 Student 类型，包含：姓名、年龄、成绩（A-F）
实现 updateGrade 更新学生的成绩

示例：
  let student = Student "Alice" 20 'B'
  updateGrade student 'A'  -- 应该返回成绩为 'A' 的学生
-}
data Student = Student
  { studentName :: String
  , studentAge :: Int
  , studentGrade :: Char
  }
  deriving (Show, Eq)

updateGrade :: Student -> Char -> Student
updateGrade student newGrade = undefined  -- TODO


{- | 5.2 定义书籍记录并实现折扣

定义 Book 类型，包含：标题、作者、价格
实现 applyDiscount 应用折扣（0.0-1.0 表示 0%-100%）

示例：
  let book = Book "Haskell Guide" "Author" 100.0
  applyDiscount 0.2 book  -- 应该返回价格为 80.0 的书
-}
data Book = Book
  { bookTitle :: String
  , bookAuthor :: String
  , bookPrice :: Double
  }
  deriving (Show, Eq)

applyDiscount :: Double -> Book -> Book
applyDiscount discount book = undefined  -- TODO


-- ============================================================================
-- 练习 6: 树结构（5 题）
-- ============================================================================

{- | 定义二叉树 -}
data Tree a = EmptyTree | Node a (Tree a) (Tree a)
  deriving (Show, Eq)

{- | 6.1 创建单个节点的树

示例：
  singletonTree 42  应该返回 Node 42 EmptyTree EmptyTree
-}
singletonTree :: a -> Tree a
singletonTree x = undefined  -- TODO


{- | 6.2 计算树的节点数

示例：
  treeSize EmptyTree                                    应该返回 0
  treeSize (Node 1 EmptyTree EmptyTree)                 应该返回 1
  treeSize (Node 1 (Node 2 EmptyTree EmptyTree) EmptyTree)  应该返回 2
-}
treeSize :: Tree a -> Int
treeSize tree = undefined  -- TODO


{- | 6.3 计算树的深度/高度

空树深度为 0，单节点树深度为 1

示例：
  treeDepth EmptyTree                                   应该返回 0
  treeDepth (Node 1 EmptyTree EmptyTree)                应该返回 1
  treeDepth (Node 1 (Node 2 EmptyTree EmptyTree) EmptyTree)  应该返回 2
-}
treeDepth :: Tree a -> Int
treeDepth tree = undefined  -- TODO


{- | 6.4 查找元素是否在树中

示例：
  let tree = Node 5 (Node 3 EmptyTree EmptyTree) (Node 7 EmptyTree EmptyTree)
  treeContains 3 tree  应该返回 True
  treeContains 10 tree 应该返回 False
-}
treeContains :: Eq a => a -> Tree a -> Bool
treeContains x tree = undefined  -- TODO


{- | 6.5 将树转换为列表（中序遍历）

对于二叉搜索树，中序遍历会得到有序列表

示例：
  let tree = Node 5 (Node 3 EmptyTree EmptyTree) (Node 7 EmptyTree EmptyTree)
  treeToList tree  应该返回 [3, 5, 7]
-}
treeToList :: Tree a -> [a]
treeToList tree = undefined  -- TODO


-- ============================================================================
-- 测试函数
-- ============================================================================

testAll :: IO ()
testAll = do
  putStrLn "测试练习 1: 元组操作"
  print $ makePoint 3 4
  print $ midpoint (0, 0) (4, 4)
  print $ thirdElement (1, 2, 3)
  print $ distanceFromOrigin (3, 4, 0)
  
  putStrLn "\n测试练习 2: 简单 ADT"
  print $ isWeekday Monday
  print $ isWeekday Saturday
  print $ toCelsius (Fahrenheit 212)
  print $ perimeter (Circle 5)
  print $ nextLight Red
  print $ isSuccess (Success 42)
  
  putStrLn "\n测试练习 3: Maybe 类型"
  print $ safeLast [1,2,3]
  print $ safeLast ([] :: [Int])
  print $ safeIndex 0 [1,2,3]
  print $ safeLookup "age" [("name", "Alice"), ("age", "25")]
  print $ combineMaybe (Just 3) (Just 5)
  print $ getOrDefault 0 (Just 42)
  
  putStrLn "\n测试练习 4: Either 类型"
  print $ divideWithError 10 2
  print $ divideWithError 10 0
  print $ parseInt "42"
  print $ parseInt "abc"
  print $ validateAge 25
  print $ validateEmail "user@example.com"
  
  putStrLn "\n测试练习 5: 记录语法"
  let student = Student "Alice" 20 'B'
  print $ updateGrade student 'A'
  let book = Book "Haskell Guide" "Author" 100.0
  print $ applyDiscount 0.2 book
  
  putStrLn "\n测试练习 6: 树结构"
  let tree = Node 5 (Node 3 EmptyTree EmptyTree) (Node 7 EmptyTree EmptyTree)
  print $ singletonTree 42
  print $ treeSize tree
  print $ treeDepth tree
  print $ treeContains 3 tree
  print $ treeToList tree

