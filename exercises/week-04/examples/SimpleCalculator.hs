{- |
Simple Calculator - 简单计算器示例

本程序演示：
1. 基本 IO 操作
2. Either Monad 错误处理
3. do-notation 使用
4. 用户输入验证

学习要点：
- IO 与纯函数分离
- 错误类型设计
- 交互式循环

运行方式：
  ghci> :load SimpleCalculator.hs
  ghci> main
-}

module SimpleCalculator where

import Text.Read (readMaybe)
import Control.Monad (when)
import System.IO (hFlush, stdout)

-- ============================================================================
-- 数据类型定义
-- ============================================================================

-- | 运算符类型
data Operator = Add | Subtract | Multiply | Divide
  deriving (Show, Eq)

-- | 错误类型
data CalcError
  = DivisionByZero
  | InvalidNumber String
  | InvalidOperator String
  | EmptyInput
  deriving (Show, Eq)

-- ============================================================================
-- 纯函数部分（无副作用）
-- ============================================================================

-- | 解析运算符
parseOperator :: String -> Either CalcError Operator
parseOperator op = case op of
  "+" -> Right Add
  "-" -> Right Subtract
  "*" -> Right Multiply
  "/" -> Right Divide
  _   -> Left (InvalidOperator op)

-- | 解析数字
parseNumber :: String -> Either CalcError Double
parseNumber str
  | null str  = Left EmptyInput
  | otherwise = case readMaybe str of
      Just n  -> Right n
      Nothing -> Left (InvalidNumber str)

-- | 执行计算
calculate :: Operator -> Double -> Double -> Either CalcError Double
calculate Add x y = Right (x + y)
calculate Subtract x y = Right (x - y)
calculate Multiply x y = Right (x * y)
calculate Divide x y
  | y == 0    = Left DivisionByZero
  | otherwise = Right (x / y)

-- | 完整的计算流程（组合上述函数）
performCalculation :: String -> String -> String -> Either CalcError Double
performCalculation numStr1 opStr numStr2 = do
  -- 使用 do-notation 链接可能失败的操作
  num1 <- parseNumber numStr1
  op   <- parseOperator opStr
  num2 <- parseNumber numStr2
  calculate op num1 num2

-- ============================================================================
-- IO 部分（与用户交互）
-- ============================================================================

-- | 提示并获取输入
prompt :: String -> IO String
prompt message = do
  putStr message
  hFlush stdout
  getLine

-- | 显示错误信息
displayError :: CalcError -> IO ()
displayError err = case err of
  DivisionByZero -> putStrLn "❌ 错误: 不能除以零！"
  InvalidNumber str -> putStrLn $ "❌ 错误: '" ++ str ++ "' 不是有效的数字"
  InvalidOperator op -> putStrLn $ "❌ 错误: '" ++ op ++ "' 不是有效的运算符 (+, -, *, /)"
  EmptyInput -> putStrLn "❌ 错误: 输入不能为空"

-- | 显示结果
displayResult :: Double -> IO ()
displayResult result = putStrLn $ "✓ 结果: " ++ show result

-- | 单次计算
runCalculation :: IO ()
runCalculation = do
  putStrLn "\n=== 简单计算器 ==="
  
  -- 获取输入
  num1 <- prompt "输入第一个数字: "
  op   <- prompt "输入运算符 (+, -, *, /): "
  num2 <- prompt "输入第二个数字: "
  
  -- 执行计算并处理结果
  case performCalculation num1 op num2 of
    Left err -> displayError err
    Right result -> displayResult result

-- | 主循环（支持多次计算）
calculatorLoop :: IO ()
calculatorLoop = do
  runCalculation
  
  -- 询问是否继续
  putStrLn ""
  continue <- prompt "继续计算? (y/n): "
  
  when (continue `elem` ["y", "Y", "yes", "Yes"]) calculatorLoop

-- | 主程序入口
main :: IO ()
main = do
  putStrLn "欢迎使用简单计算器！"
  putStrLn "支持的运算: + (加), - (减), * (乘), / (除)"
  calculatorLoop
  putStrLn "再见！"

-- ============================================================================
-- 测试示例
-- ============================================================================

-- | 测试纯函数部分
testCalculator :: IO ()
testCalculator = do
  putStrLn "=== 测试计算器功能 ==="
  
  -- 测试正常计算
  print $ performCalculation "10" "+" "5"   -- Right 15.0
  print $ performCalculation "10" "-" "5"   -- Right 5.0
  print $ performCalculation "10" "*" "5"   -- Right 50.0
  print $ performCalculation "10" "/" "5"   -- Right 2.0
  
  -- 测试错误情况
  print $ performCalculation "10" "/" "0"   -- Left DivisionByZero
  print $ performCalculation "abc" "+" "5"  -- Left (InvalidNumber "abc")
  print $ performCalculation "10" "%" "5"   -- Left (InvalidOperator "%")
  
  putStrLn "测试完成！"

{-
使用说明：

1. 基本使用：
   ghci> main
   
2. 运行测试：
   ghci> testCalculator

3. 单次计算（不循环）：
   ghci> runCalculation

学习要点：
- 注意纯函数（calculate, parseNumber 等）与 IO 函数（main, prompt 等）的分离
- Either Monad 通过 do-notation 优雅地处理错误传播
- 错误类型让错误处理更清晰和类型安全
- 主循环使用递归实现
-}



