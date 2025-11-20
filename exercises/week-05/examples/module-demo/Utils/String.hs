module Utils.String
  ( reverseString
  , toUpperString
  , toLowerString
  ) where

import Data.Char (toUpper, toLower)

reverseString :: String -> String
reverseString = reverse

toUpperString :: String -> String
toUpperString = map toUpper

toLowerString :: String -> String
toLowerString = map toLower

