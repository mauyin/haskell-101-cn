module Monitor.CLI
  ( Command(..)
  , parseCommand
  , runCommand
  , showHelp
  ) where

import Data.Time (getCurrentTime)
import System.Exit (exitSuccess)
import Monitor.Types
import qualified Monitor.Query as Query
import qualified Monitor.Tracker as Tracker
import qualified Monitor.Storage as Storage
import qualified Monitor.Config as Cfg

-- | CLI commands
data Command
  = Add Address (Maybe String)    -- Add address to monitor
  | Remove Address                -- Remove address
  | List                          -- List all monitored addresses
  | Info Address                  -- Show address info
  | Start (Maybe Int)             -- Start monitoring with optional interval
  | Stop                          -- Stop monitoring
  | Status                        -- Show monitoring status
  | History (Maybe Address)       -- Show change history
  | Export FilePath               -- Export history to CSV
  | InitConfig FilePath           -- Create default config
  | Help
  | Version
  deriving (Eq, Show)

-- | Parse command line arguments
--
-- TODO: Implement command parsing
parseCommand :: [String] -> Either String Command
parseCommand [] = Right Help
parseCommand ["help"] = Right Help
parseCommand ["version"] = Right Version
parseCommand ["add", addr] = Right (Add (Address addr) Nothing)
parseCommand ["add", addr, label] = Right (Add (Address addr) (Just label))
parseCommand ["remove", addr] = Right (Remove (Address addr))
parseCommand ["list"] = Right List
parseCommand ["info", addr] = Right (Info (Address addr))
parseCommand ["start"] = Right (Start Nothing)
parseCommand ["start", "--interval", interval] =
  case reads interval of
    [(n, "")] -> Right (Start (Just n))
    _ -> Left "Invalid interval"
parseCommand ["history"] = Right (History Nothing)
parseCommand ["history", addr] = Right (History (Just (Address addr)))
parseCommand ["export", path] = Right (Export path)
parseCommand ["init-config", path] = Right (InitConfig path)
parseCommand _ = Left "Unknown command"

-- | Run a command
--
-- TODO: Implement command execution
runCommand :: Config -> Command -> IO ()
runCommand config cmd = case cmd of
  Help -> showHelp
  
  Version -> putStrLn "Balance Monitor v0.1.0"
  
  Add addr mlabel -> do
    -- TODO: Implement add address
    putStrLn "TODO: Implement add address"
  
  Remove addr -> do
    -- TODO: Implement remove address
    putStrLn "TODO: Implement remove address"
  
  List -> do
    -- TODO: Implement list addresses
    putStrLn "TODO: Implement list addresses"
  
  Info addr -> do
    -- TODO: Implement show address info
    putStrLn "TODO: Implement show address info"
  
  Start mInterval -> do
    -- TODO: Implement start monitoring
    -- Load state, start monitor loop
    putStrLn "TODO: Implement start monitoring"
  
  History mAddr -> do
    -- TODO: Implement show history
    putStrLn "TODO: Implement show history"
  
  Export path -> do
    -- TODO: Implement export history
    putStrLn "TODO: Implement export history"
  
  InitConfig path -> do
    Cfg.saveDefaultConfig path
  
  _ -> putStrLn "Command not implemented"

-- | Show help message
showHelp :: IO ()
showHelp = do
  putStrLn "Cardano Balance Monitor - Automated balance monitoring"
  putStrLn ""
  putStrLn "USAGE:"
  putStrLn "  monitor <COMMAND> [OPTIONS]"
  putStrLn ""
  putStrLn "COMMANDS:"
  putStrLn "  add <addr> [label]           Add address to monitor"
  putStrLn "  remove <addr>                Remove address from monitoring"
  putStrLn "  list                         List all monitored addresses"
  putStrLn "  info <addr>                  Show address information"
  putStrLn "  start [--interval SECONDS]   Start monitoring"
  putStrLn "  history [addr]               Show change history"
  putStrLn "  export <file>                Export history to CSV"
  putStrLn "  init-config <file>           Create default config file"
  putStrLn "  help                         Show this help"
  putStrLn "  version                      Show version"
  putStrLn ""
  putStrLn "EXAMPLES:"
  putStrLn "  monitor add addr_test1q... \"My Wallet\""
  putStrLn "  monitor list"
  putStrLn "  monitor start --interval 300"
  putStrLn "  monitor history"
  putStrLn ""
  putStrLn "For more info, see the project README"

