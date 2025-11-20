{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Monitor.Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.Map (Map)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

-- | Cardano address
newtype Address = Address { getAddress :: String }
  deriving (Eq, Ord, Show, Generic, FromJSON, ToJSON)

-- | Lovelace amount
newtype Lovelace = Lovelace { getLovelace :: Integer }
  deriving (Eq, Ord, Show, Num, Generic, FromJSON, ToJSON)

-- | Monitored address with metadata
data MonitoredAddress = MonitoredAddress
  { maAddress      :: Address
  , maLabel        :: Maybe String
  , maAddedAt      :: UTCTime
  , maLastChecked  :: Maybe UTCTime
  , maLastBalance  :: Maybe Lovelace
  } deriving (Eq, Show, Generic)

instance FromJSON MonitoredAddress
instance ToJSON MonitoredAddress

-- | Balance change event
data BalanceChange = BalanceChange
  { bcAddress :: Address
  , bcTime    :: UTCTime
  , bcOld     :: Lovelace
  , bcNew     :: Lovelace
  , bcDelta   :: Integer  -- Positive = increase, Negative = decrease
  } deriving (Eq, Show, Generic)

instance FromJSON BalanceChange
instance ToJSON BalanceChange

-- | Monitor state
data MonitorState = MonitorState
  { msAddresses :: [MonitoredAddress]
  , msHistory   :: [BalanceChange]
  , msLastSaved :: UTCTime
  } deriving (Eq, Show, Generic)

instance FromJSON MonitorState
instance ToJSON MonitorState

-- | API configuration
data APIConfig = APIConfig
  { apiKey      :: String
  , apiEndpoint :: String
  } deriving (Eq, Show, Generic)

instance FromJSON APIConfig
instance ToJSON APIConfig

-- | Monitor configuration
data MonitorConfig = MonitorConfig
  { monInterval   :: Int  -- Check interval in seconds
  , monRetryCount :: Int  -- Number of retries on error
  , monRetryDelay :: Int  -- Delay between retries in seconds
  } deriving (Eq, Show, Generic)

instance FromJSON MonitorConfig
instance ToJSON MonitorConfig

-- | Storage configuration
data StorageConfig = StorageConfig
  { stgDataDir     :: FilePath
  , stgBackupCount :: Int
  } deriving (Eq, Show, Generic)

instance FromJSON StorageConfig
instance ToJSON StorageConfig

-- | Notification configuration
data NotificationConfig = NotificationConfig
  { notifyConsole :: Bool
  , notifyColor   :: Bool
  , notifySound   :: Bool
  } deriving (Eq, Show, Generic)

instance FromJSON NotificationConfig
instance ToJSON NotificationConfig

-- | Complete configuration
data Config = Config
  { cfgAPI          :: APIConfig
  , cfgMonitor      :: MonitorConfig
  , cfgStorage      :: StorageConfig
  , cfgNotification :: NotificationConfig
  } deriving (Eq, Show, Generic)

instance FromJSON Config
instance ToJSON Config

-- | Monitor errors
data MonitorError
  = APIError String
  | ConfigError String
  | StorageError String
  | ValidationError String
  | NetworkError String
  deriving (Eq, Show)

