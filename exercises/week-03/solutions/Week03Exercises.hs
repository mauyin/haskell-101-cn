{-
  Week 3: 类型类练习 - 参考答案
  
  这是所有练习的完整解答。
  建议先独立完成练习，再查看答案。
-}

module Week03Exercises where

import Data.List (sort)

{- ============================================
   练习 1: Eq 实例 (5 题)
   ============================================ -}

-- 1.1 颜色类型
data Color = Red | Green | Blue

instance Eq Color where
  Red == Red = True
  Green == Green = True
  Blue == Blue = True
  _ == _ = False


-- 1.2 扑克牌点数
data Rank = Ace | Two | Three | Four | Five 
          | Six | Seven | Eight | Nine | Ten
          | Jack | Queen | King

instance Eq Rank where
  Ace == Ace = True
  Two == Two = True
  Three == Three = True
  Four == Four = True
  Five == Five = True
  Six == Six = True
  Seven == Seven = True
  Eight == Eight = True
  Nine == Nine = True
  Ten == Ten = True
  Jack == Jack = True
  Queen == Queen = True
  King == King = True
  _ == _ = False


-- 1.3 点类型
data Point = Point Int Int

instance Eq Point where
  Point x1 y1 == Point x2 y2 = x1 == x2 && y1 == y2


-- 1.4 温度类型
data Temperature = Celsius Double

instance Eq Temperature where
  Celsius t1 == Celsius t2 = t1 == t2


-- 1.5 用户类型
data User = User
  { userId :: Int
  , userName :: String
  }

instance Eq User where
  User id1 _ == User id2 _ = id1 == id2


{- ============================================
   练习 2: Ord 实例 (5 题)
   ============================================ -}

-- 2.1 优先级类型
data Priority = Low | Medium | High
  deriving (Eq, Show)

instance Ord Priority where
  compare Low Low = EQ
  compare Low _ = LT
  compare Medium Low = GT
  compare Medium Medium = EQ
  compare Medium High = LT
  compare High High = EQ
  compare High _ = GT


-- 2.2 扑克牌点数排序
instance Ord Rank where
  compare r1 r2 = compare (rankToInt r1) (rankToInt r2)
    where
      rankToInt :: Rank -> Int
      rankToInt Ace = 1
      rankToInt Two = 2
      rankToInt Three = 3
      rankToInt Four = 4
      rankToInt Five = 5
      rankToInt Six = 6
      rankToInt Seven = 7
      rankToInt Eight = 8
      rankToInt Nine = 9
      rankToInt Ten = 10
      rankToInt Jack = 11
      rankToInt Queen = 12
      rankToInt King = 13


-- 2.3 点类型排序
instance Ord Point where
  compare (Point x1 y1) (Point x2 y2) =
    case compare x1 x2 of
      EQ -> compare y1 y2
      other -> other


-- 2.4 温度排序
instance Ord Temperature where
  compare (Celsius t1) (Celsius t2) = compare t1 t2


-- 2.5 文件大小类型
data FileSize = Bytes Int
  deriving (Eq)

instance Ord FileSize where
  compare (Bytes s1) (Bytes s2) = compare s1 s2


{- ============================================
   练习 3: Show 实例 (5 题)
   ============================================ -}

-- 3.1 颜色的友好显示
instance Show Color where
  show Red = "红色"
  show Green = "绿色"
  show Blue = "蓝色"


-- 3.2 温度的单位显示
instance Show Temperature where
  show (Celsius t) = show t ++ "°C"


-- 3.3 点的坐标显示
instance Show Point where
  show (Point x y) = "(" ++ show x ++ ", " ++ show y ++ ")"


-- 3.4 扑克牌花色
data Suit = Hearts | Diamonds | Clubs | Spades
  deriving (Eq)

instance Show Suit where
  show Hearts = "♥"
  show Diamonds = "♦"
  show Clubs = "♣"
  show Spades = "♠"

instance Show Rank where
  show Ace = "A"
  show Two = "2"
  show Three = "3"
  show Four = "4"
  show Five = "5"
  show Six = "6"
  show Seven = "7"
  show Eight = "8"
  show Nine = "9"
  show Ten = "10"
  show Jack = "J"
  show Queen = "Q"
  show King = "K"

data Card = Card Rank Suit

instance Show Card where
  show (Card rank suit) = show rank ++ show suit


-- 3.5 时间类型
data Time = Time Int Int

instance Show Time where
  show (Time h m) = 
    let hourStr = if h < 10 then "0" ++ show h else show h
        minStr = if m < 10 then "0" ++ show m else show m
    in hourStr ++ ":" ++ minStr


{- ============================================
   练习 4: deriving 和组合 (5 题)
   ============================================ -}

-- 4.1 使用 deriving
data Shape = Circle Double
           | Rectangle Double Double
           | Triangle Double Double Double
  deriving (Eq, Show)

area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle a b c) = 
  let s = (a + b + c) / 2
  in sqrt (s * (s - a) * (s - b) * (s - c))

instance Ord Shape where
  compare s1 s2 = compare (area s1) (area s2)


-- 4.2 方向枚举
data Direction = North | South | East | West
  deriving (Eq, Ord, Show, Enum, Bounded)

allDirections :: [Direction]
allDirections = [minBound .. maxBound]


-- 4.3 交通信号灯
data TrafficLight = Red' | Yellow | Green'
  deriving (Eq, Show, Enum)

nextLight :: TrafficLight -> TrafficLight
nextLight Green' = Red'
nextLight light = succ light


-- 4.4 产品类型
data Product = Product
  { productName :: String
  , productPrice :: Double
  , productStock :: Int
  } deriving (Eq, Show)

instance Ord Product where
  compare p1 p2 = compare (productPrice p1) (productPrice p2)


-- 4.5 结果类型
data Result a = Success a | Failure String
  deriving (Eq, Show)

instance Functor Result where
  fmap f (Success x) = Success (f x)
  fmap _ (Failure msg) = Failure msg


{- ============================================
   练习 5: Functor 练习 (5 题)
   ============================================ -}

-- 5.1 使用 fmap 转换 Maybe
doubleIfPresent :: Maybe Int -> Maybe Int
doubleIfPresent = fmap (*2)


-- 5.2 使用 <$> 操作符
addTen :: Maybe Int -> Maybe Int
addTen mx = (+10) <$> mx


-- 5.3 链式 fmap
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

calculatePercentage :: Double -> Double -> Maybe Double
calculatePercentage part total = fmap (*100) (safeDivide part total)


-- 5.4 Box 类型实现 Functor
data Box a = Empty | Full a
  deriving (Eq, Show)

instance Functor Box where
  fmap _ Empty = Empty
  fmap f (Full x) = Full (f x)


-- 5.5 Tree 类型实现 Functor
data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving (Eq, Show)

instance Functor Tree where
  fmap f (Leaf x) = Leaf (f x)
  fmap f (Node left right) = Node (fmap f left) (fmap f right)


{- ============================================
   练习 6: Applicative 练习 (5 题)
   ============================================ -}

-- 6.1 基础 Applicative 使用
addMaybe :: Maybe Int -> Maybe Int -> Maybe Int
addMaybe mx my = (+) <$> mx <*> my


-- 6.2 三个参数的函数
add3 :: Int -> Int -> Int -> Int
add3 x y z = x + y + z

add3Maybe :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int
add3Maybe mx my mz = add3 <$> mx <*> my <*> mz


-- 6.3 表单验证
data Person = Person String Int String
  deriving (Eq, Show)

validateName :: String -> Maybe String
validateName n = if length n > 0 then Just n else Nothing

validateAge :: Int -> Maybe Int  
validateAge a = if a >= 18 then Just a else Nothing

validateEmail :: String -> Maybe String
validateEmail e = if '@' `elem` e then Just e else Nothing

createPerson :: String -> Int -> String -> Maybe Person
createPerson name age email = 
  Person <$> validateName name <*> validateAge age <*> validateEmail email


-- 6.4 列表的 Applicative
allPairs :: [a] -> [b] -> [(a, b)]
allPairs xs ys = (,) <$> xs <*> ys


-- 6.5 实现 Box 的 Applicative
instance Applicative Box where
  pure = Full
  Empty <*> _ = Empty
  _ <*> Empty = Empty
  Full f <*> Full x = Full (f x)


{- ============================================
   练习 7: Monad 入门 (5 题)
   ============================================ -}

-- 7.1 使用 >>= 链接操作
addOneIfEven :: Int -> Maybe Int
addOneIfEven n = if even n then Just (n + 1) else Nothing

processNumber :: Maybe Int -> Maybe Int
processNumber mx = mx >>= addOneIfEven


-- 7.2 安全除法链
calculate :: Double -> Maybe Double
calculate x = do
  a <- safeDivide x 2
  b <- safeDivide a 3
  safeDivide b 4


-- 7.3 查找链
type Database = [(String, Int)]

lookupAge :: String -> Database -> Maybe Int
lookupAge name db = lookup name db

lookupAndDouble :: String -> Database -> Maybe Int
lookupAndDouble name db = do
  age <- lookupAge name db
  return (age * 2)


-- 7.4 列表 Monad
pairs :: [Int] -> [Int] -> [(Int, Int)]
pairs xs ys = do
  x <- xs
  y <- ys
  return (x, y)


-- 7.5 实现 Box 的 Monad
instance Monad Box where
  return = Full
  Empty >>= _ = Empty
  Full x >>= f = f x


{- ============================================
   辅助测试函数
   ============================================ -}

-- 测试 Eq 实例
testEq :: IO ()
testEq = do
  putStrLn "=== Testing Eq instances ==="
  print $ Red == Red                    -- True
  print $ Red == Blue                   -- False
  print $ Point 1 2 == Point 1 2        -- True
  print $ Celsius 20.0 == Celsius 20.0  -- True

-- 测试 Ord 实例
testOrd :: IO ()
testOrd = do
  putStrLn "\n=== Testing Ord instances ==="
  print $ sort [High, Low, Medium]      -- [Low,Medium,High]
  print $ Low < High                    -- True
  print $ sort [Point 2 1, Point 1 2, Point 1 1]  -- [Point 1 1, Point 1 2, Point 2 1]

-- 测试 Show 实例
testShow :: IO ()
testShow = do
  putStrLn "\n=== Testing Show instances ==="
  print Red                             -- "红色"
  print $ Celsius 20.0                  -- "20.0°C"
  print $ Point 1 2                     -- "(1, 2)"
  print $ Time 14 30                    -- "14:30"

-- 测试 Functor
testFunctor :: IO ()
testFunctor = do
  putStrLn "\n=== Testing Functor instances ==="
  print $ fmap (+1) (Just 5)            -- Just 6
  print $ fmap (*2) (Full 10)           -- Full 20
  print $ fmap (+1) (Leaf 5)            -- Leaf 6

-- 测试 Applicative
testApplicative :: IO ()
testApplicative = do
  putStrLn "\n=== Testing Applicative instances ==="
  print $ addMaybe (Just 3) (Just 5)    -- Just 8
  print $ createPerson "Alice" 25 "alice@example.com"  -- Just (Person ...)
  print $ allPairs [1,2] [10,20]        -- [(1,10),(1,20),(2,10),(2,20)]

-- 测试 Monad
testMonad :: IO ()
testMonad = do
  putStrLn "\n=== Testing Monad instances ==="
  print $ processNumber (Just 4)        -- Just 5
  print $ calculate 24                  -- Just 1.0
  print $ pairs [1,2] [10,20]           -- [(1,10),(1,20),(2,10),(2,20)]

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

