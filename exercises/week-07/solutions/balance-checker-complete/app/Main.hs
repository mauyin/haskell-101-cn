{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Environment (getArgs, lookupEnv)
import qualified Data.Text as T
import Data.Text (Text)
import Control.Monad (when)

import Types
import API
import Cache
import Display

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> printUsage
    ["--help"] -> printUsage
    ["--version"] -> printVersion
    addrs -> runBalanceChecker addrs

runBalanceChecker :: [String] -> IO ()
runBalanceChecker addrStrs = do
  -- Get API key from environment
  maybeKey <- lookupEnv "BLOCKFROST_API_KEY"
  case maybeKey of
    Nothing -> do
      putStrLn "Error: BLOCKFROST_API_KEY environment variable not set"
      putStrLn "Please set it with: export BLOCKFROST_API_KEY=your_key_here"
      putStrLn ""
      putStrLn "Or for testing, use sample data:"
      putStrLn "  cd exercises/week-07/tasks/sample-data"
      putStrLn "  cat address-info.json"
    Just key -> do
      let config = BlockfrostConfig (T.pack key) True  -- Testnet
      let addrs = map T.pack addrStrs
      
      putStrLn "Querying balances..."
      putStrLn ""
      
      -- Query all addresses
      results <- queryBalances config addrs
      
      -- Display results
      putStrLn $ displayResults results

printUsage :: IO ()
printUsage = putStrLn $ unlines
  [ "Balance Checker - Week 7 Project 1"
  , ""
  , "Usage:"
  , "  balance-checker <address> [<address>...]"
  , ""
  , "Options:"
  , "  --help     Show this help message"
  , "  --version  Show version information"
  , ""
  , "Examples:"
  , "  balance-checker addr_test1q..."
  , "  balance-checker addr_test1q... addr_test1q..."
  , ""
  , "Environment Variables:"
  , "  BLOCKFROST_API_KEY  Your Blockfrost API key (required)"
  , ""
  , "Setup:"
  , "  1. Register at https://blockfrost.io"
  , "  2. Create a testnet project"
  , "  3. Copy your API key"
  , "  4. export BLOCKFROST_API_KEY=your_key_here"
  ]

printVersion :: IO ()
printVersion = putStrLn "balance-checker version 0.1.0.0"

