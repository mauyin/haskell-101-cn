{- |
Week 2 - 挑战题: ADT 进阶练习
================================

难度：⭐⭐⭐⭐☆
-}

module Week02Challenges where

-- ============================================================================
-- 挑战 1: 表达式求值器
-- ============================================================================

data Expr = Num Int
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr

eval :: Expr -> Either String Int
eval expr = undefined  -- TODO


-- ============================================================================
-- 挑战 2: 简化 JSON 类型
-- ============================================================================

data JSON = JNull
          | JBool Bool
          | JNumber Double
          | JString String
          | JArray [JSON]
          | JObject [(String, JSON)]
  deriving (Show, Eq)

-- 从 JSON 中提取字符串
getString :: JSON -> Maybe String
getString json = undefined  -- TODO

-- 从 JSON 对象中获取字段
getField :: String -> JSON -> Maybe JSON
getField key json = undefined  -- TODO


-- ============================================================================
-- 挑战 3: 二叉搜索树
-- ============================================================================

data BST a = BSTEmpty | BSTNode a (BST a) (BST a)
  deriving (Show, Eq)

-- 插入元素（保持 BST 性质）
bstInsert :: Ord a => a -> BST a -> BST a
bstInsert x tree = undefined  -- TODO

-- 查找最小值
bstMin :: BST a -> Maybe a
bstMin tree = undefined  -- TODO


-- ============================================================================
-- 挑战 4: 玫瑰树（多叉树）
-- ============================================================================

data RoseTree a = RoseNode a [RoseTree a]
  deriving (Show, Eq)

-- 计算节点数
roseSize :: RoseTree a -> Int
roseSize tree = undefined  -- TODO

-- 查找深度
roseDepth :: RoseTree a -> Int
roseDepth tree = undefined  -- TODO

