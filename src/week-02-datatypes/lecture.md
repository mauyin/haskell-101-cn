# Week 2: 数据类型与模式匹配 - 详细讲义

> 💡 **自学提示**: 这一周引入了新的思维方式 - 用类型建模问题。如果你习惯面向对象编程，可能需要时间适应"数据与行为分离"的理念。慢慢来，多看例子！

---

## 1. 元组 (Tuples)

### 1.1 什么是元组？

元组是**固定长度**的异构容器 - 可以包含不同类型的值。

```haskell
-- 二元组 (pair)
point :: (Int, Int)
point = (3, 4)

-- 三元组 (triple)
person :: (String, Int, Bool)
person = ("Alice", 25, True)

-- 可以嵌套
nested :: ((Int, Int), String)
nested = ((1, 2), "coordinates")
```

### 1.2 元组操作

```haskell
-- 提取二元组的元素
fst :: (a, b) -> a
snd :: (a, b) -> b

ghci> fst (3, 4)
3
ghci> snd (3, 4)
4
```

> ⚠️ **注意**: `fst` 和 `snd` 只适用于二元组！三元组需要模式匹配。

### 1.3 模式匹配元组

```haskell
-- 提取三元组的第一个元素
first :: (a, b, c) -> a
first (x, _, _) = x

-- 计算两点之间的距离
distance :: (Double, Double) -> (Double, Double) -> Double
distance (x1, y1) (x2, y2) = sqrt ((x2-x1)^2 + (y2-y1)^2)

-- 交换元组
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)
```

### 1.4 元组 vs 列表

| 特性 | 元组 | 列表 |
|------|------|------|
| **长度** | 固定 | 可变 |
| **类型** | 异构（不同类型）| 同构（相同类型）|
| **用途** | 打包相关数据 | 同类元素集合 |

```haskell
-- ✅ 正确：元组可以混合类型
valid :: (String, Int, Bool)
valid = ("Alice", 25, True)

-- ✅ 正确：列表元素类型相同
numbers :: [Int]
numbers = [1, 2, 3]

-- ❌ 错误：列表不能混合类型
-- invalid = ["Alice", 25, True]  -- 类型错误！
```

---

## 2. 自定义数据类型 (ADT)

### 2.1 简单枚举类型

```haskell
-- 定义交通信号灯
data TrafficLight = Red | Yellow | Green

-- 使用模式匹配
action :: TrafficLight -> String
action Red    = "Stop"
action Yellow = "Prepare to stop"
action Green  = "Go"

ghci> action Red
"Stop"
```

### 2.2 带参数的构造器

```haskell
-- 定义形状
data Shape = Circle Double              -- 圆：半径
           | Rectangle Double Double    -- 矩形：宽 高
           | Triangle Double Double Double  -- 三角形：三边长

-- 计算面积
area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle a b c) =  -- 海伦公式
  let s = (a + b + c) / 2
  in sqrt (s * (s-a) * (s-b) * (s-c))

ghci> area (Circle 5)
78.53981633974483
ghci> area (Rectangle 3 4)
12.0
```

### 2.3 类型参数（泛型）

```haskell
-- 定义一个"盒子"，可以装任何类型
data Box a = Box a

-- 从盒子中取出值
unbox :: Box a -> a
unbox (Box x) = x

ghci> unbox (Box 42)
42
ghci> unbox (Box "hello")
"hello"
```

### 💭 常见困惑

**"为什么类型和构造器可以同名？"**

```haskell
data Box a = Box a
--   ^       ^
--   |       构造器
--   类型
```

这在 Haskell 中很常见！类型和构造器在不同的命名空间。

---

## 3. Maybe - 处理可选值

### 3.1 Maybe 的定义

```haskell
-- Haskell 标准库中的定义
data Maybe a = Nothing | Just a
```

`Maybe` 用于表示"可能有值，也可能没有值"的情况，替代其他语言的 `null`/`None`。

### 3.2 为什么需要 Maybe？

```python
# Python: null 引用是十亿美元的错误
def find_user(id):
    # 可能返回 None
    return users.get(id)

user = find_user(123)
print(user.name)  # 💥 如果 user 是 None，运行时崩溃！
```

```haskell
-- Haskell: 类型系统强制你处理缺失情况
findUser :: Int -> Maybe User
findUser id = ...

case findUser 123 of
  Nothing -> putStrLn "User not found"
  Just user -> putStrLn (userName user)  -- 编译器确保你处理了两种情况！
```

### 3.3 Maybe 的常用函数

```haskell
-- 安全的列表头部
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x

-- 安全的除法
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)

-- 查找元素的索引
findIndex :: Eq a => a -> [a] -> Maybe Int
findIndex x xs = find' 0 xs
  where
    find' _ [] = Nothing
    find' n (y:ys)
      | x == y    = Just n
      | otherwise = find' (n+1) ys

ghci> safeHead [1,2,3]
Just 1
ghci> safeHead []
Nothing
ghci> safeDiv 10 2
Just 5
ghci> safeDiv 10 0
Nothing
```

### 3.4 处理 Maybe 的模式

```haskell
-- 模式 1: 模式匹配
displayAge :: Maybe Int -> String
displayAge Nothing = "Age unknown"
displayAge (Just age) = "Age: " ++ show age

-- 模式 2: case 表达式
displayAge' :: Maybe Int -> String
displayAge' mAge = case mAge of
  Nothing -> "Age unknown"
  Just age -> "Age: " ++ show age

-- 模式 3: maybe 函数（高阶函数）
displayAge'' :: Maybe Int -> String
displayAge'' = maybe "Age unknown" (\age -> "Age: " ++ show age)
```

---

## 4. Either - 处理错误

### 4.1 Either 的定义

```haskell
-- Haskell 标准库中的定义
data Either a b = Left a | Right b
```

约定俗成：
- `Left` 表示错误/失败
- `Right` 表示成功/正确值（Right = 正确）

### 4.2 Either vs Maybe

| 类型 | 用途 | 信息量 |
|------|------|--------|
| `Maybe a` | 有值或无值 | 无值时不知道原因 |
| `Either String a` | 成功或失败 | 失败时可以附带错误信息 |

```haskell
-- 用 Maybe
safeDiv' :: Int -> Int -> Maybe Int
safeDiv' _ 0 = Nothing  -- 只知道失败了，不知道为什么
safeDiv' x y = Just (x `div` y)

-- 用 Either
safeDiv'' :: Int -> Int -> Either String Int
safeDiv'' _ 0 = Left "Division by zero"  -- 明确的错误信息
safeDiv'' x y = Right (x `div` y)

ghci> safeDiv'' 10 0
Left "Division by zero"
ghci> safeDiv'' 10 2
Right 5
```

### 4.3 Either 的实际应用

```haskell
-- 解析整数
parseInt :: String -> Either String Int
parseInt str
  | null str = Left "Empty string"
  | all isDigit str = Right (read str)
  | otherwise = Left ("Invalid number: " ++ str)

-- 验证年龄
validateAge :: Int -> Either String Int
validateAge age
  | age < 0 = Left "Age cannot be negative"
  | age > 150 = Left "Age too large"
  | otherwise = Right age

ghci> parseInt "42"
Right 42
ghci> parseInt "abc"
Left "Invalid number: abc"
ghci> validateAge 25
Right 25
ghci> validateAge (-5)
Left "Age cannot be negative"
```

---

## 5. 记录语法 (Record Syntax)

### 5.1 基本记录

```haskell
-- 不使用记录语法（位置参数）
data Person = Person String Int String
--                   姓名   年龄 邮箱

-- 问题：难以记住顺序，代码不清晰
person1 = Person "Alice" 25 "alice@example.com"

-- 使用记录语法
data Person = Person
  { personName  :: String
  , personAge   :: Int
  , personEmail :: String
  }

-- 清晰多了！
person2 = Person
  { personName = "Alice"
  , personAge = 25
  , personEmail = "alice@example.com"
  }
```

### 5.2 访问字段

```haskell
-- 自动生成访问函数
ghci> personName person2
"Alice"
ghci> personAge person2
25

-- 也可以模式匹配
greet :: Person -> String
greet (Person {personName = name}) = "Hello, " ++ name
```

### 5.3 更新记录

```haskell
-- 记录更新语法（非破坏性）
celebrateBirthday :: Person -> Person
celebrateBirthday p = p { personAge = personAge p + 1 }

ghci> person2
Person {personName = "Alice", personAge = 25, personEmail = "alice@example.com"}
ghci> celebrateBirthday person2
Person {personName = "Alice", personAge = 26, personEmail = "alice@example.com"}
ghci> person2  -- 原值不变！
Person {personName = "Alice", personAge = 25, personEmail = "alice@example.com"}
```

---

## 6. 递归数据类型

### 6.1 列表的定义

Haskell 的列表实际上是这样定义的：

```haskell
-- 简化版（实际定义更复杂）
data List a = Empty | Cons a (List a)
--            空列表   元素 :: 剩余列表

-- [1, 2, 3] 等价于：
-- Cons 1 (Cons 2 (Cons 3 Empty))
```

### 6.2 二叉树

```haskell
-- 定义二叉树
data Tree a = EmptyTree
            | Node a (Tree a) (Tree a)
  deriving (Show)

-- 示例树
exampleTree :: Tree Int
exampleTree = Node 5
                (Node 3
                  (Node 1 EmptyTree EmptyTree)
                  (Node 4 EmptyTree EmptyTree))
                (Node 7
                  (Node 6 EmptyTree EmptyTree)
                  (Node 9 EmptyTree EmptyTree))

{-
        5
       / \
      3   7
     / \ / \
    1  4 6  9
-}
```

### 6.3 树的基本操作

```haskell
-- 插入元素（保持二叉搜索树性质）
insert :: Ord a => a -> Tree a -> Tree a
insert x EmptyTree = Node x EmptyTree EmptyTree
insert x (Node val left right)
  | x < val  = Node val (insert x left) right
  | x > val  = Node val left (insert x right)
  | otherwise = Node val left right  -- 已存在，不插入

-- 查找元素
search :: Ord a => a -> Tree a -> Bool
search x EmptyTree = False
search x (Node val left right)
  | x == val = True
  | x < val  = search x left
  | x > val  = search x right

-- 中序遍历（得到有序列表）
inorder :: Tree a -> [a]
inorder EmptyTree = []
inorder (Node val left right) = inorder left ++ [val] ++ inorder right

ghci> let tree = insert 5 $ insert 3 $ insert 7 EmptyTree
ghci> search 3 tree
True
ghci> search 10 tree
False
ghci> inorder tree
[3,5,7]
```

---

## 7. 深入模式匹配

### 7.1 多层模式匹配

```haskell
-- 匹配嵌套结构
describePair :: (Maybe Int, Maybe Int) -> String
describePair (Nothing, Nothing) = "Both missing"
describePair (Just x, Nothing)  = "First: " ++ show x
describePair (Nothing, Just y)  = "Second: " ++ show y
describePair (Just x, Just y)   = "Both: " ++ show x ++ " and " ++ show y
```

### 7.2 as-patterns

```haskell
-- 使用 @ 给整个模式命名
firstTwo :: Show a => [a] -> String
firstTwo xs@(x:y:_) = show x ++ " and " ++ show y ++ " from " ++ show xs
firstTwo _ = "List too short"

ghci> firstTwo [1,2,3,4]
"1 and 2 from [1,2,3,4]"
```

### 7.3 Guards vs 模式匹配

```haskell
-- 模式匹配：根据值的"形状"
describeList :: [a] -> String
describeList [] = "Empty"
describeList [x] = "Singleton"
describeList [x,y] = "Pair"
describeList _ = "Longer list"

-- Guards：根据布尔条件
describeLength :: [a] -> String
describeLength xs
  | len == 0  = "Empty"
  | len == 1  = "Singleton"
  | len < 10  = "Short"
  | len < 100 = "Medium"
  | otherwise = "Long"
  where len = length xs
```

### 7.4 case 表达式

```haskell
-- case 是模式匹配的表达式形式
describeNumber :: Int -> String
describeNumber n = case n of
  0 -> "Zero"
  1 -> "One"
  2 -> "Two"
  _ -> "Many"

-- 可以在任何地方使用 case
describeList' :: [a] -> String
describeList' xs = "The list is " ++ case xs of
  [] -> "empty"
  [x] -> "a singleton"
  _ -> "longer"
```

---

## 8. newtype

### 8.1 为什么需要 newtype？

有时我们想为已存在的类型创建新名字，但保持零运行时开销：

```haskell
-- 使用 type（类型别名）
type UserId = Int
type ProductId = Int

-- 问题：这两个可以混用！
processUser :: UserId -> String
processUser id = ...

ghci> processUser (42 :: ProductId)  -- 应该报错，但没有！
```

```haskell
-- 使用 newtype
newtype UserId = UserId Int
newtype ProductId = ProductId Int

-- 现在它们是不同的类型！
processUser :: UserId -> String
processUser (UserId id) = ...

-- ghci> processUser (ProductId 42)  -- 编译错误！类型不匹配
```

### 8.2 newtype vs data

```haskell
-- data：可以有多个构造器或多个字段
data Shape = Circle Double | Rectangle Double Double

-- newtype：只能有一个构造器，一个字段
newtype Age = Age Int

-- newtype 的优势：零运行时开销（编译后消失）
-- data 的优势：更灵活
```

---

## 9. 实战示例：扑克牌

让我们综合运用本周所学，实现一个扑克牌系统：

```haskell
-- 花色
data Suit = Hearts | Diamonds | Clubs | Spades
  deriving (Eq, Show)

-- 牌面
data Rank = Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten
          | Jack | Queen | King | Ace
  deriving (Eq, Ord, Show)

-- 扑克牌
data Card = Card
  { rank :: Rank
  , suit :: Suit
  }
  deriving (Eq, Show)

-- 判断是否为同花
sameSuit :: Card -> Card -> Bool
sameSuit c1 c2 = suit c1 == suit c2

-- 比较牌面大小
compareCards :: Card -> Card -> Ordering
compareCards c1 c2 = compare (rank c1) (rank c2)

-- 牌组
type Deck = [Card]

-- 创建完整牌组
fullDeck :: Deck
fullDeck = [Card r s | s <- [Hearts, Diamonds, Clubs, Spades],
                       r <- [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten,
                             Jack, Queen, King, Ace]]

-- 从牌组抽牌
drawCard :: Deck -> Maybe (Card, Deck)
drawCard [] = Nothing
drawCard (c:cs) = Just (c, cs)

ghci> length fullDeck
52
ghci> drawCard fullDeck
Just (Card {rank = Two, suit = Hearts}, [Card {rank = Three, suit = Hearts}, ...])
```

---

## 10. 常见错误和调试

### 10.1 不完整的模式匹配

```haskell
-- ⚠️ 危险：没有处理所有情况
head' :: [a] -> a
head' (x:xs) = x
-- 运行时如果传入空列表会崩溃！

-- ✅ 安全：处理所有情况
head'' :: [a] -> Maybe a
head'' [] = Nothing
head'' (x:xs) = Just x
```

### 10.2 记录字段命名冲突

```haskell
-- ❌ 错误：两个类型有相同的字段名
data Person = Person { name :: String }
data Company = Company { name :: String }  -- 冲突！

-- ✅ 解决：使用前缀
data Person = Person { personName :: String }
data Company = Company { companyName :: String }
```

### 10.3 混淆类型和构造器

```haskell
data Box a = Box a

-- ✅ 正确：Box 作为类型
myBox :: Box Int

-- ✅ 正确：Box 作为构造器
myBox = Box 42

-- ❌ 错误：混淆两者
-- myBox = myBox 42  -- 类型错误！
```

---

## 11. 本周总结

### 你学会了：

✅ **元组** - 打包固定数量的异构数据  
✅ **ADT** - 用类型建模问题域  
✅ **Maybe** - 类型安全地处理可选值  
✅ **Either** - 携带错误信息的失败处理  
✅ **记录语法** - 为字段命名  
✅ **递归类型** - 如列表和树  
✅ **模式匹配** - 根据数据结构分支  

### 关键概念

1. **类型安全** - 用类型系统防止错误
2. **数据与行为分离** - ADT 只定义数据，函数定义行为
3. **不可变性** - 数据不可修改，只能创建新数据
4. **穷尽性检查** - 编译器确保你处理了所有情况

### 设计原则

- **让非法状态无法表示** - 好的类型设计让错误无法编译
- **优先使用 Maybe/Either** - 避免异常和 null
- **小而精的类型** - 每个类型只做一件事

---

## 练习时间

准备好测试你的理解了吗？

前往 [练习作业](exercises.md) 完成本周练习！

记住：
- ADT 的概念需要时间适应
- 多画图帮助理解树结构
- Maybe 和 Either 一开始可能觉得繁琐，但很快就会感激它们
- 完成至少 80% 的练习再进入下一周

**加油！** 💪

