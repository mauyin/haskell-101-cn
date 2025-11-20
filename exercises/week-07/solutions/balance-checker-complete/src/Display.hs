{-# LANGUAGE OverloadedStrings #-}

module Display
  ( displayResults
  , displaySingleResult
  , displayTable
  , formatAda
  ) where

import Types
import qualified Data.Text as T
import Data.Text (Text)
import Data.List (intercalate)

-- Display all results
displayResults :: [QueryResult] -> String
displayResults results = 
  let (successes, failures) = partitionResults results
  in unlines $
    [ "╔════════════════════════════════════════════════════════╗"
    , "║         Cardano Address Balance Checker               ║"
    , "╚════════════════════════════════════════════════════════╝"
    , ""
    ] ++
    (if not (null successes)
     then displayTable successes ++ [""]
     else []) ++
    (if not (null failures)
     then displayFailures failures
     else []) ++
    [ ""
    , "Summary:"
    , "  Total addresses: " ++ show (length results)
    , "  Successful: " ++ show (length successes)
    , "  Failed: " ++ show (length failures)
    , if not (null successes)
      then "  Total balance: " ++ formatAda (sum $ map balance successes) ++ " ADA"
      else ""
    ]

-- Partition results into successes and failures
partitionResults :: [QueryResult] -> ([BalanceInfo], [(Text, String)])
partitionResults = foldr part ([], [])
  where
    part (Success info) (succ, fail) = (info : succ, fail)
    part (Failure addr err) (succ, fail) = (succ, (addr, err) : fail)

-- Display results as table
displayTable :: [BalanceInfo] -> [String]
displayTable infos = 
  [ "╔════════════════════════════════════════════════╤════════════╤═══════╗"
  , "║ Address                                        │ Balance    │ UTxOs ║"
  , "╠════════════════════════════════════════════════╪════════════╪═══════╣"
  ] ++
  map formatRow infos ++
  [ "╠════════════════════════════════════════════════╪════════════╪═══════╣"
  , "║ TOTAL                                          │ " 
      ++ padRight 10 (formatAda totalBal) ++ " │       ║"
  , "╚════════════════════════════════════════════════╧════════════╧═══════╝"
  ]
  where
    totalBal = sum $ map balance infos
    
    formatRow info =
      "║ " ++ padRight 46 (shortenAddr $ address info) ++
      " │ " ++ padRight 10 (formatAda $ balance info) ++
      " │ " ++ padLeft 5 (show $ utxoCount info) ++ " ║"

-- Display single result
displaySingleResult :: QueryResult -> String
displaySingleResult (Success info) = unlines
  [ "Address: " ++ T.unpack (address info)
  , "Balance: " ++ formatAda (balance info) ++ " ADA"
  , "UTxOs: " ++ show (utxoCount info)
  ]
displaySingleResult (Failure addr err) = unlines
  [ "Address: " ++ T.unpack addr
  , "Error: " ++ err
  ]

-- Display failures
displayFailures :: [(Text, String)] -> [String]
displayFailures failures =
  ["Failed addresses:"] ++
  concatMap formatFailure failures
  where
    formatFailure (addr, err) =
      [ "  ✗ " ++ T.unpack addr
      , "    " ++ err
      ]

-- Format lovelace as ADA
formatAda :: Integer -> String
formatAda lovelace = 
  let ada = fromIntegral lovelace / 1000000 :: Double
  in show ada

-- Shorten address for display
shortenAddr :: Text -> String
shortenAddr addr = 
  let s = T.unpack addr
  in if length s > 46
     then take 20 s ++ "..." ++ drop (length s - 20) s
     else s

-- Padding helpers
padRight :: Int -> String -> String
padRight n s = s ++ replicate (n - length s) ' '

padLeft :: Int -> String -> String
padLeft n s = replicate (n - length s) ' ' ++ s

