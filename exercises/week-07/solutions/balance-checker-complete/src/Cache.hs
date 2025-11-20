{-# LANGUAGE OverloadedStrings #-}

module Cache
  ( CacheEntry(..)
  , loadCache
  , saveCache
  , lookupCache
  , updateCache
  ) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import Data.Text (Text)
import qualified Data.Map as Map
import Data.Map (Map)
import Data.Time.Clock (UTCTime, getCurrentTime, addUTCTime)
import GHC.Generics
import Control.Exception (try, SomeException)

data CacheEntry = CacheEntry
  { ceBalance :: BalanceInfo
  , ceTimestamp :: UTCTime
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

type CacheMap = Map Text CacheEntry

-- Cache file path
cacheFile :: FilePath
cacheFile = ".balance-cache.json"

-- Load cache from file
loadCache :: IO CacheMap
loadCache = do
  result <- try $ BSL.readFile cacheFile
  case result of
    Left (_ :: SomeException) -> return Map.empty
    Right content ->
      case eitherDecode content of
        Left _ -> return Map.empty
        Right cache -> return cache

-- Save cache to file
saveCache :: CacheMap -> IO ()
saveCache cache = BSL.writeFile cacheFile (encode cache)

-- Lookup address in cache
lookupCache :: Text -> CacheMap -> Maybe CacheEntry
lookupCache = Map.lookup

-- Update cache with new entry
updateCache :: Text -> BalanceInfo -> CacheMap -> IO CacheMap
updateCache addr info cache = do
  now <- getCurrentTime
  let entry = CacheEntry info now
  return $ Map.insert addr entry cache

-- Check if cache entry is stale (older than 5 minutes)
isStale :: CacheEntry -> UTCTime -> Bool
isStale entry now = 
  let expiryTime = addUTCTime (5 * 60) (ceTimestamp entry)
  in now > expiryTime

