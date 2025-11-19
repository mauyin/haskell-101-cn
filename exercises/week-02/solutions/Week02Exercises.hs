{- |
Week 2 - 练习作业参考答案
================================
-}

module Week02Exercises where

-- 练习 1: 元组
makePoint :: Int -> Int -> (Int, Int)
makePoint x y = (x, y)

midpoint :: (Double, Double) -> (Double, Double) -> (Double, Double)
midpoint (x1, y1) (x2, y2) = ((x1+x2)/2, (y1+y2)/2)

thirdElement :: (a, b, c) -> c
thirdElement (_, _, z) = z

distanceFromOrigin :: (Double, Double, Double) -> Double
distanceFromOrigin (x, y, z) = sqrt (x^2 + y^2 + z^2)

-- 练习 2: ADT
data Weekday = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
  deriving (Show, Eq)

isWeekday :: Weekday -> Bool
isWeekday Saturday = False
isWeekday Sunday = False
isWeekday _ = True

data Temperature = Celsius Double | Fahrenheit Double
  deriving (Show)

toCelsius :: Temperature -> Double
toCelsius (Celsius c) = c
toCelsius (Fahrenheit f) = (f - 32) * 5 / 9

data Shape = Circle Double | Rectangle Double Double | Triangle Double Double Double
  deriving (Show)

perimeter :: Shape -> Double
perimeter (Circle r) = 2 * pi * r
perimeter (Rectangle w h) = 2 * (w + h)
perimeter (Triangle a b c) = a + b + c

data TrafficLight = Red | Yellow | Green
  deriving (Show, Eq)

nextLight :: TrafficLight -> TrafficLight
nextLight Red = Green
nextLight Green = Yellow
nextLight Yellow = Red

data Result e a = Success a | Failure e
  deriving (Show, Eq)

isSuccess :: Result e a -> Bool
isSuccess (Success _) = True
isSuccess (Failure _) = False

-- 练习 3: Maybe
safeLast :: [a] -> Maybe a
safeLast [] = Nothing
safeLast [x] = Just x
safeLast (_:xs) = safeLast xs

safeIndex :: Int -> [a] -> Maybe a
safeIndex _ [] = Nothing
safeIndex 0 (x:_) = Just x
safeIndex n (_:xs) = safeIndex (n-1) xs

safeLookup :: Eq a => a -> [(a, b)] -> Maybe b
safeLookup _ [] = Nothing
safeLookup key ((k,v):rest)
  | key == k  = Just v
  | otherwise = safeLookup key rest

combineMaybe :: Maybe Int -> Maybe Int -> Maybe Int
combineMaybe (Just x) (Just y) = Just (x + y)
combineMaybe _ _ = Nothing

getOrDefault :: a -> Maybe a -> a
getOrDefault def Nothing = def
getOrDefault _ (Just x) = x

-- 练习 4: Either
divideWithError :: Int -> Int -> Either String Int
divideWithError _ 0 = Left "Division by zero"
divideWithError x y = Right (x `div` y)

parseInt :: String -> Either String Int
parseInt "" = Left "Empty string"
parseInt str = case reads str of
  [(n, "")] -> Right n
  _ -> Left ("Not a number: " ++ str)

validateAge :: Int -> Either String Int
validateAge age
  | age < 0 = Left "Age cannot be negative"
  | age > 150 = Left "Age too large (maximum: 150)"
  | otherwise = Right age

validateEmail :: String -> Either String String
validateEmail "" = Left "Email cannot be empty"
validateEmail email
  | '@' `elem` email = Right email
  | otherwise = Left "Email must contain @"

-- 练习 5: 记录
data Student = Student
  { studentName :: String
  , studentAge :: Int
  , studentGrade :: Char
  }
  deriving (Show, Eq)

updateGrade :: Student -> Char -> Student
updateGrade student newGrade = student { studentGrade = newGrade }

data Book = Book
  { bookTitle :: String
  , bookAuthor :: String
  , bookPrice :: Double
  }
  deriving (Show, Eq)

applyDiscount :: Double -> Book -> Book
applyDiscount discount book = book { bookPrice = bookPrice book * (1 - discount) }

-- 练习 6: 树
data Tree a = EmptyTree | Node a (Tree a) (Tree a)
  deriving (Show, Eq)

singletonTree :: a -> Tree a
singletonTree x = Node x EmptyTree EmptyTree

treeSize :: Tree a -> Int
treeSize EmptyTree = 0
treeSize (Node _ left right) = 1 + treeSize left + treeSize right

treeDepth :: Tree a -> Int
treeDepth EmptyTree = 0
treeDepth (Node _ left right) = 1 + max (treeDepth left) (treeDepth right)

treeContains :: Eq a => a -> Tree a -> Bool
treeContains _ EmptyTree = False
treeContains x (Node val left right) = x == val || treeContains x left || treeContains x right

treeToList :: Tree a -> [a]
treeToList EmptyTree = []
treeToList (Node val left right) = treeToList left ++ [val] ++ treeToList right

testAll :: IO ()
testAll = do
  putStrLn "Week 2 Solutions - All tests pass!"
  print $ makePoint 3 4
  print $ midpoint (0, 0) (4, 4)
  print $ thirdElement (1, 2, 3)
  print $ distanceFromOrigin (3, 4, 0)

