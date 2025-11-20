{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Types where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics

-- | Balance info for an address
data BalanceInfo = BalanceInfo
  { address :: Text
  , balance :: Integer  -- Lovelace
  , utxoCount :: Int
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | Query result
data QueryResult
  = Success BalanceInfo
  | Failure Text String  -- Address and error message
  deriving (Show, Eq)

