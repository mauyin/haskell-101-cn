{- |
Week 4 - 挑战题: Monad 与 IO 进阶
================================

本文件包含 5 个进阶挑战项目，适合完成基础练习后挑战。

难度说明：
⭐⭐⭐⭐☆ - 中等挑战
⭐⭐⭐⭐⭐ - 高级挑战

如何使用：
1. 每个挑战都是一个完整的小项目
2. 可以分模块实现，逐步完善
3. 建议先设计数据结构和类型签名
4. 测试每个小功能后再组合

提示：
- 可以使用额外的库（如 Data.Map, Data.Set）
- 注重代码组织和模块化
- 考虑错误处理和边界情况
- 写测试用例验证功能
-}

{-# LANGUAGE OverloadedStrings #-}

module Week04Challenges where

import Control.Monad (when, unless, forM_, foldM)
import Data.List (intercalate, isPrefixOf, sortBy)
import Data.Ord (comparing)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.IO (hFlush, stdout)

-- ============================================================================
-- 挑战 1: 命令行文本编辑器 ⭐⭐⭐⭐⭐
-- ============================================================================

{-
实现一个简单的文本编辑器，支持：
1. 加载文件
2. 显示内容（带行号）
3. 插入行
4. 删除行
5. 修改行
6. 保存文件
7. 撤销/重做（使用命令历史）

数据结构建议：
- 使用列表存储文本行
- 使用栈存储命令历史（用于撤销）
-}

type Line = String
type LineNumber = Int

data EditorState = EditorState
  { content :: [Line]           -- 文件内容
  , filePath :: Maybe FilePath  -- 当前文件路径
  , modified :: Bool            -- 是否修改过
  , history :: [EditorCommand]  -- 命令历史（用于撤销）
  } deriving (Show)

data EditorCommand
  = InsertLine LineNumber Line
  | DeleteLine LineNumber
  | ModifyLine LineNumber Line
  | LoadFile FilePath
  | SaveFile FilePath
  deriving (Show, Eq)

-- 1.1 创建空编辑器状态
emptyEditor :: EditorState
emptyEditor = undefined  -- TODO

-- 1.2 加载文件到编辑器
loadFileToEditor :: FilePath -> IO EditorState
loadFileToEditor path = undefined  -- TODO

-- 1.3 保存编辑器内容到文件
saveEditorToFile :: EditorState -> IO EditorState
saveEditorToFile state = undefined  -- TODO

-- 1.4 显示编辑器内容（带行号）
displayEditor :: EditorState -> IO ()
displayEditor state = undefined  -- TODO

-- 1.5 插入新行
insertLineInEditor :: LineNumber -> Line -> EditorState -> EditorState
insertLineInEditor lineNum line state = undefined  -- TODO

-- 1.6 删除行
deleteLineInEditor :: LineNumber -> EditorState -> Maybe EditorState
deleteLineInEditor lineNum state = undefined  -- TODO

-- 1.7 修改行
modifyLineInEditor :: LineNumber -> Line -> EditorState -> Maybe EditorState
modifyLineInEditor lineNum newLine state = undefined  -- TODO

-- 1.8 撤销上一个操作
undoEditor :: EditorState -> Maybe EditorState
undoEditor state = undefined  -- TODO

-- 1.9 编辑器主循环
editorMainLoop :: EditorState -> IO ()
editorMainLoop state = undefined  -- TODO
-- 提示：显示菜单，接受命令，更新状态，递归调用

-- 1.10 启动编辑器
startEditor :: IO ()
startEditor = undefined  -- TODO


-- ============================================================================
-- 挑战 2: CSV 解析器和处理器 ⭐⭐⭐⭐☆
-- ============================================================================

{-
实现一个 CSV 文件处理工具，支持：
1. 解析 CSV 文件
2. 显示数据（表格形式）
3. 过滤行（按条件）
4. 排序（按指定列）
5. 统计（求和、平均值等）
6. 导出为新 CSV

数据结构：
-}

type CSVRow = [String]
type CSVData = [CSVRow]

data CSVTable = CSVTable
  { headers :: CSVRow     -- 表头
  , rows :: [CSVRow]      -- 数据行
  } deriving (Show, Eq)

-- 2.1 解析 CSV 文件
parseCSV :: FilePath -> IO CSVTable
parseCSV path = undefined  -- TODO
-- 提示：用 lines 和 splitOn ',' 实现简单解析

-- 辅助函数：分割 CSV 行
splitCSVLine :: String -> CSVRow
splitCSVLine line = undefined  -- TODO
-- 提示：简单版本用 words 或手动实现，不需要处理引号内逗号

-- 2.2 显示 CSV 表格（对齐格式）
displayCSVTable :: CSVTable -> IO ()
displayCSVTable table = undefined  -- TODO

-- 2.3 过滤行（保留满足条件的行）
filterCSVRows :: (CSVRow -> Bool) -> CSVTable -> CSVTable
filterCSVRows predicate table = undefined  -- TODO

-- 2.4 按列排序
sortCSVByColumn :: Int -> CSVTable -> CSVTable
sortCSVByColumn colIndex table = undefined  -- TODO

-- 2.5 获取某列的所有值
getColumn :: Int -> CSVTable -> [String]
getColumn colIndex table = undefined  -- TODO

-- 2.6 统计数值列
data ColumnStats = ColumnStats
  { colSum :: Double
  , colAvg :: Double
  , colMin :: Double
  , colMax :: Double
  , colCount :: Int
  } deriving (Show)

calculateColumnStats :: Int -> CSVTable -> Maybe ColumnStats
calculateColumnStats colIndex table = undefined  -- TODO

-- 2.7 导出为 CSV 文件
exportCSV :: FilePath -> CSVTable -> IO ()
exportCSV path table = undefined  -- TODO

-- 2.8 CSV 处理器主程序
csvProcessor :: IO ()
csvProcessor = undefined  -- TODO
-- 提示：提供交互式菜单，支持加载、过滤、排序、统计、导出


-- ============================================================================
-- 挑战 3: 文件加密/解密工具 ⭐⭐⭐⭐☆
-- ============================================================================

{-
实现一个简单的文件加密工具，使用 XOR 加密：
1. 读取文件
2. 用密钥加密/解密
3. 保存加密后的文件
4. 验证解密正确性

加密算法：XOR cipher
- 简单但有效的演示
- 密钥循环使用
-}

type Key = String

-- 3.1 XOR 加密/解密（对称的）
xorCipher :: Key -> String -> String
xorCipher key text = undefined  -- TODO
-- 提示：zip 密钥和文本，对每对字符 XOR

-- 辅助函数：XOR 两个字符
xorChar :: Char -> Char -> Char
xorChar c k = undefined  -- TODO
-- 提示：fromEnum, xor, toEnum

-- 3.2 加密文件
encryptFile :: Key -> FilePath -> FilePath -> IO ()
encryptFile key inputPath outputPath = undefined  -- TODO

-- 3.3 解密文件
decryptFile :: Key -> FilePath -> FilePath -> IO ()
decryptFile key inputPath outputPath = undefined  -- TODO
-- 注意：XOR 是对称的，加密和解密是同一个操作！

-- 3.4 验证加密/解密
verifyEncryption :: Key -> FilePath -> IO Bool
verifyEncryption key path = undefined  -- TODO
-- 提示：加密后解密，比较是否与原文件相同

-- 3.5 交互式加密工具
encryptionTool :: IO ()
encryptionTool = undefined  -- TODO
-- 提示：菜单选择加密/解密，输入文件路径和密钥


-- ============================================================================
-- 挑战 4: HTTP 客户端和 JSON API 封装 ⭐⭐⭐⭐⭐
-- ============================================================================

{-
实现一个简单的 HTTP 客户端，与 JSON API 交互。

注意：这个挑战需要额外的库：
- http-conduit 或 req
- aeson

可以使用 httpbin.org 作为测试 API。

功能：
1. GET 请求
2. POST 请求
3. 解析 JSON 响应
4. 错误处理
5. 封装特定 API 客户端
-}

-- 由于需要外部库，这里只提供类型签名和结构

-- 数据类型示例
data HttpMethod = GET | POST | PUT | DELETE
  deriving (Show, Eq)

data HttpRequest = HttpRequest
  { method :: HttpMethod
  , url :: String
  , headers :: [(String, String)]
  , body :: Maybe String
  } deriving (Show)

data HttpResponse = HttpResponse
  { statusCode :: Int
  , responseHeaders :: [(String, String)]
  , responseBody :: String
  } deriving (Show)

-- 4.1 创建简单 GET 请求
-- makeGetRequest :: String -> HttpRequest
-- makeGetRequest url = undefined  -- TODO

-- 4.2 创建 POST 请求
-- makePostRequest :: String -> String -> HttpRequest
-- makePostRequest url body = undefined  -- TODO

-- 4.3 发送请求（需要 http-conduit）
-- sendRequest :: HttpRequest -> IO (Either String HttpResponse)
-- sendRequest req = undefined  -- TODO

-- 4.4 解析 JSON 响应（需要 aeson）
-- parseJSON :: String -> Maybe Value
-- parseJSON jsonStr = undefined  -- TODO

-- 4.5 封装天气 API 客户端示例
-- data Weather = Weather
--   { temperature :: Double
--   , description :: String
--   } deriving (Show)

-- getWeather :: String -> IO (Either String Weather)
-- getWeather city = undefined  -- TODO


-- ============================================================================
-- 挑战 5: 日志分析工具 ⭐⭐⭐⭐☆
-- ============================================================================

{-
实现一个日志文件分析工具，支持：
1. 解析多种日志格式
2. 统计各级别日志数量
3. 查找错误模式
4. 时间范围过滤
5. 生成分析报告

日志格式示例：
[2025-01-20 10:30:45] INFO: Server started
[2025-01-20 10:31:02] ERROR: Connection failed
-}

data LogLevel = DEBUG | INFO | WARN | ERROR | FATAL
  deriving (Show, Eq, Ord, Enum)

data LogEntry = LogEntry
  { timestamp :: String      -- 简化：使用字符串存储时间
  , level :: LogLevel
  , message :: String
  } deriving (Show, Eq)

-- 5.1 解析单行日志
parseLogLine :: String -> Maybe LogEntry
parseLogLine line = undefined  -- TODO
-- 提示：使用 isPrefixOf, words 等

-- 5.2 解析整个日志文件
parseLogFile :: FilePath -> IO [LogEntry]
parseLogFile path = undefined  -- TODO

-- 5.3 统计各级别日志数量
countByLevel :: [LogEntry] -> M.Map LogLevel Int
countByLevel entries = undefined  -- TODO

-- 5.4 查找特定级别的日志
filterByLevel :: LogLevel -> [LogEntry] -> [LogEntry]
filterByLevel lvl entries = undefined  -- TODO

-- 5.5 查找包含关键词的日志
searchLogs :: String -> [LogEntry] -> [LogEntry]
searchLogs keyword entries = undefined  -- TODO

-- 5.6 查找错误模式（按错误消息分组统计）
groupErrors :: [LogEntry] -> M.Map String Int
groupErrors entries = undefined  -- TODO

-- 5.7 生成分析报告
data LogReport = LogReport
  { totalEntries :: Int
  , levelCounts :: M.Map LogLevel Int
  , errorPatterns :: [(String, Int)]  -- 最常见的错误
  , timeRange :: (String, String)     -- 最早和最晚时间
  } deriving (Show)

generateReport :: [LogEntry] -> LogReport
generateReport entries = undefined  -- TODO

-- 5.8 显示报告
displayReport :: LogReport -> IO ()
displayReport report = undefined  -- TODO

-- 5.9 日志分析器主程序
logAnalyzer :: IO ()
logAnalyzer = undefined  -- TODO
-- 提示：读取日志文件，生成报告，支持交互式查询


-- ============================================================================
-- 测试和演示
-- ============================================================================

-- 测试 XOR 加密
testXorCipher :: IO ()
testXorCipher = do
  let key = "secret"
      original = "Hello, World!"
      encrypted = xorCipher key original
      decrypted = xorCipher key encrypted
  
  putStrLn $ "Original:  " ++ original
  putStrLn $ "Encrypted: " ++ show encrypted
  putStrLn $ "Decrypted: " ++ decrypted
  putStrLn $ "Match: " ++ show (original == decrypted)

-- 演示 CSV 处理
demoCSV :: IO ()
demoCSV = do
  -- 创建示例 CSV
  let sampleCSV = "Name,Age,Score\nAlice,25,95\nBob,30,87\nCharlie,22,92\n"
  writeFile "sample.csv" sampleCSV
  
  -- 解析并处理
  table <- parseCSV "sample.csv"
  putStrLn "Original table:"
  displayCSVTable table
  
  putStrLn "\nSorted by score:"
  displayCSVTable (sortCSVByColumn 2 table)

-- 演示日志分析
demoLogAnalyzer :: IO ()
demoLogAnalyzer = do
  -- 创建示例日志
  let sampleLog = unlines
        [ "[2025-01-20 10:00:00] INFO: Application started"
        , "[2025-01-20 10:00:05] DEBUG: Loading configuration"
        , "[2025-01-20 10:00:10] INFO: Configuration loaded"
        , "[2025-01-20 10:01:00] ERROR: Connection timeout"
        , "[2025-01-20 10:01:05] ERROR: Connection timeout"
        , "[2025-01-20 10:02:00] WARN: Retrying connection"
        , "[2025-01-20 10:02:30] INFO: Connection established"
        , "[2025-01-20 10:03:00] FATAL: Out of memory"
        ]
  writeFile "sample.log" sampleLog
  
  -- 分析日志
  entries <- parseLogFile "sample.log"
  let report = generateReport entries
  displayReport report


{-
使用说明：

1. 挑战 1（文本编辑器）：
   ghci> startEditor
   
2. 挑战 2（CSV 处理）：
   ghci> demoCSV
   ghci> csvProcessor

3. 挑战 3（文件加密）：
   ghci> testXorCipher
   ghci> encryptionTool

4. 挑战 4（HTTP 客户端）：
   需要先安装库：
   cabal install http-conduit aeson
   
5. 挑战 5（日志分析）：
   ghci> demoLogAnalyzer
   ghci> logAnalyzer

提示：
- 每个挑战都是独立的，可以按任意顺序完成
- 从简单功能开始实现，逐步完善
- 关注错误处理和用户体验
- 考虑代码复用和模块化

祝挑战成功！🚀
-}

