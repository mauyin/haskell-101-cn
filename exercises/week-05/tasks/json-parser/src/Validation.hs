{-# LANGUAGE OverloadedStrings #-}

{- |
Validation - 配置验证
=====================

验证配置的合法性
-}

module Validation
  ( ValidationError(..)
  , validateConfig
  , isValid
  ) where

import Config
import qualified Data.Text as T

-- ============================================================================
-- 验证错误类型
-- ============================================================================

-- | 验证错误
data ValidationError
  = InvalidPort Int           -- 端口号无效
  | InvalidHost T.Text        -- 主机名无效
  | InvalidLogLevel T.Text    -- 日志级别无效
  | InvalidDbName T.Text      -- 数据库名无效
  | EmptyAppName              -- 应用名为空
  | InvalidVersion T.Text     -- 版本号格式无效
  deriving (Show, Eq)


-- ============================================================================
-- TODO: 实现验证函数
-- ============================================================================

-- | 验证配置
--
-- 返回所有验证错误的列表
-- 如果列表为空，表示配置有效
validateConfig :: AppConfig -> [ValidationError]
validateConfig config = undefined  -- TODO: 实现
  {-
  提示：
  1. 验证各个字段
  2. 收集所有错误
  3. 返回错误列表
  
  示例实现结构：
  
  validateConfig config = 
    validateServer (server config)
    ++ validateDatabase (database config)
    ++ validateLogging (logging config)
    ++ validateApp config
  
  where
    validateServer srv = 
      if port srv < 1 || port srv > 65535
        then [InvalidPort (port srv)]
        else []
    
    validateDatabase db =
      if T.null (dbName db)
        then [InvalidDbName (dbName db)]
        else []
    
    ... 等等
  -}


-- | 检查配置是否有效
isValid :: AppConfig -> Bool
isValid config = null (validateConfig config)


-- ============================================================================
-- 辅助验证函数
-- ============================================================================

-- | 验证端口号
isValidPort :: Int -> Bool
isValidPort p = p >= 1 && p <= 65535


-- | 验证主机名（简单检查）
isValidHost :: T.Text -> Bool
isValidHost h = not (T.null h)


-- | 验证日志级别
isValidLogLevel :: T.Text -> Bool
isValidLogLevel level = level `elem` validLevels
  where
    validLevels = ["debug", "info", "warn", "error"]


-- | 验证版本号格式（简单检查：x.y.z）
isValidVersion :: T.Text -> Bool
isValidVersion v = length (T.split (== '.') v) == 3


{-
使用示例：

main :: IO ()
main = do
  result <- loadConfig "config.json"
  case result of
    Left err -> putStrLn $ "加载错误: " ++ err
    Right config -> do
      let errors = validateConfig config
      if null errors
        then putStrLn "配置有效！"
        else do
          putStrLn "配置错误："
          mapM_ print errors
-}

