{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module API
  ( queryBalance
  , queryBalances
  , BlockfrostConfig(..)
  ) where

import Types
import Network.HTTP.Req
import Data.Aeson
import qualified Data.Text as T
import Data.Text (Text)
import qualified Data.ByteString.Char8 as BS8
import GHC.Generics
import Control.Exception (try, SomeException)
import Control.Monad.IO.Class (liftIO)

data BlockfrostConfig = BlockfrostConfig
  { bfApiKey  :: Text
  , bfTestnet :: Bool
  } deriving (Show)

-- Blockfrost API types
data AddressInfo = AddressInfo
  { aiAddress :: Text
  , aiAmount  :: [AmountUnit]
  } deriving (Show, Generic)

instance FromJSON AddressInfo where
  parseJSON = withObject "AddressInfo" $ \v -> AddressInfo
    <$> v .: "address"
    <*> v .: "amount"

data AmountUnit = AmountUnit
  { auUnit     :: Text
  , auQuantity :: Text
  } deriving (Show, Generic)

instance FromJSON AmountUnit where
  parseJSON = withObject "AmountUnit" $ \v -> AmountUnit
    <$> v .: "unit"
    <*> v .: "quantity"

data UTxO = UTxO
  { uTxHash  :: Text
  , uTxIndex :: Int
  , uAmount  :: [AmountUnit]
  } deriving (Show, Generic)

instance FromJSON UTxO where
  parseJSON = withObject "UTxO" $ \v -> UTxO
    <$> v .: "tx_hash"
    <*> v .: "tx_index"
    <*> v .: "amount"

-- API base URL
apiBaseUrl :: BlockfrostConfig -> Url 'Https
apiBaseUrl config
  | bfTestnet config = https "cardano-testnet.blockfrost.io"
  | otherwise = https "cardano-mainnet.blockfrost.io"

-- Query single address balance
queryBalance :: BlockfrostConfig -> Text -> IO QueryResult
queryBalance config addr = do
  result <- try $ runReq defaultHttpConfig $ do
    let url = apiBaseUrl config /: "api" /: "v0" /: "addresses" /: addr /: "utxos"
    response <- req
      GET
      url
      NoReqBody
      jsonResponse
      (header "project_id" (BS8.pack $ T.unpack $ bfApiKey config))
    return (responseBody response :: [UTxO])
  
  case result of
    Left (err :: SomeException) -> 
      return $ Failure addr (show err)
    Right utxos -> do
      let lovelaceSum = sum $ map extractLovelace utxos
      return $ Success $ BalanceInfo
        { address = addr
        , balance = lovelaceSum
        , utxoCount = length utxos
        }

-- Extract lovelace amount from UTxO
extractLovelace :: UTxO -> Integer
extractLovelace utxo =
  case filter (\a -> auUnit a == "lovelace") (uAmount utxo) of
    [] -> 0
    (a:_) -> 
      case reads (T.unpack $ auQuantity a) of
        [(amount, "")] -> amount
        _ -> 0

-- Query multiple addresses
queryBalances :: BlockfrostConfig -> [Text] -> IO [QueryResult]
queryBalances config addrs = mapM (queryBalance config) addrs

