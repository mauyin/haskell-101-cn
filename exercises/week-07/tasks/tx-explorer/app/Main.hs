module Main where

import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Usage: tx-explorer <transaction.json>"
    (file:_) -> do
      putStrLn $ "Exploring: " ++ file
      putStrLn "TODO: Implement transaction explorer"

