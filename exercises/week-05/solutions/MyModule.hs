{- |
MyModule - 模块练习答案
====================
-}

module MyModule
  ( square
  , cube
  , factorial
  , fibonacci
  , Shape(..)
  , area
  , perimeter
  ) where

-- 数学函数
square :: Int -> Int
square x = x * x

cube :: Int -> Int
cube x = x * x * x

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

-- 私有辅助函数
helper :: Int -> Int
helper x = x * 2

-- 几何形状
data Shape 
  = Circle Double
  | Rectangle Double Double
  | Triangle Double Double
  deriving (Show, Eq)

area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle b h) = b * h / 2

perimeter :: Shape -> Double
perimeter (Circle r) = 2 * pi * r
perimeter (Rectangle w h) = 2 * (w + h)
perimeter (Triangle b h) = b + 2 * sqrt ((b/2)^2 + h^2)  -- 假设等腰三角形

