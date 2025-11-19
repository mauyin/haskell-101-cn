{- |
Week 2 - 挑战题参考答案
================================
-}

module Week02Challenges where

-- 挑战 1: 表达式求值
data Expr = Num Int | Add Expr Expr | Sub Expr Expr | Mul Expr Expr | Div Expr Expr

eval :: Expr -> Either String Int
eval (Num n) = Right n
eval (Add e1 e2) = case (eval e1, eval e2) of
  (Right v1, Right v2) -> Right (v1 + v2)
  (Left err, _) -> Left err
  (_, Left err) -> Left err
eval (Sub e1 e2) = case (eval e1, eval e2) of
  (Right v1, Right v2) -> Right (v1 - v2)
  (Left err, _) -> Left err
  (_, Left err) -> Left err
eval (Mul e1 e2) = case (eval e1, eval e2) of
  (Right v1, Right v2) -> Right (v1 * v2)
  (Left err, _) -> Left err
  (_, Left err) -> Left err
eval (Div e1 e2) = case (eval e1, eval e2) of
  (Right v1, Right v2) -> if v2 == 0 
                          then Left "Division by zero" 
                          else Right (v1 `div` v2)
  (Left err, _) -> Left err
  (_, Left err) -> Left err

-- 挑战 2: JSON
data JSON = JNull | JBool Bool | JNumber Double | JString String | JArray [JSON] | JObject [(String, JSON)]
  deriving (Show, Eq)

getString :: JSON -> Maybe String
getString (JString s) = Just s
getString _ = Nothing

getField :: String -> JSON -> Maybe JSON
getField key (JObject fields) = lookup key fields
getField _ _ = Nothing

-- 挑战 3: BST
data BST a = BSTEmpty | BSTNode a (BST a) (BST a)
  deriving (Show, Eq)

bstInsert :: Ord a => a -> BST a -> BST a
bstInsert x BSTEmpty = BSTNode x BSTEmpty BSTEmpty
bstInsert x (BSTNode val left right)
  | x < val  = BSTNode val (bstInsert x left) right
  | x > val  = BSTNode val left (bstInsert x right)
  | otherwise = BSTNode val left right

bstMin :: BST a -> Maybe a
bstMin BSTEmpty = Nothing
bstMin (BSTNode val BSTEmpty _) = Just val
bstMin (BSTNode _ left _) = bstMin left

-- 挑战 4: 玫瑰树
data RoseTree a = RoseNode a [RoseTree a]
  deriving (Show, Eq)

roseSize :: RoseTree a -> Int
roseSize (RoseNode _ children) = 1 + sum (map roseSize children)

roseDepth :: RoseTree a -> Int
roseDepth (RoseNode _ []) = 1
roseDepth (RoseNode _ children) = 1 + maximum (map roseDepth children)

