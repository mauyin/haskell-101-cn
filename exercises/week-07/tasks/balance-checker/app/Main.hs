module Main where

import System.Environment (getArgs)
import qualified Data.Text as T

-- TODO: Implement main CLI

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Usage: balance-checker <address> [<address>...]"
    addrs -> do
      putStrLn "Balance Checker - Week 7 Project"
      putStrLn "TODO: Query and display balances"
      -- TODO:
      -- 1. Parse command line arguments
      -- 2. Query each address
      -- 3. Display results in a table

