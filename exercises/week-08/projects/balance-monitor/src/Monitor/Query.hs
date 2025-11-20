module Monitor.Query
  ( queryBalance
  , queryAllBalances
  , formatBalance
  ) where

import Control.Concurrent (threadDelay)
import Control.Monad (forM)
import Control.Monad.Except (ExceptT, runExceptT, throwError, liftIO)
import Monitor.Types

-- | Query balance for a single address
--
-- TODO: Implement balance query
-- Use Blockfrost API to get current balance
queryBalance :: Config -> Address -> IO (Either MonitorError Lovelace)
queryBalance config addr = runExceptT $ do
  -- TODO: Implement this
  -- 1. Call Blockfrost API: /addresses/{address}
  -- 2. Parse response to extract lovelace amount
  -- 3. Handle errors
  undefined

-- | Query balances for all addresses
--
-- TODO: Implement batch balance query
-- Query all addresses with delay between requests to avoid rate limiting
queryAllBalances :: Config -> [Address] -> IO [(Address, Either MonitorError Lovelace)]
queryAllBalances config addrs = do
  -- TODO: Implement this
  -- Use forM to query each address
  -- Add threadDelay between queries (100ms recommended)
  undefined

-- | Format balance for display
--
-- TODO: Implement balance formatting
formatBalance :: Lovelace -> String
formatBalance (Lovelace l) =
  let ada = fromIntegral l / 1000000.0 :: Double
  in undefined  -- Format as "X.XXXXXX ADA"

-- Helper: Display progress
displayProgress :: Int -> Int -> IO ()
displayProgress current total =
  putStr $ "\rProgress: " ++ show current ++ "/" ++ show total

