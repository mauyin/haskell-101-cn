{- |
Main - JSON 解析器主程序
========================

命令行配置管理工具
-}

module Main where

import CLI
import System.Environment (getArgs)

-- ============================================================================
-- TODO: 实现主程序
-- ============================================================================

main :: IO ()
main = undefined  -- TODO: 实现
  {-
  提示：
  1. 获取命令行参数
  2. 解析命令
  3. 执行命令
  
  main = do
    args <- getArgs
    case parseCommand args of
      Left err -> do
        putStrLn $ "错误: " ++ err
        putStrLn ""
        runCommand Help
      Right cmd -> runCommand cmd
  -}


{-
使用说明：

1. 构建项目:
   cabal build

2. 创建默认配置:
   cabal run json-parser init config.json

3. 查看配置:
   cabal run json-parser show config.json

4. 验证配置:
   cabal run json-parser validate config.json

5. 显示帮助:
   cabal run json-parser help

配置文件格式：
{
  "appName": "MyApp",
  "version": "1.0.0",
  "server": {
    "port": 8080,
    "host": "localhost",
    "enableSSL": false
  },
  "database": {
    "dbHost": "localhost",
    "dbPort": 5432,
    "dbName": "mydb",
    "maxConnections": 10
  },
  "logging": {
    "level": "info",
    "file": "app.log"
  }
}
-}

