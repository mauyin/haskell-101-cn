module Parser where

import Types
import qualified Data.ByteString.Lazy as BSL
import Data.Aeson

-- TODO: Parse transaction from file
parseTxFile :: FilePath -> IO (Either String Tx)
parseTxFile = undefined

