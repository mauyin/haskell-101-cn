{-# LANGUAGE OverloadedStrings #-}

{- |
Weather - 天气 API 客户端
=========================

使用 req 库调用 OpenWeatherMap API
-}

module Weather
  ( getWeather
  , WeatherError(..)
  ) where

import Network.HTTP.Req
import Data.Aeson
import Types
import qualified Data.Text as T

-- ============================================================================
-- 错误类型
-- ============================================================================

-- | 天气查询可能的错误
data WeatherError
  = NetworkError String      -- 网络错误
  | ParseError String        -- JSON 解析错误
  | APIError String          -- API 返回错误
  deriving (Show)


-- ============================================================================
-- API 配置
-- ============================================================================

-- API 基础 URL
-- https://api.openweathermap.org/data/2.5/weather
apiBase :: Url 'Https
apiBase = https "api.openweathermap.org" /: "data" /: "2.5" /: "weather"


-- ============================================================================
-- TODO: 实现天气查询
-- ============================================================================

-- | 获取指定城市的天气信息
--
-- 参数:
--   - apiKey: OpenWeatherMap API 密钥
--   - city: 城市名称（英文或拼音）
--
-- 返回:
--   - Right WeatherResponse: 成功获取天气数据
--   - Left WeatherError: 发生错误
--
-- 示例:
--   getWeather "YOUR_API_KEY" "Beijing"
getWeather :: String -> String -> IO (Either WeatherError WeatherResponse)
getWeather apiKey city = undefined  -- TODO: 实现
  {-
  提示：
  1. 使用 runReq defaultHttpConfig
  2. 构建查询参数：
     - q: 城市名
     - appid: API 密钥
     - units: "metric" (使用摄氏度)
     - lang: "zh_cn" (中文描述)
  3. 发起 GET 请求到 apiBase
  4. 使用 jsonResponse 自动解析
  5. 处理可能的异常（使用 try）
  
  参考实现结构：
  
  getWeather apiKey city = do
    result <- try $ runReq defaultHttpConfig $ do
      let params = "q" =: city
                <> "appid" =: apiKey
                <> "units" =: ("metric" :: String)
                <> "lang" =: ("zh_cn" :: String)
      
      response <- req
        GET
        apiBase
        NoReqBody
        jsonResponse
        params
      
      return $ responseBody response
    
    case result of
      Left (err :: SomeException) -> return $ Left (NetworkError $ show err)
      Right wr -> return $ Right wr
  -}


-- ============================================================================
-- 辅助函数（可选）
-- ============================================================================

-- | 验证 API 密钥格式（简单检查）
isValidApiKey :: String -> Bool
isValidApiKey key = length key > 10


-- | 清理城市名称（移除多余空格等）
cleanCityName :: String -> String
cleanCityName = undefined  -- TODO: 实现（可选）


{-
使用示例：

main :: IO ()
main = do
  result <- getWeather "YOUR_API_KEY" "Beijing"
  case result of
    Left err -> putStrLn $ "错误: " ++ show err
    Right wr -> print wr

API 文档:
https://openweathermap.org/current
-}

