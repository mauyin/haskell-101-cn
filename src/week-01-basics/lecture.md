# Week 1: Haskell 基础语法 - 详细讲义

> 💡 **自学提示**: 这一周内容较多，建议分 2-3 天完成。不要着急，慢慢来！如果某个概念不理解，先跳过继续往下看，后面会逐渐清晰。

---

## 1. 函数和类型签名

### 1.1 第一个函数

Haskell 中，函数定义非常简洁：

```haskell
-- 定义一个简单的加法函数
add :: Int -> Int -> Int
add x y = x + y
```

让我们分解一下：

1. **类型签名** (第一行): `add :: Int -> Int -> Int`
   - `add` 是函数名
   - `::` 读作"的类型是"
   - `Int -> Int -> Int` 表示"接受两个 Int，返回一个 Int"

2. **函数体** (第二行): `add x y = x + y`
   - `x` 和 `y` 是参数
   - `= x + y` 是函数的实现

### 1.2 在 GHCi 中测试

```haskell
ghci> :load Week01.hs
ghci> add 3 5
8
ghci> add 10 20
30
```

### 1.3 类型签名的重要性

虽然 Haskell 可以自动推断类型，但**强烈建议总是写类型签名**：

❌ **不推荐**（没有类型签名）:
```haskell
double x = x * 2
```

✅ **推荐**（有类型签名）:
```haskell
double :: Int -> Int
double x = x * 2
```

**为什么？**
- 类型签名是最好的文档
- 帮助编译器更早发现错误
- 让代码更易读

### 💭 常见困惑

**"为什么是 `Int -> Int -> Int` 而不是 `(Int, Int) -> Int`?"**

这是因为 Haskell 的**柯里化**（Currying）。每个函数实际上只接受一个参数：

```haskell
add :: Int -> (Int -> Int)
--    ^^^^    ^^^^^^^^^^
--    参数1    返回一个函数
```

现在不完全理解也没关系，继续往下看！

---

## 2. 列表操作

### 2.1 列表基础

列表是 Haskell 中最常用的数据结构：

```haskell
-- 定义列表
numbers :: [Int]
numbers = [1, 2, 3, 4, 5]

words :: [String]
words = ["hello", "world"]

-- 空列表
empty :: [Int]
empty = []
```

### 2.2 列表构造

使用 `:` (cons) 运算符构造列表：

```haskell
-- 在列表前面添加元素
ghci> 1 : [2, 3, 4]
[1,2,3,4]

ghci> 'H' : "ello"
"Hello"

-- 多次使用 cons
ghci> 1 : 2 : 3 : []
[1,2,3]
```

> 💡 **重要**：`[1,2,3]` 其实是 `1:2:3:[]` 的语法糖！

### 2.3 列表操作符

```haskell
-- 拼接列表
ghci> [1, 2] ++ [3, 4]
[1,2,3,4]

-- 获取元素
ghci> [1,2,3,4] !! 0    -- 第一个元素（从 0 开始）
1

ghci> head [1,2,3]      -- 第一个元素
1

ghci> tail [1,2,3]      -- 除了第一个的其他元素
[2,3]

ghci> last [1,2,3]      -- 最后一个元素
3

ghci> init [1,2,3]      -- 除了最后一个的其他元素
[1,2]
```

### 2.4 列表范围

```haskell
-- 简单范围
ghci> [1..10]
[1,2,3,4,5,6,7,8,9,10]

-- 带步长的范围
ghci> [1,3..10]
[1,3,5,7,9]

-- 无限列表（Haskell 是惰性求值的！）
ghci> take 5 [1..]
[1,2,3,4,5]
```

### 2.5 常用列表函数

```haskell
ghci> length [1,2,3,4]
4

ghci> reverse [1,2,3]
[3,2,1]

ghci> sum [1,2,3,4]
10

ghci> product [1,2,3,4]
24

ghci> maximum [3,1,4,1,5]
5

ghci> minimum [3,1,4,1,5]
1
```

---

## 3. 模式匹配

### 3.1 什么是模式匹配？

模式匹配是 Haskell 的强大特性，可以根据值的"形状"执行不同的代码：

```haskell
-- 判断列表是否为空
isEmpty :: [a] -> Bool
isEmpty [] = True          -- 空列表的情况
isEmpty _  = False         -- 其他情况（_ 表示任意值）
```

### 3.2 列表模式匹配

```haskell
-- 获取列表的第一个元素（手动实现 head）
first :: [a] -> a
first (x:xs) = x
--     ^  ^^
--     |  剩余部分
--     第一个元素

-- 获取前两个元素的和
sumFirstTwo :: [Int] -> Int
sumFirstTwo (x:y:rest) = x + y
sumFirstTwo [x] = x            -- 只有一个元素
sumFirstTwo [] = 0             -- 空列表
```

### 3.3 数字模式匹配

```haskell
-- 计算阶乘
factorial :: Int -> Int
factorial 0 = 1                    -- 基础情况
factorial n = n * factorial (n-1)  -- 递归情况

-- 实数检查
tellNumber :: Int -> String
tellNumber 1 = "One"
tellNumber 2 = "Two"
tellNumber 3 = "Three"
tellNumber _ = "Many"
```

---

## 4. Guards（守卫）- 条件判断

### 4.1 什么是 Guards？

Guards 让你根据条件执行不同的代码分支，类似于其他语言的 if-else，但更优雅：

```haskell
-- 使用 guards 判断数字的符号
signOf :: Int -> String
signOf n
  | n < 0     = "负数"
  | n == 0    = "零"
  | n > 0     = "正数"
  | otherwise = "不可能到达这里"
```

### 4.2 Guards 语法

```haskell
functionName parameter
  | condition1 = result1
  | condition2 = result2
  | condition3 = result3
  | otherwise  = defaultResult
```

- `|` 后面跟一个布尔表达式（条件）
- `=` 后面是这个条件为真时的结果
- `otherwise` 是一个特殊的"总是真"的条件（相当于 `True`）

### 4.3 实用示例

```haskell
-- 计算绝对值
abs' :: Int -> Int
abs' n
  | n < 0     = -n
  | otherwise = n

-- 判断成绩等级
gradeToLevel :: Int -> String
gradeToLevel score
  | score >= 90 = "优秀"
  | score >= 80 = "良好"
  | score >= 60 = "及格"
  | otherwise   = "不及格"

-- 比较两个数
compare' :: Int -> Int -> String
compare' x y
  | x > y     = "第一个更大"
  | x < y     = "第二个更大"
  | otherwise = "两个相等"
```

### 4.4 Guards vs 模式匹配

**模式匹配**：根据值的结构/形状

```haskell
isEmpty :: [a] -> Bool
isEmpty [] = True     -- 匹配空列表的"形状"
isEmpty _  = False    -- 匹配其他任何东西
```

**Guards**：根据条件（布尔表达式）

```haskell
isLongList :: [a] -> Bool
isLongList xs
  | length xs > 10 = True   -- 根据条件判断
  | otherwise      = False
```

💡 **选择建议**：
- 检查值的结构 → 用模式匹配
- 比较大小、范围判断 → 用 guards
- 两者可以组合使用！

```haskell
-- 组合使用模式匹配和 guards
describe :: [Int] -> String
describe []  = "空列表"                    -- 模式匹配
describe [x]                               -- 模式匹配
  | x > 0     = "单个正数"                 -- guards
  | otherwise = "单个非正数"
describe xs                                -- 模式匹配
  | length xs > 10 = "很长的列表"          -- guards
  | otherwise      = "普通列表"
```

---

## 5. 递归

### 5.1 递归思维

递归是函数式编程的核心。一个递归函数需要两部分：

1. **基础情况** (base case) - 何时停止
2. **递归情况** (recursive case) - 如何缩小问题

### 5.2 简单递归示例

```haskell
-- 计算列表长度
myLength :: [a] -> Int
myLength [] = 0                    -- 基础情况：空列表长度为 0
myLength (x:xs) = 1 + myLength xs  -- 递归：1 + 剩余列表的长度
```

**执行过程**：
```haskell
myLength [1,2,3]
= 1 + myLength [2,3]
= 1 + (1 + myLength [3])
= 1 + (1 + (1 + myLength []))
= 1 + (1 + (1 + 0))
= 3
```

### 5.3 更多递归示例

```haskell
-- 求和
mySum :: [Int] -> Int
mySum [] = 0
mySum (x:xs) = x + mySum xs

-- 翻转列表
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

-- 计算最大值
myMax :: [Int] -> Int
myMax [x] = x                           -- 只有一个元素
myMax (x:xs) = max x (myMax xs)        -- 比较第一个和剩余的最大值
```

### 💭 常见困惑

**"为什么不用 for 循环？"**

Haskell 是纯函数式语言，没有传统的循环。但递归可以做同样的事情，而且更符合数学思维：

```python
# Python 的循环
def sum_list(lst):
    result = 0
    for x in lst:
        result += x
    return result
```

```haskell
-- Haskell 的递归
sumList :: [Int] -> Int
sumList [] = 0
sumList (x:xs) = x + sumList xs
```

递归版本更接近数学定义："列表的和 = 第一个元素 + 剩余元素的和"

---

## 6. 高阶函数

### 6.1 什么是高阶函数？

**高阶函数**是可以接受函数作为参数或返回函数的函数。

听起来复杂？看例子就明白了！

### 6.2 map - 映射

`map` 对列表的每个元素应用一个函数：

```haskell
-- 类型签名
map :: (a -> b) -> [a] -> [b]
--     ^^^^^^^    ^^^    ^^^
--     函数      输入列表  输出列表

-- 示例：所有元素翻倍
ghci> map (*2) [1,2,3,4]
[2,4,6,8]

-- 示例：所有元素平方
ghci> map (^2) [1,2,3,4]
[1,4,9,16]

-- 示例：判断是否为偶数
ghci> map even [1,2,3,4]
[False,True,False,True]
```

**手动实现 map**：
```haskell
myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs
```

### 6.3 filter - 过滤

`filter` 保留满足条件的元素：

```haskell
-- 类型签名
filter :: (a -> Bool) -> [a] -> [a]
--        ^^^^^^^^^^    ^^^    ^^^
--        判断函数    输入列表  输出列表

-- 示例：只保留偶数
ghci> filter even [1,2,3,4,5,6]
[2,4,6]

-- 示例：只保留大于 5 的数
ghci> filter (>5) [3,7,2,9,1,8]
[7,9,8]

-- 示例：只保留正数
ghci> filter (>0) [-3, 5, -1, 7, 0, 2]
[5,7,2]
```

**手动实现 filter**：
```haskell
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p [] = []
myFilter p (x:xs)
  | p x       = x : myFilter p xs    -- 如果满足条件，保留
  | otherwise = myFilter p xs        -- 否则跳过
```

### 6.4 fold - 折叠（分步理解）

`fold` 是最强大的列表函数，可以"折叠"整个列表为一个值。

💡 **学习提示**：fold 是本周最难的概念之一，慢慢来，多看几遍示例！

#### 步骤 1：理解"折叠"的想法

想象你有一个列表，要把它"折叠"成单个值：
- `[1,2,3,4]` 折叠成 `10` (求和)
- `["hello", "world"]` 折叠成 `"helloworld"` (拼接)
- `[True, False, True]` 折叠成 `False` (逻辑与)

#### 步骤 2：理解 foldr 的三个参数

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
--       ^^^^^^^^^^^^^    ^    ^^^    ^
--       1. 折叠函数      2. 初始值  3. 列表  4. 结果
```

让我们逐个理解：

1. **折叠函数** `(a -> b -> b)`: 如何组合一个元素和累积值
2. **初始值** `b`: 从什么开始累积（空列表时的答案）
3. **列表** `[a]`: 要处理的数据
4. **结果** `b`: 最终的累积值

#### 步骤 3：最简单的例子 - 求和

```haskell
-- 手动实现求和（没有 fold）
sumManual :: [Int] -> Int
sumManual [] = 0              -- 空列表的和是 0
sumManual (x:xs) = x + sumManual xs

-- 使用 foldr（等价！）
sumWithFold :: [Int] -> Int
sumWithFold xs = foldr (+) 0 xs
--                      ^   ^
--                      |   初始值：从 0 开始
--                      折叠函数：把元素加到累积值上
```

**详细执行过程**（重要！）:
```haskell
foldr (+) 0 [1,2,3]

-- foldr 从右边开始处理：
-- [1,2,3] 其实是 1 : 2 : 3 : []
-- 用 (+) 替换 (:)，用 0 替换 []：
= 1 + (2 + (3 + 0))   -- 从右往左"折叠"
= 1 + (2 + 3)
= 1 + 5
= 6
```

#### 步骤 4：另一个例子 - 列表拼接

```haskell
-- 任务：连接所有字符串
words = ["Hello", " ", "World"]

-- 使用 foldr
ghci> foldr (++) "" ["Hello", " ", "World"]
"Hello World"

-- 执行过程：
-- foldr (++) "" ["Hello", " ", "World"]
= "Hello" ++ (" " ++ ("World" ++ ""))
= "Hello" ++ (" " ++ "World")
= "Hello" ++ " World"
= "Hello World"
```

#### 步骤 5：理解初始值的选择

初始值很重要！它应该是"什么都不做"的值：

```haskell
-- 加法：0 是加法的"什么都不做"的值
foldr (+) 0 [1,2,3]  -- 0 + 任何数 = 那个数

-- 乘法：1 是乘法的"什么都不做"的值
foldr (*) 1 [2,3,4]  -- 1 * 任何数 = 那个数

-- 字符串拼接："" 是拼接的"什么都不做"的值
foldr (++) "" ["a","b"]  -- "" ++ 任何字符串 = 那个字符串
```

#### foldr - 完整说明

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b

-- 更多示例
ghci> foldr (+) 0 [1,2,3,4]
10

ghci> foldr (*) 1 [1,2,3,4]
24

ghci> foldr (++) "" ["Hello", " ", "World"]
"Hello World"
```

💡 **记忆技巧**: foldr 从右(right)开始，就像从列表末尾往前"折"

#### foldl - 从左往右折叠

```haskell
-- 类型签名（注意参数顺序不同！）
foldl :: (b -> a -> b) -> b -> [a] -> b
--       ^^ 累积值在前！

-- 示例：求和
ghci> foldl (+) 0 [1,2,3,4]
10

-- 执行过程：
-- foldl (+) 0 [1,2,3,4]
= (((0 + 1) + 2) + 3) + 4   -- 从左往右
= ((1 + 2) + 3) + 4
= (3 + 3) + 4
= 6 + 4
= 10
```

#### foldr vs foldl - 何时使用？

**初学者建议**：大多数情况用 `foldr`，它更符合 Haskell 的惰性求值特性。

- **foldr**: 对无限列表友好，可以提前终止
- **foldl**: 需要遍历整个列表，但有时更高效

```haskell
-- foldr 可以处理无限列表（如果函数可以提前终止）
ghci> foldr (||) False [False, True, undefined]
True  -- 找到 True 就停止了

-- foldl 会先遍历整个列表
ghci> foldl (||) False [False, True, undefined]
*** Exception: Prelude.undefined  -- 出错！
```

💭 **现在不理解也没关系**，先会用 foldr 求和、求积就够了！

### 6.5 组合使用高阶函数（重要！）

高阶函数的真正威力在于组合使用。让我们一步步构建：

#### 例子 1：计算所有字符串的总长度

```haskell
-- 任务：计算所有字符串的总长度
words = ["hello", "world", "!"]

-- 第 1 步：把每个字符串变成它的长度
ghci> map length ["hello", "world", "!"]
[5,5,1]

-- 第 2 步：把所有长度加起来
ghci> sum [5,5,1]
11

-- 组合起来：
ghci> sum (map length ["hello", "world", "!"])
11
```

**阅读顺序**：从内往外读
1. 最内层 `map length ["hello", "world", "!"]` 先执行
2. 结果 `[5,5,1]` 传给 `sum`

#### 例子 2：偶数的平方

```haskell
-- 任务：找出所有偶数，然后平方
numbers = [1,2,3,4,5]

-- 第 1 步：filter even
ghci> filter even [1,2,3,4,5]
[2,4]

-- 第 2 步：map (^2)
ghci> map (^2) [2,4]
[4,16]

-- 组合：
ghci> map (^2) (filter even [1,2,3,4,5])
[4,16]
```

#### 例子 3：综合应用

```haskell
-- 计算偶数的平方和
ghci> sum (map (^2) (filter even [1..10]))
220

-- 执行过程（从内往外）：
-- 1. filter even [1..10] => [2,4,6,8,10]
-- 2. map (^2) [2,4,6,8,10] => [4,16,36,64,100]
-- 3. sum [4,16,36,64,100] => 220
```

💡 **组合技巧**：
1. 先在 GHCi 中单独测试每一步
2. 确认每步的输出是下一步的正确输入
3. 最后组合起来

---

## 7. Lambda 表达式

### 7.1 什么是 Lambda？

Lambda 表达式是**匿名函数** - 没有名字的函数。

### 7.2 语法

```haskell
-- 普通函数
double :: Int -> Int
double x = x * 2

-- Lambda 表达式（匿名函数）
\x -> x * 2
```

`\` 表示 lambda (看起来像希腊字母 λ)

### 7.3 使用场景

Lambda 常用于高阶函数：

```haskell
-- 使用 lambda
ghci> map (\x -> x * 2) [1,2,3]
[2,4,6]

-- 等价于定义一个函数
ghci> map double [1,2,3]
[2,4,6]

-- 多个参数的 lambda
ghci> foldr (\x acc -> x + acc) 0 [1,2,3,4]
10

-- 过滤大于 5 的数
ghci> filter (\x -> x > 5) [3,7,2,9,1]
[7,9]
```

### 7.4 何时使用 Lambda？

✅ **适合使用 lambda**：
- 函数很简单
- 只用一次
- 在高阶函数中当场定义

❌ **不适合使用 lambda**：
- 函数复杂
- 会重复使用
- 需要给函数起个有意义的名字

---

## 8. 部分应用

### 8.1 柯里化的威力

还记得之前提到的柯里化吗？现在是时候理解它了：

```haskell
-- 这个函数
add :: Int -> Int -> Int
add x y = x + y

-- 可以部分应用
addFive :: Int -> Int
addFive = add 5    -- 只提供第一个参数

ghci> addFive 3
8
ghci> addFive 10
15
```

### 8.2 更多示例

```haskell
-- 部分应用 map
ghci> let doubleAll = map (*2)
ghci> doubleAll [1,2,3]
[2,4,6]

-- 部分应用 filter
ghci> let onlyPositive = filter (>0)
ghci> onlyPositive [-2, 3, -1, 5]
[3,5]

-- 部分应用运算符
ghci> let addTen = (+10)
ghci> addTen 5
15
```

---

## 9. 综合示例

让我们用本周学到的知识解决一个实际问题：

**问题**：找出 1-100 中所有偶数的平方和

### 解法 1：递归

```haskell
sumEvenSquares :: Int -> Int -> Int
sumEvenSquares start end
  | start > end = 0
  | even start  = start^2 + sumEvenSquares (start+1) end
  | otherwise   = sumEvenSquares (start+1) end

ghci> sumEvenSquares 1 100
171700
```

### 解法 2：高阶函数（更优雅！）

```haskell
sumEvenSquares :: Int -> Int -> Int
sumEvenSquares start end =
  sum (map (^2) (filter even [start..end]))

ghci> sumEvenSquares 1 100
171700
```

---

## 10. 调试技巧 - 自学者必备

作为自学者，学会调试是非常重要的技能！这一节会帮你快速定位和解决问题。

### 10.1 看懂类型错误

这是最常见的错误类型。GHC 的错误信息虽然详细，但初学者可能觉得难懂。

#### 错误示例 1：类型不匹配

```haskell
-- 错误代码
ghci> head 5

-- 错误信息
• Couldn't match expected type '[a]' with actual type 'Integer'
• In the first argument of 'head', namely '5'
```

**如何理解**：
- `expected type '[a]'`: GHC 期望一个列表
- `actual type 'Integer'`: 但你给了一个整数
- `In the first argument`: 错误发生在第一个参数

**解决方法**：
```haskell
ghci> head [5]  -- 正确：给 head 一个列表
5
```

#### 错误示例 2：函数应用错误

```haskell
-- 错误代码
ghci> map [1,2,3] (*2)

-- 错误信息
• Couldn't match expected type 'a -> b'
  with actual type '[Integer]'
```

**如何理解**：
- `map` 期望第一个参数是函数 `(a -> b)`
- 但你给了一个列表 `[Integer]`

**解决方法**：
```haskell
ghci> map (*2) [1,2,3]  -- 正确：参数顺序对调
[2,4,6]
```

#### 错误示例 3：运算符类型不匹配

```haskell
-- 错误代码
ghci> "hello" + "world"

-- 错误信息
• No instance for (Num [Char]) arising from a use of '+'
```

**如何理解**：
- `+` 用于数字，不能用于字符串
- `Num [Char]` 表示 GHC 想把字符串当作数字，但做不到

**解决方法**：
```haskell
ghci> "hello" ++ "world"  -- 正确：字符串用 ++ 拼接
"helloworld"
```

### 10.2 无穷递归（程序卡住）

#### 症状
程序一直运行，按 `Ctrl+C` 才能停止

#### 原因
忘记写基础情况 (base case)

```haskell
-- ❌ 危险！会无限递归
badSum :: [Int] -> Int
badSum (x:xs) = x + badSum xs  -- 没有处理空列表！

-- 会发生什么：
-- badSum [1,2,3]
-- = 1 + badSum [2,3]
-- = 1 + 2 + badSum [3]
-- = 1 + 2 + 3 + badSum []
-- = 1 + 2 + 3 + (badSum [] 的第一个元素) -- 💥 错误！空列表没有第一个元素
```

```haskell
-- ✅ 正确：总是要有基础情况
goodSum :: [Int] -> Int
goodSum [] = 0                  -- 基础情况：空列表的和是 0
goodSum (x:xs) = x + goodSum xs -- 递归情况
```

#### 调试技巧
如果程序卡住了：
1. 检查是否有基础情况
2. 检查递归是否真的在"缩小"问题
3. 用小数据测试（如 `[1]` 或 `[1,2]`）

### 10.3 模式匹配不完整

```haskell
-- ⚠️ 警告：模式匹配不完整
firstTwo :: [a] -> (a, a)
firstTwo (x:y:_) = (x, y)

-- 如果列表少于 2 个元素会怎样？
ghci> firstTwo [1]
*** Exception: Non-exhaustive patterns in function firstTwo
```

**解决方法**：处理所有可能的情况
```haskell
firstTwo :: [a] -> Maybe (a, a)
firstTwo (x:y:_) = Just (x, y)
firstTwo _       = Nothing  -- 处理其他所有情况
```

### 10.4 使用 GHCi 调试工具

#### :type - 查看类型

```haskell
ghci> :type map
map :: (a -> b) -> [a] -> [b]

ghci> :type filter
filter :: (a -> Bool) -> [a] -> [a]

ghci> :type foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b

-- 查看表达式的类型
ghci> :type filter even
filter even :: Integral a => [a] -> [a]
```

💡 **技巧**：不确定类型时，先用 `:type` 查看！

#### :info - 查看详细信息

```haskell
ghci> :info map
map :: (a -> b) -> [a] -> [b]   -- 定义在 GHC.Base

ghci> :info even
even :: Integral a => a -> Bool -- 定义在 GHC.Real
```

#### :load 和 :reload - 加载文件

```haskell
ghci> :load MyFile.hs
[1 of 1] Compiling Main             ( MyFile.hs, interpreted )
Ok, one module loaded.

-- 修改文件后重新加载
ghci> :reload
[1 of 1] Compiling Main             ( MyFile.hs, interpreted )
Ok, one module loaded.

-- 简写
ghci> :l MyFile.hs
ghci> :r
```

### 10.5 分步调试

当复杂表达式出错时，分步执行可以帮助找到问题：

```haskell
-- 复杂表达式
ghci> sum (map (^2) (filter even [1..10]))
220

-- 分步执行
ghci> let step1 = filter even [1..10]
ghci> step1
[2,4,6,8,10]

ghci> let step2 = map (^2) step1
ghci> step2
[4,16,36,64,100]

ghci> sum step2
220
```

💡 **技巧**：从内往外，一步步测试每个部分

### 10.6 常见陷阱

#### 陷阱 1：忘记括号

```haskell
-- ❌ 错误
ghci> head tail [1,2,3]
-- GHC 理解为: head(tail, [1,2,3])，参数太多了！

-- ✅ 正确
ghci> head (tail [1,2,3])
2
```

#### 陷阱 2：混淆 `:` 和 `++`

```haskell
-- : 用于添加单个元素到列表前面
ghci> 1 : [2,3]
[1,2,3]

-- ++ 用于连接两个列表
ghci> [1] ++ [2,3]
[1,2,3]

-- ❌ 错误
ghci> 1 ++ [2,3]
-- 错误：++ 需要两个列表
```

#### 陷阱 3：整数除法

```haskell
-- / 用于浮点数除法
ghci> 10 / 3
3.3333333333333335

-- div 用于整数除法
ghci> 10 `div` 3
3

-- ❌ 常见错误
ghci> 10 / 3 :: Int
-- 错误：/ 返回浮点数，不能转换为 Int
```

### 10.7 调试策略总结

当遇到错误时，按这个顺序尝试：

1. **读错误信息** - 仔细看 GHC 告诉你什么
2. **检查类型** - 用 `:type` 确认函数和参数的类型
3. **简化问题** - 用最小的测试用例（如 `[1]` 或 `[1,2]`）
4. **分步执行** - 把复杂表达式拆开，逐个测试
5. **检查基础情况** - 确保递归有停止条件
6. **查看示例** - 回顾讲义中的类似例子

💡 **记住**：每个人都会遇到错误，关键是学会如何快速找到和修复！

---

## 11. 本周总结

### 你学会了：

✅ **函数和类型签名** - Haskell 代码的基础  
✅ **列表操作** - 最常用的数据结构  
✅ **递归** - 函数式编程的核心思维  
✅ **高阶函数** - map、filter、fold 的强大之处  
✅ **Lambda 表达式** - 匿名函数的使用  
✅ **部分应用** - 柯里化的实际应用  

### 关键概念

1. **函数是一等公民** - 可以作为参数和返回值
2. **模式匹配** - 根据值的结构执行不同代码
3. **递归代替循环** - 更符合数学思维
4. **组合胜于命令** - map + filter + fold 组合使用

---

## 练习时间

准备好测试你的理解了吗？

前往 [练习作业](exercises.md) 完成本周练习！

记住：
- 完成至少 80% 的练习
- 在 GHCi 中测试每个函数
- 遇到困难查看参考答案
- 不理解的地方多实验几次

**加油！** 💪

