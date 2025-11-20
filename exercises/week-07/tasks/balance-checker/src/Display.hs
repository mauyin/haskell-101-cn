{-# LANGUAGE OverloadedStrings #-}

module Display where

import Types
import Data.Text (Text)
import qualified Data.Text as T

-- TODO: Format balance display

formatBalance :: Integer -> Text
formatBalance lovelace = undefined
  -- TODO: Convert to ADA and format

displayResult :: QueryResult -> IO ()
displayResult result = undefined
  -- TODO: Pretty print the result

displayTable :: [QueryResult] -> IO ()
displayTable results = undefined
  -- TODO: Display as a table with borders

