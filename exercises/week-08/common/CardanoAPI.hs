{-# LANGUAGE OverloadedStrings #-}

-- | Blockfrost API helper functions
-- 
-- This module provides utility functions for calling the Blockfrost API.
-- Copy to your project's src/ directory to use, or use as reference.

module CardanoAPI where

import Control.Concurrent (threadDelay)
import Control.Monad.Except (ExceptT, throwError, liftIO, runExceptT)
import Data.Aeson (Value, eitherDecode)
import qualified Data.ByteString.Lazy as BSL
import Data.Text (Text)
import qualified Data.Text as T

-- Note: This is a reference implementation.
-- To actually use this, you need to:
-- 1. Add 'req' library to your dependencies
-- 2. Import Network.HTTP.Req
-- 3. Implement the actual HTTP calls

-- | API configuration
data APIConfig = APIConfig
  { apiKey      :: String
  , apiEndpoint :: String
  } deriving (Show)

-- | API error type
data APIError
  = NetworkError String
  | ParseError String
  | HTTPError Int String  -- Status code and message
  deriving (Show, Eq)

-- | Call Blockfrost API (reference implementation)
--
-- Example usage:
-- > callBlockfrost config "/addresses/addr_test1q..."
-- > callBlockfrost config "/addresses/addr_test1q.../utxos"
--
-- TODO: Implement using 'req' library
callBlockfrost :: APIConfig -> String -> ExceptT APIError IO Value
callBlockfrost config path = do
  -- This is a placeholder. Real implementation would:
  -- 1. Build the full URL: apiEndpoint ++ "/api/v0" ++ path
  -- 2. Create headers: [("project_id", apiKey)]
  -- 3. Make HTTP GET request using 'req'
  -- 4. Parse JSON response
  -- 5. Handle errors
  
  throwError $ NetworkError "Not implemented - use 'req' library"

-- | Call API with retry on network errors
--
-- Retries up to N times with exponential backoff
callWithRetry :: Int -> ExceptT APIError IO a -> IO (Either APIError a)
callWithRetry maxRetries action = go maxRetries 1
  where
    go 0 _ = runExceptT action
    go n delaySeconds = do
      result <- runExceptT action
      case result of
        Left (NetworkError _) -> do
          putStrLn $ "Network error, retrying in " ++ show delaySeconds ++ "s... (" ++ show n ++ " attempts left)"
          threadDelay (delaySeconds * 1000000)
          go (n-1) (delaySeconds * 2)  -- Exponential backoff
        _ -> return result

-- | Parse Blockfrost address response
--
-- Blockfrost returns: {"address": "...", "amount": [{"unit": "lovelace", "quantity": "123456"}]}
parseAddressBalance :: Value -> Either APIError Integer
parseAddressBalance val = do
  -- TODO: Implement JSON parsing
  -- Use aeson's (.:) operator to extract fields
  Left $ ParseError "Not implemented"

-- | Parse Blockfrost UTxO response
--
-- Returns list of UTxOs for an address
parseUTxOs :: Value -> Either APIError [(String, Integer)]
parseUTxOs val = do
  -- TODO: Implement JSON parsing
  Left $ ParseError "Not implemented"

-- | Format lovelace as ADA
lovelaceToAda :: Integer -> Double
lovelaceToAda l = fromIntegral l / 1000000.0

-- | Format ADA with proper decimals
formatAda :: Double -> String
formatAda ada = show ada ++ " ADA"

-- | Complete example function (reference)
--
-- This shows how all the pieces fit together
exampleQueryBalance :: APIConfig -> String -> IO ()
exampleQueryBalance config address = do
  result <- callWithRetry 3 $ do
    response <- callBlockfrost config ("/addresses/" ++ address)
    case parseAddressBalance response of
      Left err -> throwError err
      Right lovelace -> return lovelace
  
  case result of
    Left err -> putStrLn $ "Error: " ++ show err
    Right lovelace -> do
      let ada = lovelaceToAda lovelace
      putStrLn $ "Balance: " ++ formatAda ada

