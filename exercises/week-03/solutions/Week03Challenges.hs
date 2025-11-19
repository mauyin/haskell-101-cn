{-
  Week 3: 类型类挑战题 - 参考答案
  
  这是所有挑战题的完整解答。
  这些是进阶内容，理解它们需要时间。
-}

module Week03Challenges where

import Control.Monad (ap, liftM2)
import Data.Char (isDigit, digitToInt)

{- ============================================
   挑战 1: 自定义 Foldable
   ============================================ -}

data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving (Eq, Show)

instance Foldable Tree where
  foldr f acc (Leaf x) = f x acc
  foldr f acc (Node left right) = 
    foldr f (foldr f acc right) left


{- ============================================
   挑战 2: 验证 Functor 法则
   ============================================ -}

data Container a = Single a | Multiple [a]
  deriving (Eq, Show)

instance Functor Container where
  fmap f (Single x) = Single (f x)
  fmap f (Multiple xs) = Multiple (map f xs)

-- 法则 1: fmap id = id
testFunctorIdentity :: Container Int -> Bool
testFunctorIdentity c = fmap id c == id c

-- 法则 2: fmap (f . g) = fmap f . fmap g
testFunctorComposition :: (Int -> Int) -> (Int -> Int) -> Container Int -> Bool
testFunctorComposition f g c = fmap (f . g) c == (fmap f . fmap g) c


{- ============================================
   挑战 3: 解析器 Monad
   ============================================ -}

newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

instance Functor Parser where
  fmap f (Parser p) = Parser $ \input ->
    case p input of
      Nothing -> Nothing
      Just (x, rest) -> Just (f x, rest)

instance Applicative Parser where
  pure x = Parser $ \input -> Just (x, input)
  (Parser pf) <*> (Parser px) = Parser $ \input ->
    case pf input of
      Nothing -> Nothing
      Just (f, rest) -> case px rest of
        Nothing -> Nothing
        Just (x, rest') -> Just (f x, rest')

instance Monad Parser where
  return = pure
  (Parser p) >>= f = Parser $ \input ->
    case p input of
      Nothing -> Nothing
      Just (x, rest) -> runParser (f x) rest

-- 基础解析器

charP :: Char -> Parser Char
charP c = Parser $ \input ->
  case input of
    (x:xs) | x == c -> Just (c, xs)
    _ -> Nothing

anyCharP :: Parser Char
anyCharP = Parser $ \input ->
  case input of
    (x:xs) -> Just (x, xs)
    [] -> Nothing

digitP :: Parser Int
digitP = Parser $ \input ->
  case input of
    (x:xs) | isDigit x -> Just (digitToInt x, xs)
    _ -> Nothing

stringP :: String -> Parser String
stringP [] = return []
stringP (c:cs) = do
  _ <- charP c
  _ <- stringP cs
  return (c:cs)


{- ============================================
   挑战 4: 状态 Monad
   ============================================ -}

newtype State s a = State { runState :: s -> (a, s) }

instance Functor (State s) where
  fmap f (State g) = State $ \s ->
    let (a, s') = g s
    in (f a, s')

instance Applicative (State s) where
  pure x = State $ \s -> (x, s)
  (State sf) <*> (State sx) = State $ \s ->
    let (f, s') = sf s
        (x, s'') = sx s'
    in (f x, s'')

instance Monad (State s) where
  return = pure
  (State h) >>= f = State $ \s ->
    let (a, s') = h s
        (State g) = f a
    in g s'

get :: State s s
get = State $ \s -> (s, s)

put :: s -> State s ()
put s = State $ \_ -> ((), s)

modify :: (s -> s) -> State s ()
modify f = State $ \s -> ((), f s)

-- 示例：计数器
increment :: State Int ()
increment = modify (+1)

getAndIncrement :: State Int Int
getAndIncrement = do
  val <- get
  modify (+1)
  return val


{- ============================================
   挑战 5: Reader Monad
   ============================================ -}

newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap f (Reader g) = Reader $ \r -> f (g r)

instance Applicative (Reader r) where
  pure x = Reader $ \_ -> x
  (Reader f) <*> (Reader x) = Reader $ \r -> f r (x r)

instance Monad (Reader r) where
  return = pure
  (Reader h) >>= f = Reader $ \r ->
    let a = h r
        (Reader g) = f a
    in g r

ask :: Reader r r
ask = Reader id

local :: (r -> r) -> Reader r a -> Reader r a
local f (Reader g) = Reader $ \r -> g (f r)

-- 示例：配置读取
data Config = Config
  { dbHost :: String
  , dbPort :: Int
  , debug :: Bool
  }

getDatabaseUrl :: Reader Config String
getDatabaseUrl = do
  config <- ask
  return $ dbHost config ++ ":" ++ show (dbPort config)

isDebugMode :: Reader Config Bool
isDebugMode = do
  config <- ask
  return $ debug config


{- ============================================
   挑战 6: 类型类组合
   ============================================ -}

data MyList a = Empty' | Cons a (MyList a)

instance Eq a => Eq (MyList a) where
  Empty' == Empty' = True
  Cons x xs == Cons y ys = x == y && xs == ys
  _ == _ = False

instance Ord a => Ord (MyList a) where
  compare Empty' Empty' = EQ
  compare Empty' _ = LT
  compare _ Empty' = GT
  compare (Cons x xs) (Cons y ys) =
    case compare x y of
      EQ -> compare xs ys
      other -> other

instance Show a => Show (MyList a) where
  show Empty' = "[]"
  show (Cons x xs) = "[" ++ showElements (Cons x xs) ++ "]"
    where
      showElements Empty' = ""
      showElements (Cons y Empty') = show y
      showElements (Cons y ys) = show y ++ ", " ++ showElements ys

instance Functor MyList where
  fmap _ Empty' = Empty'
  fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative MyList where
  pure x = Cons x Empty'
  Empty' <*> _ = Empty'
  _ <*> Empty' = Empty'
  Cons f fs <*> xs = appendList (fmap f xs) (fs <*> xs)
    where
      appendList Empty' ys = ys
      appendList (Cons x xs') ys = Cons x (appendList xs' ys)

instance Monad MyList where
  return = pure
  Empty' >>= _ = Empty'
  Cons x xs >>= f = appendList (f x) (xs >>= f)
    where
      appendList Empty' ys = ys
      appendList (Cons x' xs') ys = Cons x' (appendList xs' ys)

instance Foldable MyList where
  foldr _ acc Empty' = acc
  foldr f acc (Cons x xs) = f x (foldr f acc xs)

fromList :: [a] -> MyList a
fromList [] = Empty'
fromList (x:xs) = Cons x (fromList xs)

toList :: MyList a -> [a]
toList Empty' = []
toList (Cons x xs) = x : toList xs


{- ============================================
   挑战 7: 自定义类型类
   ============================================ -}

class Serializable a where
  serialize :: a -> String
  deserialize :: String -> Maybe a

instance Serializable Int where
  serialize = show
  deserialize s = case reads s of
    [(x, "")] -> Just x
    _ -> Nothing

instance Serializable Bool where
  serialize True = "true"
  serialize False = "false"
  deserialize "true" = Just True
  deserialize "false" = Just False
  deserialize _ = Nothing

instance Serializable a => Serializable [a] where
  serialize xs = "[" ++ serializeList xs ++ "]"
    where
      serializeList [] = ""
      serializeList [x] = serialize x
      serializeList (x:xs') = serialize x ++ "," ++ serializeList xs'
  deserialize = undefined  -- 简化：解析较复杂

instance Serializable a => Serializable (Maybe a) where
  serialize Nothing = "null"
  serialize (Just x) = serialize x
  deserialize "null" = Just Nothing
  deserialize s = Just <$> deserialize s


{- ============================================
   挑战 8: Monad Transformer
   ============================================ -}

newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

instance Functor m => Functor (MaybeT m) where
  fmap f (MaybeT ma) = MaybeT $ fmap (fmap f) ma

instance Applicative m => Applicative (MaybeT m) where
  pure x = MaybeT $ pure (Just x)
  (MaybeT mf) <*> (MaybeT mx) = MaybeT $ 
    liftM2 (<*>) mf mx

instance Monad m => Monad (MaybeT m) where
  return = pure
  (MaybeT ma) >>= f = MaybeT $ do
    maybeA <- ma
    case maybeA of
      Nothing -> return Nothing
      Just a -> runMaybeT (f a)

liftMaybe :: Monad m => Maybe a -> MaybeT m a
liftMaybe = MaybeT . return

liftM :: Monad m => m a -> MaybeT m a
liftM ma = MaybeT $ fmap Just ma


{- ============================================
   测试函数
   ============================================ -}

testAllChallenges :: IO ()
testAllChallenges = do
  putStrLn "=== Week 3 Challenges - Tests ==="
  
  -- Test Foldable
  putStrLn "\n1. Foldable Tree:"
  print $ foldr (+) 0 (Node (Leaf 1) (Leaf 2))
  print $ sum (Node (Leaf 1) (Node (Leaf 2) (Leaf 3)))
  
  -- Test Parser
  putStrLn "\n2. Parser:"
  print $ runParser (charP 'a') "abc"
  print $ runParser digitP "123"
  
  -- Test State
  putStrLn "\n3. State:"
  print $ runState (do { increment; increment; get }) 0
  print $ runState getAndIncrement 5
  
  -- Test Reader
  putStrLn "\n4. Reader:"
  let config = Config "localhost" 5432 True
  print $ runReader getDatabaseUrl config
  print $ runReader isDebugMode config
  
  -- Test MyList
  putStrLn "\n5. MyList:"
  let list = fromList [1,2,3]
  print $ toList list
  print $ toList (fmap (+1) list)
  print $ foldr (+) 0 list
  
  putStrLn "\n=== All challenge tests completed! ==="

