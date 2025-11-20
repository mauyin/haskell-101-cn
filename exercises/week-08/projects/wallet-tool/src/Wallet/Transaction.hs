module Wallet.Transaction
  ( buildTransaction
  , validateTransaction
  , estimateFee
  , selectInputs
  , saveTransaction
  ) where

import Control.Monad.Except (ExceptT, throwError)
import Data.Aeson (encodeFile)
import Data.Time (getCurrentTime, formatTime, defaultTimeLocale)
import Wallet.Types

-- | Build a payment transaction
--
-- TODO: Implement transaction building
-- Steps:
-- 1. Select UTxOs to cover amount + fee
-- 2. Calculate fee
-- 3. Calculate change
-- 4. Create transaction structure
buildTransaction 
  :: Address      -- ^ From address
  -> Address      -- ^ To address
  -> Lovelace     -- ^ Amount to send
  -> [UTxO]       -- ^ Available UTxOs
  -> Either WalletError Transaction
buildTransaction fromAddr toAddr amount utxos = do
  -- TODO: Implement this
  -- Use selectInputs, estimateFee, etc.
  undefined

-- | Select UTxOs to cover the required amount
--
-- TODO: Implement UTxO selection
-- Simple strategy: keep adding UTxOs until sum >= required amount
selectInputs :: Lovelace -> [UTxO] -> Either WalletError [UTxO]
selectInputs required utxos =
  -- TODO: Implement this
  -- Return InsufficientFunds if not enough
  undefined

-- | Estimate transaction fee
--
-- TODO: Implement fee estimation
-- Simple estimation: 0.17 ADA (170000 Lovelace)
estimateFee :: [UTxO] -> Lovelace
estimateFee inputs = Lovelace 170000  -- Simple fixed fee

-- | Validate transaction
--
-- TODO: Implement transaction validation
-- Check: sum(inputs) == sum(outputs) + fee
validateTransaction :: Transaction -> Either WalletError ()
validateTransaction tx =
  let inputSum = sum $ map utxoAmount (txInputs tx)
      outputSum = sum $ map txOutAmount (txOutputs tx)
      fee = txFee tx
  in if inputSum == outputSum + fee
       then Right ()
       else Left $ ValidationError "Transaction not balanced"

-- | Save transaction to file
--
-- TODO: Implement transaction saving
-- Save as JSON with timestamp in filename
saveTransaction :: Transaction -> IO FilePath
saveTransaction tx = do
  -- TODO: Implement this
  -- Generate filename: tx_YYYYMMDD_HHMMSS.json
  -- Use encodeFile to save
  undefined

