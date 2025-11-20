{-# LANGUAGE OverloadedStrings #-}

module Export
  ( exportToJSON
  , exportToCSV
  , exportSummary
  ) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import Data.List (intercalate)

-- Export transaction to JSON file
exportToJSON :: FilePath -> Tx -> IO ()
exportToJSON path tx = BSL.writeFile path (encodePretty tx)

-- Export transaction to CSV format
exportToCSV :: FilePath -> Tx -> IO ()
exportToCSV path tx = do
  let csvContent = txToCSV tx
  writeFile path csvContent

-- Convert transaction to CSV format
txToCSV :: Tx -> String
txToCSV tx =
  let body = txBody tx
      header = "type,index,txhash,address,amount\n"
      inputRows = map formatInputRow (zip [0::Int ..] $ inputs body)
      outputRows = map formatOutputRow (zip [0::Int ..] $ outputs body)
  in header ++ unlines (inputRows ++ outputRows)
  where
    formatInputRow (idx, txIn) =
      "input," ++ show idx ++ "," ++ txInHash txIn ++ "#" ++ show (txInIndex txIn) ++ ",,"
    
    formatOutputRow (idx, txOut) =
      "output," ++ show idx ++ ",," ++ address txOut ++ "," ++ show (lovelace $ value txOut)

-- Export summary to text file
exportSummary :: FilePath -> Tx -> IO ()
exportSummary path tx = do
  let summary = generateSummaryText tx
  writeFile path summary

-- Generate summary text
generateSummaryText :: Tx -> String
generateSummaryText tx =
  let body = txBody tx
  in unlines
       [ "Transaction Summary"
       , "==================="
       , ""
       , "ID: " ++ txId tx
       , "Inputs: " ++ show (length $ inputs body)
       , "Outputs: " ++ show (length $ outputs body)
       , "Fee: " ++ show (fee body) ++ " Lovelace"
       , ""
       , "Total Output: " ++ show (sum $ map (lovelace . value) (outputs body)) ++ " Lovelace"
       ]

