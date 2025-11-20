{- |
MyModule - 模块练习
==================

这是一个练习模块，用于学习：
- 模块声明
- 导出列表
- 函数定义

任务：
1. 完成所有 TODO 标记的函数
2. 在另一个文件中 import 并使用这个模块
3. 实验 qualified import
-}

module MyModule
  ( -- * 导出的函数
    square
  , cube
  , factorial
  , fibonacci
    -- * 导出的类型
  , Shape(..)
  , area
  , perimeter
    -- * 注意：helper 函数不导出（私有）
  ) where

-- ============================================================================
-- 数学函数
-- ============================================================================

-- | 计算平方
-- 
-- 示例:
-- >>> square 5
-- 25
square :: Int -> Int
square = undefined  -- TODO: 实现 x^2


-- | 计算立方
--
-- 示例:
-- >>> cube 3
-- 27
cube :: Int -> Int
cube = undefined  -- TODO: 实现 x^3


-- | 计算阶乘
--
-- 示例:
-- >>> factorial 5
-- 120
factorial :: Int -> Int
factorial = undefined  -- TODO: 递归实现


-- | 计算斐波那契数列第 n 项
--
-- 示例:
-- >>> fibonacci 10
-- 55
fibonacci :: Int -> Int
fibonacci = undefined  -- TODO: 递归实现


-- | 辅助函数（不导出，模块私有）
-- 这个函数外部无法访问
helper :: Int -> Int
helper x = x * 2


-- ============================================================================
-- 几何形状
-- ============================================================================

-- | 形状类型
data Shape 
  = Circle Double           -- 圆（半径）
  | Rectangle Double Double -- 矩形（宽、高）
  | Triangle Double Double  -- 三角形（底、高）
  deriving (Show, Eq)


-- | 计算形状面积
--
-- 示例:
-- >>> area (Circle 5)
-- 78.53981633974483
-- >>> area (Rectangle 4 6)
-- 24.0
area :: Shape -> Double
area = undefined  -- TODO: 模式匹配实现


-- | 计算形状周长
--
-- 示例:
-- >>> perimeter (Circle 5)
-- 31.41592653589793
-- >>> perimeter (Rectangle 4 6)
-- 20.0
perimeter :: Shape -> Double
perimeter = undefined  -- TODO: 实现


-- ============================================================================
-- 使用示例
-- ============================================================================

{-
在另一个文件中使用这个模块：

-- 基本导入
import MyModule

main = do
  print (square 5)
  print (area (Circle 10))

-- Qualified 导入
import qualified MyModule as M

main = do
  print (M.square 5)
  print (M.area (M.Circle 10))

-- 选择性导入
import MyModule (square, cube)

main = do
  print (square 5)
  print (cube 3)
  -- area 不可用

-- 注意：helper 函数永远无法从外部访问！
-}

