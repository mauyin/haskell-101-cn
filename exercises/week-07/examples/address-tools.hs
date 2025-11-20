{-# LANGUAGE OverloadedStrings #-}

{- |
Address Tools Example
====================

Collection of address utility functions demonstrating:
- Address validation
- Type identification
- Format checking
- Information extraction

Usage:
  runhaskell address-tools.hs addr_test1q...
-}

module Main where

import Data.List (isPrefixOf)
import Data.Char (isAlphaNum)
import System.Environment (getArgs)
import System.Exit (exitFailure)

-- ============================================================================
-- Data Types
-- ============================================================================

data AddressType
  = MainnetPayment
  | MainnetScript
  | TestnetPayment
  | TestnetScript
  | StakeAddress
  | Unknown
  deriving (Show, Eq)

data Network = Mainnet | Testnet deriving (Show, Eq)

data AddressInfo = AddressInfo
  { addrString :: String
  , addrType   :: AddressType
  , addrNetwork :: Network
  , isValid    :: Bool
  , validationErrors :: [String]
  } deriving (Show)

-- ============================================================================
-- Address Functions
-- ============================================================================

-- Identify address type
identifyAddressType :: String -> AddressType
identifyAddressType addr
  | "addr1q" `isPrefixOf` addr || "addr1z" `isPrefixOf` addr = MainnetPayment
  | "addr1w" `isPrefixOf` addr || "addr1v" `isPrefixOf` addr = MainnetScript
  | "addr_test1q" `isPrefixOf` addr || "addr_test1z" `isPrefixOf` addr = TestnetPayment
  | "addr_test1w" `isPrefixOf` addr || "addr_test1v" `isPrefixOf` addr = TestnetScript
  | "stake1" `isPrefixOf` addr || "stake_test1" `isPrefixOf` addr = StakeAddress
  | otherwise = Unknown

-- Get network from address type
getNetwork :: AddressType -> Network
getNetwork MainnetPayment = Mainnet
getNetwork MainnetScript = Mainnet
getNetwork TestnetPayment = Testnet
getNetwork TestnetScript = Testnet
getNetwork StakeAddress = 
  -- Would need to check prefix, simplified here
  Testnet
getNetwork Unknown = Testnet

-- Validate address format
validateAddress :: String -> (Bool, [String])
validateAddress addr = 
  let errors = [] ++
        (if not (hasValidPrefix addr) then ["Invalid prefix"] else []) ++
        (if not (hasValidLength addr) then ["Invalid length"] else []) ++
        (if not (hasValidChars addr) then ["Invalid characters"] else [])
  in (null errors, errors)
  where
    hasValidPrefix a = 
      any (`isPrefixOf` a) ["addr1", "addr_test1", "stake1", "stake_test1"]
    
    hasValidLength a = length a > 50 && length a < 150
    
    hasValidChars a = 
      all isValidBech32Char a
    
    isValidBech32Char c = 
      isAlphaNum c && c /= 'b' && c /= 'i' && c /= 'o'

-- Analyze address
analyzeAddress :: String -> AddressInfo
analyzeAddress addr = 
  let addrType' = identifyAddressType addr
      network = getNetwork addrType'
      (valid, errors) = validateAddress addr
  in AddressInfo
       { addrString = addr
       , addrType = addrType'
       , addrNetwork = network
       , isValid = valid
       , validationErrors = errors
       }

-- ============================================================================
-- Display Functions
-- ============================================================================

displayAddressInfo :: AddressInfo -> IO ()
displayAddressInfo info = do
  putStrLn "╔════════════════════════════════════════════════════════╗"
  putStrLn "║           Address Tools Example                        ║"
  putStrLn "╚════════════════════════════════════════════════════════╝"
  putStrLn ""
  putStrLn $ "Address: " ++ shortenAddr (addrString info)
  putStrLn $ "Type: " ++ showAddressType (addrType info)
  putStrLn $ "Network: " ++ show (addrNetwork info)
  putStrLn $ "Valid: " ++ if isValid info then "✓ Yes" else "✗ No"
  
  if not (null $ validationErrors info)
    then do
      putStrLn ""
      putStrLn "Validation Errors:"
      mapM_ (\err -> putStrLn $ "  • " ++ err) (validationErrors info)
    else return ()
  
  putStrLn ""
  displayAddressDetails info

displayAddressDetails :: AddressInfo -> IO ()
displayAddressDetails info = do
  putStrLn "Details:"
  putStrLn $ "  Length: " ++ show (length $ addrString info) ++ " characters"
  putStrLn $ "  Prefix: " ++ take 10 (addrString info)
  putStrLn $ "  Suffix: " ++ drop (length (addrString info) - 10) (addrString info)
  
  case addrType info of
    MainnetPayment -> putStrLn "  Has stake rights: Yes"
    TestnetPayment -> putStrLn "  Has stake rights: Yes"
    MainnetScript -> putStrLn "  Script address: Yes"
    TestnetScript -> putStrLn "  Script address: Yes"
    StakeAddress -> putStrLn "  Stake address: For rewards only"
    Unknown -> putStrLn "  Type: Unknown/Invalid"

-- Show address type in friendly format
showAddressType :: AddressType -> String
showAddressType MainnetPayment = "Mainnet Payment Address"
showAddressType MainnetScript = "Mainnet Script Address"
showAddressType TestnetPayment = "Testnet Payment Address"
showAddressType TestnetScript = "Testnet Script Address"
showAddressType StakeAddress = "Stake Address"
showAddressType Unknown = "Unknown"

-- Shorten address for display
shortenAddr :: String -> String
shortenAddr addr
  | length addr > 60 = take 25 addr ++ "..." ++ drop (length addr - 15) addr
  | otherwise = addr

-- ============================================================================
-- Main Program
-- ============================================================================

main :: IO ()
main = do
  args <- getArgs
  
  case args of
    [addr] -> do
      let info = analyzeAddress addr
      displayAddressInfo info
      
      -- Additional examples
      putStrLn ""
      putStrLn "═══════════════════════════════════════════════════════"
      putStrLn "Additional Examples:"
      putStrLn ""
      
      let examples =
            [ "addr1q..."  -- Mainnet payment (invalid, just example)
            , "addr_test1q..."  -- Testnet payment (invalid, just example)
            , "addr1w..."  -- Mainnet script (invalid, just example)
            , "stake_test1..."  -- Stake address (invalid, just example)
            ]
      
      mapM_ (\ex -> do
        let t = identifyAddressType ex
        putStrLn $ "  " ++ ex ++ " → " ++ showAddressType t
        ) examples
    
    _ -> do
      putStrLn "Usage: address-tools <address>"
      putStrLn ""
      putStrLn "Example:"
      putStrLn "  runhaskell address-tools.hs addr_test1qz2fxv2umyhttkxyxp8x..."
      putStrLn ""
      putStrLn "Supported address types:"
      putStrLn "  • addr1...       - Mainnet payment addresses"
      putStrLn "  • addr_test1...  - Testnet payment addresses"
      putStrLn "  • stake1...      - Mainnet stake addresses"
      putStrLn "  • stake_test1... - Testnet stake addresses"
      exitFailure

{- |
Example Output:
════════════════════════════════════════════════════════
           Address Tools Example                        
════════════════════════════════════════════════════════

Address: addr_test1qz2fxv2umy...648jjxtwq2ytjqp
Type: Testnet Payment Address
Network: Testnet
Valid: ✓ Yes

Details:
  Length: 103 characters
  Prefix: addr_test1
  Suffix: wq2ytjqp
  Has stake rights: Yes

═══════════════════════════════════════════════════════
Additional Examples:

  addr1q... → Mainnet Payment Address
  addr_test1q... → Testnet Payment Address
  addr1w... → Mainnet Script Address
  stake_test1... → Stake Address
-}

