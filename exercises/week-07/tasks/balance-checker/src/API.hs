{-# LANGUAGE OverloadedStrings #-}

module API where

import Types
import Data.Text (Text)
import qualified Data.Text as T

-- TODO: Implement API queries
-- You can use Blockfrost or mock data

queryBalance :: Text -> Text -> IO (Either String BalanceInfo)
queryBalance apiKey addr = undefined
  -- TODO:
  -- 1. Query address info using Blockfrost
  -- 2. Extract lovelace balance
  -- 3. Count UTxOs
  -- 4. Return BalanceInfo

-- TODO: Mock implementation (for Path A)
mockQueryBalance :: Text -> IO (Either String BalanceInfo)
mockQueryBalance addr = undefined
  -- TODO: Return hardcoded balance for testing

