{-# LANGUAGE OverloadedStrings #-}

{- |
Display - 天气信息显示
======================

格式化输出天气信息
-}

module Display
  ( displayWeather
  , displayError
  , prettyPrintWeather
  ) where

import Types
import Weather (WeatherError(..))
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- ============================================================================
-- TODO: 实现显示函数
-- ============================================================================

-- | 显示天气信息（简单版本）
--
-- 输出格式:
--   城市：北京
--   天气：晴
--   描述：万里无云
--   温度：25.5°C
--   体感：27.0°C
--   湿度：60%
displayWeather :: WeatherResponse -> IO ()
displayWeather wr = undefined  -- TODO: 实现
  {-
  提示：
  1. 使用 TIO.putStrLn 输出 Text
  2. 使用 putStrLn 输出 String
  3. 从 weather 列表获取第一个元素（使用 head 或模式匹配）
  4. 格式化温度和湿度数字
  
  参考实现：
  
  displayWeather wr = do
    TIO.putStrLn $ "城市：" <> name wr
    
    case weather wr of
      [] -> putStrLn "无天气数据"
      (w:_) -> do
        TIO.putStrLn $ "天气：" <> main w
        TIO.putStrLn $ "描述：" <> description w
    
    let m = mainInfo wr
    putStrLn $ "温度：" ++ show (temp m) ++ "°C"
    putStrLn $ "体感：" ++ show (feels_like m) ++ "°C"
    putStrLn $ "湿度：" ++ show (humidity m) ++ "%"
  -}


-- | 显示错误信息
displayError :: WeatherError -> IO ()
displayError = undefined  -- TODO: 实现
  {-
  提示：根据不同的错误类型显示不同消息
  
  displayError (NetworkError msg) = putStrLn $ "网络错误: " ++ msg
  displayError (ParseError msg) = putStrLn $ "解析错误: " ++ msg
  displayError (APIError msg) = putStrLn $ "API 错误: " ++ msg
  -}


-- | 美化输出（带边框）
--
-- 输出格式:
--   ╔════════════════════════╗
--   ║     天气信息 - 北京     ║
--   ╠════════════════════════╣
--   ║ 天气：晴               ║
--   ║ 温度：25.5°C           ║
--   ║ 湿度：60%              ║
--   ╚════════════════════════╝
prettyPrintWeather :: WeatherResponse -> IO ()
prettyPrintWeather wr = undefined  -- TODO: 实现（挑战题）
  {-
  提示：
  1. 使用 Unicode 绘制边框
  2. 计算字符串长度以对齐
  3. 使用 T.length 获取 Text 长度
  -}


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- | 格式化温度（带单位和颜色提示，可选）
formatTemp :: Double -> String
formatTemp t = show t ++ "°C"


-- | 温度转华氏度（可选功能）
celsiusToFahrenheit :: Double -> Double
celsiusToFahrenheit c = c * 9 / 5 + 32


{-
使用示例：

main :: IO ()
main = do
  result <- getWeather "API_KEY" "Beijing"
  case result of
    Left err -> displayError err
    Right wr -> displayWeather wr
-}

