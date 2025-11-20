module Monitor.Storage
  ( saveState
  , loadState
  , defaultState
  , exportCSV
  ) where

import qualified Data.ByteString.Lazy as BSL
import Data.Aeson (eitherDecode, encodeFile)
import Data.Time (getCurrentTime, formatTime, defaultTimeLocale)
import System.Directory (createDirectoryIfMissing, doesFileExist, copyFile)
import System.FilePath ((</>))
import qualified Data.Map as Map
import Monitor.Types
import Monitor.Query (formatBalance)

-- | State file path
stateFile :: FilePath -> FilePath
stateFile dataDir = dataDir </> "monitor-state.json"

-- | Backup file path
backupFile :: FilePath -> FilePath
backupFile dataDir = dataDir </> "monitor-state.json.bak"

-- | Create default state
--
-- TODO: Implement default state creation
defaultState :: IO MonitorState
defaultState = do
  now <- getCurrentTime
  return $ MonitorState
    { msAddresses = []
    , msHistory = []
    , msLastSaved = now
    }

-- | Save monitor state
--
-- TODO: Implement state saving
-- Save state to JSON file with backup
saveState :: FilePath -> MonitorState -> IO ()
saveState dataDir state = do
  -- TODO: Implement this
  -- 1. Ensure data directory exists
  -- 2. Backup old file if exists
  -- 3. Save new state with encodeFile
  undefined

-- | Load monitor state
--
-- TODO: Implement state loading
-- Load state from JSON file or return default
loadState :: FilePath -> IO (Either String MonitorState)
loadState dataDir = do
  let path = stateFile dataDir
  exists <- doesFileExist path
  if exists
    then eitherDecode <$> BSL.readFile path
    else Right <$> defaultState

-- | Export change history to CSV
--
-- TODO: Implement CSV export
exportCSV :: [BalanceChange] -> FilePath -> IO ()
exportCSV changes path = do
  let header = "Time,Address,Old Balance,New Balance,Change\n"
  let rows = map formatRow changes
  writeFile path (header ++ unlines rows)
  where
    formatRow change =
      let time = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
          addr = getAddress (bcAddress change)
          oldBal = show (getLovelace $ bcOld change)
          newBal = show (getLovelace $ bcNew change)
          delta = show (bcDelta change)
      in time ++ "," ++ addr ++ "," ++ oldBal ++ "," ++ newBal ++ "," ++ delta

