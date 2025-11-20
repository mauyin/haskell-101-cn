module Parser
  ( parseTxFile
  , parseTxFromString
  ) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy as BSL

-- Parse transaction from file
parseTxFile :: FilePath -> IO (Either String Tx)
parseTxFile path = do
  content <- BSL.readFile path
  return $ eitherDecode content

-- Parse transaction from string
parseTxFromString :: String -> Either String Tx
parseTxFromString = eitherDecode . BSL.pack . map (toEnum . fromEnum)

