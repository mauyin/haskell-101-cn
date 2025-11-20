{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Wallet.Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.Map (Map)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

-- | Cardano address newtype
newtype Address = Address { getAddress :: String }
  deriving (Eq, Ord, Show, Generic, FromJSON, ToJSON)

-- | Lovelace (smallest unit of ADA)
newtype Lovelace = Lovelace { getLovelace :: Integer }
  deriving (Eq, Ord, Show, Num, Generic, FromJSON, ToJSON)

-- | Transaction hash
newtype TxHash = TxHash { getTxHash :: String }
  deriving (Eq, Ord, Show, Generic, FromJSON, ToJSON)

-- | Transaction output index
newtype TxIndex = TxIndex { getTxIndex :: Integer }
  deriving (Eq, Ord, Show, Generic, FromJSON, ToJSON)

-- | Transaction output reference (hash + index)
data TxOutRef = TxOutRef
  { txOutRefHash  :: TxHash
  , txOutRefIndex :: TxIndex
  } deriving (Eq, Ord, Show, Generic)

instance FromJSON TxOutRef
instance ToJSON TxOutRef

-- | UTxO (unspent transaction output)
data UTxO = UTxO
  { utxoRef    :: TxOutRef
  , utxoAmount :: Lovelace
  , utxoAddr   :: Address
  } deriving (Eq, Show, Generic)

instance FromJSON UTxO
instance ToJSON UTxO

-- | Address information with metadata
data AddressInfo = AddressInfo
  { aiAddress :: Address
  , aiLabel   :: Maybe String
  , aiCreated :: UTCTime
  } deriving (Eq, Show, Generic)

instance FromJSON AddressInfo
instance ToJSON AddressInfo

-- | Transaction output
data TxOut = TxOut
  { txOutAddress :: Address
  , txOutAmount  :: Lovelace
  } deriving (Eq, Show, Generic)

instance FromJSON TxOut
instance ToJSON TxOut

-- | Transaction
data Transaction = Transaction
  { txInputs  :: [UTxO]
  , txOutputs :: [TxOut]
  , txFee     :: Lovelace
  } deriving (Eq, Show, Generic)

instance FromJSON Transaction
instance ToJSON Transaction

-- | Balance information
data BalanceInfo = BalanceInfo
  { balanceAddress :: Address
  , balanceAmount  :: Lovelace
  , balanceUTxOs   :: [UTxO]
  , balanceChecked :: UTCTime
  } deriving (Eq, Show, Generic)

instance FromJSON BalanceInfo
instance ToJSON BalanceInfo

-- | Wallet state
data WalletState = WalletState
  { wsAddresses  :: [AddressInfo]
  , wsCache      :: Map Address BalanceInfo
  , wsLastUpdate :: UTCTime
  } deriving (Eq, Show, Generic)

instance FromJSON WalletState
instance ToJSON WalletState

-- | API configuration
data Config = Config
  { cfgApiKey      :: String
  , cfgApiEndpoint :: String
  , cfgDataDir     :: FilePath
  } deriving (Eq, Show, Generic)

instance FromJSON Config
instance ToJSON Config

-- | Wallet errors
data WalletError
  = APIError String
  | FileError String
  | ValidationError String
  | NetworkError String
  | ParseError String
  | InsufficientFunds
  | NegativeChange
  deriving (Eq, Show)

