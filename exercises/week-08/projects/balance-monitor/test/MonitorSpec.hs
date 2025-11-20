module Main where

import Test.Hspec
import Monitor.Types
import Monitor.Query
import Monitor.Tracker

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Balance formatting" $ do
    it "formats lovelace correctly" $ do
      pending  -- TODO: Implement
      -- formatBalance (Lovelace 1000000) `shouldBe` "1.000000 ADA"
  
  describe "Change detection" $ do
    it "detects balance increase" $ do
      pending  -- TODO: Implement
    
    it "detects balance decrease" $ do
      pending  -- TODO: Implement
    
    it "handles no change" $ do
      pending  -- TODO: Implement
  
  -- Add more tests here

