module Utils.Math
  ( square
  , cube
  , factorial
  ) where

square :: Int -> Int
square x = x * x

cube :: Int -> Int
cube x = x * x * x

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

