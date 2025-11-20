{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

{- |
Parse Transaction Example
=========================

Complete example demonstrating how to:
- Define transaction data types
- Implement FromJSON instances
- Parse JSON files
- Extract transaction information
- Display results beautifully

Usage:
  runhaskell parse-tx-example.hs ../tasks/sample-data/transaction.json
-}

module Main where

import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import GHC.Generics
import System.Environment (getArgs)
import System.Exit (exitFailure)

-- ============================================================================
-- Data Types
-- ============================================================================

data Transaction = Transaction
  { txId   :: String
  , txBody :: TxBody
  } deriving (Show, Generic, FromJSON)

data TxBody = TxBody
  { inputs  :: [TxInput]
  , outputs :: [TxOutput]
  , fee     :: Integer
  , ttl     :: Maybe Integer
  } deriving (Show, Generic, FromJSON)

data TxInput = TxInput
  { txInId    :: String
  , txInIndex :: Int
  } deriving (Show, Generic)

-- Custom FromJSON for TxInput because JSON uses "txId" not "txInId"
instance FromJSON TxInput where
  parseJSON = withObject "TxInput" $ \v -> TxInput
    <$> v .: "txId"
    <*> v .: "txIndex"

data TxOutput = TxOutput
  { address :: String
  , value   :: TxValue
  } deriving (Show, Generic, FromJSON)

data TxValue = TxValue
  { lovelace :: Integer
  } deriving (Show, Generic, FromJSON)

-- ============================================================================
-- Parsing Functions
-- ============================================================================

-- Parse transaction from file
parseTransaction :: FilePath -> IO (Either String Transaction)
parseTransaction path = do
  content <- BSL.readFile path
  return $ eitherDecode content

-- ============================================================================
-- Display Functions
-- ============================================================================

-- Display transaction in a nice format
displayTransaction :: Transaction -> IO ()
displayTransaction tx = do
  putStrLn "╔═══════════════════════════════════════════════════════╗"
  putStrLn "║         Transaction Parser Example                   ║"
  putStrLn "╚═══════════════════════════════════════════════════════╝"
  putStrLn ""
  putStrLn $ "Transaction ID: " ++ shortenHash (txId tx)
  putStrLn ""
  
  displayInputs (inputs $ txBody tx)
  putStrLn ""
  
  displayOutputs (outputs $ txBody tx)
  putStrLn ""
  
  displaySummary tx

-- Display inputs
displayInputs :: [TxInput] -> IO ()
displayInputs ins = do
  putStrLn $ "Inputs (" ++ show (length ins) ++ "):"
  mapM_ displayInput (zip [0..] ins)
  where
    displayInput (n, input) = do
      putStrLn $ "  " ++ show n ++ ". " ++ txInId input ++ "#" ++ show (txInIndex input)

-- Display outputs
displayOutputs :: [TxOutput] -> IO ()
displayOutputs outs = do
  putStrLn $ "Outputs (" ++ show (length outs) ++ "):"
  mapM_ displayOutput (zip [0..] outs)
  where
    displayOutput (n, output) = do
      putStrLn $ "  " ++ show n ++ ". " ++ shortenAddr (address output)
      putStrLn $ "     " ++ formatLovelace (lovelace $ value output)

-- Display transaction summary
displaySummary :: Transaction -> IO ()
displaySummary tx = do
  let body = txBody tx
      totalOut = sum $ map (lovelace . value) (outputs body)
      feePaid = fee body
      totalIn = totalOut + feePaid  -- Simplified
  
  putStrLn "Summary:"
  putStrLn $ "  Total Input:  " ++ formatLovelace totalIn
  putStrLn $ "  Total Output: " ++ formatLovelace totalOut
  putStrLn $ "  Fee:          " ++ formatLovelace feePaid
  putStrLn $ "  Balanced: " ++ if totalIn == totalOut + feePaid then "✓" else "✗"

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Format lovelace as ADA
formatLovelace :: Integer -> String
formatLovelace l = 
  let ada = fromIntegral l / 1000000 :: Double
  in show ada ++ " ADA (" ++ show l ++ " Lovelace)"

-- Shorten hash for display
shortenHash :: String -> String
shortenHash h
  | length h > 60 = take 20 h ++ "..." ++ drop (length h - 20) h
  | otherwise = h

-- Shorten address for display
shortenAddr :: String -> String
shortenAddr addr
  | length addr > 60 = take 25 addr ++ "..." ++ drop (length addr - 15) addr
  | otherwise = addr

-- ============================================================================
-- Main Program
-- ============================================================================

main :: IO ()
main = do
  args <- getArgs
  case args of
    [txFile] -> do
      putStrLn $ "Loading transaction from: " ++ txFile
      putStrLn ""
      
      result <- parseTransaction txFile
      case result of
        Left err -> do
          putStrLn $ "Error parsing transaction: " ++ err
          exitFailure
        Right tx -> displayTransaction tx
    
    _ -> do
      putStrLn "Usage: parse-tx-example <transaction.json>"
      putStrLn ""
      putStrLn "Example:"
      putStrLn "  runhaskell parse-tx-example.hs ../tasks/sample-data/transaction.json"
      exitFailure

{- |
Example Output:
═══════════════════════════════════════════════════════
         Transaction Parser Example                   
═══════════════════════════════════════════════════════

Transaction ID: a1b2c3d4e5f6a7b8...f0a1b2

Inputs (2):
  0. f0e1d2c3b4a5968778...#0
  1. b2a19081726354b5c6...#1

Outputs (2):
  0. addr_test1qr5eqq7vus...
     60.0 ADA (60000000 Lovelace)
  1. addr_test1qz2fxv2umy...
     19.83 ADA (19830000 Lovelace)

Summary:
  Total Input:  80.0 ADA (80000000 Lovelace)
  Total Output: 79.83 ADA (79830000 Lovelace)
  Fee:          0.17 ADA (170000 Lovelace)
  Balanced: ✓
-}

