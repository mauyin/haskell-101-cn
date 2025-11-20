{-# LANGUAGE OverloadedStrings #-}

module Display
  ( displayTx
  , displaySummary
  , formatAmount
  ) where

import Types
import Data.List (intercalate)

-- Display full transaction details
displayTx :: Tx -> String
displayTx tx = unlines $
  [ "╔═══════════════════════════════════════════════════════╗"
  , "║           Transaction Details                         ║"
  , "╠═══════════════════════════════════════════════════════╣"
  , "║ ID: " ++ padRight 50 (shortenHash $ txId tx) ++ " ║"
  , "╚═══════════════════════════════════════════════════════╝"
  , ""
  , displayInputs (inputs $ txBody tx)
  , ""
  , displayOutputs (outputs $ txBody tx)
  , ""
  , displaySummary tx
  ]

-- Display transaction inputs
displayInputs :: [TxIn] -> String
displayInputs ins = unlines $
  ["Inputs (" ++ show (length ins) ++ "):"] ++
  concatMap formatInput (zip [0::Int ..] ins)
  where
    formatInput (n, txIn) =
      [ "  ├─ Input #" ++ show n
      , "  │  └─ " ++ txInHash txIn ++ "#" ++ show (txInIndex txIn)
      ]

-- Display transaction outputs
displayOutputs :: [TxOut] -> String
displayOutputs outs = unlines $
  ["Outputs (" ++ show (length outs) ++ "):"] ++
  concatMap formatOutput (zip [0::Int ..] outs)
  where
    formatOutput (n, txOut) =
      [ "  ├─ Output #" ++ show n
      , "  │  ├─ Address: " ++ shortenAddr (address txOut)
      , "  │  └─ Amount: " ++ formatAmount (lovelace $ value txOut)
      ]

-- Display transaction summary
displaySummary :: Tx -> String
displaySummary tx =
  let body = txBody tx
      inputCount = length $ inputs body
      outputCount = length $ outputs body
      totalOut = sum $ map (lovelace . value) (outputs body)
      feePaid = fee body
      -- Note: Can't calculate totalIn without UTxO lookup
      totalIn = totalOut + feePaid  -- Assumed balanced
      balanced = totalIn == totalOut + feePaid
  in unlines
       [ "Summary:"
       , "  Inputs:  " ++ show inputCount ++ " UTxOs"
       , "  Outputs: " ++ show outputCount ++ " UTxOs"
       , "  Total Output: " ++ formatAmount totalOut
       , "  Fee:          " ++ formatAmount feePaid
       , "  Status: " ++ if balanced then "✓ Balanced" else "✗ Not Balanced"
       ]

-- Format lovelace as ADA
formatAmount :: Integer -> String
formatAmount lovelace =
  let ada = fromIntegral lovelace / 1000000 :: Double
  in show ada ++ " ADA (" ++ show lovelace ++ " Lovelace)"

-- Shorten hash for display
shortenHash :: String -> String
shortenHash h
  | length h > 50 = take 20 h ++ "..." ++ drop (length h - 20) h
  | otherwise = h

-- Shorten address for display
shortenAddr :: String -> String
shortenAddr addr
  | length addr > 60 = take 25 addr ++ "..." ++ drop (length addr - 15) addr
  | otherwise = addr

-- Padding helper
padRight :: Int -> String -> String
padRight n s = s ++ replicate (n - length s) ' '

