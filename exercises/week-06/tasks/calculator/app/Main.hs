{- |
Main - 计算器命令行接口
=======================

简单的 REPL 计算器
-}

module Main where

import Calculator
import Calculator.Types
import System.IO (hFlush, stdout)
import System.Exit (exitSuccess)
import Prelude hiding (subtract, sqrt)

main :: IO ()
main = do
  putStrLn "======================================"
  putStrLn "   简单计算器 - TDD 练习项目"
  putStrLn "======================================"
  putStrLn ""
  putStrLn "支持的操作："
  putStrLn "  数字1 + 数字2  (加法)"
  putStrLn "  数字1 - 数字2  (减法)"
  putStrLn "  数字1 * 数字2  (乘法)"
  putStrLn "  数字1 / 数字2  (除法)"
  putStrLn "  quit          (退出)"
  putStrLn ""
  repl

-- REPL 循环
repl :: IO ()
repl = do
  putStr "> "
  hFlush stdout
  input <- getLine
  
  case words input of
    ["quit"] -> do
      putStrLn "再见！"
      exitSuccess
    
    [x, op, y] -> do
      case (parseNumber x, parseNumber y) of
        (Just num1, Just num2) -> do
          let result = calculate op num1 num2
          displayResult result
        _ -> putStrLn "错误：无效的数字"
      repl
    
    _ -> do
      putStrLn "错误：格式应为 '数字1 操作符 数字2'"
      repl

-- 解析数字
parseNumber :: String -> Maybe Double
parseNumber s = case reads s of
  [(n, "")] -> Just n
  _ -> Nothing

-- 执行计算
calculate :: String -> Double -> Double -> CalcResult
calculate "+" = add
calculate "-" = subtract
calculate "*" = multiply
calculate "/" = divide
calculate _ = \_ _ -> Left InvalidOperation

-- 显示结果
displayResult :: CalcResult -> IO ()
displayResult (Right n) = putStrLn $ "结果: " ++ show n
displayResult (Left DivisionByZero) = putStrLn "错误：不能除以零"
displayResult (Left InvalidOperation) = putStrLn "错误：无效的操作"
displayResult (Left Overflow) = putStrLn "错误：结果溢出"
displayResult (Left Underflow) = putStrLn "错误：结果下溢"

{-
使用示例：

$ cabal run calculator

> 10 + 5
结果: 15.0

> 20 / 4
结果: 5.0

> 10 / 0
错误：不能除以零

> quit
再见！
-}

