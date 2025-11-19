{-
  Week 3: 类型类练习
  
  完成以下练习，实现 TODO 标记的部分。
  在 GHCi 中测试你的实现：
  
  ghci> :load Week03Exercises.hs
  ghci> testFunction args
-}

module Week03Exercises where

import Data.List (sort)

{- ============================================
   练习 1: Eq 实例 (5 题)
   难度: ⭐⭐☆☆☆
   ============================================ -}

-- 1.1 颜色类型
data Color = Red | Green | Blue

instance Eq Color where
  -- TODO: 实现 (==)
  -- 提示：每个颜色只与自己相等
  (==) = undefined

-- 测试：
-- Red == Red          --> True
-- Red == Blue         --> False


-- 1.2 扑克牌点数
data Rank = Ace | Two | Three | Four | Five 
          | Six | Seven | Eight | Nine | Ten
          | Jack | Queen | King

instance Eq Rank where
  -- TODO: 实现 (==)
  (==) = undefined


-- 1.3 点类型（包含坐标）
data Point = Point Int Int

instance Eq Point where
  -- TODO: 实现 (==)
  -- 提示：两个点的 x 和 y 坐标都相同才相等
  Point x1 y1 == Point x2 y2 = undefined

-- 测试：
-- Point 1 2 == Point 1 2  --> True
-- Point 1 2 == Point 2 1  --> False


-- 1.4 温度类型（摄氏度）
data Temperature = Celsius Double

instance Eq Temperature where
  -- TODO: 实现 (==)
  Celsius t1 == Celsius t2 = undefined


-- 1.5 用户类型
data User = User
  { userId :: Int
  , userName :: String
  }

instance Eq User where
  -- TODO: 实现 (==)
  -- 提示：只比较 userId
  (==) = undefined


{- ============================================
   练习 2: Ord 实例 (5 题)
   难度: ⭐⭐☆☆☆
   ============================================ -}

-- 2.1 优先级类型
data Priority = Low | Medium | High
  deriving (Eq, Show)

instance Ord Priority where
  -- TODO: 实现 compare
  -- Low < Medium < High
  compare = undefined

-- 测试：
-- sort [High, Low, Medium]  --> [Low, Medium, High]
-- Low < High                 --> True


-- 2.2 扑克牌点数排序
instance Ord Rank where
  -- TODO: 实现 compare
  -- Ace < Two < Three < ... < King
  compare = undefined


-- 2.3 点类型排序
instance Ord Point where
  -- TODO: 实现 compare
  -- 先比较 x 坐标，x 相同再比较 y 坐标
  compare (Point x1 y1) (Point x2 y2) = undefined

-- 测试：
-- Point 1 2 < Point 1 3  --> True
-- Point 1 2 < Point 2 1  --> True


-- 2.4 温度排序
instance Ord Temperature where
  -- TODO: 实现 compare
  compare (Celsius t1) (Celsius t2) = undefined


-- 2.5 文件大小类型
data FileSize = Bytes Int
  deriving (Eq)

instance Ord FileSize where
  -- TODO: 实现 compare
  compare (Bytes s1) (Bytes s2) = undefined


{- ============================================
   练习 3: Show 实例 (5 题)
   难度: ⭐⭐☆☆☆
   ============================================ -}

-- 3.1 颜色的友好显示
instance Show Color where
  -- TODO: 显示为中文
  -- show Red   --> "红色"
  -- show Green --> "绿色"
  -- show Blue  --> "蓝色"
  show = undefined


-- 3.2 温度的单位显示
instance Show Temperature where
  -- TODO: 显示为 "20.0°C" 格式
  show (Celsius t) = undefined


-- 3.3 点的坐标显示
instance Show Point where
  -- TODO: 显示为 "(1, 2)" 格式
  show (Point x y) = undefined


-- 3.4 扑克牌花色
data Suit = Hearts | Diamonds | Clubs | Spades
  deriving (Eq)

instance Show Suit where
  show Hearts = "♥"
  show Diamonds = "♦"
  show Clubs = "♣"
  show Spades = "♠"

-- 扑克牌完整显示
data Card = Card Rank Suit

instance Show Card where
  -- TODO: 显示为 "A♠" 这样的格式
  show (Card rank suit) = undefined


-- 3.5 时间类型
data Time = Time Int Int  -- 小时 分钟

instance Show Time where
  -- TODO: 显示为 "14:30" 格式
  -- 提示：使用 show 或 printf
  show (Time h m) = undefined


{- ============================================
   练习 4: deriving 和组合 (5 题)
   难度: ⭐⭐⭐☆☆
   ============================================ -}

-- 4.1 使用 deriving
data Shape = Circle Double
           | Rectangle Double Double
           | Triangle Double Double Double
  deriving (Eq, Show)

-- 计算面积
area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle a b c) = 
  let s = (a + b + c) / 2
  in sqrt (s * (s - a) * (s - b) * (s - c))

-- TODO: 实现 Ord 实例，按面积大小排序
instance Ord Shape where
  compare = undefined


-- 4.2 方向枚举
data Direction = North | South | East | West
  deriving (Eq, Ord, Show, Enum, Bounded)

-- TODO: 实现函数获取所有方向
allDirections :: [Direction]
allDirections = undefined  -- 提示：使用 [minBound .. maxBound]


-- 4.3 交通信号灯
data TrafficLight = Red' | Yellow | Green'
  deriving (Eq, Show, Enum)

-- TODO: 实现下一个状态
-- Red' -> Yellow -> Green' -> Red' -> ...
nextLight :: TrafficLight -> TrafficLight
nextLight = undefined


-- 4.4 产品类型
data Product = Product
  { productName :: String
  , productPrice :: Double
  , productStock :: Int
  } deriving (Eq, Show)

-- TODO: 实现 Ord，按价格排序
instance Ord Product where
  compare = undefined


-- 4.5 结果类型
data Result a = Success a | Failure String
  deriving (Eq, Show)

-- TODO: 使这个类型支持 Functor
instance Functor Result where
  fmap = undefined


{- ============================================
   练习 5: Functor 练习 (5 题)
   难度: ⭐⭐⭐☆☆
   ============================================ -}

-- 5.1 使用 fmap 转换 Maybe
doubleIfPresent :: Maybe Int -> Maybe Int
doubleIfPresent = undefined  -- 使用 fmap

-- 测试：
-- doubleIfPresent (Just 5)  --> Just 10
-- doubleIfPresent Nothing   --> Nothing


-- 5.2 使用 <$> 操作符
addTen :: Maybe Int -> Maybe Int
addTen mx = undefined  -- 使用 <$>


-- 5.3 链式 fmap
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

calculatePercentage :: Double -> Double -> Maybe Double
calculatePercentage part total = undefined
  -- 提示：先除法，再乘以 100，使用 fmap


-- 5.4 Box 类型实现 Functor
data Box a = Empty | Full a
  deriving (Eq, Show)

instance Functor Box where
  fmap = undefined

-- 测试：
-- fmap (+1) (Full 5)  --> Full 6
-- fmap (+1) Empty     --> Empty


-- 5.5 Tree 类型实现 Functor
data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving (Eq, Show)

instance Functor Tree where
  fmap = undefined

-- 测试：
-- fmap (+1) (Leaf 5)             --> Leaf 6
-- fmap (*2) (Node (Leaf 1) (Leaf 2))  --> Node (Leaf 2) (Leaf 4)


{- ============================================
   练习 6: Applicative 练习 (5 题)
   难度: ⭐⭐⭐⭐☆
   ============================================ -}

-- 6.1 基础 Applicative 使用
addMaybe :: Maybe Int -> Maybe Int -> Maybe Int
addMaybe mx my = undefined  -- 使用 <$> 和 <*>

-- 测试：
-- addMaybe (Just 3) (Just 5)  --> Just 8
-- addMaybe (Just 3) Nothing   --> Nothing


-- 6.2 三个参数的函数
add3Maybe :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int
add3Maybe = undefined


-- 6.3 表单验证
data Person = Person String Int String  -- name age email
  deriving (Eq, Show)

validateName :: String -> Maybe String
validateName n = if length n > 0 then Just n else Nothing

validateAge :: Int -> Maybe Int  
validateAge a = if a >= 18 then Just a else Nothing

validateEmail :: String -> Maybe String
validateEmail e = if '@' `elem` e then Just e else Nothing

-- TODO: 组合验证创建 Person
createPerson :: String -> Int -> String -> Maybe Person
createPerson name age email = undefined
  -- 使用 Person <$> ... <*> ... <*> ...

-- 测试：
-- createPerson "Alice" 25 "alice@example.com"  --> Just (Person ...)
-- createPerson "" 25 "alice@example.com"        --> Nothing


-- 6.4 列表的 Applicative
allPairs :: [a] -> [b] -> [(a, b)]
allPairs xs ys = undefined  -- 使用 <$> 和 <*>

-- 测试：
-- allPairs [1,2] [10,20]  --> [(1,10),(1,20),(2,10),(2,20)]


-- 6.5 实现 Box 的 Applicative
instance Applicative Box where
  pure = undefined
  (<*>) = undefined

-- 测试：
-- pure (+) <*> Full 3 <*> Full 5  --> Full 8
-- pure (+) <*> Empty <*> Full 5   --> Empty


{- ============================================
   练习 7: Monad 入门 (5 题)
   难度: ⭐⭐⭐⭐☆
   ============================================ -}

-- 7.1 使用 >>= 链接操作
addOneIfEven :: Int -> Maybe Int
addOneIfEven n = if even n then Just (n + 1) else Nothing

processNumber :: Maybe Int -> Maybe Int
processNumber mx = undefined  -- 使用 >>= 和 addOneIfEven

-- 测试：
-- processNumber (Just 4)  --> Just 5
-- processNumber (Just 5)  --> Nothing


-- 7.2 安全除法链
calculate :: Double -> Maybe Double
calculate x = undefined
  -- 计算：((x / 2) / 3) / 4
  -- 使用 do 记法和 safeDivide


-- 7.3 查找链
type Database = [(String, Int)]

lookupAge :: String -> Database -> Maybe Int
lookupAge name db = lookup name db

lookupAndDouble :: String -> Database -> Maybe Int
lookupAndDouble name db = undefined
  -- 查找年龄并翻倍
  -- 使用 do 记法


-- 7.4 列表 Monad
pairs :: [Int] -> [Int] -> [(Int, Int)]
pairs xs ys = undefined
  -- 使用 do 记法生成所有配对

-- 测试：
-- pairs [1,2] [10,20]  --> [(1,10),(1,20),(2,10),(2,20)]


-- 7.5 实现 Box 的 Monad
instance Monad Box where
  return = undefined
  (>>=) = undefined

-- 测试：
-- Full 5 >>= (\x -> Full (x + 1))  --> Full 6
-- Empty >>= (\x -> Full (x + 1))   --> Empty
-- do { x <- Full 5; y <- Full 10; return (x + y) }  --> Full 15


{- ============================================
   辅助测试函数
   ============================================ -}

-- 测试 Eq 实例
testEq :: IO ()
testEq = do
  putStrLn "=== Testing Eq instances ==="
  print $ Red == Red
  print $ Red == Blue
  print $ Point 1 2 == Point 1 2
  print $ Celsius 20.0 == Celsius 20.0

-- 测试 Ord 实例
testOrd :: IO ()
testOrd = do
  putStrLn "\n=== Testing Ord instances ==="
  print $ sort [High, Low, Medium]
  print $ Low < High
  print $ sort [Point 2 1, Point 1 2, Point 1 1]

-- 测试 Show 实例
testShow :: IO ()
testShow = do
  putStrLn "\n=== Testing Show instances ==="
  print Red
  print $ Celsius 20.0
  print $ Point 1 2
  print $ Time 14 30

-- 测试 Functor
testFunctor :: IO ()
testFunctor = do
  putStrLn "\n=== Testing Functor instances ==="
  print $ fmap (+1) (Just 5)
  print $ fmap (*2) (Full 10)
  print $ fmap (+1) (Leaf 5)

-- 测试 Applicative
testApplicative :: IO ()
testApplicative = do
  putStrLn "\n=== Testing Applicative instances ==="
  print $ addMaybe (Just 3) (Just 5)
  print $ createPerson "Alice" 25 "alice@example.com"
  print $ allPairs [1,2] [10,20]

-- 测试 Monad
testMonad :: IO ()
testMonad = do
  putStrLn "\n=== Testing Monad instances ==="
  print $ processNumber (Just 4)
  print $ calculate 24
  print $ pairs [1,2] [10,20]

-- 运行所有测试
runAllTests :: IO ()
runAllTests = do
  testEq
  testOrd
  testShow
  testFunctor
  testApplicative
  testMonad
  putStrLn "\n=== All tests completed! ==="

