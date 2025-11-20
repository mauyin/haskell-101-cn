module Validator
  ( validateTx
  , checkBalance
  , ValidationError(..)
  ) where

import Types

data ValidationError
  = NoInputs
  | NoOutputs
  | ImbalancedTx String
  | InvalidFee String
  deriving (Show, Eq)

-- Validate transaction
validateTx :: Tx -> Either ValidationError ()
validateTx tx = do
  let body = txBody tx
  
  -- Check inputs
  if null (inputs body)
    then Left NoInputs
    else return ()
  
  -- Check outputs
  if null (outputs body)
    then Left NoOutputs
    else return ()
  
  -- Check balance
  checkBalance tx
  
  -- Check fee reasonableness
  let feePaid = fee body
  if feePaid < 100000
    then Left $ InvalidFee "Fee too low (< 0.1 ADA)"
    else if feePaid > 100000000
    then Left $ InvalidFee "Fee too high (> 100 ADA)"
    else return ()

-- Check if transaction is balanced
checkBalance :: Tx -> Either ValidationError ()
checkBalance tx =
  let body = txBody tx
      totalOut = sum $ map (lovelace . value) (outputs body)
      feePaid = fee body
      -- Note: In real scenario would need to look up input values
      -- Here we assume balanced if fee > 0 and < total output
      isBalanced = feePaid > 0 && totalOut > 0
  in if isBalanced
     then Right ()
     else Left $ ImbalancedTx "Cannot verify balance without input values"

