{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

{- |
Blockfrost Client Example
=========================

Simple Blockfrost API client demonstrating:
- API configuration
- Sending HTTP requests
- Parsing responses
- Error handling
- Using environment variables

Usage:
  export BLOCKFROST_API_KEY="testnetXXXXXXXXXXXX"
  runhaskell blockfrost-client.hs addr_test1q...
-}

module Main where

import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T
import Data.Text (Text)
import qualified Data.ByteString.Char8 as BS8
import GHC.Generics
import System.Environment (getArgs, lookupEnv)
import System.Exit (exitFailure)
import Control.Exception (try, SomeException)

-- ============================================================================
-- Configuration
-- ============================================================================

data Config = Config
  { apiKey    :: Text
  , isTestnet :: Bool
  } deriving (Show)

-- API base URL
apiBaseUrl :: Config -> Url 'Https
apiBaseUrl config
  | isTestnet config = https "cardano-testnet.blockfrost.io"
  | otherwise = https "cardano-mainnet.blockfrost.io"

-- ============================================================================
-- API Types
-- ============================================================================

data AddressInfo = AddressInfo
  { address       :: Text
  , amount        :: [AmountUnit]
  , stake_address :: Maybe Text
  , type_         :: Text
  } deriving (Show, Generic)

instance FromJSON AddressInfo where
  parseJSON = withObject "AddressInfo" $ \v -> AddressInfo
    <$> v .: "address"
    <*> v .: "amount"
    <*> v .:? "stake_address"
    <*> v .: "type"

data AmountUnit = AmountUnit
  { unit     :: Text
  , quantity :: Text
  } deriving (Show, Generic, FromJSON)

-- ============================================================================
-- API Functions
-- ============================================================================

-- Query address information
queryAddress :: Config -> Text -> IO (Either String AddressInfo)
queryAddress config addr = do
  result <- try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl config /: "api" /: "v0" /: "addresses" /: addr
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))
    return (responseBody response :: AddressInfo)
  
  case result of
    Left (err :: SomeException) -> return $ Left $ show err
    Right info -> return $ Right info

-- Extract lovelace balance from address info
extractBalance :: AddressInfo -> Integer
extractBalance info =
  case filter (\a -> unit a == "lovelace") (amount info) of
    [] -> 0
    (a:_) -> 
      case reads (T.unpack $ quantity a) of
        [(balance, "")] -> balance
        _ -> 0

-- ============================================================================
-- Display Functions
-- ============================================================================

displayAddressInfo :: AddressInfo -> IO ()
displayAddressInfo info = do
  putStrLn "╔════════════════════════════════════════════════════════╗"
  putStrLn "║         Blockfrost API Client Example                 ║"
  putStrLn "╚════════════════════════════════════════════════════════╝"
  putStrLn ""
  putStrLn $ "Address: " ++ T.unpack (address info)
  putStrLn $ "Type: " ++ T.unpack (type_ info)
  putStrLn $ "Balance: " ++ formatAda (extractBalance info)
  putStrLn ""
  
  case stake_address info of
    Nothing -> putStrLn "Stake Address: None"
    Just stake -> putStrLn $ "Stake Address: " ++ T.unpack stake
  
  putStrLn ""
  putStrLn "All assets:"
  mapM_ displayAsset (amount info)

displayAsset :: AmountUnit -> IO ()
displayAsset asset =
  putStrLn $ "  " ++ T.unpack (unit asset) ++ ": " ++ T.unpack (quantity asset)

-- Format lovelace as ADA
formatAda :: Integer -> String
formatAda lovelace = 
  let ada = fromIntegral lovelace / 1000000 :: Double
  in show ada ++ " ADA (" ++ show lovelace ++ " Lovelace)"

-- ============================================================================
-- Main Program
-- ============================================================================

main :: IO ()
main = do
  args <- getArgs
  
  case args of
    [addr] -> do
      -- Get API key from environment
      maybeKey <- lookupEnv "BLOCKFROST_API_KEY"
      
      case maybeKey of
        Nothing -> do
          putStrLn "Error: BLOCKFROST_API_KEY environment variable not set"
          putStrLn ""
          putStrLn "Please set it with:"
          putStrLn "  export BLOCKFROST_API_KEY=testnetXXXXXXXXXXXX"
          putStrLn ""
          putStrLn "Get your API key from: https://blockfrost.io"
          exitFailure
        
        Just key -> do
          let config = Config (T.pack key) True  -- Testnet
          
          putStrLn $ "Querying address: " ++ addr
          putStrLn ""
          
          result <- queryAddress config (T.pack addr)
          
          case result of
            Left err -> do
              putStrLn $ "Error: " ++ err
              exitFailure
            Right info -> displayAddressInfo info
    
    _ -> do
      putStrLn "Usage: blockfrost-client <address>"
      putStrLn ""
      putStrLn "Example:"
      putStrLn "  export BLOCKFROST_API_KEY=testnetXXXXXXXXXXXX"
      putStrLn "  runhaskell blockfrost-client.hs addr_test1q..."
      exitFailure

{- |
Example Output:
════════════════════════════════════════════════════════
         Blockfrost API Client Example                 
════════════════════════════════════════════════════════

Address: addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3...
Type: shelley
Balance: 100.523 ADA (100523000 Lovelace)

Stake Address: stake_test1uzqf8rjgnwknvtjqnflfryf7tjsj6g...

All assets:
  lovelace: 100523000
-}

