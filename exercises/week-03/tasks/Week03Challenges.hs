{-
  Week 3: 类型类挑战题
  
  这些是进阶练习，适合完成主练习后的学生。
  难度较高，但能帮助你更深入理解类型类。
-}

module Week03Challenges where

{- ============================================
   挑战 1: 自定义 Foldable
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- Tree 类型
data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving (Eq, Show)

-- TODO: 为 Tree 实现 Foldable
-- 提示：对于 Node，先 fold 左子树，再 fold 右子树
instance Foldable Tree where
  foldr = undefined

-- 测试：
-- foldr (+) 0 (Node (Leaf 1) (Leaf 2))        --> 3
-- foldr (*) 1 (Node (Leaf 2) (Node (Leaf 3) (Leaf 4))) --> 24
-- sum (Node (Leaf 1) (Node (Leaf 2) (Leaf 3)))  --> 6


{- ============================================
   挑战 2: 验证 Functor 法则
   难度: ⭐⭐⭐⭐☆
   ============================================ -}

-- 自定义容器类型
data Container a = Single a | Multiple [a]
  deriving (Eq, Show)

-- TODO: 实现 Functor 实例
instance Functor Container where
  fmap = undefined

-- TODO: 编写测试验证 Functor 法则

-- 法则 1: fmap id = id
testFunctorIdentity :: Container Int -> Bool
testFunctorIdentity c = undefined

-- 法则 2: fmap (f . g) = fmap f . fmap g
testFunctorComposition :: (Int -> Int) -> (Int -> Int) -> Container Int -> Bool
testFunctorComposition f g c = undefined


{- ============================================
   挑战 3: 解析器 Monad
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- 解析器类型：接受字符串，返回解析结果和剩余字符串
newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

-- TODO: 实现 Functor 实例
instance Functor Parser where
  fmap = undefined

-- TODO: 实现 Applicative 实例
instance Applicative Parser where
  pure = undefined
  (<*>) = undefined

-- TODO: 实现 Monad 实例
instance Monad Parser where
  return = pure
  (>>=) = undefined

-- 基础解析器

-- TODO: 解析单个字符
charP :: Char -> Parser Char
charP c = undefined

-- TODO: 解析任意字符
anyCharP :: Parser Char
anyCharP = undefined

-- TODO: 解析数字
digitP :: Parser Int
digitP = undefined

-- TODO: 解析字符串
stringP :: String -> Parser String
stringP = undefined

-- 测试：
-- runParser (charP 'a') "abc"      --> Just ('a', "bc")
-- runParser (stringP "hello") "hello world"  --> Just ("hello", " world")


{- ============================================
   挑战 4: 状态 Monad
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- 状态 Monad：封装带状态的计算
newtype State s a = State { runState :: s -> (a, s) }

-- TODO: 实现 Functor 实例
instance Functor (State s) where
  fmap = undefined

-- TODO: 实现 Applicative 实例
instance Applicative (State s) where
  pure = undefined
  (<*>) = undefined

-- TODO: 实现 Monad 实例
instance Monad (State s) where
  return = pure
  (>>=) = undefined

-- 实用函数

-- TODO: 获取当前状态
get :: State s s
get = undefined

-- TODO: 设置新状态
put :: s -> State s ()
put = undefined

-- TODO: 修改状态
modify :: (s -> s) -> State s ()
modify = undefined

-- 示例：计数器

-- 递增计数器
increment :: State Int ()
increment = undefined

-- 获取并递增
getAndIncrement :: State Int Int
getAndIncrement = undefined

-- 测试：
-- runState (do { increment; increment; get }) 0  --> (2, 2)
-- runState getAndIncrement 5                     --> (5, 6)


{- ============================================
   挑战 5: Reader Monad
   难度: ⭐⭐⭐⭐☆
   ============================================ -}

-- Reader Monad：封装依赖环境的计算
newtype Reader r a = Reader { runReader :: r -> a }

-- TODO: 实现 Functor 实例
instance Functor (Reader r) where
  fmap = undefined

-- TODO: 实现 Applicative 实例
instance Applicative (Reader r) where
  pure = undefined
  (<*>) = undefined

-- TODO: 实现 Monad 实例
instance Monad (Reader r) where
  return = pure
  (>>=) = undefined

-- 实用函数

-- TODO: 获取环境
ask :: Reader r r
ask = undefined

-- TODO: 在局部环境中运行计算
local :: (r -> r) -> Reader r a -> Reader r a
local = undefined

-- 示例：配置读取
data Config = Config
  { dbHost :: String
  , dbPort :: Int
  , debug :: Bool
  }

-- TODO: 读取数据库 URL
getDatabaseUrl :: Reader Config String
getDatabaseUrl = undefined

-- TODO: 读取调试标志
isDebugMode :: Reader Config Bool
isDebugMode = undefined


{- ============================================
   挑战 6: 类型类组合
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- 创建一个同时支持多个类型类的复杂类型
data MyList a = Empty' | Cons a (MyList a)

-- TODO: 实现 Eq 实例
instance Eq a => Eq (MyList a) where
  (==) = undefined

-- TODO: 实现 Ord 实例
instance Ord a => Ord (MyList a) where
  compare = undefined

-- TODO: 实现 Show 实例
instance Show a => Show (MyList a) where
  show = undefined

-- TODO: 实现 Functor 实例
instance Functor MyList where
  fmap = undefined

-- TODO: 实现 Applicative 实例
instance Applicative MyList where
  pure = undefined
  (<*>) = undefined

-- TODO: 实现 Monad 实例
instance Monad MyList where
  return = pure
  (>>=) = undefined

-- TODO: 实现 Foldable 实例
instance Foldable MyList where
  foldr = undefined

-- 辅助函数

-- TODO: 将普通列表转换为 MyList
fromList :: [a] -> MyList a
fromList = undefined

-- TODO: 将 MyList 转换为普通列表
toList :: MyList a -> [a]
toList = undefined


{- ============================================
   挑战 7: 自定义类型类
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- 定义一个 Serializable 类型类
class Serializable a where
  serialize :: a -> String
  deserialize :: String -> Maybe a

-- TODO: 为 Int 实现 Serializable
instance Serializable Int where
  serialize = undefined
  deserialize = undefined

-- TODO: 为 Bool 实现 Serializable
instance Serializable Bool where
  serialize = undefined
  deserialize = undefined

-- TODO: 为列表实现 Serializable（如果元素可序列化）
instance Serializable a => Serializable [a] where
  serialize = undefined
  deserialize = undefined

-- TODO: 为 Maybe 实现 Serializable
instance Serializable a => Serializable (Maybe a) where
  serialize = undefined
  deserialize = undefined


{- ============================================
   挑战 8: Monad Transformer
   难度: ⭐⭐⭐⭐⭐
   ============================================ -}

-- MaybeT: Maybe Monad Transformer
newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

-- TODO: 实现 Functor 实例
instance Functor m => Functor (MaybeT m) where
  fmap = undefined

-- TODO: 实现 Applicative 实例
instance Applicative m => Applicative (MaybeT m) where
  pure = undefined
  (<*>) = undefined

-- TODO: 实现 Monad 实例
instance Monad m => Monad (MaybeT m) where
  return = pure
  (>>=) = undefined

-- 实用函数

-- TODO: 提升 Maybe 值到 MaybeT
liftMaybe :: Monad m => Maybe a -> MaybeT m a
liftMaybe = undefined

-- TODO: 提升 Monad 值到 MaybeT
liftM :: Monad m => m a -> MaybeT m a
liftM = undefined


{- ============================================
   测试函数
   ============================================ -}

testAllChallenges :: IO ()
testAllChallenges = do
  putStrLn "=== Week 3 Challenges ==="
  putStrLn "完成这些挑战题后，你就是 Haskell 类型类大师了！"
  putStrLn "\n提示："
  putStrLn "1. 从简单的挑战开始"
  putStrLn "2. 参考讲义和其他实例的实现"
  putStrLn "3. 不要害怕失败，多尝试！"
  putStrLn "4. 使用 :type 和 :info 探索类型"

