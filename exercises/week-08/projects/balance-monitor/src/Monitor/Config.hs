module Monitor.Config
  ( loadConfig
  , defaultConfig
  , saveDefaultConfig
  ) where

import Data.Yaml (decodeFileEither, encodeFile)
import System.Directory (doesFileExist)
import Monitor.Types

-- | Default configuration
--
-- TODO: Implement default config
defaultConfig :: Config
defaultConfig = Config
  { cfgAPI = APIConfig
      { apiKey = "testnetXXXXXXXXXXXX"  -- TODO: Replace with actual key
      , apiEndpoint = "https://cardano-testnet.blockfrost.io"
      }
  , cfgMonitor = MonitorConfig
      { monInterval = 300      -- 5 minutes
      , monRetryCount = 3
      , monRetryDelay = 5
      }
  , cfgStorage = StorageConfig
      { stgDataDir = ".cardano-monitor"
      , stgBackupCount = 5
      }
  , cfgNotification = NotificationConfig
      { notifyConsole = True
      , notifyColor = True
      , notifySound = False
      }
  }

-- | Load configuration from YAML file
--
-- TODO: Implement config loading
loadConfig :: FilePath -> IO (Either String Config)
loadConfig path = do
  exists <- doesFileExist path
  if exists
    then do
      result <- decodeFileEither path
      return $ case result of
        Left err -> Left (show err)
        Right cfg -> Right cfg
    else
      return $ Right defaultConfig

-- | Save default configuration to file
--
-- TODO: Implement config saving
saveDefaultConfig :: FilePath -> IO ()
saveDefaultConfig path = do
  encodeFile path defaultConfig
  putStrLn $ "Default configuration saved to: " ++ path

