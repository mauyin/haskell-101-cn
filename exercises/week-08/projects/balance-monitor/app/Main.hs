module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure)
import Monitor
import Monitor.CLI
import qualified Monitor.Config as Cfg

main :: IO ()
main = do
  args <- getArgs
  
  -- Load configuration
  configResult <- Cfg.loadConfig "config.yaml"
  config <- case configResult of
    Left err -> do
      putStrLn $ "Warning: Could not load config: " ++ err
      putStrLn "Using default configuration"
      return Cfg.defaultConfig
    Right cfg -> return cfg
  
  -- Parse and run command
  case parseCommand args of
    Left err -> do
      putStrLn $ "Error: " ++ err
      putStrLn ""
      showHelp
      exitFailure
    
    Right cmd -> do
      runCommand config cmd

