{- |
Week 5 - 练习答案: 模块与项目管理
==================================

这是Week05Exercises.hs的完整参考答案
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Week05Exercises where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import Data.Aeson
import qualified Data.Aeson.Key as K
import GHC.Generics
import qualified Data.Text as T
import Data.Text (Text)
import Network.HTTP.Req hiding (port)
import qualified Data.Map as M
import Data.List (nub, sort)
import Control.Exception (try, SomeException)
import Data.Char (toUpper)
import Control.Monad.IO.Class (liftIO)

-- ============================================================================
-- 练习 1: 模块基础
-- ============================================================================

-- 1.1 qualified import 示例
exampleQualifiedImport :: M.Map String Int -> String -> Maybe Int
exampleQualifiedImport m k = M.lookup k m

-- 1.2 对列表排序并去重
uniqueSorted :: Ord a => [a] -> [a]
uniqueSorted = nub . sort

-- ============================================================================
-- 练习 2: ByteString 操作
-- ============================================================================

-- 2.1 统计文件的字节数
countBytes :: FilePath -> IO Int
countBytes path = do
  content <- BC.readFile path
  return $ B.length content

-- 2.2 查找并替换
replaceBytes :: BC.ByteString -> BC.ByteString -> BC.ByteString -> BC.ByteString
replaceBytes old new content =
  BC.intercalate new (BC.split (BC.head old) content)

-- 2.3 按行处理大文件
processLargeFile :: FilePath -> (BC.ByteString -> BC.ByteString) -> FilePath -> IO ()
processLargeFile inputPath transform outputPath = do
  content <- BC.readFile inputPath
  let processed = BC.unlines $ map transform $ BC.lines content
  BC.writeFile outputPath processed

-- 2.4 简单 CSV 解析
parseCSV :: BC.ByteString -> [[BC.ByteString]]
parseCSV = map (BC.split ',') . BC.lines

-- ============================================================================
-- 练习 3: aeson JSON 处理
-- ============================================================================

-- 3.1 Person 类型
data Person = Person
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Show, Generic)

instance FromJSON Person
instance ToJSON Person

parsePerson :: BL.ByteString -> Maybe Person
parsePerson = decode

-- 3.2 Company 类型（嵌套）
data Company = Company
  { companyName :: String
  , employees :: [Person]
  , founded :: Int
  } deriving (Show, Generic)

instance FromJSON Company
instance ToJSON Company

parseCompany :: BL.ByteString -> Maybe Company
parseCompany = decode

-- 3.3 Config 类型（可选字段）
data Config = Config
  { host :: String
  , port :: Int
  , debug :: Maybe Bool
  , maxConnections :: Maybe Int
  } deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config

defaultConfig :: Config
defaultConfig = Config
  { host = "localhost"
  , port = 8080
  , debug = Just False
  , maxConnections = Just 100
  }

parseConfigWithDefaults :: BL.ByteString -> Maybe Config
parseConfigWithDefaults jsonData = do
  config <- decode jsonData
  return $ config
    { debug = case debug config of
        Nothing -> Just False
        Just d -> Just d
    , maxConnections = case maxConnections config of
        Nothing -> Just 100
        Just mc -> Just mc
    }

-- 3.4 User 类型（自定义字段名）
data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  } deriving (Show, Generic)

instance FromJSON User where
  parseJSON = withObject "User" $ \v -> User
    <$> v .: "user_id"
    <*> v .: "user_name"
    <*> v .: "user_email"

instance ToJSON User where
  toJSON user = object
    [ "user_id" .= userId user
    , "user_name" .= userName user
    , "user_email" .= userEmail user
    ]

-- ============================================================================
-- 练习 4: req HTTP 请求
-- ============================================================================

-- 4.1 简单 GET 请求
simpleGet :: IO ()
simpleGet = runReq defaultHttpConfig $ do
  response <- req
    GET
    (https "httpbin.org" /: "get")
    NoReqBody
    bsResponse
    mempty
  liftIO $ print (responseBody response)

-- 4.2 带参数的 GET 请求
getWithParams :: IO ()
getWithParams = runReq defaultHttpConfig $ do
  let params = "name" =: ("Alice" :: String)
            <> "age" =: (30 :: Int)
  response <- req
    GET
    (https "httpbin.org" /: "get")
    NoReqBody
    jsonResponse
    params
  liftIO $ print (responseBody response :: Value)

-- 4.3 POST JSON 数据
data Message = Message
  { message :: String
  , count :: Int
  } deriving (Show, Generic)

instance ToJSON Message
instance FromJSON Message

postJSON :: IO ()
postJSON = runReq defaultHttpConfig $ do
  let msg = Message "Hello" 42
  response <- req
    POST
    (https "httpbin.org" /: "post")
    (ReqBodyJson msg)
    jsonResponse
    mempty
  liftIO $ print (responseBody response :: Value)

-- 4.4 错误处理
safeRequest :: String -> IO (Either String String)
safeRequest url = do
  result <- try $ runReq defaultHttpConfig $ do
    response <- req
      GET
      (https "httpbin.org" /: "get")
      NoReqBody
      bsResponse
      mempty
    return $ show $ responseBody response
  case result of
    Left (e :: SomeException) -> return $ Left (show e)
    Right body -> return $ Right body

-- ============================================================================
-- 练习 5: 综合练习
-- ============================================================================

-- 5.1 简单网页爬虫
fetchPage :: String -> IO (Maybe BL.ByteString)
fetchPage url = do
  result <- try $ runReq defaultHttpConfig $ do
    response <- req
      GET
      (https "httpbin.org" /: "html")  -- 示例 URL
      NoReqBody
      bsResponse
      mempty
    return $ BL.fromStrict $ responseBody response
  case result of
    Left (_ :: SomeException) -> return Nothing
    Right content -> return $ Just content

extractTitle :: BL.ByteString -> Maybe String
extractTitle content =
  let str = map (toEnum . fromEnum) $ BL.unpack content :: String
      startTag = "<title>" :: String
      endTag = "</title>" :: String
  in case (findSubstring startTag str, findSubstring endTag str) of
       (Just start, Just end) | start < end ->
         Just $ take (end - start - length startTag) $ drop (start + length startTag) str
       _ -> Nothing
  where
    findSubstring needle haystack =
      let matches = [ i | i <- [0..length haystack - length needle]
                       , take (length needle) (drop i haystack) == needle ]
      in case matches of
           [] -> Nothing
           (x:_) -> Just x

crawl :: [String] -> FilePath -> IO ()
crawl urls outputFile = do
  results <- mapM fetchPage urls
  let titles = [ maybe "No title" id (extractTitle content)
               | Just content <- results ]
  writeFile outputFile (unlines titles)

-- 5.2 多 API 数据聚合
data APIResponse = APIResponse
  { source :: String
  , responseData :: Value
  } deriving (Show)

fetchFromAPIs :: [String] -> IO [APIResponse]
fetchFromAPIs urls = do
  mapM fetchOne (zip [1..] urls)
  where
    fetchOne (i, url) = do
      result <- try $ runReq defaultHttpConfig $ do
        response <- req
          GET
          (https "httpbin.org" /: "get")
          NoReqBody
          jsonResponse
          mempty
        return $ responseBody response
      case result of
        Left (_ :: SomeException) -> return $ APIResponse ("API " ++ show i) Null
        Right val -> return $ APIResponse ("API " ++ show i) val

aggregateData :: [APIResponse] -> Value
aggregateData responses =
  object [ K.fromText (T.pack (source r)) .= responseData r | r <- responses ]

-- ============================================================================
-- 测试数据和测试函数
-- ============================================================================

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

runTests :: IO ()
runTests = do
  putStrLn "=== Week 5 练习测试 ==="
  
  putStrLn "\n--- ByteString 测试 ---"
  let testBS = "foo bar foo"
  let replaced = replaceBytes "f" "b" testBS
  putStrLn $ "Replace test: " ++ show replaced
  
  putStrLn "\n--- JSON 测试 ---"
  case parsePerson testPersonJSON of
    Just person -> putStrLn $ "Person: " ++ show person
    Nothing -> putStrLn "Person parse failed"
  
  case parseCompany testCompanyJSON of
    Just company -> putStrLn $ "Company: " ++ show company
    Nothing -> putStrLn "Company parse failed"
  
  case decode testUserJSON of
    Just (user :: User) -> putStrLn $ "User: " ++ show user
    Nothing -> putStrLn "User parse failed"
  
  putStrLn "\n完成测试！"

