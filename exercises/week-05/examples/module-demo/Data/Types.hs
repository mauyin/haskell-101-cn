module Data.Types
  ( User(..)
  , createUser
  ) where

data User = User
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Show, Eq)

createUser :: String -> Int -> String -> Maybe User
createUser n a e
  | null n = Nothing
  | a < 0 = Nothing
  | '@' `notElem` e = Nothing
  | otherwise = Just (User n a e)

