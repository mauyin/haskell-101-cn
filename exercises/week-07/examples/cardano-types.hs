{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

{- |
Cardano Types - 常用类型定义
=============================

这些类型定义可以作为你的 Cardano 项目的基础。
-}

module CardanoTypes where

import Data.Aeson
import qualified Data.Text as T
import Data.Text (Text)
import GHC.Generics

-- | 交易 ID (哈希)
newtype TxId = TxId Text deriving (Show, Eq, Ord, Generic, FromJSON, ToJSON)

-- | Lovelace (ADA 的最小单位)
newtype Lovelace = Lovelace Integer deriving (Show, Eq, Ord, Num, Generic, FromJSON, ToJSON)

-- | 地址
newtype Address = Address Text deriving (Show, Eq, Ord, Generic, FromJSON, ToJSON)

-- | 交易输入
data TxInput = TxInput
  { txInId    :: TxId
  , txInIndex :: Int
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | 交易输出
data TxOutput = TxOutput
  { txOutAddress :: Address
  , txOutValue   :: Lovelace
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | 交易主体
data TxBody = TxBody
  { txBodyInputs  :: [TxInput]
  , txBodyOutputs :: [TxOutput]
  , txBodyFee     :: Lovelace
  , txBodyTTL     :: Maybe Integer
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | 完整交易
data Transaction = Transaction
  { txId   :: TxId
  , txBody :: TxBody
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | UTxO
data UTxO = UTxO
  { utxoRef    :: TxInput
  , utxoOutput :: TxOutput
  } deriving (Show, Eq, Generic, FromJSON, ToJSON)

-- | 地址类型
data AddressType
  = MainnetPayment
  | MainnetScript
  | TestnetPayment
  | TestnetScript
  deriving (Show, Eq)

-- 辅助函数

lovelaceToAda :: Lovelace -> Double
lovelaceToAda (Lovelace l) = fromIntegral l / 1_000_000

adaToLovelace :: Double -> Lovelace
adaToLovelace ada = Lovelace $ round (ada * 1_000_000)

-- 示例数据
exampleTx :: Transaction
exampleTx = Transaction
  { txId = TxId "abc123..."
  , txBody = TxBody
      { txBodyInputs = [TxInput (TxId "def456...") 0]
      , txBodyOutputs = 
          [ TxOutput (Address "addr1...") (Lovelace 10_000_000)
          , TxOutput (Address "addr1...") (Lovelace 5_000_000)
          ]
      , txBodyFee = Lovelace 170_000
      , txBodyTTL = Just 8_000_000
      }
  }

main :: IO ()
main = do
  putStrLn "Cardano Types Examples"
  putStrLn $ "Example TX: " ++ show exampleTx
  putStrLn $ "Fee in ADA: " ++ show (lovelaceToAda $ txBodyFee $ txBody exampleTx)

