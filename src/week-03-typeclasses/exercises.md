# Week 3: 练习作业

> 动手实践，掌握类型类

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week03Exercises.hs](../../exercises/week-03/tasks/Week03Exercises.hs)** - 主练习文件（25 道题）
- **[挑战题: Week03Challenges.hs](../../exercises/week-03/tasks/Week03Challenges.hs)** - 进阶挑战（选做）
- **[参考答案](../../exercises/week-03/solutions/)** - 完成后查看

### 如何使用

```bash
# 1. 下载练习文件到本地
# 2. 用编辑器打开（VS Code 推荐）
# 3. 完成每个 TODO 标记的函数
# 4. 在 GHCi 中测试：
ghci> :load Week03Exercises.hs
ghci> testFunction 参数
```

---

## 练习 1: Eq 实例（5 题）

**文件**: `Week03Exercises.hs` (第 1-5 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 为自定义类型实现 Eq 实例
- 理解 == 和 /= 的关系
- 使用 Eq 进行比较

### 内容预览

```haskell
-- 1.1 定义颜色类型并实现 Eq
data Color = Red | Green | Blue

instance Eq Color where
  -- TODO: 实现 (==)

-- 测试
-- Red == Red          --> True
-- Red == Blue         --> False

-- 1.2 扑克牌点数类型
data Rank = Ace | Two | Three | Four | Five 
          | Six | Seven | Eight | Nine | Ten
          | Jack | Queen | King

instance Eq Rank where
  -- TODO: 实现 (==)

-- 1.3 点类型（包含坐标）
data Point = Point Int Int

instance Eq Point where
  -- TODO: 实现 (==)
  -- 提示：两个点坐标都相同才相等

-- 测试
-- Point 1 2 == Point 1 2  --> True
-- Point 1 2 == Point 2 1  --> False

-- 1.4 温度类型（摄氏度）
data Temperature = Celsius Double

instance Eq Temperature where
  -- TODO: 实现 (==)
  -- 提示：使用浮点数比较

-- 1.5 用户类型
data User = User
  { userId :: Int
  , userName :: String
  }

instance Eq User where
  -- TODO: 实现 (==)
  -- 提示：两个用户 ID 相同即认为相同
```

---

## 练习 2: Ord 实例（5 题）

**文件**: `Week03Exercises.hs` (第 6-10 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 实现 Ord 实例
- 使用 compare 函数
- 理解排序规则

### 内容预览

```haskell
-- 2.1 优先级类型（已有 Eq 实例）
data Priority = Low | Medium | High

instance Ord Priority where
  -- TODO: 实现 compare
  -- Low < Medium < High

-- 测试
-- sort [High, Low, Medium]  --> [Low, Medium, High]

-- 2.2 扑克牌点数（已有 Eq 实例）
instance Ord Rank where
  -- TODO: 实现 compare
  -- 顺序：Ace < Two < ... < King

-- 2.3 点类型的排序
instance Ord Point where
  -- TODO: 实现 compare
  -- 先比较 x 坐标，再比较 y 坐标

-- 测试
-- Point 1 2 < Point 1 3  --> True
-- Point 1 2 < Point 2 1  --> True

-- 2.4 温度排序
instance Ord Temperature where
  -- TODO: 实现 compare

-- 测试
-- Celsius 20 < Celsius 30  --> True

-- 2.5 文件大小类型
data FileSize = Bytes Int

instance Eq FileSize where
  Bytes x == Bytes y = x == y

instance Ord FileSize where
  -- TODO: 实现 compare
```

---

## 练习 3: Show 实例（5 题）

**文件**: `Week03Exercises.hs` (第 11-15 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 实现自定义 Show 实例
- 格式化输出
- 创建友好的字符串表示

### 内容预览

```haskell
-- 3.1 颜色的友好显示
instance Show Color where
  -- TODO: 显示为中文
  -- show Red   --> "红色"
  -- show Green --> "绿色"
  -- show Blue  --> "蓝色"

-- 3.2 温度的单位显示
instance Show Temperature where
  -- TODO: 显示为 "20.0°C" 格式

-- 3.3 点的坐标显示
instance Show Point where
  -- TODO: 显示为 "(1, 2)" 格式

-- 3.4 扑克牌完整显示
data Card = Card Rank Suit

instance Show Card where
  -- TODO: 显示为 "红桃 A" 格式

-- 3.5 时间类型
data Time = Time Int Int  -- 小时 分钟

instance Show Time where
  -- TODO: 显示为 "14:30" 格式
  -- 提示：使用 printf 或字符串拼接
```

---

## 练习 4: deriving 和组合（5 题）

**文件**: `Week03Exercises.hs` (第 16-20 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 deriving 自动派生
- 理解 deriving 的限制
- 组合多个类型类

### 内容预览

```haskell
-- 4.1 使用 deriving
data Shape = Circle Double
           | Rectangle Double Double
           | Triangle Double Double Double
  deriving (Eq, Show)

-- TODO: 实现 Ord 实例
-- 按面积大小排序
instance Ord Shape where
  -- 提示：先实现 area 函数

-- 4.2 方向枚举
data Direction = North | South | East | West
  deriving (Eq, Ord, Show, Enum, Bounded)

-- TODO: 实现函数获取所有方向
allDirections :: [Direction]
allDirections = undefined  -- 使用 [minBound .. maxBound]

-- 4.3 交通信号灯
data TrafficLight = Red | Yellow | Green
  deriving (Eq, Show, Enum)

-- TODO: 实现下一个状态
nextLight :: TrafficLight -> TrafficLight
nextLight = undefined  -- 使用 Enum 的功能

-- 4.4 产品类型
data Product = Product
  { productName :: String
  , productPrice :: Double
  , productStock :: Int
  } deriving (Eq, Show)

-- TODO: 实现 Ord，按价格排序
instance Ord Product where
  -- ...

-- 4.5 结果类型
data Result a = Success a | Failure String
  deriving (Eq, Show)

-- TODO: 使这个类型支持 Functor
instance Functor Result where
  fmap = undefined
```

---

## 练习 5: Functor 练习（5 题）

**文件**: `Week03Exercises.hs` (第 21-25 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 理解 Functor 的作用
- 使用 fmap 和 <$>
- 为自定义类型实现 Functor

### 内容预览

```haskell
-- 5.1 使用 fmap 转换 Maybe
doubleIfPresent :: Maybe Int -> Maybe Int
doubleIfPresent = undefined  -- 使用 fmap

-- 5.2 使用 <$> 操作符
addTen :: Maybe Int -> Maybe Int
addTen mx = undefined  -- 使用 <$>

-- 5.3 链式 fmap
-- 给定：safeDivide :: Double -> Double -> Maybe Double
calculatePercentage :: Double -> Double -> Maybe Double
calculatePercentage part total = undefined
  -- 提示：先除法，再乘以 100

-- 5.4 Box 类型实现 Functor
data Box a = Empty | Full a

instance Functor Box where
  fmap = undefined

-- 测试
-- fmap (+1) (Full 5)  --> Full 6
-- fmap (+1) Empty     --> Empty

-- 5.5 Tree 类型实现 Functor
data Tree a = Leaf a | Node (Tree a) (Tree a)

instance Functor Tree where
  fmap = undefined

-- 测试
-- fmap (+1) (Leaf 5)  --> Leaf 6
```

---

## 练习 6: Applicative 练习（5 题）

**文件**: `Week03Exercises.hs` (第 26-30 题)  
**难度**: ⭐⭐⭐⭐☆

### 目标

- 使用 pure 和 <*>
- 组合多个 Applicative 值
- 实际应用：表单验证

### 内容预览

```haskell
-- 6.1 基础 Applicative 使用
addMaybe :: Maybe Int -> Maybe Int -> Maybe Int
addMaybe mx my = undefined  -- 使用 <$> 和 <*>

-- 测试
-- addMaybe (Just 3) (Just 5)  --> Just 8
-- addMaybe (Just 3) Nothing   --> Nothing

-- 6.2 三个参数的函数
add3Maybe :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int
add3Maybe = undefined

-- 6.3 表单验证
data Person = Person String Int String  -- name age email

validateName :: String -> Maybe String
validateName n = if length n > 0 then Just n else Nothing

validateAge :: Int -> Maybe Int  
validateAge a = if a >= 18 then Just a else Nothing

validateEmail :: String -> Maybe String
validateEmail e = if '@' `elem` e then Just e else Nothing

-- TODO: 组合验证创建 Person
createPerson :: String -> Int -> String -> Maybe Person
createPerson name age email = undefined
  -- 使用 Person <$> ... <*> ... <*> ...

-- 6.4 列表的 Applicative
allPairs :: [a] -> [b] -> [(a, b)]
allPairs xs ys = undefined  -- 使用 <$> 和 <*>

-- 测试
-- allPairs [1,2] [10,20]  --> [(1,10),(1,20),(2,10),(2,20)]

-- 6.5 实现 Box 的 Applicative
instance Applicative Box where
  pure = undefined
  (<*>) = undefined

-- 测试
-- pure (+) <*> Full 3 <*> Full 5  --> Full 8
```

---

## 练习 7: Monad 入门（5 题）

**文件**: `Week03Exercises.hs` (第 31-35 题)  
**难度**: ⭐⭐⭐⭐☆

### 目标

- 使用 >>= (bind) 运算符
- 使用 do 记法
- 链接多个 Monad 操作

### 内容预览

```haskell
-- 7.1 使用 >>= 链接操作
addOneIfEven :: Int -> Maybe Int
addOneIfEven n = if even n then Just n else Nothing

addTwo :: Maybe Int -> Maybe Int
addTwo mx = undefined  -- 使用 >>= 和 addOneIfEven

-- 测试
-- addTwo (Just 4)  --> Just 4  (4 是偶数，但 5 不是)
-- addTwo (Just 5)  --> Nothing

-- 7.2 安全除法链
-- 给定：safeDivide :: Double -> Double -> Maybe Double

calculate :: Double -> Maybe Double
calculate x = undefined
  -- 计算：((x / 2) / 3) / 4
  -- 使用 do 记法

-- 7.3 查找链
-- 给定：
type Database = [(String, Int)]
lookupAge :: String -> Database -> Maybe Int

lookupAndDouble :: String -> Database -> Maybe Int
lookupAndDouble name db = undefined
  -- 查找年龄并翻倍
  -- 使用 do 记法

-- 7.4 列表 Monad
pairs :: [Int] -> [Int] -> [(Int, Int)]
pairs xs ys = undefined
  -- 使用 do 记法生成所有配对

-- 测试
-- pairs [1,2] [10,20]  --> [(1,10),(1,20),(2,10),(2,20)]

-- 7.5 实现 Box 的 Monad
instance Monad Box where
  return = undefined
  (>>=) = undefined

-- 测试
-- Full 5 >>= (\x -> Full (x + 1))  --> Full 6
-- Empty >>= (\x -> Full (x + 1))   --> Empty
```

---

## 挑战题（5 题）

**文件**: `Week03Challenges.hs`  
**难度**: ⭐⭐⭐⭐⭐

### 挑战 1: 自定义 Foldable

```haskell
-- 为 Tree 实现 Foldable
data Tree a = Leaf a | Node (Tree a) (Tree a)

instance Foldable Tree where
  -- TODO: 实现 foldr
  foldr = undefined

-- 测试
-- foldr (+) 0 (Node (Leaf 1) (Leaf 2))  --> 3
```

### 挑战 2: 验证 Functor 法则

```haskell
-- 为你的自定义 Functor 编写测试
-- 验证：fmap id = id
-- 验证：fmap (f . g) = fmap f . fmap g
```

### 挑战 3: 解析器 Monad

```haskell
-- 创建简单的解析器类型
newtype Parser a = Parser (String -> Maybe (a, String))

instance Functor Parser where
  -- TODO

instance Applicative Parser where
  -- TODO

instance Monad Parser where
  -- TODO

-- 实现基础解析器
charP :: Char -> Parser Char
stringP :: String -> Parser String
```

### 挑战 4: 状态 Monad

```haskell
-- 实现简单的状态 Monad
data State s a = State (s -> (a, s))

instance Functor (State s) where
  -- TODO

instance Applicative (State s) where
  -- TODO

instance Monad (State s) where
  -- TODO

-- 实用函数
get :: State s s
put :: s -> State s ()
modify :: (s -> s) -> State s ()
```

### 挑战 5: 类型类组合

```haskell
-- 创建一个类型同时是 Eq, Ord, Show, Functor, Applicative, Monad
data MyType a = ...

-- 实现所有实例并确保它们遵守类型类法则
```

---

## 💡 完成提示

### 学习建议

1. **按顺序完成** - 难度是递进的
2. **多测试** - 在 GHCi 中验证每个函数
3. **参考讲义** - 遇到困难回顾相关章节
4. **不要跳过** - 每个练习都很重要

### 常见错误

```haskell
-- ❌ 忘记实现所有必需的方法
instance Eq Color where
  Red == Red = True  -- 缺少其他情况！

-- ✅ 完整实现
instance Eq Color where
  Red == Red = True
  Green == Green = True
  Blue == Blue = True
  _ == _ = False
```

```haskell
-- ❌ Ord 没有先实现 Eq
instance Ord Priority where  -- 错误！
  compare Low Low = EQ
  -- ...

-- ✅ 先实现 Eq
instance Eq Priority where
  -- ...
instance Ord Priority where
  -- ...
```

### 测试方法

```bash
# 在 GHCi 中测试
ghci> :load Week03Exercises.hs
ghci> Red == Red
True

ghci> sort [High, Low, Medium]
[Low,Medium,High]

ghci> fmap (+1) (Just 5)
Just 6

# 运行所有测试（如果你写了测试函数）
ghci> runTests
```

---

## 📊 进度检查

完成练习后，检查你是否达到了学习目标：

- [ ] 能为自定义类型实现 Eq、Ord、Show
- [ ] 理解何时使用 deriving
- [ ] 掌握 Functor 的 fmap 和 <$>
- [ ] 会用 Applicative 组合多个值
- [ ] 能使用 do 记法进行 Monad 操作
- [ ] 理解各类型类之间的关系

**全部完成？** 恭喜！你已经掌握了 Haskell 类型类的核心知识！

继续前进：[Week 4: Monad 与 IO](../../week-04-monad-io/README.md) →

---

## 📚 参考答案

完成练习后，可以查看参考答案：

- [Week03Exercises.hs 答案](../../exercises/week-03/solutions/Week03Exercises.hs)
- [Week03Challenges.hs 答案](../../exercises/week-03/solutions/Week03Challenges.hs)

**重要**：先独立完成练习，再查看答案！只有自己动手写代码才能真正掌握。

