module Wallet.Balance
  ( queryBalance
  , formatBalance
  , lovelaceToAda
  ) where

import Control.Monad.Except (ExceptT, runExceptT, throwError, liftIO)
import Wallet.Types
import Wallet.API (queryAddressInfo)

-- | Query balance for an address
--
-- TODO: Implement balance query
-- Use Wallet.API.queryAddressInfo to get balance
queryBalance :: Config -> Address -> IO (Either WalletError Lovelace)
queryBalance config addr = runExceptT $ do
  -- TODO: Implement this
  -- 1. Call queryAddressInfo
  -- 2. Extract balance from response
  -- 3. Handle errors
  undefined

-- | Format balance for display
--
-- TODO: Implement balance formatting
-- Convert Lovelace to ADA (1 ADA = 1,000,000 Lovelace)
-- Format: "10.523000 ADA"
formatBalance :: Lovelace -> String
formatBalance lovelace =
  let ada = lovelaceToAda lovelace
  in undefined  -- TODO: Format as "X.XXXXXX ADA"

-- | Convert Lovelace to ADA
--
-- TODO: Implement conversion
-- 1 ADA = 1,000,000 Lovelace
lovelaceToAda :: Lovelace -> Double
lovelaceToAda (Lovelace l) = undefined  -- TODO: Implement

-- | Display balance information
--
-- TODO: Implement balance display
displayBalance :: Address -> Lovelace -> IO ()
displayBalance addr lovelace = do
  putStrLn $ "Address: " ++ show addr
  putStrLn $ "Balance: " ++ formatBalance lovelace

