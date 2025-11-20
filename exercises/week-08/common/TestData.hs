-- | Test data for development and testing
--
-- Use this data to test your application without calling the real API

module TestData where

-- | Sample test addresses (not real)
sampleAddresses :: [String]
sampleAddresses =
  [ "addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgs68faae"
  , "addr_test1qpw0djgj0x59ngrjvqthn7enhvruxnsavsw5th63la3mjel3tkc974sr23jmlzgq5zda4gtv8k9cy38756r9y3qgmkqqjz6aa7"
  , "addr_test1qqy6nhfyks7wdu3dudslys37v252w2nwhv0fw2nfawemmnqs5r5vjt0qlk0q5x8v7rqz0y9h5fxg4nnjw6nru7wy9j9q6xp8dq"
  ]

-- | Sample balance in lovelace
sampleBalances :: [(String, Integer)]
sampleBalances = zip sampleAddresses [100000000, 50000000, 75000000]

-- | Sample UTxO data
sampleUTxOs :: [(String, String, Int, Integer)]  -- (address, txhash, index, amount)
sampleUTxOs =
  [ ("addr_test1qz2...", "abc123def456...", 0, 50000000)
  , ("addr_test1qz2...", "def789ghi012...", 1, 50000000)
  , ("addr_test1qpw...", "ghi345jkl678...", 0, 50000000)
  ]

-- | Sample transaction JSON (simplified)
sampleTxJSON :: String
sampleTxJSON = unlines
  [ "{"
  , "  \"hash\": \"abc123def456...\","
  , "  \"block\": \"block_abc...\","
  , "  \"block_height\": 1234567,"
  , "  \"slot\": 987654,"
  , "  \"index\": 0,"
  , "  \"output_amount\": ["
  , "    {"
  , "      \"unit\": \"lovelace\","
  , "      \"quantity\": \"10000000\""
  , "    }"
  , "  ],"
  , "  \"fees\": \"170000\","
  , "  \"deposit\": \"0\""
  , "}"
  ]

-- | Sample address info JSON
sampleAddressJSON :: String
sampleAddressJSON = unlines
  [ "{"
  , "  \"address\": \"addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgs68faae\","
  , "  \"amount\": ["
  , "    {"
  , "      \"unit\": \"lovelace\","
  , "      \"quantity\": \"100000000\""
  , "    }"
  , "  ],"
  , "  \"stake_address\": \"stake_test1...\","
  , "  \"type\": \"shelley\""
  , "}"
  ]

-- | Sample UTxO list JSON
sampleUTxOsJSON :: String
sampleUTxOsJSON = unlines
  [ "["
  , "  {"
  , "    \"tx_hash\": \"abc123def456...\","
  , "    \"output_index\": 0,"
  , "    \"amount\": ["
  , "      {"
  , "        \"unit\": \"lovelace\","
  , "        \"quantity\": \"50000000\""
  , "      }"
  , "    ]"
  , "  },"
  , "  {"
  , "    \"tx_hash\": \"def789ghi012...\","
  , "    \"output_index\": 1,"
  , "    \"amount\": ["
  , "      {"
  , "        \"unit\": \"lovelace\","
  , "        \"quantity\": \"50000000\""
  , "      }"
  , "    ]"
  , "  }"
  , "]"
  ]

-- | Mock API response generator
mockAPIResponse :: String -> Either String String
mockAPIResponse "/addresses/addr_test1qz2..." = Right sampleAddressJSON
mockAPIResponse "/addresses/addr_test1qz2.../utxos" = Right sampleUTxOsJSON
mockAPIResponse _ = Left "Not found"

-- | Helper: pretty print test data
printTestData :: IO ()
printTestData = do
  putStrLn "=== Sample Addresses ==="
  mapM_ putStrLn sampleAddresses
  putStrLn ""
  
  putStrLn "=== Sample Balances ==="
  mapM_ (\(addr, bal) -> putStrLn $ take 20 addr ++ "... -> " ++ show bal ++ " lovelace") sampleBalances
  putStrLn ""
  
  putStrLn "=== Sample Address JSON ==="
  putStrLn sampleAddressJSON

