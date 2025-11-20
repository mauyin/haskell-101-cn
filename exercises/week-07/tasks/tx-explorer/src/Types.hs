{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Types where

import Data.Aeson
import GHC.Generics

-- Transaction types (simplified)
data Tx = Tx
  { txId   :: String
  , txBody :: TxBody
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxBody = TxBody
  { inputs  :: [TxIn]
  , outputs :: [TxOut]
  , fee     :: Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxIn = TxIn
  { txHash  :: String
  , txIndex :: Int
  } deriving (Show, Generic, FromJSON, ToJSON)

data TxOut = TxOut
  { address :: String
  , value   :: Integer
  } deriving (Show, Generic, FromJSON, ToJSON)

