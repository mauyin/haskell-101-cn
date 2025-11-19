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

## 4. 递归

### 4.1 递归思维

递归是函数式编程的核心。一个递归函数需要两部分：

1. **基础情况** (base case) - 何时停止
2. **递归情况** (recursive case) - 如何缩小问题

### 4.2 简单递归示例

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

### 4.3 更多递归示例

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

## 5. 高阶函数

### 5.1 什么是高阶函数？

**高阶函数**是可以接受函数作为参数或返回函数的函数。

听起来复杂？看例子就明白了！

### 5.2 map - 映射

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

-- 示例：转换为大写
ghci> map toUpper "hello"
"HELLO"
```

**手动实现 map**：
```haskell
myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs
```

### 5.3 filter - 过滤

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

-- 示例：只保留大写字母
ghci> filter isUpper "Hello World"
"HW"
```

**手动实现 filter**：
```haskell
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p [] = []
myFilter p (x:xs)
  | p x       = x : myFilter p xs    -- 如果满足条件，保留
  | otherwise = myFilter p xs        -- 否则跳过
```

### 5.4 fold - 折叠

`fold` 是最强大的列表函数，可以"折叠"整个列表为一个值：

#### foldr - 从右往左折叠

```haskell
-- 类型签名
foldr :: (a -> b -> b) -> b -> [a] -> b
--       ^^^^^^^^^^^^    ^    ^^^    ^
--       折叠函数      初始值  列表  结果

-- 示例：求和
ghci> foldr (+) 0 [1,2,3,4]
10

-- 执行过程：
-- foldr (+) 0 [1,2,3,4]
-- = 1 + (2 + (3 + (4 + 0)))
-- = 10

-- 示例：求积
ghci> foldr (*) 1 [1,2,3,4]
24

-- 示例：拼接字符串
ghci> foldr (++) "" ["Hello", " ", "World"]
"Hello World"
```

#### foldl - 从左往右折叠

```haskell
-- 类型签名
foldl :: (b -> a -> b) -> b -> [a] -> b

-- 示例：求和
ghci> foldl (+) 0 [1,2,3,4]
10

-- 执行过程：
-- foldl (+) 0 [1,2,3,4]
-- = (((0 + 1) + 2) + 3) + 4
-- = 10
```

### 5.5 组合使用

高阶函数可以组合使用，非常强大：

```haskell
-- 计算偶数的平方和
ghci> sum (map (^2) (filter even [1..10]))
220

-- 执行过程：
-- 1. filter even [1..10] => [2,4,6,8,10]
-- 2. map (^2) [2,4,6,8,10] => [4,16,36,64,100]
-- 3. sum [4,16,36,64,100] => 220
```

---

## 6. Lambda 表达式

### 6.1 什么是 Lambda？

Lambda 表达式是**匿名函数** - 没有名字的函数。

### 6.2 语法

```haskell
-- 普通函数
double :: Int -> Int
double x = x * 2

-- Lambda 表达式（匿名函数）
\x -> x * 2
```

`\` 表示 lambda (看起来像希腊字母 λ)

### 6.3 使用场景

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

### 6.4 何时使用 Lambda？

✅ **适合使用 lambda**：
- 函数很简单
- 只用一次
- 在高阶函数中当场定义

❌ **不适合使用 lambda**：
- 函数复杂
- 会重复使用
- 需要给函数起个有意义的名字

---

## 7. 部分应用

### 7.1 柯里化的威力

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

### 7.2 更多示例

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

## 8. 综合示例

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

## 9. 常见错误和调试

### 9.1 类型错误

```haskell
-- 错误：类型不匹配
ghci> head 5
Error: Couldn't match expected type '[a]' with actual type 'Integer'

-- 解释：head 期待一个列表，但你给了一个数字
```

### 9.2 无穷递归

```haskell
-- 危险！没有基础情况
badLength :: [a] -> Int
badLength (x:xs) = 1 + badLength xs

-- 会无限递归！总是记得写基础情况
```

### 9.3 使用 :type 调试

```haskell
ghci> :type map
map :: (a -> b) -> [a] -> [b]

ghci> :type filter
filter :: (a -> Bool) -> [a] -> [a]

ghci> :type foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

---

## 10. 本周总结

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

