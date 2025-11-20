module Main where

import Test.Hspec
import Wallet.Types
import Wallet.Address
import Wallet.Balance
import Wallet.Transaction

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Address validation" $ do
    it "accepts valid testnet addresses" $ do
      let result = validateAddress "addr_test1qabcdef..."
      result `shouldSatisfy` isRight
    
    it "rejects invalid format" $ do
      let result = validateAddress "invalid"
      result `shouldSatisfy` isLeft
  
  describe "Balance formatting" $ do
    it "converts lovelace to ADA correctly" $ do
      pending  -- TODO: Implement
      -- formatBalance (Lovelace 1000000) `shouldBe` "1.000000 ADA"
  
  describe "Transaction building" $ do
    it "validates balanced transactions" $ do
      pending  -- TODO: Implement
      -- Create a balanced transaction and validate it
  
  -- Add more tests here

isRight :: Either a b -> Bool
isRight (Right _) = True
isRight _ = False

isLeft :: Either a b -> Bool
isLeft (Left _) = True
isLeft _ = False

