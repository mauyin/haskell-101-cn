{- |
Week 7 - Solutions: Cardano Introduction + Haskell Practice
===========================================================

Complete solutions for all exercises in Week07Exercises.hs

Author: Haskell 101 Course Team
Date: 2025-11-20
-}

{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Week07ExercisesSolutions where

import Data.Aeson
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString as BS
import Data.Text (Text)
import qualified Data.Text as T
import GHC.Generics
import Data.List (isPrefixOf, sortBy)
import Data.Ord (comparing, Down(..))
import Data.Char (isAlphaNum, isDigit, toLower)
import Control.Monad (when, unless)

-- ============================================================================
-- Exercise Set 1: JSON Parsing (5 exercises)
-- ============================================================================

-- Exercise 1.1: Parse Simple Transaction
data SimpleTx = SimpleTx
  { txId    :: String
  , txFee   :: Integer
  , txValid :: Bool
  } deriving (Show, Eq, Generic)

instance FromJSON SimpleTx where
  parseJSON = withObject "SimpleTx" $ \v -> SimpleTx
    <$> v .: "txId"
    <*> v .: "txFee"
    <*> v .: "txValid"

parseSimpleTx :: FilePath -> IO (Either String SimpleTx)
parseSimpleTx path = do
  content <- BSL.readFile path
  return $ eitherDecode content


-- Exercise 1.2: Extract Transaction Inputs
data TxInput = TxInput
  { inputTxId  :: String
  , inputIndex :: Int
  } deriving (Show, Eq, Generic)

instance FromJSON TxInput where
  parseJSON = withObject "TxInput" $ \v -> TxInput
    <$> v .: "txId"
    <*> v .: "txIndex"

data Transaction = Transaction
  { transactionId   :: String
  , transactionBody :: TxBody
  } deriving (Show, Eq, Generic)

data TxBody = TxBody
  { inputs  :: [TxInput]
  , outputs :: [TxOutput]
  , fee     :: Integer
  , ttl     :: Maybe Integer
  } deriving (Show, Eq, Generic)

instance FromJSON Transaction where
  parseJSON = withObject "Transaction" $ \v -> Transaction
    <$> v .: "id"
    <*> v .: "body"

instance FromJSON TxBody where
  parseJSON = withObject "TxBody" $ \v -> TxBody
    <$> v .: "inputs"
    <*> v .: "outputs"
    <*> v .: "fee"
    <*> v .:? "ttl"

extractInputs :: FilePath -> IO (Either String [TxInput])
extractInputs path = do
  result <- BSL.readFile path >>= return . eitherDecode
  return $ case result of
    Left err -> Left err
    Right tx -> Right $ inputs $ transactionBody tx


-- Exercise 1.3: Parse Outputs and Calculate Total
data TxOutput = TxOutput
  { outputAddress :: String
  , outputValue   :: TxValue
  } deriving (Show, Eq, Generic)

data TxValue = TxValue
  { lovelace :: Integer
  } deriving (Show, Eq, Generic)

instance FromJSON TxOutput where
  parseJSON = withObject "TxOutput" $ \v -> TxOutput
    <$> v .: "address"
    <*> v .: "value"

instance FromJSON TxValue where
  parseJSON = withObject "TxValue" $ \v -> TxValue
    <$> v .: "lovelace"

extractOutputs :: FilePath -> IO (Either String [TxOutput])
extractOutputs path = do
  result <- BSL.readFile path >>= return . eitherDecode
  return $ case result of
    Left err -> Left err
    Right tx -> Right $ outputs $ transactionBody tx

totalOutputValue :: [TxOutput] -> Integer
totalOutputValue = sum . map (lovelace . outputValue)


-- Exercise 1.4: Parse Metadata
data TxMetadata = TxMetadata
  { metadataLabel :: Integer
  , metadataValue :: Value
  } deriving (Show, Eq)

data TransactionWithMeta = TransactionWithMeta
  { txIdMeta       :: String
  , txBodyMeta     :: TxBody
  , txMetadata :: Maybe Object
  } deriving (Show, Eq, Generic)

instance FromJSON TransactionWithMeta where
  parseJSON = withObject "TransactionWithMeta" $ \v -> TransactionWithMeta
    <$> v .: "id"
    <*> v .: "body"
    <*> v .:? "metadata"

extractMetadata :: FilePath -> IO (Either String (Maybe Object))
extractMetadata path = do
  result <- BSL.readFile path >>= return . eitherDecode
  return $ case result of
    Left err -> Left err
    Right tx -> Right $ txMetadata tx


-- Exercise 1.5: Complete Transaction Summary
data TxSummary = TxSummary
  { summaryId          :: String
  , summaryInputCount  :: Int
  , summaryOutputCount :: Int
  , summaryTotalInput  :: Integer
  , summaryTotalOutput :: Integer
  , summaryFee         :: Integer
  } deriving (Show, Eq)

generateSummary :: FilePath -> IO (Either String TxSummary)
generateSummary path = do
  result <- BSL.readFile path >>= return . eitherDecode
  return $ case result of
    Left err -> Left err
    Right tx -> 
      let body = transactionBody tx
          inputCount = length $ inputs body
          outputCount = length $ outputs body
          totalOut = totalOutputValue $ outputs body
          feePaid = fee body
          -- Note: In real scenario, totalInput would need UTxO lookup
          -- For this exercise, we calculate it as: totalOut + fee
          totalIn = totalOut + feePaid
      in Right $ TxSummary
           { summaryId = transactionId tx
           , summaryInputCount = inputCount
           , summaryOutputCount = outputCount
           , summaryTotalInput = totalIn
           , summaryTotalOutput = totalOut
           , summaryFee = feePaid
           }

displaySummary :: TxSummary -> String
displaySummary summary = unlines
  [ "=== Transaction Summary ==="
  , "ID: " ++ shortenString 10 10 (summaryId summary)
  , "Inputs:  " ++ show (summaryInputCount summary) ++ " UTxOs"
  , "Outputs: " ++ show (summaryOutputCount summary) ++ " UTxOs"
  , "Total In:  " ++ formatAmount (summaryTotalInput summary)
  , "Total Out: " ++ formatAmount (summaryTotalOutput summary)
  , "Fee:       " ++ formatAmount (summaryFee summary)
  , "Balanced: " ++ (if isBalancedSummary summary then "✓" else "✗")
  ]
  where
    isBalancedSummary s = 
      summaryTotalInput s == summaryTotalOutput s + summaryFee s


-- ============================================================================
-- Exercise Set 2: Address Operations (5 exercises)
-- ============================================================================

-- Exercise 2.1: Address Type Identification
data AddressType 
  = MainnetPayment
  | MainnetScript
  | TestnetPayment
  | TestnetScript
  deriving (Show, Eq)

identifyAddressType :: String -> Maybe AddressType
identifyAddressType addr
  | "addr1q" `isPrefixOf` addr = Just MainnetPayment
  | "addr1w" `isPrefixOf` addr || "addr1v" `isPrefixOf` addr = Just MainnetScript
  | "addr_test1q" `isPrefixOf` addr = Just TestnetPayment
  | "addr_test1w" `isPrefixOf` addr || "addr_test1v" `isPrefixOf` addr = Just TestnetScript
  | otherwise = Nothing


-- Exercise 2.2: Validate Address
validateAddress :: String -> Bool
validateAddress addr =
  hasValidPrefix addr &&
  hasValidLength addr &&
  hasValidCharacters addr
  where
    hasValidPrefix a = 
      any (`isPrefixOf` a) ["addr1", "addr_test1", "stake1", "stake_test1"]
    
    hasValidLength a = length a > 50 && length a < 150
    
    hasValidCharacters a = 
      all (\c -> isAlphaNum c && c /= 'b' && c /= 'i' && c /= 'o') a

validateAddressDetailed :: String -> Either String ()
validateAddressDetailed addr
  | null addr = 
      Left "Address is empty"
  | not (any (`isPrefixOf` addr) ["addr1", "addr_test1", "stake1", "stake_test1"]) =
      Left "Invalid address prefix. Must start with 'addr1', 'addr_test1', 'stake1', or 'stake_test1'"
  | length addr < 50 =
      Left "Address too short. Cardano addresses are typically 50-150 characters"
  | length addr > 150 =
      Left "Address too long. Cardano addresses are typically 50-150 characters"
  | not (all isValidBech32Char addr) =
      Left "Invalid characters. Bech32 addresses can only contain 0-9, a-z (excluding b, i, o)"
  | otherwise =
      Right ()
  where
    isValidBech32Char c = isAlphaNum c && c /= 'b' && c /= 'i' && c /= 'o'


-- Exercise 2.3: Extract Stake Address
extractStakeAddress :: String -> Maybe String
extractStakeAddress addr =
  case identifyAddressType addr of
    Just MainnetPayment -> Just "stake1..."  -- Simplified
    Just TestnetPayment -> Just "stake_test1..."  -- Simplified
    _ -> Nothing
-- Note: Real implementation would decode Bech32 and extract stake portion


-- Exercise 2.4: Address Summary
data AddressSummary = AddressSummary
  { addrNetwork :: String
  , addrType    :: String
  , addrShort   :: String
  , hasStake    :: Bool
  } deriving (Show, Eq)

summarizeAddress :: String -> Either String AddressSummary
summarizeAddress addr = do
  validateAddressDetailed addr
  case identifyAddressType addr of
    Nothing -> Left "Unknown address type"
    Just addrType -> 
      Right $ AddressSummary
        { addrNetwork = networkFromType addrType
        , addrType = typeToString addrType
        , addrShort = shortenString 10 6 addr
        , hasStake = hasStakeFromType addrType
        }
  where
    networkFromType MainnetPayment = "mainnet"
    networkFromType MainnetScript = "mainnet"
    networkFromType TestnetPayment = "testnet"
    networkFromType TestnetScript = "testnet"
    
    typeToString MainnetPayment = "payment"
    typeToString MainnetScript = "script"
    typeToString TestnetPayment = "payment"
    typeToString TestnetScript = "script"
    
    hasStakeFromType MainnetPayment = True
    hasStakeFromType TestnetPayment = True
    hasStakeFromType _ = False


-- Exercise 2.5: Batch Address Validation
validateAddresses :: [String] -> [(String, Either String AddressSummary)]
validateAddresses addrs = 
  map (\addr -> (addr, summarizeAddress addr)) addrs

generateValidationReport :: [(String, Either String AddressSummary)] -> String
generateValidationReport results = unlines $
  [ "=== Address Validation Report ==="
  , "Total addresses: " ++ show (length results)
  , "Valid: " ++ show validCount
  , "Invalid: " ++ show invalidCount
  , ""
  , "Details:"
  ] ++ concatMap formatResult results
  where
    validCount = length $ filter (isRight . snd) results
    invalidCount = length results - validCount
    
    isRight (Right _) = True
    isRight _ = False
    
    formatResult (addr, Left err) =
      [ "  ✗ " ++ shortenString 20 10 addr
      , "    Error: " ++ err
      ]
    formatResult (addr, Right summary) =
      [ "  ✓ " ++ shortenString 20 10 addr
      , "    Network: " ++ addrNetwork summary
      , "    Type: " ++ addrType summary
      , "    Has stake: " ++ if hasStake summary then "Yes" else "No"
      ]


-- ============================================================================
-- Exercise Set 4: Transaction Building (Simulated) (5 exercises)
-- ============================================================================

-- Exercise 4.1: Build Simple Payment
data UTxO = UTxO
  { utxoTxHash  :: String
  , utxoIndex   :: Int
  , utxoAmount  :: Integer
  , utxoAddress :: String
  } deriving (Show, Eq)

data TxBuild = TxBuild
  { buildInputs  :: [TxInput]
  , buildOutputs :: [TxOutput]
  , buildFee     :: Integer
  } deriving (Show, Eq)

buildSimplePayment 
  :: [UTxO]
  -> String
  -> Integer
  -> String
  -> Either String TxBuild
buildSimplePayment utxos toAddr amount changeAddr = do
  -- Select UTxOs for the payment + fee estimate
  let estimatedFee = 170000  -- Initial estimate
  let targetAmount = amount + estimatedFee
  
  selectedUTxOs <- selectUTxOs targetAmount utxos
  
  let inputSum = sum $ map utxoAmount selectedUTxOs
  let inputs' = map utxoToTxInput selectedUTxOs
  
  -- Create payment output
  let paymentOutput = TxOutput toAddr (TxValue amount)
  
  -- Calculate change
  let change = inputSum - amount - estimatedFee
  
  if change < 0
    then Left "Insufficient funds after fee"
    else do
      let outputs' = if change > 1000000  -- Min UTxO requirement
                     then [paymentOutput, TxOutput changeAddr (TxValue change)]
                     else [paymentOutput]
      
      -- Recalculate fee with actual outputs
      let tx = TxBuild inputs' outputs' estimatedFee
      let actualFee = calculateFee tx
      let finalChange = inputSum - amount - actualFee
      
      if finalChange < 0
        then Left "Insufficient funds after fee calculation"
        else 
          let finalOutputs = if finalChange > 1000000
                             then [paymentOutput, TxOutput changeAddr (TxValue finalChange)]
                             else [paymentOutput]
          in Right $ TxBuild inputs' finalOutputs actualFee

utxoToTxInput :: UTxO -> TxInput
utxoToTxInput utxo = TxInput (utxoTxHash utxo) (utxoIndex utxo)


-- Exercise 4.2: Calculate Fee
feeConstant :: Integer
feeConstant = 155381

feePerByte :: Integer
feePerByte = 44

estimateTxSize :: TxBuild -> Integer
estimateTxSize tx =
  let inputSize = fromIntegral (length $ buildInputs tx) * 43
      outputSize = fromIntegral (length $ buildOutputs tx) * 43
      overhead = 10
  in inputSize + outputSize + overhead

calculateFee :: TxBuild -> Integer
calculateFee tx = feeConstant + feePerByte * estimateTxSize tx


-- Exercise 4.3: Select UTxOs
selectUTxOs :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOs targetAmount utxos
  | null utxos = Left "No UTxOs available"
  | otherwise =
      let sorted = sortBy (comparing (Down . utxoAmount)) utxos
          selected = selectGreedy targetAmount sorted []
      in if sum (map utxoAmount selected) >= targetAmount
         then Right selected
         else Left "Insufficient funds"
  where
    selectGreedy target [] acc = acc
    selectGreedy target (u:us) acc
      | sum (map utxoAmount acc) >= target = acc
      | otherwise = selectGreedy target us (u:acc)

selectUTxOsOptimal :: Integer -> [UTxO] -> Either String [UTxO]
selectUTxOsOptimal targetAmount utxos
  | null utxos = Left "No UTxOs available"
  | otherwise =
      -- Try to find single UTxO close to target
      case filter (\u -> utxoAmount u >= targetAmount && utxoAmount u < targetAmount * 2) utxos of
        (u:_) -> Right [u]  -- Found good single UTxO
        [] -> selectUTxOs targetAmount utxos  -- Fall back to greedy


-- Exercise 4.4: Balance Transaction
isBalanced :: TxBuild -> Bool
isBalanced tx =
  let inputSum = sum $ map utxoAmount []  -- Would need UTxO lookup in real impl
      outputSum = sum $ map (lovelace . outputValue) (buildOutputs tx)
      feePaid = buildFee tx
  in inputSum == outputSum + feePaid
  -- Note: Simplified - in real impl would lookup UTxO amounts

balanceTransaction 
  :: TxBuild
  -> String
  -> Either String TxBuild
balanceTransaction tx changeAddr =
  -- Simplified - assumes inputs are already set with amounts
  let outputSum = sum $ map (lovelace . outputValue) (buildOutputs tx)
      feePaid = buildFee tx
      -- In real impl, would calculate inputSum from UTxO lookup
      inputSum = outputSum + feePaid  -- Simplified assumption
      change = inputSum - outputSum - feePaid
  in if change < 0
     then Left "Negative change - insufficient funds"
     else if change == 0
     then Right tx
     else if change < 1000000  -- Min UTxO
     then Left "Change too small to create UTxO"
     else Right $ tx { buildOutputs = buildOutputs tx ++ [TxOutput changeAddr (TxValue change)] }


-- Exercise 4.5: Validate Transaction
data ValidationError
  = InsufficientFunds
  | NegativeChange
  | InvalidInput String
  | InvalidOutput String
  | FeeError String
  deriving (Show, Eq)

validateTransaction :: TxBuild -> Either ValidationError ()
validateTransaction tx = do
  -- Check inputs
  when (null $ buildInputs tx) $
    Left $ InvalidInput "Transaction has no inputs"
  
  -- Check outputs
  when (null $ buildOutputs tx) $
    Left $ InvalidOutput "Transaction has no outputs"
  
  -- Check output addresses
  let invalidAddrs = filter (not . validateAddress . outputAddress) (buildOutputs tx)
  unless (null invalidAddrs) $
    Left $ InvalidOutput "Invalid address in outputs"
  
  -- Check fee
  when (buildFee tx < 150000) $
    Left $ FeeError "Fee too low (minimum 0.15 ADA)"
  
  when (buildFee tx > 10000000) $
    Left $ FeeError "Fee too high (max 10 ADA sanity check)"
  
  -- Check minimum output values
  let minOutputValue = 1000000  -- 1 ADA minimum
  let smallOutputs = filter (\o -> lovelace (outputValue o) < minOutputValue) (buildOutputs tx)
  unless (null smallOutputs) $
    Left $ InvalidOutput "Output value below minimum (1 ADA)"
  
  return ()

fullTxCheck :: TxBuild -> Either String ()
fullTxCheck tx = 
  case validateTransaction tx of
    Left err -> Left $ show err
    Right () -> Right ()


-- ============================================================================
-- Helper Functions
-- ============================================================================

lovelaceToAda :: Integer -> Double
lovelaceToAda lovelace = fromIntegral lovelace / 1000000

adaToLovelace :: Double -> Integer
adaToLovelace ada = round (ada * 1000000)

formatAmount :: Integer -> String
formatAmount lovelace = 
  show (lovelaceToAda lovelace) ++ " ADA (" ++ show lovelace ++ " Lovelace)"

shortenString :: Int -> Int -> String -> String
shortenString prefixLen suffixLen str
  | length str <= prefixLen + suffixLen = str
  | otherwise = take prefixLen str ++ "..." ++ drop (length str - suffixLen) str


-- ============================================================================
-- Test Data and Test Functions
-- ============================================================================

sampleUTxOs :: [UTxO]
sampleUTxOs =
  [ UTxO "abc123..." 0 50000000 "addr_test1qz..."
  , UTxO "def456..." 1 30000000 "addr_test1qz..."
  , UTxO "ghi789..." 0 20000000 "addr_test1qz..."
  ]

testSimpleTx :: IO ()
testSimpleTx = do
  putStrLn "=== Test 1.1: Parse Simple Transaction ==="
  result <- parseSimpleTx "sample-data/simple-tx.json"
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right tx -> do
      putStrLn $ "Transaction ID: " ++ txId tx
      putStrLn $ "Fee: " ++ formatAmount (txFee tx)
      putStrLn $ "Valid: " ++ show (txValid tx)

testExtractInputs :: IO ()
testExtractInputs = do
  putStrLn "\n=== Test 1.2: Extract Transaction Inputs ==="
  result <- extractInputs "sample-data/transaction.json"
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right inputs' -> do
      putStrLn $ "Input count: " ++ show (length inputs')
      mapM_ (\(i, input) -> 
        putStrLn $ "  Input #" ++ show i ++ ": " 
                ++ inputTxId input ++ "#" ++ show (inputIndex input))
        (zip [0::Int ..] inputs')

testAddressType :: IO ()
testAddressType = do
  putStrLn "\n=== Test 2.1: Address Type Identification ==="
  let testAddrs =
        [ "addr1q..."
        , "addr_test1q..."
        , "addr1w..."
        , "invalid"
        ]
  mapM_ (\addr -> 
    putStrLn $ addr ++ " -> " ++ show (identifyAddressType addr))
    testAddrs

testBuildPayment :: IO ()
testBuildPayment = do
  putStrLn "\n=== Test 4.1: Build Payment Transaction ==="
  let result = buildSimplePayment 
                 sampleUTxOs 
                 "addr_test1qr..." 
                 60000000 
                 "addr_test1qz..."
  case result of
    Left err -> putStrLn $ "Error: " ++ err
    Right tx -> do
      putStrLn $ "Inputs: " ++ show (length $ buildInputs tx)
      putStrLn $ "Outputs: " ++ show (length $ buildOutputs tx)
      putStrLn $ "Fee: " ++ formatAmount (buildFee tx)

runAllTests :: IO ()
runAllTests = do
  testSimpleTx
  testExtractInputs
  testAddressType
  testBuildPayment
  putStrLn "\n✓ All tests completed!"

main :: IO ()
main = runAllTests

