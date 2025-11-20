module Wallet.CLI
  ( Command(..)
  , parseCommand
  , runCommand
  , showHelp
  ) where

import System.Environment (getArgs)
import System.Exit (exitSuccess)
import Wallet.Types
import qualified Wallet.Address as Address
import qualified Wallet.Balance as Balance
import qualified Wallet.Transaction as Tx
import qualified Wallet.Storage as Storage

-- | CLI commands
data Command
  = Generate (Maybe String)        -- ^ Generate address with optional label
  | List                           -- ^ List all addresses
  | Balance Address                -- ^ Query balance
  | UTxOs Address                  -- ^ View UTxOs
  | Send Address Address Double    -- ^ Send ADA
  | Help                           -- ^ Show help
  | Version                        -- ^ Show version
  deriving (Eq, Show)

-- | Parse command line arguments
--
-- TODO: Implement command parsing
parseCommand :: [String] -> Either String Command
parseCommand [] = Right Help
parseCommand ["help"] = Right Help
parseCommand ["version"] = Right Version
parseCommand ["generate"] = Right (Generate Nothing)
parseCommand ["generate", label] = Right (Generate (Just label))
parseCommand ["list"] = Right List
parseCommand ["balance", addr] = Right (Balance (Address addr))
parseCommand ["utxos", addr] = Right (UTxOs (Address addr))
parseCommand ["send", from, to, amtStr] =
  case reads amtStr of
    [(amt, "")] -> Right (Send (Address from) (Address to) amt)
    _ -> Left "Invalid amount"
parseCommand _ = Left "Unknown command"

-- | Run a command
--
-- TODO: Implement command execution
runCommand :: Config -> Command -> IO ()
runCommand config cmd = case cmd of
  Help -> showHelp
  
  Version -> do
    putStrLn "Cardano Wallet Tool v0.1.0"
  
  Generate mlabel -> do
    -- TODO: Implement address generation
    -- 1. Generate new address
    -- 2. Add to state
    -- 3. Save state
    -- 4. Display result
    putStrLn "TODO: Implement address generation"
  
  List -> do
    -- TODO: Implement address listing
    -- 1. Load state
    -- 2. Display all addresses
    putStrLn "TODO: Implement address listing"
  
  Balance addr -> do
    -- TODO: Implement balance query
    -- 1. Query API
    -- 2. Display balance
    putStrLn "TODO: Implement balance query"
  
  UTxOs addr -> do
    -- TODO: Implement UTxO query
    putStrLn "TODO: Implement UTxO query"
  
  Send fromAddr toAddr amt -> do
    -- TODO: Implement transaction building
    putStrLn "TODO: Implement transaction building"

-- | Show help message
showHelp :: IO ()
showHelp = do
  putStrLn "Cardano Wallet Tool - Command-line wallet"
  putStrLn ""
  putStrLn "USAGE:"
  putStrLn "  wallet <COMMAND> [OPTIONS]"
  putStrLn ""
  putStrLn "COMMANDS:"
  putStrLn "  generate [label]       Generate a new address"
  putStrLn "  list                   List all addresses"
  putStrLn "  balance <addr>         Query balance of an address"
  putStrLn "  utxos <addr>           View UTxOs of an address"
  putStrLn "  send <from> <to> <amt> Build a payment transaction"
  putStrLn "  help                   Show this help message"
  putStrLn "  version                Show version"
  putStrLn ""
  putStrLn "EXAMPLES:"
  putStrLn "  wallet generate \"My Wallet\""
  putStrLn "  wallet balance addr_test1q..."
  putStrLn "  wallet send addr1 addr2 10.5"
  putStrLn ""
  putStrLn "For more info, see the project README"

