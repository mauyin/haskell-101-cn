module Wallet.API
  ( queryAddressInfo
  , queryUTxOs
  , requestWithRetry
  ) where

import Control.Concurrent (threadDelay)
import Control.Monad.Except (ExceptT, runExceptT, throwError, liftIO)
import Data.Aeson (eitherDecode, Value)
import qualified Data.ByteString.Lazy as BSL
import Wallet.Types

-- | Query address information from Blockfrost API
--
-- TODO: Implement API query
-- Endpoint: /addresses/{address}
-- This is a placeholder - in real implementation would use 'req' library
queryAddressInfo :: Config -> Address -> ExceptT WalletError IO Value
queryAddressInfo config addr = do
  -- TODO: Implement this using req library
  -- For now, return a mock response
  -- 
  -- Real implementation would:
  -- 1. Build request URL
  -- 2. Add API key header
  -- 3. Make HTTP request
  -- 4. Parse response
  --
  -- Example (pseudo-code):
  -- response <- liftIO $ req GET url NoReqBody jsonResponse headers
  -- return $ responseBody response
  
  throwError $ APIError "Not implemented - TODO: Use req library to call Blockfrost API"

-- | Query UTxOs for an address
--
-- TODO: Implement UTxO query
-- Endpoint: /addresses/{address}/utxos
queryUTxOs :: Config -> Address -> ExceptT WalletError IO [UTxO]
queryUTxOs config addr = do
  -- TODO: Implement this
  undefined

-- | Request with retry logic
--
-- TODO: Implement retry mechanism
-- Retry on network errors, with exponential backoff
requestWithRetry :: Int -> IO (Either WalletError a) -> IO (Either WalletError a)
requestWithRetry 0 action = action
requestWithRetry n action = do
  result <- action
  case result of
    Left (NetworkError _) -> do
      putStrLn $ "Retrying... (" ++ show n ++ " attempts left)"
      threadDelay 1000000  -- Wait 1 second
      requestWithRetry (n-1) action
    _ -> return result

-- | Parse Blockfrost balance response
--
-- TODO: Implement response parsing
-- Response format: {"address": "...", "amount": [{"unit": "lovelace", "quantity": "..."}]}
parseBalanceResponse :: Value -> Either WalletError Lovelace
parseBalanceResponse val = do
  -- TODO: Parse JSON value
  -- Extract lovelace amount
  undefined

