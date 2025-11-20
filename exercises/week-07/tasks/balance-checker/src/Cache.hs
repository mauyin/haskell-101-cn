module Cache where

import Types
import qualified Data.Map as Map
import Data.Map (Map)
import Data.Text (Text)

-- Simple in-memory cache
type Cache = Map Text BalanceInfo

-- TODO: Implement cache operations

emptyCache :: Cache
emptyCache = Map.empty

lookupCache :: Text -> Cache -> Maybe BalanceInfo
lookupCache = undefined

insertCache :: Text -> BalanceInfo -> Cache -> Cache
insertCache = undefined

