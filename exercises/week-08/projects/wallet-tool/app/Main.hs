module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure)
import Wallet
import Wallet.CLI

main :: IO ()
main = do
  args <- getArgs
  
  -- Default configuration
  let config = Config
        { cfgApiKey = "testnetXXXXXXXXXXXX"  -- TODO: Load from config file
        , cfgApiEndpoint = "https://cardano-testnet.blockfrost.io"
        , cfgDataDir = ".cardano-wallet"
        }
  
  case parseCommand args of
    Left err -> do
      putStrLn $ "Error: " ++ err
      putStrLn ""
      showHelp
      exitFailure
    
    Right cmd -> do
      runCommand config cmd

