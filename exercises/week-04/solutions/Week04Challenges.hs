{-
  Week 4: 挑战题 - 参考答案和实现指导
  
  这些是进阶项目的参考实现。
  挑战题较复杂，建议先尝试自己实现，遇到困难再参考。
-}

{-# LANGUAGE OverloadedStrings #-}

module Week04Challenges where

import Control.Monad (when, unless, forM_)
import Data.List (intercalate, isPrefixOf, sortBy, group, sort)
import Data.Ord (comparing)
import qualified Data.Map.Strict as M
import System.IO (hFlush, stdout)
import Data.Char (ord, chr)
import Data.Bits (xor)

{- ============================================
   挑战 1: 命令行文本编辑器
   ============================================ -}

type Line = String
type LineNumber = Int

data EditorState = EditorState
  { content :: [Line]
  , filePath :: Maybe FilePath
  , modified :: Bool
  , history :: [EditorCommand]
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
emptyEditor = EditorState
  { content = []
  , filePath = Nothing
  , modified = False
  , history = []
  }

-- 1.2 加载文件到编辑器
loadFileToEditor :: FilePath -> IO EditorState
loadFileToEditor path = do
  fileContent <- readFile path
  return $ EditorState
    { content = lines fileContent
    , filePath = Just path
    , modified = False
    , history = [LoadFile path]
    }

-- 1.3 保存编辑器内容到文件
saveEditorToFile :: EditorState -> IO EditorState
saveEditorToFile state = do
  case filePath state of
    Nothing -> do
      putStrLn "No file path specified!"
      return state
    Just path -> do
      writeFile path (unlines (content state))
      putStrLn $ "Saved to " ++ path
      return state { modified = False, history = SaveFile path : history state }

-- 1.4 显示编辑器内容（带行号）
displayEditor :: EditorState -> IO ()
displayEditor state = do
  putStrLn "=== Editor Content ==="
  if null (content state)
    then putStrLn "(empty)"
    else mapM_ printLine (zip [1..] (content state))
  putStrLn "======================"
  when (modified state) $ putStrLn "[Modified]"
  where
    printLine (n, line) = putStrLn (padNum n ++ " | " ++ line)
    padNum n = replicate (4 - length (show n)) ' ' ++ show n

-- 1.5 插入新行
insertLineInEditor :: LineNumber -> Line -> EditorState -> EditorState
insertLineInEditor lineNum line state =
  let (before, after) = splitAt (lineNum - 1) (content state)
      newContent = before ++ [line] ++ after
  in state
      { content = newContent
      , modified = True
      , history = InsertLine lineNum line : history state
      }

-- 1.6 删除行
deleteLineInEditor :: LineNumber -> EditorState -> Maybe EditorState
deleteLineInEditor lineNum state
  | lineNum < 1 || lineNum > length (content state) = Nothing
  | otherwise =
      let (before, _:after) = splitAt (lineNum - 1) (content state)
          newContent = before ++ after
      in Just $ state
          { content = newContent
          , modified = True
          , history = DeleteLine lineNum : history state
          }

-- 1.7 修改行
modifyLineInEditor :: LineNumber -> Line -> EditorState -> Maybe EditorState
modifyLineInEditor lineNum newLine state
  | lineNum < 1 || lineNum > length (content state) = Nothing
  | otherwise =
      let (before, _:after) = splitAt (lineNum - 1) (content state)
          newContent = before ++ [newLine] ++ after
      in Just $ state
          { content = newContent
          , modified = True
          , history = ModifyLine lineNum newLine : history state
          }

-- 1.8 撤销上一个操作
undoEditor :: EditorState -> Maybe EditorState
undoEditor state = case history state of
  [] -> Nothing
  (cmd:rest) -> Just $ reverseCommand cmd (state { history = rest })
  where
    reverseCommand (InsertLine n _) s = s  -- 简化：实际需要删除插入的行
    reverseCommand (DeleteLine n) s = s    -- 简化：实际需要恢复删除的行
    reverseCommand _ s = s

-- 1.9 编辑器主循环
editorMainLoop :: EditorState -> IO ()
editorMainLoop state = do
  putStrLn "\n=== Text Editor ==="
  putStrLn "1. Display content"
  putStrLn "2. Insert line"
  putStrLn "3. Delete line"
  putStrLn "4. Modify line"
  putStrLn "5. Load file"
  putStrLn "6. Save file"
  putStrLn "7. Exit"
  putStr "Choice: "
  hFlush stdout
  choice <- getLine
  
  case choice of
    "1" -> displayEditor state >> editorMainLoop state
    "2" -> do
      putStr "Line number: "
      hFlush stdout
      lineNum <- read <$> getLine
      putStr "Content: "
      hFlush stdout
      line <- getLine
      editorMainLoop (insertLineInEditor lineNum line state)
    "3" -> do
      displayEditor state
      putStr "Line number to delete: "
      hFlush stdout
      lineNum <- read <$> getLine
      case deleteLineInEditor lineNum state of
        Nothing -> putStrLn "Invalid line number!" >> editorMainLoop state
        Just newState -> editorMainLoop newState
    "4" -> do
      displayEditor state
      putStr "Line number to modify: "
      hFlush stdout
      lineNum <- read <$> getLine
      putStr "New content: "
      hFlush stdout
      newLine <- getLine
      case modifyLineInEditor lineNum newLine state of
        Nothing -> putStrLn "Invalid line number!" >> editorMainLoop state
        Just newState -> editorMainLoop newState
    "5" -> do
      putStr "File path: "
      hFlush stdout
      path <- getLine
      newState <- loadFileToEditor path
      editorMainLoop newState
    "6" -> do
      newState <- saveEditorToFile state
      editorMainLoop newState
    "7" -> do
      when (modified state) $ putStrLn "Warning: unsaved changes!"
      putStrLn "Goodbye!"
    _ -> putStrLn "Invalid choice!" >> editorMainLoop state

-- 1.10 启动编辑器
startEditor :: IO ()
startEditor = editorMainLoop emptyEditor


{- ============================================
   挑战 2: CSV 解析器和处理器
   ============================================ -}

type CSVRow = [String]
type CSVData = [CSVRow]

data CSVTable = CSVTable
  { headers :: CSVRow
  , rows :: [CSVRow]
  } deriving (Show, Eq)

-- 2.1 解析 CSV 文件
parseCSV :: FilePath -> IO CSVTable
parseCSV path = do
  content <- readFile path
  let allLines = lines content
  case allLines of
    [] -> return $ CSVTable [] []
    (h:rs) -> return $ CSVTable (splitCSVLine h) (map splitCSVLine rs)

-- 辅助函数：分割 CSV 行（简化版，不处理引号内逗号）
splitCSVLine :: String -> CSVRow
splitCSVLine = splitOn ','
  where
    splitOn :: Char -> String -> [String]
    splitOn _ [] = [""]
    splitOn delim (c:cs)
      | c == delim = "" : splitOn delim cs
      | otherwise = 
          let (x:xs) = splitOn delim cs
          in (c:x):xs

-- 2.2 显示 CSV 表格（对齐格式）
displayCSVTable :: CSVTable -> IO ()
displayCSVTable table = do
  let allRows = headers table : rows table
      colWidths = getColumnWidths allRows
  
  -- 显示表头
  putStrLn $ formatRow colWidths (headers table)
  putStrLn $ replicate (sum colWidths + length colWidths - 1) '-'
  
  -- 显示数据行
  mapM_ (putStrLn . formatRow colWidths) (rows table)
  where
    getColumnWidths :: [CSVRow] -> [Int]
    getColumnWidths rows =
      let numCols = maximum (map length rows)
          cols = [[row !! i | row <- rows, i < length row] | i <- [0..numCols-1]]
      in map (maximum . map length) cols
    
    formatRow :: [Int] -> CSVRow -> String
    formatRow widths row = 
      intercalate " " $ zipWith padTo widths row
    
    padTo :: Int -> String -> String
    padTo width str = str ++ replicate (width - length str) ' '

-- 2.3 过滤行
filterCSVRows :: (CSVRow -> Bool) -> CSVTable -> CSVTable
filterCSVRows predicate table =
  table { rows = filter predicate (rows table) }

-- 2.4 按列排序
sortCSVByColumn :: Int -> CSVTable -> CSVTable
sortCSVByColumn colIndex table =
  table { rows = sortBy (comparing (!! colIndex)) (rows table) }

-- 2.5 获取某列的所有值
getColumn :: Int -> CSVTable -> [String]
getColumn colIndex table = map (!! colIndex) (rows table)

-- 2.6 统计数值列
data ColumnStats = ColumnStats
  { colSum :: Double
  , colAvg :: Double
  , colMin :: Double
  , colMax :: Double
  , colCount :: Int
  } deriving (Show)

calculateColumnStats :: Int -> CSVTable -> Maybe ColumnStats
calculateColumnStats colIndex table = do
  let column = getColumn colIndex table
      values = [read v :: Double | v <- column, all (`elem` "0123456789.-") v]
  
  if null values
    then Nothing
    else Just $ ColumnStats
      { colSum = sum values
      , colAvg = sum values / fromIntegral (length values)
      , colMin = minimum values
      , colMax = maximum values
      , colCount = length values
      }

-- 2.7 导出为 CSV 文件
exportCSV :: FilePath -> CSVTable -> IO ()
exportCSV path table = do
  let allLines = headers table : rows table
      csvContent = unlines $ map (intercalate ",") allLines
  writeFile path csvContent
  putStrLn $ "Exported to " ++ path

-- 2.8 CSV 处理器主程序
csvProcessor :: IO ()
csvProcessor = do
  putStrLn "CSV Processor"
  putStr "Enter CSV file path: "
  hFlush stdout
  path <- getLine
  table <- parseCSV path
  processorLoop table
  where
    processorLoop table = do
      putStrLn "\n1. Display table"
      putStrLn "2. Filter rows"
      putStrLn "3. Sort by column"
      putStrLn "4. Column statistics"
      putStrLn "5. Export"
      putStrLn "6. Exit"
      putStr "Choice: "
      hFlush stdout
      choice <- getLine
      
      case choice of
        "1" -> displayCSVTable table >> processorLoop table
        "2" -> do
          putStrLn "Filter by column value (simplified)"
          processorLoop table  -- 简化：跳过实现
        "3" -> do
          putStr "Column index (0-based): "
          hFlush stdout
          colIdx <- read <$> getLine
          processorLoop (sortCSVByColumn colIdx table)
        "4" -> do
          putStr "Column index (0-based): "
          hFlush stdout
          colIdx <- read <$> getLine
          case calculateColumnStats colIdx table of
            Nothing -> putStrLn "Invalid column or non-numeric data"
            Just stats -> print stats
          processorLoop table
        "5" -> do
          putStr "Output file path: "
          hFlush stdout
          outPath <- getLine
          exportCSV outPath table
          processorLoop table
        "6" -> putStrLn "Goodbye!"
        _ -> putStrLn "Invalid choice!" >> processorLoop table


{- ============================================
   挑战 3: 文件加密/解密工具
   ============================================ -}

type Key = String

-- 3.1 XOR 加密/解密（对称的）
xorCipher :: Key -> String -> String
xorCipher key text = zipWith xorChar (cycle key) text

-- 辅助函数：XOR 两个字符
xorChar :: Char -> Char -> Char
xorChar c k = chr (ord c `xor` ord k)

-- 3.2 加密文件
encryptFile :: Key -> FilePath -> FilePath -> IO ()
encryptFile key inputPath outputPath = do
  content <- readFile inputPath
  let encrypted = xorCipher key content
  writeFile outputPath encrypted
  putStrLn $ "Encrypted " ++ inputPath ++ " -> " ++ outputPath

-- 3.3 解密文件
decryptFile :: Key -> FilePath -> FilePath -> IO ()
decryptFile key inputPath outputPath = do
  content <- readFile inputPath
  let decrypted = xorCipher key content  -- XOR 是对称的！
  writeFile outputPath decrypted
  putStrLn $ "Decrypted " ++ inputPath ++ " -> " ++ outputPath

-- 3.4 验证加密/解密
verifyEncryption :: Key -> FilePath -> IO Bool
verifyEncryption key path = do
  original <- readFile path
  let encrypted = xorCipher key original
      decrypted = xorCipher key encrypted
  return (original == decrypted)

-- 3.5 交互式加密工具
encryptionTool :: IO ()
encryptionTool = do
  putStrLn "=== File Encryption Tool ==="
  putStrLn "1. Encrypt file"
  putStrLn "2. Decrypt file"
  putStrLn "3. Verify encryption"
  putStrLn "4. Exit"
  putStr "Choice: "
  hFlush stdout
  choice <- getLine
  
  case choice of
    "1" -> do
      putStr "Input file: "
      hFlush stdout
      input <- getLine
      putStr "Output file: "
      hFlush stdout
      output <- getLine
      putStr "Encryption key: "
      hFlush stdout
      key <- getLine
      encryptFile key input output
      encryptionTool
    "2" -> do
      putStr "Input file: "
      hFlush stdout
      input <- getLine
      putStr "Output file: "
      hFlush stdout
      output <- getLine
      putStr "Decryption key: "
      hFlush stdout
      key <- getLine
      decryptFile key input output
      encryptionTool
    "3" -> do
      putStr "File: "
      hFlush stdout
      file <- getLine
      putStr "Key: "
      hFlush stdout
      key <- getLine
      result <- verifyEncryption key file
      putStrLn $ "Verification: " ++ if result then "PASS" else "FAIL"
      encryptionTool
    "4" -> putStrLn "Goodbye!"
    _ -> putStrLn "Invalid choice!" >> encryptionTool


{- ============================================
   挑战 5: 日志分析工具
   ============================================ -}

data LogLevel = DEBUG | INFO | WARN | ERROR | FATAL
  deriving (Show, Eq, Ord, Enum)

data LogEntry = LogEntry
  { timestamp :: String
  , level :: LogLevel
  , message :: String
  } deriving (Show, Eq)

-- 5.1 解析单行日志
parseLogLine :: String -> Maybe LogEntry
parseLogLine line = do
  -- 格式: [timestamp] LEVEL: message
  let (timestampPart, rest1) = break (== ']') line
  if null rest1 then Nothing else do
    let timestamp' = drop 1 timestampPart  -- 去掉 '['
        rest2 = drop 2 rest1  -- 去掉 '] '
        (levelStr, rest3) = break (== ':') rest2
        levelM = case trim levelStr of
          "DEBUG" -> Just DEBUG
          "INFO"  -> Just INFO
          "WARN"  -> Just WARN
          "ERROR" -> Just ERROR
          "FATAL" -> Just FATAL
          _ -> Nothing
    level' <- levelM
    let message' = drop 2 rest3  -- 去掉 ': '
    return $ LogEntry timestamp' level' message'
  where
    trim = dropWhile (== ' ')

-- 5.2 解析整个日志文件
parseLogFile :: FilePath -> IO [LogEntry]
parseLogFile path = do
  content <- readFile path
  let lns = lines content
      entries = [e | Just e <- map parseLogLine lns]
  return entries

-- 5.3 统计各级别日志数量
countByLevel :: [LogEntry] -> M.Map LogLevel Int
countByLevel entries = 
  M.fromListWith (+) [(level e, 1) | e <- entries]

-- 5.4 查找特定级别的日志
filterByLevel :: LogLevel -> [LogEntry] -> [LogEntry]
filterByLevel lvl = filter (\e -> level e == lvl)

-- 5.5 查找包含关键词的日志
searchLogs :: String -> [LogEntry] -> [LogEntry]
searchLogs keyword = filter (\e -> keyword `isInfixOf` message e)
  where
    isInfixOf needle haystack = any (isPrefixOf needle) (tails haystack)
    tails [] = [[]]
    tails s@(_:xs) = s : tails xs

-- 5.6 查找错误模式
groupErrors :: [LogEntry] -> M.Map String Int
groupErrors entries =
  let errors = filter (\e -> level e == ERROR) entries
      errorMsgs = map message errors
  in M.fromListWith (+) [(msg, 1) | msg <- errorMsgs]

-- 5.7 生成分析报告
data LogReport = LogReport
  { totalEntries :: Int
  , levelCounts :: M.Map LogLevel Int
  , errorPatterns :: [(String, Int)]
  , timeRange :: (String, String)
  } deriving (Show)

generateReport :: [LogEntry] -> LogReport
generateReport entries =
  let counts = countByLevel entries
      errors = take 10 $ sortBy (flip $ comparing snd) $ M.toList (groupErrors entries)
      times = map timestamp entries
      timeR = if null times then ("", "") else (head times, last times)
  in LogReport
      { totalEntries = length entries
      , levelCounts = counts
      , errorPatterns = errors
      , timeRange = timeR
      }

-- 5.8 显示报告
displayReport :: LogReport -> IO ()
displayReport report = do
  putStrLn "=== Log Analysis Report ==="
  putStrLn $ "Total entries: " ++ show (totalEntries report)
  putStrLn "\nLevel counts:"
  forM_ (M.toList (levelCounts report)) $ \(lvl, count) ->
    putStrLn $ "  " ++ show lvl ++ ": " ++ show count
  putStrLn "\nTop error patterns:"
  forM_ (errorPatterns report) $ \(msg, count) ->
    putStrLn $ "  " ++ show count ++ "x: " ++ msg
  let (start, end) = timeRange report
  putStrLn $ "\nTime range: " ++ start ++ " to " ++ end

-- 5.9 日志分析器主程序
logAnalyzer :: IO ()
logAnalyzer = do
  putStr "Log file path: "
  hFlush stdout
  path <- getLine
  entries <- parseLogFile path
  let report = generateReport entries
  displayReport report


{- ============================================
   测试和演示
   ============================================ -}

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
  let sampleCSV = "Name,Age,Score\nAlice,25,95\nBob,30,87\nCharlie,22,92\n"
  writeFile "sample.csv" sampleCSV
  
  table <- parseCSV "sample.csv"
  putStrLn "Original table:"
  displayCSVTable table
  
  putStrLn "\nSorted by score:"
  displayCSVTable (sortCSVByColumn 2 table)

-- 演示日志分析
demoLogAnalyzer :: IO ()
demoLogAnalyzer = do
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
  
  entries <- parseLogFile "sample.log"
  let report = generateReport entries
  displayReport report


{-
使用说明：

1. 测试 XOR 加密：
   ghci> testXorCipher

2. 演示 CSV 处理：
   ghci> demoCSV
   ghci> csvProcessor

3. 运行加密工具：
   ghci> encryptionTool

4. 演示日志分析：
   ghci> demoLogAnalyzer
   ghci> logAnalyzer

5. 启动文本编辑器：
   ghci> startEditor

这些是参考实现，展示了基本功能。
实际项目可以进一步完善错误处理、用户体验等。
-}

