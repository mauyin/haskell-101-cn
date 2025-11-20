module Wallet.Address
  ( generateAddress
  , validateAddress
  , formatAddress
  , addAddress
  , removeAddress
  , findAddress
  ) where

import Control.Monad (replicateM)
import Data.List (find)
import System.Random (randomRIO)
import Wallet.Types

-- | Generate a new address (simulated)
--
-- TODO: Implement address generation
-- Hint: Use randomRIO to generate random characters
-- Format: "addr_test1q" ++ 50 random alphanumeric chars
generateAddress :: IO Address
generateAddress = do
  -- TODO: Implement this
  -- Use replicateM and randomRIO to generate random string
  undefined

-- | Validate address format
--
-- TODO: Implement address validation
-- Check if address starts with "addr_test1" (testnet)
validateAddress :: String -> Either WalletError Address
validateAddress addr
  | "addr_test1" `isPrefixOf` addr = Right (Address addr)
  | otherwise = Left $ ValidationError "Invalid address format. Must start with 'addr_test1'"
  where
    isPrefixOf = undefined  -- TODO: Implement or import from Data.List

-- | Format address for display (truncate middle)
--
-- TODO: Implement address formatting
-- Example: "addr_test1q...abc123" (show first 12 and last 6 chars)
formatAddress :: Address -> String
formatAddress (Address addr) =
  -- TODO: Implement this
  -- Hint: Use take, drop, and length
  undefined

-- | Add address to list
--
-- TODO: Implement adding address
addAddress :: AddressInfo -> [AddressInfo] -> [AddressInfo]
addAddress addr addrs = undefined  -- TODO: Implement

-- | Remove address from list
--
-- TODO: Implement removing address
removeAddress :: Address -> [AddressInfo] -> [AddressInfo]
removeAddress addr addrs = undefined  -- TODO: Implement (use filter)

-- | Find address in list
--
-- TODO: Implement finding address
findAddress :: Address -> [AddressInfo] -> Maybe AddressInfo
findAddress addr addrs = undefined  -- TODO: Implement (use find)

-- Helper function to generate random char
randomChar :: IO Char
randomChar = do
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  idx <- randomRIO (0, length chars - 1)
  return $ chars !! idx

