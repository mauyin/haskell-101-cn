-- | Display and formatting utilities
--
-- Helper functions for beautiful console output

module Display where

import Data.List (intercalate, transpose)
import Data.Time (UTCTime, formatTime, defaultTimeLocale)

-- | Display a simple table
--
-- Example:
-- > displayTable [["Name", "Age"], ["Alice", "30"], ["Bob", "25"]]
displayTable :: [[String]] -> IO ()
displayTable rows = do
  let colWidths = map (maximum . map length) (transpose rows)
  let formatRow row = "  " ++ intercalate " | " (zipWith padRight colWidths row)
  let separator = "  " ++ intercalate "-+-" (map (`replicate` '-') colWidths)
  
  case rows of
    [] -> return ()
    (header:rest) -> do
      putStrLn $ formatRow header
      putStrLn separator
      mapM_ (putStrLn . formatRow) rest

-- | Pad string to the right
padRight :: Int -> String -> String
padRight n s = s ++ replicate (n - length s) ' '

-- | Display a progress bar
--
-- Example:
-- > displayProgress 7 10
-- [=======   ] 70%
displayProgress :: Int -> Int -> IO ()
displayProgress current total = do
  let percentage = (current * 100) `div` total
  let barWidth = 20
  let filled = (current * barWidth) `div` total
  let bar = replicate filled '=' ++ replicate (barWidth - filled) ' '
  putStr $ "\r[" ++ bar ++ "] " ++ show percentage ++ "%"
  if current == total
    then putStrLn ""
    else return ()

-- | Display with timestamp
displayWithTime :: String -> IO ()
displayWithTime msg = do
  putStrLn $ "[" ++ currentTime ++ "] " ++ msg
  where
    currentTime = "HH:MM:SS"  -- TODO: Get actual time

-- | Format time nicely
formatTimeNice :: UTCTime -> String
formatTimeNice = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"

-- | Display a box around text
displayBox :: String -> IO ()
displayBox text = do
  let len = length text
  let border = replicate (len + 4) '='
  putStrLn border
  putStrLn $ "  " ++ text ++ "  "
  putStrLn border

-- | Display success message
displaySuccess :: String -> IO ()
displaySuccess msg = putStrLn $ "✓ " ++ msg

-- | Display error message
displayError :: String -> IO ()
displayError msg = putStrLn $ "✗ " ++ msg

-- | Display info message
displayInfo :: String -> IO ()
displayInfo msg = putStrLn $ "ℹ " ++ msg

-- | Display warning message
displayWarning :: String -> IO ()
displayWarning msg = putStrLn $ "⚠ " ++ msg

-- Color codes (optional, requires ANSI terminal support)
-- Uncomment and use with `ansi-terminal` library

{-
import System.Console.ANSI

displaySuccessColor :: String -> IO ()
displaySuccessColor msg = do
  setSGR [SetColor Foreground Vivid Green]
  putStr "✓ "
  setSGR [Reset]
  putStrLn msg

displayErrorColor :: String -> IO ()
displayErrorColor msg = do
  setSGR [SetColor Foreground Vivid Red]
  putStr "✗ "
  setSGR [Reset]
  putStrLn msg
-}

-- | Example usage
exampleDisplay :: IO ()
exampleDisplay = do
  displayBox "Example Output"
  putStrLn ""
  
  displayInfo "Starting process..."
  displaySuccess "Step 1 completed"
  displaySuccess "Step 2 completed"
  displayWarning "Step 3 has a warning"
  displayError "Step 4 failed"
  putStrLn ""
  
  displayTable
    [ ["Name", "Balance", "Status"]
    , ["Alice", "100 ADA", "Active"]
    , ["Bob", "50 ADA", "Active"]
    , ["Charlie", "0 ADA", "Inactive"]
    ]
  
  putStrLn ""
  putStrLn "Loading..."
  mapM_ (\i -> displayProgress i 10 >> threadDelay 100000) [1..10]
  where
    threadDelay _ = return ()  -- Placeholder

