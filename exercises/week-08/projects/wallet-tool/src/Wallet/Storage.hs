module Wallet.Storage
  ( saveState
  , loadState
  , defaultState
  , ensureDataDir
  ) where

import qualified Data.ByteString.Lazy as BSL
import Data.Aeson (eitherDecode, encode, encodeFile, decodeFileStrict)
import Data.Time (getCurrentTime)
import System.Directory (createDirectoryIfMissing, doesFileExist, copyFile)
import System.FilePath ((</>))
import qualified Data.Map as Map
import Wallet.Types

-- | Default state file name
stateFile :: FilePath -> FilePath
stateFile dataDir = dataDir </> "wallet-state.json"

-- | Default backup file name
backupFile :: FilePath -> FilePath
backupFile dataDir = dataDir </> "wallet-state.json.bak"

-- | Create default empty state
--
-- TODO: Implement default state creation
defaultState :: IO WalletState
defaultState = do
  now <- getCurrentTime
  return $ WalletState
    { wsAddresses = []
    , wsCache = Map.empty
    , wsLastUpdate = now
    }

-- | Ensure data directory exists
--
-- TODO: Implement directory creation
ensureDataDir :: FilePath -> IO ()
ensureDataDir dir = do
  -- TODO: Use createDirectoryIfMissing
  undefined

-- | Save wallet state to file
--
-- TODO: Implement state saving
-- Steps:
-- 1. Ensure data directory exists
-- 2. Backup old file if exists
-- 3. Save new state
saveState :: FilePath -> WalletState -> IO ()
saveState dataDir state = do
  -- TODO: Implement this
  undefined

-- | Load wallet state from file
--
-- TODO: Implement state loading
-- Return default state if file doesn't exist
loadState :: FilePath -> IO (Either String WalletState)
loadState dataDir = do
  let path = stateFile dataDir
  exists <- doesFileExist path
  if exists
    then do
      -- TODO: Read and decode file
      -- Use eitherDecode
      undefined
    else do
      -- No state file, return default
      state <- defaultState
      return $ Right state

