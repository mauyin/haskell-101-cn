{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

{- |
Simple HTTP Client Example
使用 req 库的完整示例
-}

module Main where

import Network.HTTP.Req
import Data.Aeson
import GHC.Generics
import qualified Data.Text as T
import Control.Monad.IO.Class (liftIO)

-- JSON 响应数据类型
data Post = Post
  { userId :: Int
  , id :: Int
  , title :: T.Text
  , body :: T.Text
  } deriving (Show, Generic)

instance FromJSON Post
instance ToJSON Post

-- 获取单个文章
getPost :: Int -> IO ()
getPost postId = runReq defaultHttpConfig $ do
  response <- req
    GET
    (https "jsonplaceholder.typicode.com" /: "posts" /~ postId)
    NoReqBody
    jsonResponse
    mempty
  let post = responseBody response :: Post
  liftIO $ do
    putStrLn $ "标题: " ++ T.unpack (title post)
    putStrLn $ "内容: " ++ T.unpack (body post)

-- 获取所有文章
getAllPosts :: IO ()
getAllPosts = runReq defaultHttpConfig $ do
  response <- req
    GET
    (https "jsonplaceholder.typicode.com" /: "posts")
    NoReqBody
    jsonResponse
    mempty
  let posts = responseBody response :: [Post]
  liftIO $ putStrLn $ "共 " ++ show (length posts) ++ " 篇文章"

-- 创建新文章
createPost :: IO ()
createPost = runReq defaultHttpConfig $ do
  let newPost = Post 1 0 "测试标题" "测试内容"
  response <- req
    POST
    (https "jsonplaceholder.typicode.com" /: "posts")
    (ReqBodyJson newPost)
    jsonResponse
    mempty
  let created = responseBody response :: Post
  liftIO $ print created

main :: IO ()
main = do
  putStrLn "=== HTTP 客户端示例 ==="
  putStrLn "\n1. 获取单个文章:"
  getPost 1
  
  putStrLn "\n2. 获取所有文章:"
  getAllPosts
  
  putStrLn "\n3. 创建新文章:"
  createPost

