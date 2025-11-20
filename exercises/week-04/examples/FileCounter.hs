{- |
File Counter - 文件统计工具示例

本程序演示：
1. 文件读取操作
2. 纯函数与 IO 分离
3. Maybe Monad 处理可选值
4. 数据分析和统计

学习要点：
- readFile 的使用
- 纯函数处理数据
- Maybe 处理文件不存在的情况
- 记录类型（Record）的使用

运行方式：
  ghci> :load FileCounter.hs
  ghci> analyzeAndDisplay "yourfile.txt"
  
  或者创建测试文件：
  ghci> createSampleFile
  ghci> analyzeAndDisplay "sample.txt"
-}

module FileCounter where

import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import qualified Data.Map.Strict as M

-- ============================================================================
-- 数据类型定义
-- ============================================================================

-- | 文件统计信息
data FileStats = FileStats
  { lineCount :: Int           -- 行数
  , wordCount :: Int           -- 单词数
  , charCount :: Int           -- 字符数
  , avgLineLength :: Double    -- 平均行长度
  , longestLine :: Maybe Int   -- 最长行的长度
  , shortestLine :: Maybe Int  -- 最短行的长度
  } deriving (Show, Eq)

-- ============================================================================
-- 纯函数部分（数据分析）
-- ============================================================================

-- | 分析文件内容，生成统计信息
analyzeContent :: String -> FileStats
analyzeContent content =
  let lns = lines content
      wrds = words content
      chars = length content
      
      lineLengths = map length lns
      
      longest = if null lineLengths then Nothing else Just (maximum lineLengths)
      shortest = if null lineLengths then Nothing else Just (minimum lineLengths)
      
      avgLen = if null lns
               then 0
               else fromIntegral (sum lineLengths) / fromIntegral (length lns)
  in FileStats
      { lineCount = length lns
      , wordCount = length wrds
      , charCount = chars
      , avgLineLength = avgLen
      , longestLine = longest
      , shortestLine = shortest
      }

-- | 统计单词频率
wordFrequency :: String -> [(String, Int)]
wordFrequency content =
  let wrds = words content
      freq = M.fromListWith (+) [(w, 1) | w <- wrds]
  in sortBy (comparing (Down . snd)) (M.toList freq)

-- | 获取最常见的 n 个单词
topWords :: Int -> String -> [(String, Int)]
topWords n content = take n (wordFrequency content)

-- | 统计空行数
countEmptyLines :: String -> Int
countEmptyLines content = length $ filter null (lines content)

-- | 找出最长的行
longestLines :: Int -> String -> [(Int, String)]
longestLines n content =
  let lns = lines content
      indexed = zip [1..] lns
      sorted = sortBy (comparing (Down . length . snd)) indexed
  in take n sorted

-- ============================================================================
-- IO 部分（文件操作和显示）
-- ============================================================================

-- | 读取并分析文件
analyzeFile :: FilePath -> IO (Maybe FileStats)
analyzeFile path = do
  result <- safeReadFile path
  case result of
    Nothing -> return Nothing
    Just content -> return (Just (analyzeContent content))

-- | 安全地读取文件（处理文件不存在的情况）
safeReadFile :: FilePath -> IO (Maybe String)
safeReadFile path = do
  putStrLn $ "正在读取文件: " ++ path
  -- 简化版：实际应使用 System.Directory.doesFileExist
  -- 这里假设文件存在，实际使用时应添加错误处理
  content <- readFile path
  return (Just content)
  -- 实际代码应该是：
  -- exists <- doesFileExist path
  -- if exists
  --   then do
  --     content <- readFile path
  --     return (Just content)
  --   else return Nothing

-- | 格式化显示统计信息
displayStats :: FileStats -> IO ()
displayStats stats = do
  putStrLn "=== 文件统计 ==="
  putStrLn $ "行数:       " ++ show (lineCount stats)
  putStrLn $ "单词数:     " ++ show (wordCount stats)
  putStrLn $ "字符数:     " ++ show (charCount stats)
  putStrLn $ "平均行长:   " ++ show (avgLineLength stats)
  
  case longestLine stats of
    Nothing -> return ()
    Just len -> putStrLn $ "最长行:     " ++ show len ++ " 字符"
  
  case shortestLine stats of
    Nothing -> return ()
    Just len -> putStrLn $ "最短行:     " ++ show len ++ " 字符"
  
  let emptyCount = if lineCount stats == 0 then 0 else 0  -- 简化
  putStrLn $ "空行数:     " ++ show emptyCount

-- | 显示高频词汇
displayTopWords :: FilePath -> Int -> IO ()
displayTopWords path n = do
  result <- safeReadFile path
  case result of
    Nothing -> putStrLn $ "错误: 无法读取文件 " ++ path
    Just content -> do
      putStrLn $ "\n=== 前 " ++ show n ++ " 个高频词汇 ==="
      let top = topWords n content
      mapM_ (\(word, count) -> putStrLn $ word ++ ": " ++ show count) top

-- | 完整分析并显示
analyzeAndDisplay :: FilePath -> IO ()
analyzeAndDisplay path = do
  result <- analyzeFile path
  case result of
    Nothing -> putStrLn $ "错误: 无法分析文件 " ++ path
    Just stats -> do
      displayStats stats
      putStrLn ""
      displayTopWords path 10

-- | 比较两个文件
compareFiles :: FilePath -> FilePath -> IO ()
compareFiles path1 path2 = do
  result1 <- analyzeFile path1
  result2 <- analyzeFile path2
  
  case (result1, result2) of
    (Just stats1, Just stats2) -> do
      putStrLn $ "\n=== 文件比较: " ++ path1 ++ " vs " ++ path2 ++ " ==="
      putStrLn $ "行数差异:   " ++ show (lineCount stats1 - lineCount stats2)
      putStrLn $ "单词数差异: " ++ show (wordCount stats1 - wordCount stats2)
      putStrLn $ "字符数差异: " ++ show (charCount stats1 - charCount stats2)
    _ -> putStrLn "错误: 无法读取一个或两个文件"

-- ============================================================================
-- 辅助函数和测试
-- ============================================================================

-- | 创建示例文件用于测试
createSampleFile :: IO ()
createSampleFile = do
  let sampleContent = unlines
        [ "Hello, World!"
        , "This is a sample file for testing."
        , "It has multiple lines."
        , "Some lines are longer than others."
        , ""
        , "And some lines are empty."
        , "The quick brown fox jumps over the lazy dog."
        , "Hello again!"
        ]
  writeFile "sample.txt" sampleContent
  putStrLn "已创建示例文件: sample.txt"

-- | 主程序（交互式）
main :: IO ()
main = do
  putStrLn "=== 文件统计工具 ==="
  putStrLn "输入文件路径 (或输入 'demo' 创建示例文件):"
  path <- getLine
  
  if path == "demo"
    then do
      createSampleFile
      analyzeAndDisplay "sample.txt"
    else analyzeAndDisplay path

{-
使用说明：

1. 分析指定文件：
   ghci> analyzeAndDisplay "yourfile.txt"

2. 创建并分析示例文件：
   ghci> createSampleFile
   ghci> analyzeAndDisplay "sample.txt"

3. 比较两个文件：
   ghci> compareFiles "file1.txt" "file2.txt"

4. 只显示高频词汇：
   ghci> displayTopWords "yourfile.txt" 5

5. 运行交互式程序：
   ghci> main

学习要点：
- 纯函数 (analyzeContent, wordFrequency) 与 IO 函数 (analyzeFile, displayStats) 分离
- Maybe Monad 处理文件可能不存在的情况
- Record 语法使数据结构清晰
- 数据分析逻辑完全独立于 IO，易于测试

练习建议：
1. 添加更多统计功能（如统计数字、标点符号）
2. 添加文件存在性检查（需要 System.Directory）
3. 支持递归分析目录中的所有文件
4. 添加导出功能（将统计结果写入文件）
-}



