{- |
Week 7 - Solutions: Blockfrost API Exercises
=============================================

Complete solutions for all API exercises in Week07API.hs

Note: These solutions require a valid Blockfrost API key to run.
For offline testing, use the mock functions provided.

Author: Haskell 101 Course Team
Date: 2025-11-20
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Week07APISolutions where

import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as BS8
import qualified Data.ByteString.Lazy as BSL
import Data.Text (Text)
import GHC.Generics
import Control.Monad.IO.Class (liftIO)
import Control.Exception (try, SomeException, catch, Handler(..))
import Control.Concurrent (threadDelay)

-- ============================================================================
-- API Configuration
-- ============================================================================

data BlockfrostConfig = BlockfrostConfig
  { apiKey  :: Text
  , isTestnet :: Bool
  } deriving (Show)

testnetConfig :: Text -> BlockfrostConfig
testnetConfig key = BlockfrostConfig key True

mainnetConfig :: Text -> BlockfrostConfig
mainnetConfig key = BlockfrostConfig key False

apiBaseUrl :: BlockfrostConfig -> Url 'Https
apiBaseUrl config
  | isTestnet config = https "cardano-testnet.blockfrost.io"
  | otherwise = https "cardano-mainnet.blockfrost.io"


-- ============================================================================
-- Exercise 3.1: Query Address Balance
-- ============================================================================

data AddressInfo = AddressInfo
  { address       :: Text
  , amount        :: [AmountUnit]
  , stake_address :: Maybe Text
  , type_         :: Text
  , script        :: Bool
  } deriving (Show, Generic)

instance FromJSON AddressInfo where
  parseJSON = withObject "AddressInfo" $ \v -> AddressInfo
    <$> v .: "address"
    <*> v .: "amount"
    <*> v .:? "stake_address"
    <*> v .: "type"
    <*> v .: "script"

data AmountUnit = AmountUnit
  { unit     :: Text
  , quantity :: Text
  } deriving (Show, Generic, FromJSON)

queryAddressInfo 
  :: BlockfrostConfig 
  -> Text
  -> IO (Either String AddressInfo)
queryAddressInfo config addr = do
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

queryAddressBalance :: BlockfrostConfig -> Text -> IO (Either String Integer)
queryAddressBalance config addr = do
  result <- queryAddressInfo config addr
  case result of
    Left err -> return $ Left err
    Right info -> 
      case filter (\a -> unit a == "lovelace") (amount info) of
        [] -> return $ Left "No lovelace balance found"
        (a:_) -> 
          case reads (T.unpack $ quantity a) of
            [(balance, "")] -> return $ Right balance
            _ -> return $ Left "Failed to parse balance"

displayBalance :: Integer -> String
displayBalance lovelace = 
  show (fromIntegral lovelace / 1000000 :: Double) ++ " ADA (" 
    ++ show lovelace ++ " Lovelace)"


-- ============================================================================
-- Exercise 3.2: Get UTxO List
-- ============================================================================

data UTxO = UTxO
  { tx_hash   :: Text
  , tx_index  :: Int
  , output_index :: Int
  , amount_utxo    :: [AmountUnit]
  , block     :: Text
  , data_hash :: Maybe Text
  } deriving (Show, Generic)

instance FromJSON UTxO where
  parseJSON = withObject "UTxO" $ \v -> UTxO
    <$> v .: "tx_hash"
    <*> v .: "tx_index"
    <*> v .: "output_index"
    <*> v .: "amount"
    <*> v .: "block"
    <*> v .:? "data_hash"

queryUTxOs 
  :: BlockfrostConfig
  -> Text
  -> IO (Either String [UTxO])
queryUTxOs config addr = do
  result <- try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl config /: "api" /: "v0" /: "addresses" /: addr /: "utxos"
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))
    return (responseBody response :: [UTxO])
  
  case result of
    Left (err :: SomeException) -> return $ Left $ show err
    Right utxos -> return $ Right utxos

displayUTxOs :: [UTxO] -> String
displayUTxOs utxos = unlines $
  ["UTxO List:"] ++
  ["  Total UTxOs: " ++ show (length utxos)] ++
  concatMap formatUTxO (zip [1::Int ..] utxos)
  where
    formatUTxO (n, utxo) = 
      [ "  UTxO #" ++ show n
      , "    TxHash: " ++ T.unpack (tx_hash utxo) ++ "#" ++ show (tx_index utxo)
      , "    Block: " ++ T.unpack (block utxo)
      , "    Amount: " ++ formatAmounts (amount_utxo utxo)
      ]
    
    formatAmounts [] = "0"
    formatAmounts amounts = 
      unwords $ map (\a -> T.unpack (quantity a) ++ " " ++ T.unpack (unit a)) amounts


-- ============================================================================
-- Exercise 3.3: Query Transaction History
-- ============================================================================

data TxHistory = TxHistory
  { tx_hash_hist       :: Text
  , tx_index_hist      :: Int
  , block_height :: Int
  , block_time   :: Int
  } deriving (Show, Generic)

instance FromJSON TxHistory where
  parseJSON = withObject "TxHistory" $ \v -> TxHistory
    <$> v .: "tx_hash"
    <*> v .: "tx_index"
    <*> v .: "block_height"
    <*> v .: "block_time"

queryRecentTransactions 
  :: BlockfrostConfig
  -> Text
  -> IO (Either String [TxHistory])
queryRecentTransactions config addr = do
  result <- try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl config /: "api" /: "v0" /: "addresses" /: addr /: "transactions"
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (  header "project_id" (BS8.pack $ T.unpack $ apiKey config)
      <> "count" =: (10 :: Int)
      <> "order" =: ("desc" :: String)
      )
    return (responseBody response :: [TxHistory])
  
  case result of
    Left (err :: SomeException) -> return $ Left $ show err
    Right txs -> return $ Right txs


-- ============================================================================
-- Exercise 3.4: Query Block Information
-- ============================================================================

data BlockInfo = BlockInfo
  { blockHeight     :: Int
  , blockHash       :: Text
  , blockTime       :: Int
  , blockTxCount    :: Int
  , blockSlot       :: Int
  , blockEpoch      :: Int
  } deriving (Show, Generic)

instance FromJSON BlockInfo where
  parseJSON = withObject "BlockInfo" $ \v -> BlockInfo
    <$> v .: "height"
    <*> v .: "hash"
    <*> v .: "time"
    <*> v .: "tx_count"
    <*> v .: "slot"
    <*> v .: "epoch"

queryLatestBlock :: BlockfrostConfig -> IO (Either String BlockInfo)
queryLatestBlock config = do
  result <- try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl config /: "api" /: "v0" /: "blocks" /: "latest"
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))
    return (responseBody response :: BlockInfo)
  
  case result of
    Left (err :: SomeException) -> return $ Left $ show err
    Right block -> return $ Right block


-- ============================================================================
-- Exercise 3.5: Error Handling
-- ============================================================================

data APIError
  = NetworkError String
  | HTTPError Int String
  | ParseError String
  | RateLimitError
  deriving (Show, Eq)

safeAPIRequest 
  :: FromJSON a
  => BlockfrostConfig
  -> Text
  -> IO (Either APIError a)
safeAPIRequest config endpoint = do
  result <- try $ runReq defaultHttpConfig $ do
    let paths = T.splitOn "/" endpoint
    let url = foldl (/:) (apiBaseUrl config /: "api" /: "v0") paths
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))
    return response
  
  case result of
    Left (err :: SomeException) -> return $ Left $ NetworkError (show err)
    Right response -> 
      case responseStatusCode response of
        200 -> return $ Right $ responseBody response
        429 -> return $ Left RateLimitError
        code -> return $ Left $ HTTPError code "Request failed"

requestWithRetry 
  :: FromJSON a
  => Int
  -> BlockfrostConfig
  -> Text
  -> IO (Either APIError a)
requestWithRetry maxRetries config endpoint = 
  retry maxRetries
  where
    retry 0 = safeAPIRequest config endpoint
    retry n = do
      result <- safeAPIRequest config endpoint
      case result of
        Left RateLimitError -> do
          threadDelay 1000000  -- Wait 1 second
          retry (n - 1)
        Left (HTTPError _ _) -> do
          threadDelay 500000  -- Wait 0.5 seconds
          retry (n - 1)
        other -> return other


-- ============================================================================
-- Helper Functions
-- ============================================================================

buildApiPath :: Text -> [Text]
buildApiPath endpoint = T.splitOn "/" endpoint

simpleGet 
  :: FromJSON a
  => BlockfrostConfig
  -> Text
  -> IO (JsonResponse a)
simpleGet config endpoint = runReq defaultHttpConfig $ do
  let paths = buildApiPath endpoint
  let url = foldl (/:) (apiBaseUrl config /: "api" /: "v0") paths
  req GET url NoReqBody jsonResponse 
      (header "project_id" (BS8.pack $ T.unpack $ apiKey config))


-- ============================================================================
-- Mock Functions (Path A - for offline testing)
-- ============================================================================

mockQueryAddressInfo :: Text -> IO (Either String AddressInfo)
mockQueryAddressInfo addr = do
  content <- BSL.readFile "sample-data/address-info.json"
  return $ eitherDecode content

mockQueryUTxOs :: Text -> IO (Either String [UTxO])
mockQueryUTxOs addr = do
  content <- BSL.readFile "sample-data/utxos.json"
  return $ eitherDecode content

mockQueryLatestBlock :: IO (Either String BlockInfo)
mockQueryLatestBlock = do
  content <- BSL.readFile "sample-data/block.json"
  return $ eitherDecode content


-- ============================================================================
-- Test Functions
-- ============================================================================

-- Test configuration (replace with your API key)
testConfig :: BlockfrostConfig
testConfig = testnetConfig "testnetXXXXXXXXXXXXXXXX"

testAddress :: Text
testAddress = "addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp"

testQueryBalance :: IO ()
testQueryBalance = do
  putStrLn "=== Test 3.1: Query Address Balance ==="
  result <- queryAddressBalance testConfig testAddress
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right balance -> do
      putStrLn $ "Address: " ++ T.unpack testAddress
      putStrLn $ "Balance: " ++ displayBalance balance

testQueryUTxOs' :: IO ()
testQueryUTxOs' = do
  putStrLn "\n=== Test 3.2: Query UTxOs ==="
  result <- queryUTxOs testConfig testAddress
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right utxos -> do
      putStrLn $ "UTxO count: " ++ show (length utxos)
      putStrLn $ displayUTxOs utxos

testQueryTransactions :: IO ()
testQueryTransactions = do
  putStrLn "\n=== Test 3.3: Query Transaction History ==="
  result <- queryRecentTransactions testConfig testAddress
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right txs -> do
      putStrLn $ "Recent transactions: " ++ show (length txs)
      mapM_ (\tx -> putStrLn $ "  " ++ T.unpack (tx_hash_hist tx)) 
            (take 5 txs)

testQueryBlock :: IO ()
testQueryBlock = do
  putStrLn "\n=== Test 3.4: Query Latest Block ==="
  result <- queryLatestBlock testConfig
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right block -> do
      putStrLn $ "Block height: " ++ show (blockHeight block)
      putStrLn $ "Block hash: " ++ T.unpack (blockHash block)
      putStrLn $ "Tx count: " ++ show (blockTxCount block)

testWithMockData :: IO ()
testWithMockData = do
  putStrLn "=== Using Sample Data (Path A) ==="
  
  addrResult <- mockQueryAddressInfo testAddress
  case addrResult of
    Left err -> putStrLn $ "Address query error: " ++ err
    Right info -> do
      putStrLn $ "Address: " ++ T.unpack (address info)
      putStrLn $ "Type: " ++ T.unpack (type_ info)
  
  utxoResult <- mockQueryUTxOs testAddress
  case utxoResult of
    Left err -> putStrLn $ "UTxO query error: " ++ err
    Right utxos -> do
      putStrLn $ "\nUTxO count: " ++ show (length utxos)

runAPITests :: IO ()
runAPITests = do
  putStrLn "Note: Set valid Blockfrost API Key in testConfig"
  putStrLn "Or use testWithMockData for offline testing\n"
  
  -- Uncomment to test with real API:
  -- testQueryBalance
  -- testQueryUTxOs'
  -- testQueryTransactions
  -- testQueryBlock
  
  -- For offline testing:
  testWithMockData
  
  putStrLn "\n✓ API tests completed!"

main :: IO ()
main = runAPITests

