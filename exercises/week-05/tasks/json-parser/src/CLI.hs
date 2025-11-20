{- |
CLI - 命令行接口
================

解析命令行参数并执行相应操作
-}

module CLI
  ( Command(..)
  , parseCommand
  , runCommand
  ) where

import Config
import Validation
import qualified Data.Text.IO as TIO

-- ============================================================================
-- 命令类型
-- ============================================================================

-- | 支持的命令
data Command
  = Init FilePath                    -- 创建默认配置
  | Show FilePath                    -- 显示配置
  | Validate FilePath                -- 验证配置
  | Set FilePath String String       -- 设置配置项（扩展功能）
  | Help                             -- 显示帮助
  deriving (Show, Eq)


-- ============================================================================
-- TODO: 实现命令解析
-- ============================================================================

-- | 从命令行参数解析命令
--
-- 示例:
--   parseCommand ["init", "config.json"] => Right (Init "config.json")
--   parseCommand ["show", "config.json"] => Right (Show "config.json")
parseCommand :: [String] -> Either String Command
parseCommand args = undefined  -- TODO: 实现
  {-
  提示：
  1. 使用模式匹配解析参数列表
  2. 检查参数数量
  3. 返回对应的 Command 或错误
  
  parseCommand ["init", path] = Right (Init path)
  parseCommand ["show", path] = Right (Show path)
  parseCommand ["validate", path] = Right (Validate path)
  parseCommand ["set", path, key, value] = Right (Set path key value)
  parseCommand ["help"] = Right Help
  parseCommand [] = Right Help
  parseCommand _ = Left "无效的命令"
  -}


-- ============================================================================
-- TODO: 实现命令执行
-- ============================================================================

-- | 执行命令
runCommand :: Command -> IO ()
runCommand cmd = undefined  -- TODO: 实现
  {-
  提示：根据不同命令执行相应操作
  
  runCommand (Init path) = do
    saveConfig path defaultConfig
    putStrLn $ "已创建默认配置: " ++ path
  
  runCommand (Show path) = do
    result <- loadConfig path
    case result of
      Left err -> putStrLn $ "加载错误: " ++ err
      Right config -> print config
  
  runCommand (Validate path) = do
    result <- loadConfig path
    case result of
      Left err -> putStrLn $ "加载错误: " ++ err
      Right config -> do
        let errors = validateConfig config
        if null errors
          then putStrLn "配置有效！"
          else do
            putStrLn "发现以下错误："
            mapM_ print errors
  
  runCommand Help = printHelp
  
  runCommand _ = putStrLn "未实现"
  -}


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- | 打印帮助信息
printHelp :: IO ()
printHelp = putStrLn $ unlines
  [ "JSON 配置管理工具"
  , ""
  , "用法:"
  , "  json-parser init <文件>      - 创建默认配置文件"
  , "  json-parser show <文件>      - 显示配置内容"
  , "  json-parser validate <文件>  - 验证配置"
  , "  json-parser help             - 显示此帮助"
  , ""
  , "示例:"
  , "  json-parser init config.json"
  , "  json-parser show config.json"
  , "  json-parser validate config.json"
  ]


{-
使用示例：

main :: IO ()
main = do
  args <- getArgs
  case parseCommand args of
    Left err -> putStrLn err >> printHelp
    Right cmd -> runCommand cmd
-}

