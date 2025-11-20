{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Types where

import Data.Aeson
import GHC.Generics

-- Transaction types
data Tx = Tx
  { txId       :: String
  , txBody     :: TxBody
  , txWitnesses :: Maybe Witnesses
  , txMetadata :: Maybe Object
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxBody = TxBody
  { inputs  :: [TxIn]
  , outputs :: [TxOut]
  , fee     :: Integer
  , ttl     :: Maybe Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxIn = TxIn
  { txInHash  :: String
  , txInIndex :: Int
  } deriving (Show, Generic)

instance FromJSON TxIn where
  parseJSON = withObject "TxIn" $ \v -> TxIn
    <$> v .: "txId"
    <*> v .: "txIndex"

instance ToJSON TxIn where
  toJSON (TxIn h i) = object ["txId" .= h, "txIndex" .= i]

data TxOut = TxOut
  { address :: String
  , value   :: Value
  } deriving (Show, Generic, FromJSON, ToJSON)

data Value = Value
  { lovelace :: Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

data Witnesses = Witnesses
  { signatures :: [Signature]
  } deriving (Show, Generic, FromJSON, ToJSON)

data Signature = Signature
  { publicKey :: String
  , signature :: String
  } deriving (Show, Generic, FromJSON, ToJSON)

-- Transaction summary for display
data TxSummary = TxSummary
  { summaryId          :: String
  , summaryInputCount  :: Int
  , summaryOutputCount :: Int
  , summaryTotalInput  :: Integer
  , summaryTotalOutput :: Integer
  , summaryFee         :: Integer
  , summaryBalanced    :: Bool
  } deriving (Show)

