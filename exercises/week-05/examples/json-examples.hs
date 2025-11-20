{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

{- |
JSON Processing Examples
aeson 库的各种用法示例
-}

module Main where

import Data.Aeson
import Data.Aeson.Encode.Pretty (encodePretty)
import GHC.Generics
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T

-- ============================================================================
-- 示例 1: 简单类型
-- ============================================================================

data Person = Person
  { name :: String
  , age :: Int
  } deriving (Show, Generic)

instance FromJSON Person
instance ToJSON Person

example1 :: IO ()
example1 = do
  putStrLn "=== 示例 1: 简单类型 ==="
  
  let person = Person "Alice" 30
  let json = encode person
  putStrLn $ "编码: " ++ show json
  
  case decode json of
    Just p -> putStrLn $ "解码: " ++ show (p :: Person)
    Nothing -> putStrLn "解码失败"

-- ============================================================================
-- 示例 2: 嵌套类型
-- ============================================================================

data Address = Address
  { street :: String
  , city :: String
  } deriving (Show, Generic)

instance FromJSON Address
instance ToJSON Address

data Employee = Employee
  { empName :: String
  , empAge :: Int
  , empAddress :: Address
  } deriving (Show, Generic)

instance FromJSON Employee
instance ToJSON Employee

example2 :: IO ()
example2 = do
  putStrLn "\n=== 示例 2: 嵌套类型 ==="
  
  let emp = Employee "Bob" 25 (Address "123 Main St" "Beijing")
  let json = encodePretty emp
  BL.putStrLn json

-- ============================================================================
-- 示例 3: 列表和 Maybe
-- ============================================================================

data Team = Team
  { teamName :: String
  , members :: [Person]
  , leader :: Maybe Person
  } deriving (Show, Generic)

instance FromJSON Team
instance ToJSON Team

example3 :: IO ()
example3 = do
  putStrLn "\n=== 示例 3: 列表和 Maybe ==="
  
  let team = Team
        { teamName = "开发团队"
        , members = [Person "Alice" 30, Person "Bob" 25]
        , leader = Just (Person "Charlie" 35)
        }
  
  BL.putStrLn $ encodePretty team

-- ============================================================================
-- 示例 4: 自定义字段名
-- ============================================================================

data Config = Config
  { cfgPort :: Int
  , cfgHost :: String
  , cfgDebug :: Bool
  } deriving (Show, Generic)

instance FromJSON Config where
  parseJSON = withObject "Config" $ \v -> Config
    <$> v .: "port"
    <$> v .: "host"
    <$> v .: "debug"

instance ToJSON Config where
  toJSON cfg = object
    [ "port" .= cfgPort cfg
    , "host" .= cfgHost cfg
    , "debug" .= cfgDebug cfg
    ]

example4 :: IO ()
example4 = do
  putStrLn "\n=== 示例 4: 自定义字段名 ==="
  
  let config = Config 8080 "localhost" True
  BL.putStrLn $ encodePretty config
  
  let jsonStr = "{\"port\":3000,\"host\":\"0.0.0.0\",\"debug\":false}"
  case decode jsonStr of
    Just cfg -> putStrLn $ "解析的配置: " ++ show (cfg :: Config)
    Nothing -> putStrLn "解析失败"

-- ============================================================================
-- Main
-- ============================================================================

main :: IO ()
main = do
  example1
  example2
  example3
  example4

