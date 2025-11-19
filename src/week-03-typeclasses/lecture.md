# Week 3: 类型类 - 详细讲义

> 💡 **自学提示**: 类型类是 Haskell 的核心特性之一，内容较多。建议分 3-4 天完成，每次学习 1-2 个小节。遇到 Monad 不要慌，Week 4 会详细讲解！

---

## 目录

1. [类型类基础](#1-类型类基础)
2. [自动派生 deriving](#2-自动派生-deriving)
3. [Functor - 可映射的容器](#3-functor---可映射的容器)
4. [Applicative - 组合计算](#4-applicative---组合计算)
5. [Monad 入门](#5-monad-入门)
6. [实用建议](#6-实用建议)

---

## 1. 类型类基础

### 1.1 什么是类型类？

类型类（Typeclass）是 Haskell 实现**多态**和**抽象**的方式。

**类比其他语言**：
- Java/C#: `interface`
- Rust: `trait`
- Go: `interface`
- Python: Protocol (PEP 544)

**关键区别**：类型类可以**事后**为已有类型添加实例，无需修改原类型定义！

```haskell
-- 类型类定义了一组函数签名
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  
  -- 默认实现（可选）
  x /= y = not (x == y)
```

### 1.2 Eq 类型类 - 相等性

`Eq` 是最简单的类型类，用于比较两个值是否相等。

**内置类型已实现 Eq**：

```haskell
ghci> 1 == 1
True

ghci> "hello" == "world"
False

ghci> [1,2,3] == [1,2,3]
True

ghci> Just 5 == Just 5
True

ghci> Nothing == Nothing
True
```

**为自定义类型实现 Eq**：

```haskell
-- 定义一个扑克牌花色类型
data Suit = Hearts | Diamonds | Clubs | Spades

-- 手动实现 Eq
instance Eq Suit where
  Hearts == Hearts = True
  Diamonds == Diamonds = True
  Clubs == Clubs = True
  Spades == Spades = True
  _ == _ = False
```

测试：

```haskell
ghci> Hearts == Hearts
True

ghci> Hearts == Spades
False
```

### 1.3 Ord 类型类 - 顺序

`Ord` 用于比较大小，**必须先实现 Eq**。

```haskell
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  -- ... 其他函数
```

**Ordering 类型**：

```haskell
data Ordering = LT | EQ | GT
-- LT: Less Than (小于)
-- EQ: Equal (等于)  
-- GT: Greater Than (大于)
```

**使用示例**：

```haskell
ghci> 3 < 5
True

ghci> "apple" <= "banana"
True

ghci> compare 10 20
LT

ghci> compare "hello" "hello"
EQ
```

**为自定义类型实现 Ord**：

```haskell
data Priority = Low | Medium | High

instance Eq Priority where
  Low == Low = True
  Medium == Medium = True
  High == High = True
  _ == _ = False

instance Ord Priority where
  compare Low Low = EQ
  compare Low _ = LT
  compare Medium Low = GT
  compare Medium Medium = EQ
  compare Medium High = LT
  compare High High = EQ
  compare High _ = GT
```

测试：

```haskell
ghci> Low < High
True

ghci> Medium >= Low
True

ghci> sort [High, Low, Medium, High]
[Low, Medium, High, High]
```

### 1.4 Show 类型类 - 字符串表示

`Show` 将值转换为字符串（用于显示和调试）。

```haskell
class Show a where
  show :: a -> String
```

**使用示例**：

```haskell
ghci> show 42
"42"

ghci> show True
"True"

ghci> show [1,2,3]
"[1,2,3]"

ghci> show (Just 5)
"Just 5"
```

**为自定义类型实现 Show**：

```haskell
data Card = Card { rank :: String, suit :: Suit }

instance Show Card where
  show (Card r s) = r ++ " of " ++ show s
```

**更复杂的例子**：

```haskell
data Person = Person
  { name :: String
  , age :: Int
  , email :: String
  }

instance Show Person where
  show (Person n a e) = 
    "Person { name: " ++ n ++ 
    ", age: " ++ show a ++ 
    ", email: " ++ e ++ " }"
```

测试：

```haskell
ghci> let alice = Person "Alice" 30 "alice@example.com"
ghci> print alice
Person { name: Alice, age: 30, email: alice@example.com }
```

### 💭 常见困惑

**"为什么不直接在类型定义里写方法？"**

这是函数式编程的哲学：**数据和行为分离**。

```haskell
-- Haskell 方式：分离
data Person = Person String Int
instance Show Person where ...

-- OOP 方式（假设）：混合
class Person {
  String name;
  int age;
  String show() { ... }  -- Haskell 不这样做
}
```

**好处**：
- 可以事后添加类型类实例
- 避免紧耦合
- 更灵活的抽象

---

## 2. 自动派生 deriving

手动实现类型类实例很繁琐，Haskell 提供 `deriving` 自动生成！

### 2.1 基本用法

```haskell
data Suit = Hearts | Diamonds | Clubs | Spades
  deriving (Eq, Ord, Show)
```

一行搞定！现在可以直接用：

```haskell
ghci> Hearts == Spades
False

ghci> Hearts < Spades
True

ghci> show Diamonds
"Diamonds"

ghci> [Hearts, Spades, Diamonds]
[Hearts,Spades,Diamonds]
```

### 2.2 deriving 的规则

**可自动派生的常见类型类**：
- `Eq` - 比较相等性
- `Ord` - 比较顺序（构造器从左到右依次增大）
- `Show` - 生成默认字符串表示
- `Read` - 从字符串解析（与 Show 相反）
- `Enum` - 可枚举（用于 `[Low..High]`）
- `Bounded` - 有界（提供 `minBound` 和 `maxBound`）

**示例**：

```haskell
data Priority = Low | Medium | High
  deriving (Eq, Ord, Show, Enum, Bounded)

ghci> [Low .. High]
[Low,Medium,High]

ghci> minBound :: Priority
Low

ghci> maxBound :: Priority
High
```

### 2.3 记录类型的 deriving

```haskell
data Person = Person
  { name :: String
  , age :: Int
  } deriving (Eq, Show)
```

测试：

```haskell
ghci> let alice = Person "Alice" 30
ghci> let bob = Person "Bob" 30
ghci> alice == bob
False

ghci> show alice
"Person {name = \"Alice\", age = 30}"
```

### 2.4 何时使用 deriving

✅ **适合 deriving**：
- 简单的枚举类型
- 默认行为足够好
- 快速原型开发

❌ **需要手动实现**：
- 需要自定义格式（如 JSON）
- 特殊的比较逻辑
- 复杂的字符串表示

---

## 3. Functor - 可映射的容器

### 3.1 Functor 是什么？

`Functor` 是一个"容器"或"上下文"，你可以对里面的值应用函数，**而不需要拆开容器**。

**盒子比喻**：
- `Maybe Int` 是一个"可能有 Int 的盒子"
- `fmap` 让你在不打开盒子的情况下对里面的 Int 操作

```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```

**读法**：
- `f` 是一个类型构造器（如 `Maybe`、`[]`）
- `fmap` 接受函数 `a -> b` 和容器 `f a`，返回 `f b`

### 3.2 Maybe 是 Functor

```haskell
instance Functor Maybe where
  fmap f Nothing = Nothing
  fmap f (Just x) = Just (f x)
```

**使用示例**：

```haskell
ghci> fmap (+1) (Just 5)
Just 6

ghci> fmap (+1) Nothing
Nothing

ghci> fmap (*2) (Just 10)
Just 20

ghci> fmap show (Just 42)
Just "42"
```

**链式调用**：

```haskell
ghci> fmap (+1) (fmap (*2) (Just 5))
Just 11

-- 使用 <$> 运算符（fmap 的中缀形式）
ghci> (+1) <$> (*2) <$> Just 5
Just 11
```

### 3.3 列表是 Functor

```haskell
instance Functor [] where
  fmap = map  -- fmap 就是 map！
```

```haskell
ghci> fmap (+1) [1,2,3]
[2,3,4]

ghci> fmap (*2) []
[]

ghci> fmap show [1,2,3]
["1","2","3"]

-- 使用 <$>
ghci> (+10) <$> [1,2,3]
[11,12,13]
```

### 3.4 Either 是 Functor

```haskell
instance Functor (Either a) where
  fmap f (Left x) = Left x
  fmap f (Right y) = Right (f y)
```

**注意**：只对 `Right` 应用函数！

```haskell
ghci> fmap (+1) (Right 5)
Right 6

ghci> fmap (+1) (Left "error")
Left "error"

ghci> fmap (*2) (Right 10)
Right 20
```

### 3.5 Functor 定律

所有 Functor 必须遵守两条定律：

**定律 1: Identity（恒等律）**

```haskell
fmap id = id
```

```haskell
ghci> fmap id (Just 5)
Just 5

ghci> fmap id [1,2,3]
[1,2,3]
```

**定律 2: Composition（组合律）**

```haskell
fmap (f . g) = fmap f . fmap g
```

```haskell
ghci> fmap ((*2) . (+1)) (Just 5)
Just 12

ghci> (fmap (*2) . fmap (+1)) (Just 5)
Just 12
```

**为什么需要定律？**
- 保证行为可预测
- 使代码可重构
- 避免意外的副作用

### 3.6 实用场景

**场景 1: 处理可选值**

```haskell
-- 不用 Functor（繁琐）
addTax :: Maybe Double -> Maybe Double
addTax Nothing = Nothing
addTax (Just price) = Just (price * 1.1)

-- 用 Functor（简洁）
addTax :: Maybe Double -> Maybe Double
addTax = fmap (*1.1)
```

**场景 2: 转换错误消息**

```haskell
result :: Either String Int
result = Right 42

-- 转换成功值
ghci> fmap (*2) result
Right 84

-- 错误值不受影响
ghci> fmap (*2) (Left "error")
Left "error"
```

**场景 3: 批量转换**

```haskell
users :: [User]
userNames :: [String]
userNames = fmap getName users

-- 等价于
userNames = map getName users
```

---

## 4. Applicative - 组合计算

### 4.1 Applicative 是什么？

`Applicative` 是比 `Functor` 更强大的抽象，允许我们在容器中应用**容器中的函数**。

```haskell
class Functor f => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```

**关键函数**：
- `pure`: 把值放入最小的上下文中
- `<*>`: 应用容器中的函数到容器中的值

### 4.2 Maybe 是 Applicative

```haskell
instance Applicative Maybe where
  pure x = Just x
  
  Nothing <*> _ = Nothing
  _ <*> Nothing = Nothing
  Just f <*> Just x = Just (f x)
```

**使用示例**：

```haskell
ghci> pure (+) <*> Just 3 <*> Just 5
Just 8

ghci> pure (*) <*> Just 2 <*> Just 10
Just 20

ghci> pure (+) <*> Just 3 <*> Nothing
Nothing
```

**简化写法**：

```haskell
-- 使用 <$> 和 <*>
ghci> (+) <$> Just 3 <*> Just 5
Just 8

ghci> (*) <$> Just 2 <*> Just 10
Just 20
```

### 4.3 实用场景：表单验证

```haskell
data User = User
  { userName :: String
  , userAge :: Int
  , userEmail :: String
  }

-- 验证函数
validateName :: String -> Maybe String
validateName n
  | length n > 0 = Just n
  | otherwise = Nothing

validateAge :: Int -> Maybe Int
validateAge a
  | a >= 18 = Just a
  | otherwise = Nothing

validateEmail :: String -> Maybe String
validateEmail e
  | '@' `elem` e = Just e
  | otherwise = Nothing

-- 使用 Applicative 组合验证
createUser :: String -> Int -> String -> Maybe User
createUser n a e =
  User <$> validateName n
       <*> validateAge a
       <*> validateEmail e
```

测试：

```haskell
ghci> createUser "Alice" 25 "alice@example.com"
Just (User {userName = "Alice", userAge = 25, userEmail = "alice@example.com"})

ghci> createUser "" 25 "alice@example.com"
Nothing

ghci> createUser "Alice" 15 "alice@example.com"
Nothing
```

### 4.4 列表是 Applicative

```haskell
instance Applicative [] where
  pure x = [x]
  fs <*> xs = [f x | f <- fs, x <- xs]
```

**笛卡尔积效果**：

```haskell
ghci> pure (+1) <*> [1,2,3]
[2,3,4]

ghci> [(+1), (*2)] <*> [1,2,3]
[2,3,4,2,4,6]

ghci> (+) <$> [1,2] <*> [10,20]
[11,21,12,22]
```

### 4.5 为什么叫 Applicative？

因为它允许我们**应用**（apply）函数到多个参数，即使这些参数都在容器中！

```haskell
-- 普通函数
add3 :: Int -> Int -> Int -> Int
add3 x y z = x + y + z

-- Applicative 版本
add3Maybe :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int
add3Maybe mx my mz = add3 <$> mx <*> my <*> mz
```

测试：

```haskell
ghci> add3Maybe (Just 1) (Just 2) (Just 3)
Just 6

ghci> add3Maybe (Just 1) Nothing (Just 3)
Nothing
```

---

## 5. Monad 入门

> ⚠️ **重要提示**：本节只是入门，Week 4 会详细讲解 Monad。现在只需要会用基本操作即可！

### 5.1 Monad 解决什么问题？

想象你有一系列操作，每一步都可能失败：

```haskell
-- 不好的方式：嵌套的 case
lookupUser :: Int -> Maybe User
processUser :: User -> Maybe Result
saveResult :: Result -> Maybe ()

handleRequest :: Int -> Maybe ()
handleRequest userId =
  case lookupUser userId of
    Nothing -> Nothing
    Just user ->
      case processUser user of
        Nothing -> Nothing
        Just result ->
          saveResult result
```

**太繁琐了！** Monad 解决这个问题：

```haskell
handleRequest :: Int -> Maybe ()
handleRequest userId = do
  user <- lookupUser userId
  result <- processUser user
  saveResult result
```

### 5.2 Monad 类型类

```haskell
class Applicative m => Monad m where
  return :: a -> m a  -- 等价于 pure
  (>>=) :: m a -> (a -> m b) -> m b  -- bind 运算符
```

**关键操作**：
- `return`: 把值放入 Monad（等同于 `pure`）
- `>>=` (bind): 链接两个 Monad 操作

### 5.3 Maybe Monad

```haskell
instance Monad Maybe where
  return = Just
  
  Nothing >>= f = Nothing
  Just x >>= f = f x
```

**使用 >>= (bind)**：

```haskell
ghci> Just 5 >>= (\x -> Just (x + 1))
Just 6

ghci> Nothing >>= (\x -> Just (x + 1))
Nothing

ghci> Just 5 >>= (\x -> Just (x * 2)) >>= (\y -> Just (y + 10))
Just 20
```

**使用 do 记法**：

```haskell
addTwo :: Maybe Int -> Maybe Int
addTwo mx = do
  x <- mx
  return (x + 2)

-- 等价于：
addTwo mx = mx >>= (\x -> return (x + 2))
```

### 5.4 实用例子：安全除法

```haskell
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

-- 链式除法
calculate :: Maybe Double
calculate = do
  x <- safeDiv 10 2    -- x = 5
  y <- safeDiv x 2     -- y = 2.5
  z <- safeDiv y 0     -- 失败！
  return z             -- 不会执行
```

测试：

```haskell
ghci> calculate
Nothing

-- 成功的例子
ghci> do
  x <- safeDiv 10 2
  y <- safeDiv x 2
  z <- safeDiv y 2
  return z
Just 1.25
```

### 5.5 List Monad

列表的 Monad 实例用于**非确定性计算**（多个可能的结果）：

```haskell
instance Monad [] where
  return x = [x]
  xs >>= f = concat (map f xs)
```

**使用示例**：

```haskell
ghci> [1,2,3] >>= (\x -> [x, x*10])
[1,10,2,20,3,30]

ghci> do
  x <- [1,2]
  y <- [10,20]
  return (x + y)
[11,21,12,22]
```

**实用场景：生成组合**：

```haskell
-- 生成所有可能的坐标
coordinates :: [(Int, Int)]
coordinates = do
  x <- [1,2,3]
  y <- [1,2,3]
  return (x, y)

ghci> coordinates
[(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3)]
```

### 5.6 do 记法详解

`do` 记法是语法糖，编译器会自动转换成 `>>=`：

```haskell
-- do 记法
foo = do
  x <- action1
  y <- action2 x
  return (y + 1)

-- 等价于
foo = action1 >>= (\x ->
        action2 x >>= (\y ->
          return (y + 1)))
```

**do 记法规则**：
1. `x <- action` - 从 Monad 中提取值
2. `let x = expr` - 定义普通值
3. 最后一行必须是 Monad 类型

```haskell
example :: Maybe Int
example = do
  x <- Just 5           -- 提取值
  let y = x * 2         -- 定义普通值
  z <- Just (y + 1)     -- 再次提取
  return (z * 3)        -- 返回结果

ghci> example
Just 33
```

### 💭 常见困惑

**"Monad 是什么？"**

不同的比喻：
- **容器观点**：Monad 是可以链式操作的容器
- **计算观点**：Monad 表示带有上下文的计算
- **控制流观点**：Monad 是一种可编程的分号

**现在不完全理解也没关系！** Week 4 会深入讲解，现在只需要会用 `do` 记法即可。

---

## 6. 实用建议

### 6.1 常用类型类速查表

| 类型类 | 用途 | 关键函数 |
|:------:|:-----|:---------|
| `Eq` | 相等性比较 | `==`, `/=` |
| `Ord` | 顺序比较 | `<`, `>`, `compare` |
| `Show` | 转字符串 | `show` |
| `Read` | 从字符串解析 | `read` |
| `Enum` | 可枚举 | `succ`, `pred`, `[Low..High]` |
| `Bounded` | 有界类型 | `minBound`, `maxBound` |
| `Functor` | 可映射 | `fmap`, `<$>` |
| `Applicative` | 组合计算 | `pure`, `<*>` |
| `Monad` | 链式计算 | `return`, `>>=`, `do` |

### 6.2 什么时候定义自己的类型类？

**大多数情况下，不需要！**

✅ **使用已有的类型类**：
- 99% 的情况只需要实现实例
- 标准库类型类已经够用

❌ **不要定义新类型类，如果**：
- 只有一两个类型会实现它
- 可以用普通函数解决
- 不确定是否需要

✅ **可以定义新类型类，如果**：
- 需要跨多个类型的抽象
- 库作者定义通用接口
- 高级抽象（如 Serializable、Parseable）

### 6.3 调试技巧

**使用 GHCi 探索类型类**：

```haskell
-- 查看类型的类型类
ghci> :info Int
-- 会显示 Int 实现了哪些类型类

-- 查看类型类的定义
ghci> :info Functor
-- 显示 Functor 的方法和实例

-- 查看函数的类型约束
ghci> :type fmap
fmap :: Functor f => (a -> b) -> f a -> f b
```

**常见编译错误**：

```haskell
-- 错误：No instance for (Show a)
ghci> show [1,2,3]
-- 需要确保类型实现了 Show

-- 错误：Ambiguous type
ghci> read "5"
-- 需要类型注解：read "5" :: Int
```

### 6.4 学习路径建议

1. **第一遍**：理解 Eq、Ord、Show，会用 deriving
2. **第二遍**：掌握 Functor 和 `<$>` 运算符
3. **第三遍**：Applicative 的基本用法
4. **第四遍**：Monad 的 do 记法（深入理解留到 Week 4）

### 6.5 下一步

完成本周练习后，你应该：
- ✅ 能够为自定义类型实现基本类型类
- ✅ 理解 Functor 的"盒子"思维
- ✅ 会用 `<$>` 和 `<*>` 组合函数
- ✅ 会用 do 记法处理 Maybe 和 List

**准备好了？** 前往 [练习作业](exercises.md) 巩固所学 →

---

## 📚 本章总结

**类型类是 Haskell 的核心特性**：
- **Eq/Ord/Show** - 基础类型类，用 deriving 自动生成
- **Functor** - "不拆盒子"的映射，用 `fmap`/`<$>`
- **Applicative** - 组合多个计算，用 `pure`/`<*>`
- **Monad** - 链式计算，用 `do` 记法（Week 4 详解）

**学习建议**：
1. 多在 GHCi 中实验
2. 先会用，再理解原理
3. Monad 不要急，Week 4 会详细讲解
4. 完成练习是关键！

---

**继续前进：** [练习作业](exercises.md) →

