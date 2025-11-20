module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure)

import Types
import Parser
import Validator
import Display
import Export

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> printUsage >> exitFailure
    ["--help"] -> printUsage
    ["--version"] -> printVersion
    [txFile] -> exploreTx txFile Nothing
    [txFile, "--export", exportType, exportFile] -> 
      exploreTx txFile (Just (exportType, exportFile))
    _ -> printUsage >> exitFailure

exploreTx :: FilePath -> Maybe (String, FilePath) -> IO ()
exploreTx txFile maybeExport = do
  putStrLn $ "Loading transaction from: " ++ txFile
  result <- parseTxFile txFile
  
  case result of
    Left err -> do
      putStrLn $ "Error parsing transaction: " ++ err
      exitFailure
    
    Right tx -> do
      -- Display transaction
      putStrLn ""
      putStrLn $ displayTx tx
      
      -- Validate transaction
      case validateTx tx of
        Left validationErr -> do
          putStrLn $ "⚠ Validation Warning: " ++ show validationErr
        Right () -> do
          putStrLn "✓ Transaction validation passed"
      
      -- Export if requested
      case maybeExport of
        Nothing -> return ()
        Just ("json", outFile) -> do
          exportToJSON outFile tx
          putStrLn $ "\n✓ Exported to JSON: " ++ outFile
        Just ("csv", outFile) -> do
          exportToCSV outFile tx
          putStrLn $ "\n✓ Exported to CSV: " ++ outFile
        Just ("summary", outFile) -> do
          exportSummary outFile tx
          putStrLn $ "\n✓ Exported summary: " ++ outFile
        Just (fmt, _) -> do
          putStrLn $ "\n✗ Unknown export format: " ++ fmt

printUsage :: IO ()
printUsage = putStrLn $ unlines
  [ "Transaction Explorer - Week 7 Project 2"
  , ""
  , "Usage:"
  , "  tx-explorer <transaction.json>"
  , "  tx-explorer <transaction.json> --export <format> <output>"
  , ""
  , "Options:"
  , "  --help     Show this help message"
  , "  --version  Show version information"
  , ""
  , "Export Formats:"
  , "  json       Export as JSON"
  , "  csv        Export as CSV"
  , "  summary    Export summary as text"
  , ""
  , "Examples:"
  , "  tx-explorer transaction.json"
  , "  tx-explorer transaction.json --export csv output.csv"
  , "  tx-explorer transaction.json --export summary summary.txt"
  ]

printVersion :: IO ()
printVersion = putStrLn "tx-explorer version 0.1.0.0"

