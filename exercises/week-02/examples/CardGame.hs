{- |
Week 2 - 示例: 扑克牌系统
================================

这是一个完整的扑克牌系统实现，展示了 Week 2 所学的所有概念：
- ADT（代数数据类型）
- 记录语法
- Maybe 类型
- 模式匹配

你可以在 GHCi 中加载此文件并尝试：
  ghci> :load CardGame.hs
  ghci> fullDeck
  ghci> drawCard fullDeck
-}

module CardGame where

-- ============================================================================
-- 1. 定义基本类型
-- ============================================================================

-- | 花色：红心、方块、梅花、黑桃
data Suit = Hearts | Diamonds | Clubs | Spades
  deriving (Eq, Show)

-- | 牌面：2-10, J, Q, K, A
data Rank = Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten
          | Jack | Queen | King | Ace
  deriving (Eq, Ord, Show)

-- | 扑克牌（使用记录语法）
data Card = Card
  { rank :: Rank  -- 牌面
  , suit :: Suit  -- 花色
  }
  deriving (Eq, Show)

-- | 牌组（就是卡牌列表）
type Deck = [Card]

-- | 手牌（也是卡牌列表）
type Hand = [Card]


-- ============================================================================
-- 2. 创建牌组
-- ============================================================================

-- | 创建完整的 52 张扑克牌
fullDeck :: Deck
fullDeck = [Card r s | s <- allSuits, r <- allRanks]
  where
    allSuits = [Hearts, Diamonds, Clubs, Spades]
    allRanks = [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten,
                Jack, Queen, King, Ace]


-- ============================================================================
-- 3. 基本操作
-- ============================================================================

-- | 从牌组抽一张牌
-- 返回 Nothing 如果牌组为空
-- 返回 Just (card, remainingDeck) 如果成功抽牌
drawCard :: Deck -> Maybe (Card, Deck)
drawCard [] = Nothing
drawCard (c:cs) = Just (c, cs)


-- | 从牌组抽 n 张牌
-- 如果牌不够，返回 Nothing
drawCards :: Int -> Deck -> Maybe (Hand, Deck)
drawCards 0 deck = Just ([], deck)
drawCards n deck = case drawCard deck of
  Nothing -> Nothing
  Just (card, restDeck) -> case drawCards (n-1) restDeck of
    Nothing -> Nothing
    Just (hand, finalDeck) -> Just (card:hand, finalDeck)


-- | 检查牌组中有多少张牌
deckSize :: Deck -> Int
deckSize = length


-- ============================================================================
-- 4. 比较和判断
-- ============================================================================

-- | 判断是否为同花（相同花色）
sameSuit :: Card -> Card -> Bool
sameSuit c1 c2 = suit c1 == suit c2


-- | 比较两张牌的大小
compareCards :: Card -> Card -> Ordering
compareCards c1 c2 = compare (rank c1) (rank c2)


-- | 判断是否为红色牌（红心或方块）
isRedCard :: Card -> Bool
isRedCard card = suit card == Hearts || suit card == Diamonds


-- | 判断是否为人头牌（J, Q, K）
isFaceCard :: Card -> Bool
isFaceCard card = r == Jack || r == Queen || r == King
  where r = rank card


-- | 判断是否为 A
isAce :: Card -> Bool
isAce card = rank card == Ace


-- ============================================================================
-- 5. 手牌分析
-- ============================================================================

-- | 计算手牌中的牌数
handSize :: Hand -> Int
handSize = length


-- | 检查手牌中是否有某张牌
hasCard :: Card -> Hand -> Bool
hasCard _ [] = False
hasCard card (c:cs)
  | card == c = True
  | otherwise = hasCard card cs


-- | 统计手牌中某个花色的牌数
countSuit :: Suit -> Hand -> Int
countSuit s hand = length [c | c <- hand, suit c == s]


-- | 检查是否为同花（所有牌都是同一花色）
isFlush :: Hand -> Bool
isFlush [] = False
isFlush (c:cs) = all (\card -> suit card == suit c) cs


-- | 统计手牌中 A 的数量
countAces :: Hand -> Int
countAces hand = length [c | c <- hand, isAce c]


-- ============================================================================
-- 6. 创建特定的牌
-- ============================================================================

-- | 创建一张指定的牌
makeCard :: Rank -> Suit -> Card
makeCard r s = Card { rank = r, suit = suit' }
  where suit' = s  -- 这只是演示记录语法


-- | 创建黑桃 A
aceOfSpades :: Card
aceOfSpades = Card Ace Spades


-- | 创建红心 K
kingOfHearts :: Card
kingOfHearts = Card King Hearts


-- ============================================================================
-- 7. 格式化输出
-- ============================================================================

-- | 将花色转换为符号
suitToSymbol :: Suit -> String
suitToSymbol Hearts = "♥"
suitToSymbol Diamonds = "♦"
suitToSymbol Clubs = "♣"
suitToSymbol Spades = "♠"


-- | 将牌面转换为字符串
rankToString :: Rank -> String
rankToString Two = "2"
rankToString Three = "3"
rankToString Four = "4"
rankToString Five = "5"
rankToString Six = "6"
rankToString Seven = "7"
rankToString Eight = "8"
rankToString Nine = "9"
rankToString Ten = "10"
rankToString Jack = "J"
rankToString Queen = "Q"
rankToString King = "K"
rankToString Ace = "A"


-- | 美化显示一张牌
prettyCard :: Card -> String
prettyCard card = rankToString (rank card) ++ suitToSymbol (suit card)


-- | 美化显示整副手牌
prettyHand :: Hand -> String
prettyHand hand = unwords (map prettyCard hand)


-- ============================================================================
-- 8. 示例用法
-- ============================================================================

-- | 测试函数：展示所有功能
demo :: IO ()
demo = do
  putStrLn "=== 扑克牌系统演示 ==="
  putStrLn ""
  
  putStrLn "1. 完整牌组："
  putStrLn $ "   共 " ++ show (deckSize fullDeck) ++ " 张牌"
  putStrLn ""
  
  putStrLn "2. 抽一张牌："
  case drawCard fullDeck of
    Nothing -> putStrLn "   牌组为空"
    Just (card, rest) -> do
      putStrLn $ "   抽到: " ++ prettyCard card
      putStrLn $ "   剩余: " ++ show (deckSize rest) ++ " 张"
  putStrLn ""
  
  putStrLn "3. 抽 5 张牌："
  case drawCards 5 fullDeck of
    Nothing -> putStrLn "   牌不够"
    Just (hand, rest) -> do
      putStrLn $ "   手牌: " ++ prettyHand hand
      putStrLn $ "   剩余: " ++ show (deckSize rest) ++ " 张"
  putStrLn ""
  
  putStrLn "4. 特殊牌："
  putStrLn $ "   黑桃A: " ++ prettyCard aceOfSpades
  putStrLn $ "   红心K: " ++ prettyCard kingOfHearts
  putStrLn ""
  
  putStrLn "5. 牌的判断："
  let testCard = Card Queen Hearts
  putStrLn $ "   测试牌: " ++ prettyCard testCard
  putStrLn $ "   是红色? " ++ show (isRedCard testCard)
  putStrLn $ "   是人头牌? " ++ show (isFaceCard testCard)
  putStrLn $ "   是A? " ++ show (isAce testCard)
  putStrLn ""
  
  putStrLn "6. 手牌分析（示例）："
  let exampleHand = [Card Ace Hearts, Card King Hearts, Card Queen Hearts, 
                     Card Jack Hearts, Card Ten Hearts]
  putStrLn $ "   手牌: " ++ prettyHand exampleHand
  putStrLn $ "   牌数: " ++ show (handSize exampleHand)
  putStrLn $ "   是同花? " ++ show (isFlush exampleHand)
  putStrLn $ "   红心数量: " ++ show (countSuit Hearts exampleHand)
  putStrLn $ "   A的数量: " ++ show (countAces exampleHand)


-- ============================================================================
-- 学习要点
-- ============================================================================

{- |
从这个例子中你应该学到：

1. **ADT 定义**
   - data Suit = ... （简单枚举）
   - data Rank = ... （可排序的枚举）
   - data Card = Card { ... } （带记录的类型）

2. **类型别名**
   - type Deck = [Card]
   - type Hand = [Card]
   让代码更易读，但不创建新类型

3. **Maybe 的使用**
   - drawCard 可能失败（牌组为空）
   - 用 Maybe 表示"可能有值，可能没有"
   - 强制调用者处理失败情况

4. **模式匹配**
   - 匹配构造器：sameSuit c1 c2 = suit c1 == suit c2
   - 匹配列表：drawCard (c:cs) = ...
   - 多层模式：case ... of ...

5. **记录语法**
   - 自动生成访问函数：rank, suit
   - 更新语法：card { rank = newRank }

6. **列表推导式**
   - [Card r s | s <- allSuits, r <- allRanks]
   - [c | c <- hand, suit c == s]

在 GHCi 中尝试：
  ghci> :load CardGame.hs
  ghci> demo
  ghci> length fullDeck
  ghci> drawCards 5 fullDeck
  ghci> isFlush [Card Ace Hearts, Card King Hearts]
-}

