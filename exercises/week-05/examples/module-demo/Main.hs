{- |
Module Organization Demo
演示如何组织多模块项目
-}

module Main where

import qualified Utils.Math as Math
import qualified Utils.String as String
import Data.Types

main :: IO ()
main = do
  putStrLn "=== 模块组织示例 ==="
  
  -- 使用 Math 模块
  putStrLn $ "\n数学运算:"
  putStrLn $ "5 的平方: " ++ show (Math.square 5)
  putStrLn $ "10 的阶乘: " ++ show (Math.factorial 10)
  
  -- 使用 String 模块
  putStrLn $ "\n字符串处理:"
  putStrLn $ "反转: " ++ String.reverseString "Hello"
  putStrLn $ "大写: " ++ String.toUpperString "hello world"
  
  -- 使用自定义类型
  putStrLn $ "\n自定义类型:"
  let user = User "Alice" 30 "alice@example.com"
  print user

