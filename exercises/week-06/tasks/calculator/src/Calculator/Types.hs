{- |
Calculator.Types - 计算器类型定义
=================================

TDD 练习：先写测试，再实现
-}

module Calculator.Types
  ( CalcError(..)
  , CalcResult
  ) where

-- TODO: 定义计算器错误类型
-- |
-- 计算器可能的错误
data CalcError
  = DivisionByZero     -- 除零错误
  | InvalidOperation   -- 无效操作
  | Overflow           -- 溢出
  | Underflow          -- 下溢
  deriving (Show, Eq)

-- | 计算结果类型
type CalcResult = Either CalcError Double

{-
TDD 工作流程：

1. 先在测试中定义需要的错误类型
2. 运行测试（失败）
3. 实现类型定义（测试通过）
4. 重构
-}

