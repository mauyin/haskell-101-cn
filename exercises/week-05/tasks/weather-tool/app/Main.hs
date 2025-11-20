{- |
Main - 天气工具主程序
=====================

命令行入口
-}

module Main where

import Weather
import Display
import System.Environment (getArgs)
import System.Exit (die)

-- ============================================================================
-- TODO: 实现主程序
-- ============================================================================

main :: IO ()
main = undefined  -- TODO: 实现
  {-
  任务：
  1. 获取命令行参数
  2. 验证参数数量（需要 API key 和城市名）
  3. 调用 getWeather
  4. 根据结果显示天气或错误
  
  参考实现：
  
  main = do
    args <- getArgs
    case args of
      [apiKey, city] -> do
        result <- getWeather apiKey city
        case result of
          Left err -> displayError err
          Right wr -> displayWeather wr
      
      _ -> die "用法: weather-tool <API_KEY> <城市名>\n\
               \示例: weather-tool abc123 Beijing"
  -}


{-
使用说明：

1. 获取 API 密钥:
   - 访问 https://openweathermap.org/api
   - 注册免费账号
   - 获取 API key

2. 构建项目:
   cabal build

3. 运行程序:
   cabal run weather-tool YOUR_API_KEY Beijing

4. 测试不同城市:
   cabal run weather-tool YOUR_API_KEY Shanghai
   cabal run weather-tool YOUR_API_KEY "New York"
   cabal run weather-tool YOUR_API_KEY Tokyo

注意：
- 城市名使用英文或拼音
- 多个单词的城市名用引号括起来
- API 有请求限制（免费版 60 次/分钟）
-}

