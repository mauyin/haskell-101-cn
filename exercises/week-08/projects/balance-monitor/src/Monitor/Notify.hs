module Monitor.Notify
  ( notifyChange
  , displayChange
  , formatChange
  ) where

import Data.Time (formatTime, defaultTimeLocale)
import Monitor.Types
import Monitor.Query (formatBalance)

-- | Notify about a balance change
--
-- TODO: Implement notification
-- Display change notification to console
notifyChange :: Config -> BalanceChange -> IO ()
notifyChange config change = do
  if notifyConsole (cfgNotification config)
    then displayChange change
    else return ()

-- | Display balance change
--
-- TODO: Implement change display
-- Show formatted notification with colors (optional)
displayChange :: BalanceChange -> IO ()
displayChange change = do
  putStrLn "═══ Balance Change Detected ═══"
  putStrLn $ "Address: " ++ show (bcAddress change)
  putStrLn $ "Change:  " ++ formatDelta (bcDelta change)
  putStrLn $ "Old:     " ++ formatBalance (bcOld change)
  putStrLn $ "New:     " ++ formatBalance (bcNew change)
  putStrLn $ "Time:    " ++ formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
  putStrLn "════════════════════════════════"
  putStrLn ""

-- | Format delta with symbol
--
-- TODO: Implement delta formatting
-- Show ↑ for increase, ↓ for decrease
formatDelta :: Integer -> String
formatDelta delta
  | delta > 0 = "↑ " ++ formatBalance (Lovelace delta)
  | delta < 0 = "↓ " ++ formatBalance (Lovelace (abs delta))
  | otherwise = "= " ++ formatBalance (Lovelace 0)

-- | Format change for display
--
-- TODO: Implement change formatting
formatChange :: BalanceChange -> String
formatChange change =
  let time = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" (bcTime change)
      addr = show (bcAddress change)
      delta = formatDelta (bcDelta change)
  in time ++ " | " ++ addr ++ " | " ++ delta

