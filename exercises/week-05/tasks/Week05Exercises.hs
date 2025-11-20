{- |
Week 5 - 练习: 模块与项目管理
================================

本练习涵盖：
- 模块系统基础
- ByteString 操作
- aeson JSON 处理
- req HTTP 请求
- 综合应用

如何使用：
1. 完成每个 TODO
2. 在 GHCi 中测试：ghci> :load Week05Exercises.hs
3. 对照 solutions/ 中的参考答案
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Week05Exercises where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import Data.Aeson
import GHC.Generics
import qualified Data.Text as T
import Data.Text (Text)
import Network.HTTP.Req
import qualified Data.Map as M
import Data.List (intercalate)

-- ============================================================================
-- 练习 1: 模块基础
-- ============================================================================

{- |
模块练习在单独的文件中：
- MyModule.hs - 定义自己的模块
- 在这里练习导入

参考 lecture.md 第1-2节
-}

-- 1.1 这个文件演示如何使用 qualified import
-- Data.Map 和 Prelude 都有 lookup 函数
exampleQualifiedImport :: M.Map String Int -> String -> Maybe Int
exampleQualifiedImport = M.lookup  -- 明确使用 Map 的 lookup

-- 1.2 TODO: 使用 Data.List 的函数（已导入）
-- 对列表排序并去重
uniqueSorted :: Ord a => [a] -> [a]
uniqueSorted = undefined
-- 提示: 使用 sort 和 nub


-- ============================================================================
-- 练习 2: ByteString 操作
-- ============================================================================

-- 2.1 TODO: 统计文件的字节数
-- |
-- 读取文件并返回字节数
-- 
-- 示例:
--   countBytes "example.txt" 应该返回文件大小
countBytes :: FilePath -> IO Int
countBytes path = undefined
-- 提示: 使用 BC.readFile 和 B.length


-- 2.2 TODO: 查找并替换
-- |
-- 在 ByteString 中查找并替换所有出现的子串
--
-- 示例:
--   replaceBytes "foo" "bar" "foo baz foo" 应该返回 "bar baz bar"
replaceBytes :: BC.ByteString -> BC.ByteString -> BC.ByteString -> BC.ByteString
replaceBytes old new content = undefined
-- 提示: 使用 BC.split 和 BC.intercalate


-- 2.3 TODO: 按行处理大文件
-- |
-- 读取大文件，对每行应用转换函数，写入输出文件
-- 使用惰性 ByteString 处理大文件
--
-- 示例:
--   processLargeFile "input.txt" (BC.map toUpper) "output.txt"
--   应该将输入文件转为大写写入输出文件
processLargeFile :: FilePath -> (BC.ByteString -> BC.ByteString) -> FilePath -> IO ()
processLargeFile inputPath transform outputPath = undefined
-- 提示: 使用 BC.lines, map transform, BC.unlines


-- 2.4 TODO: 简单 CSV 解析
-- |
-- 解析 CSV 格式的 ByteString
--
-- 示例:
--   parseCSV "a,b,c\n1,2,3" 应该返回 [["a","b","c"], ["1","2","3"]]
parseCSV :: BC.ByteString -> [[BC.ByteString]]
parseCSV = undefined
-- 提示: 使用 BC.lines 和 BC.split ','


-- ============================================================================
-- 练习 3: aeson JSON 处理
-- ============================================================================

-- 3.1 TODO: 定义并解析简单 JSON
-- |
-- Person 类型表示一个人
data Person = Person
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Show, Generic)

-- TODO: 实现 FromJSON 和 ToJSON 实例
-- 提示: 使用 Generic 派生
instance FromJSON Person
instance ToJSON Person

-- TODO: 解析 Person JSON
-- |
-- 示例:
--   parsePerson "{\"name\":\"Alice\",\"age\":30,\"email\":\"alice@example.com\"}"
--   应该返回 Just (Person "Alice" 30 "alice@example.com")
parsePerson :: BL.ByteString -> Maybe Person
parsePerson = undefined
-- 提示: 使用 decode


-- 3.2 TODO: 处理嵌套 JSON
-- |
-- Company 类型表示公司（包含员工列表）
data Company = Company
  { companyName :: String
  , employees :: [Person]
  , founded :: Int
  } deriving (Show, Generic)

instance FromJSON Company
instance ToJSON Company

-- TODO: 解析公司 JSON
parseCompany :: BL.ByteString -> Maybe Company
parseCompany = undefined


-- 3.3 TODO: 处理可选字段
-- |
-- Config 类型有些字段是可选的
data Config = Config
  { host :: String
  , port :: Int
  , debug :: Maybe Bool
  , maxConnections :: Maybe Int
  } deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config

-- TODO: 创建默认配置
-- debug 默认 False，maxConnections 默认 100
defaultConfig :: Config
defaultConfig = undefined


-- TODO: 解析配置并应用默认值
parseConfigWithDefaults :: BL.ByteString -> Maybe Config
parseConfigWithDefaults jsonData = undefined
-- 提示: 解析后，用 maybe 处理可选字段


-- 3.4 TODO: 自定义字段名映射
-- |
-- User 类型使用 camelCase，但 JSON 使用 snake_case
data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  } deriving (Show, Generic)

-- TODO: 实现自定义 FromJSON 实例
-- JSON 格式: {"user_id": 1, "user_name": "Alice", "user_email": "alice@example.com"}
instance FromJSON User where
  parseJSON = undefined
-- 提示: 使用 withObject 和 (.:)

instance ToJSON User where
  toJSON user = object
    [ "user_id" .= userId user
    , "user_name" .= userName user
    , "user_email" .= userEmail user
    ]


-- ============================================================================
-- 练习 4: req HTTP 请求
-- ============================================================================

-- 4.1 TODO: 简单 GET 请求
-- |
-- 获取 https://httpbin.org/get 并打印响应体
--
-- 注意: 这是 IO 操作，在 GHCi 中运行测试
simpleGet :: IO ()
simpleGet = undefined
-- 提示: 使用 runReq defaultHttpConfig


-- 4.2 TODO: 带参数的 GET 请求
-- |
-- 请求 https://httpbin.org/get?name=Alice&age=30
-- 打印 JSON 响应
getWithParams :: IO ()
getWithParams = undefined
-- 提示: 使用 (=:) 构建参数，mempty 连接多个参数


-- 4.3 TODO: POST JSON 数据
-- |
-- POST 到 https://httpbin.org/post
-- Body: {"message": "Hello", "count": 42}
data Message = Message
  { message :: String
  , count :: Int
  } deriving (Show, Generic)

instance ToJSON Message
instance FromJSON Message

postJSON :: IO ()
postJSON = undefined
-- 提示: 使用 ReqBodyJson


-- 4.4 TODO: 错误处理
-- |
-- 安全地请求 URL，捕获可能的错误
-- 返回 Left 错误消息 或 Right 响应体
safeRequest :: String -> IO (Either String String)
safeRequest url = undefined
-- 提示: 使用 Control.Exception.try


-- ============================================================================
-- 练习 5: 综合练习
-- ============================================================================

-- 5.1 TODO: 简单网页爬虫
-- |
-- 获取网页内容
fetchPage :: String -> IO (Maybe BL.ByteString)
fetchPage url = undefined
-- 提示: 使用 req GET，返回 bsResponse


-- TODO: 提取标题（简化版：查找第一个 <title> ... </title>）
extractTitle :: BL.ByteString -> Maybe String
extractTitle content = undefined
-- 提示: 转换为 String，使用字符串查找


-- TODO: 爬取多个 URL 并保存标题
crawl :: [String] -> FilePath -> IO ()
crawl urls outputFile = undefined
-- 提示: mapM fetchPage urls，然后 mapM extractTitle


-- 5.2 TODO: 多 API 数据聚合
-- |
-- API 响应类型
data APIResponse = APIResponse
  { source :: String
  , responseData :: Value
  } deriving (Show)

-- TODO: 从多个 API 获取数据
fetchFromAPIs :: [String] -> IO [APIResponse]
fetchFromAPIs urls = undefined


-- TODO: 聚合数据（合并为一个 JSON）
aggregateData :: [APIResponse] -> Value
aggregateData responses = undefined


-- ============================================================================
-- 辅助函数和测试
-- ============================================================================

-- 测试用的 JSON 数据
testPersonJSON :: BL.ByteString
testPersonJSON = "{\"name\":\"Alice\",\"age\":30,\"email\":\"alice@example.com\"}"

testCompanyJSON :: BL.ByteString
testCompanyJSON = "{\
  \\"companyName\":\"Tech Corp\",\
  \\"employees\":[\
    \{\"name\":\"Alice\",\"age\":30,\"email\":\"alice@example.com\"},\
    \{\"name\":\"Bob\",\"age\":25,\"email\":\"bob@example.com\"}\
  \],\
  \\"founded\":2020\
  \}"

testConfigJSON :: BL.ByteString
testConfigJSON = "{\"host\":\"localhost\",\"port\":8080}"

testUserJSON :: BL.ByteString
testUserJSON = "{\"user_id\":1,\"user_name\":\"Alice\",\"user_email\":\"alice@example.com\"}"

-- 运行所有测试
runTests :: IO ()
runTests = do
  putStrLn "=== Week 5 练习测试 ==="
  
  putStrLn "\n--- ByteString 测试 ---"
  -- 测试 replaceBytes
  let testBS = "foo bar foo"
  let replaced = replaceBytes "foo" "baz" testBS
  putStrLn $ "Replace test: " ++ show replaced
  
  putStrLn "\n--- JSON 测试 ---"
  -- 测试 Person 解析
  case parsePerson testPersonJSON of
    Just person -> putStrLn $ "Person: " ++ show person
    Nothing -> putStrLn "Person parse failed"
  
  -- 测试 Company 解析
  case parseCompany testCompanyJSON of
    Just company -> putStrLn $ "Company: " ++ show company
    Nothing -> putStrLn "Company parse failed"
  
  putStrLn "\n完成测试！"

{-
在 GHCi 中测试：

ghci> :load Week05Exercises.hs
ghci> runTests

单独测试函数：
ghci> parsePerson testPersonJSON
ghci> parseCompany testCompanyJSON
ghci> simpleGet
ghci> getWithParams

记得完成所有 TODO！
-}

