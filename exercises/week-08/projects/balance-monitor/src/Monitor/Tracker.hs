module Monitor.Tracker
  ( detectChanges
  , updateBalances
  , monitorLoop
  ) where

import Control.Concurrent (threadDelay)
import Control.Monad (forever, when)
import Data.Maybe (catMaybes)
import Data.Time (getCurrentTime)
import Monitor.Types
import qualified Monitor.Query as Query
import qualified Monitor.Notify as Notify
import qualified Monitor.Storage as Storage

-- | Detect balance changes
--
-- TODO: Implement change detection
-- Compare old and new balances, return changes
detectChanges 
  :: [MonitoredAddress]  -- Monitored addresses
  -> [(Address, Lovelace)]  -- New balances
  -> IO ([BalanceChange], [MonitoredAddress])
detectChanges addrs newBalances = do
  now <- getCurrentTime
  -- TODO: Implement this
  -- For each address:
  -- 1. Find corresponding new balance
  -- 2. Compare with last balance
  -- 3. If different, create BalanceChange
  -- 4. Update MonitoredAddress
  undefined

-- | Update balances for all monitored addresses
--
-- TODO: Implement balance update
-- Query all addresses and detect changes
updateBalances :: Config -> [MonitoredAddress] -> IO ([BalanceChange], [MonitoredAddress])
updateBalances config addrs = do
  let addresses = map maAddress addrs
  putStrLn $ "Checking " ++ show (length addresses) ++ " addresses..."
  
  -- Query all balances
  results <- Query.queryAllBalances config addresses
  
  -- Extract successful queries
  let successes = [(addr, bal) | (addr, Right bal) <- results]
  let failures = [(addr, err) | (addr, Left err) <- results]
  
  -- Report failures
  mapM_ reportFailure failures
  
  -- Detect changes
  detectChanges addrs successes
  where
    reportFailure (addr, err) =
      putStrLn $ "Error querying " ++ show addr ++ ": " ++ show err

-- | Main monitor loop
--
-- TODO: Implement monitoring loop
-- Periodically check balances and notify on changes
monitorLoop :: Config -> MonitorState -> IO ()
monitorLoop config initialState = do
  putStrLn "Starting monitor..."
  putStrLn $ "Interval: " ++ show (monInterval $ cfgMonitor config) ++ " seconds"
  putStrLn "Press Ctrl+C to stop"
  putStrLn ""
  
  loop initialState
  where
    loop state = do
      -- Check balances
      (changes, updatedAddrs) <- updateBalances config (msAddresses state)
      
      -- Notify changes
      mapM_ (Notify.notifyChange config) changes
      
      -- Update state
      now <- getCurrentTime
      let newState = state
            { msAddresses = updatedAddrs
            , msHistory = changes ++ msHistory state
            , msLastSaved = now
            }
      
      -- Save state
      Storage.saveState (stgDataDir $ cfgStorage config) newState
      
      -- Report status
      if null changes
        then putStrLn "No changes detected."
        else putStrLn $ show (length changes) ++ " change(s) detected."
      
      putStrLn ""
      
      -- Wait for next check
      let interval = monInterval $ cfgMonitor config
      threadDelay (interval * 1000000)
      
      -- Continue loop
      loop newState

