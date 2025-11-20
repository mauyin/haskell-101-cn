{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

{- |
Config - 配置类型和操作
=======================

定义应用配置的数据结构和加载/保存函数
-}

module Config
  ( -- * 配置类型
    AppConfig(..)
  , ServerConfig(..)
  , DatabaseConfig(..)
  , LoggingConfig(..)
    -- * 操作
  , loadConfig
  , saveConfig
  , defaultConfig
  ) where

import Data.Aeson
import Data.Aeson.Encode.Pretty (encodePretty)
import GHC.Generics
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T

-- ============================================================================
-- 配置类型定义
-- ============================================================================

-- | 服务器配置
data ServerConfig = ServerConfig
  { port :: Int
  , host :: T.Text
  , enableSSL :: Bool
  } deriving (Show, Eq, Generic)

-- TODO: 实现 FromJSON 和 ToJSON 实例
instance FromJSON ServerConfig
instance ToJSON ServerConfig


-- | 数据库配置
data DatabaseConfig = DatabaseConfig
  { dbHost :: T.Text
  , dbPort :: Int
  , dbName :: T.Text
  , maxConnections :: Int
  } deriving (Show, Eq, Generic)

-- TODO: 实现 FromJSON 和 ToJSON 实例
instance FromJSON DatabaseConfig
instance ToJSON DatabaseConfig


-- | 日志配置
data LoggingConfig = LoggingConfig
  { level :: T.Text     -- "debug", "info", "warn", "error"
  , file :: T.Text      -- 日志文件路径
  } deriving (Show, Eq, Generic)

-- TODO: 实现 FromJSON 和 ToJSON 实例
instance FromJSON LoggingConfig
instance ToJSON LoggingConfig


-- | 应用配置（顶层）
data AppConfig = AppConfig
  { appName :: T.Text
  , version :: T.Text
  , server :: ServerConfig
  , database :: DatabaseConfig
  , logging :: LoggingConfig
  } deriving (Show, Eq, Generic)

-- TODO: 实现 FromJSON 和 ToJSON 实例
instance FromJSON AppConfig
instance ToJSON AppConfig


-- ============================================================================
-- 默认配置
-- ============================================================================

-- | 创建默认配置
--
-- 返回一个合理的默认配置，可以直接使用
defaultConfig :: AppConfig
defaultConfig = undefined  -- TODO: 实现
  {-
  提示：创建合理的默认值
  
  defaultConfig = AppConfig
    { appName = "MyApp"
    , version = "1.0.0"
    , server = ServerConfig
        { port = 8080
        , host = "localhost"
        , enableSSL = False
        }
    , database = DatabaseConfig
        { dbHost = "localhost"
        , dbPort = 5432
        , dbName = "mydb"
        , maxConnections = 10
        }
    , logging = LoggingConfig
        { level = "info"
        , file = "app.log"
        }
    }
  -}


-- ============================================================================
-- 加载和保存
-- ============================================================================

-- | 从文件加载配置
--
-- 返回:
--   - Right AppConfig: 成功加载并解析
--   - Left String: 错误消息
loadConfig :: FilePath -> IO (Either String AppConfig)
loadConfig path = undefined  -- TODO: 实现
  {-
  提示：
  1. 使用 BL.readFile 读取文件
  2. 使用 eitherDecode 解析 JSON
  3. 返回结果
  
  loadConfig path = do
    content <- BL.readFile path
    return $ eitherDecode content
  -}


-- | 保存配置到文件
--
-- 使用美化的 JSON 格式（带缩进）
saveConfig :: FilePath -> AppConfig -> IO ()
saveConfig path config = undefined  -- TODO: 实现
  {-
  提示：
  1. 使用 encodePretty 生成美化的 JSON
  2. 使用 BL.writeFile 写入文件
  
  saveConfig path config = BL.writeFile path (encodePretty config)
  -}


-- ============================================================================
-- 辅助函数（可选）
-- ============================================================================

-- | 更新服务器端口
updateServerPort :: Int -> AppConfig -> AppConfig
updateServerPort newPort config = 
  config { server = (server config) { port = newPort } }


-- | 更新日志级别
updateLogLevel :: T.Text -> AppConfig -> AppConfig
updateLogLevel newLevel config =
  config { logging = (logging config) { level = newLevel } }


{-
JSON 格式示例：

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

