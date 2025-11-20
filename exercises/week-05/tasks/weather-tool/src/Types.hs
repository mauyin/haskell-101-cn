{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

{- |
Types - 天气数据类型定义
========================

定义天气 API 响应的数据类型
-}

module Types where

import Data.Aeson
import GHC.Generics
import qualified Data.Text as T

-- ============================================================================
-- TODO: 定义天气数据类型
-- ============================================================================

-- | 天气信息（天气状况描述）
-- JSON 示例: {"main": "Clear", "description": "clear sky"}
data WeatherInfo = WeatherInfo
  { main :: T.Text         -- 主要天气状况（如 "Clear", "Rain"）
  , description :: T.Text  -- 详细描述
  } deriving (Show, Generic)

-- TODO: 实现 FromJSON 实例
-- 提示: 使用 Generic 自动派生
instance FromJSON WeatherInfo


-- | 温度和湿度信息
-- JSON 示例: {"temp": 25.5, "feels_like": 27.0, "humidity": 60}
data MainInfo = MainInfo
  { temp :: Double        -- 温度（摄氏度）
  , feels_like :: Double  -- 体感温度
  , humidity :: Int       -- 湿度（百分比）
  } deriving (Show, Generic)

-- TODO: 实现 FromJSON 实例
instance FromJSON MainInfo


-- | 完整天气响应
-- OpenWeatherMap API 返回的 JSON 结构
data WeatherResponse = WeatherResponse
  { weather :: [WeatherInfo]  -- 天气信息列表（通常只有一个）
  , mainInfo :: MainInfo      -- 温度信息
  , name :: T.Text            -- 城市名称
  } deriving (Show, Generic)

-- TODO: 实现自定义 FromJSON 实例
-- 注意：JSON 中的字段是 "main"，但我们的类型使用 "mainInfo"
instance FromJSON WeatherResponse where
  parseJSON = undefined  -- TODO: 使用 withObject 实现
  -- 提示:
  -- parseJSON = withObject "WeatherResponse" $ \v -> WeatherResponse
  --   <$> v .: "weather"
  --   <$> v .: "main"      -- JSON 字段是 "main"
  --   <$> v .: "name"


-- ============================================================================
-- 辅助函数
-- ============================================================================

-- | 从响应中获取第一个天气信息（如果存在）
getFirstWeather :: WeatherResponse -> Maybe WeatherInfo
getFirstWeather wr = case weather wr of
  []    -> Nothing
  (w:_) -> Just w


{-
JSON 响应示例：

{
  "weather": [
    {
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "main": {
    "temp": 25.5,
    "feels_like": 27.0,
    "humidity": 60
  },
  "name": "Beijing"
}
-}

