# Week 0 - 练习 2: GHCi 操作练习（参考答案）

## 第 1 部分：基本计算

### 1.1 算术运算

```haskell
ghci> 7 + 3
10

ghci> 20 - 8
12

ghci> 6 * 7
42

ghci> 100 / 4
25.0

ghci> div 17 5
3

ghci> mod 17 5
2

ghci> 2 ^ 8
256
```

**注意**：`/` 是浮点除法，返回 `Double` 类型；`div` 是整数除法。

### 1.2 布尔运算

```haskell
ghci> True && False
False

ghci> True || False
True

ghci> not True
False

ghci> 5 > 3
True

ghci> 10 == 10
True

ghci> "hello" == "world"
False
```

---

## 第 2 部分：类型查询

```haskell
ghci> :type 42
42 :: Num p => p

ghci> :type 3.14
3.14 :: Fractional p => p

ghci> :type True
True :: Bool

ghci> :type 'a'
'a' :: Char

ghci> :type "Hello"
"Hello" :: String

ghci> :type (1, "hello")
(1, "hello") :: Num a => (a, String)

ghci> :type [1, 2, 3]
[1, 2, 3] :: Num a => [a]
```

**思考题答案**：

`42` 的类型是 `Num p => p`，这叫做"多态数字常量"。它意味着 `42` 可以是任何实现了 `Num` 类型类的类型，比如 `Int`、`Integer`、`Double` 等。这让 Haskell 的数字使用更灵活。

---

## 第 3 部分：列表操作

```haskell
ghci> [1, 2, 3] ++ [4, 5, 6]
[1,2,3,4,5,6]

ghci> 0 : [1, 2, 3]
[0,1,2,3]

ghci> head [1, 2, 3, 4]
1

ghci> tail [1, 2, 3, 4]
[2,3,4]

ghci> length [1, 2, 3, 4, 5]
5

ghci> reverse [1, 2, 3]
[3,2,1]

ghci> take 3 [1, 2, 3, 4, 5]
[1,2,3]

ghci> drop 2 [1, 2, 3, 4, 5]
[3,4,5]
```

**关键点**：
- `++` 连接两个列表
- `:` (cons) 在列表头部添加元素
- `head` 和 `tail` 分别返回首元素和剩余元素

---

## 第 4 部分：字符串操作

```haskell
ghci> "Hello" ++ " " ++ "World"
"Hello World"

ghci> reverse "Haskell"
"lleksaH"

ghci> head "Haskell"
'H'

ghci> tail "Haskell"
"askell"

ghci> length "你好，世界！"
6
```

**注意**：中文字符每个算一个字符，`length` 返回字符数量。

---

## 第 5 部分：函数定义

```haskell
ghci> let triple x = x * 3
ghci> triple 5
15

ghci> let greet name = "Hello, " ++ name
ghci> greet "Haskell"
"Hello, Haskell"

ghci> let isLarge n = n > 100
ghci> isLarge 50
False

ghci> isLarge 150
True
```

---

## 第 6 部分：加载文件

```haskell
ghci> :load exercise-01-hello.hs
[1 of 1] Compiling Exercise01       ( exercise-01-hello.hs, interpreted )
Ok, one module loaded.

ghci> sayHello "世界"
"你好，世界！"

ghci> double 7
14

ghci> isEven 10
True
```

如果看到类型错误或其他编译错误，回到文件修改，然后用 `:reload` 重新加载。

---

## 第 7 部分：信息查询

```haskell
ghci> :info Bool
type Bool :: *
data Bool = False | True
  	-- Defined in 'GHC.Types'
instance Eq Bool -- Defined in 'GHC.Classes'
instance Ord Bool -- Defined in 'GHC.Classes'
... (还有更多实例)

ghci> :info Int
type Int :: *
data Int = GHC.Types.I# GHC.Prim.Int#
  	-- Defined in 'GHC.Types'
instance Eq Int -- Defined in 'GHC.Classes'
... (还有更多实例)

ghci> :info head
head :: GHC.Stack.Types.HasCallStack => [a] -> a
  	-- Defined in 'GHC.List'
```

**解读**：
- `data Bool = False | True` 表示 Bool 有两个值：False 和 True
- `instance Eq Bool` 表示 Bool 实现了 Eq 类型类（可以比较相等性）
- `head :: [a] -> a` 表示 head 接受任意类型的列表，返回该类型的元素

---

## 第 8 部分：浏览模块（可选挑战）

```haskell
ghci> :browse Prelude
-- 输出示例（前 10 个）：
1. (&&) :: Bool -> Bool -> Bool
2. (||) :: Bool -> Bool -> Bool
3. not :: Bool -> Bool
4. (++) :: [a] -> [a] -> [a]
5. head :: [a] -> a
6. tail :: [a] -> [a]
7. length :: Foldable t => t a -> Int
8. map :: (a -> b) -> [a] -> [b]
9. filter :: (a -> Bool) -> [a] -> [a]
10. foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

---

## 第 9 部分：错误探索

```haskell
ghci> head []
*** Exception: Prelude.head: empty list

ghci> 5 / 0
Infinity

ghci> "hello" + "world"
<interactive>:1:1: error:
    • No instance for (Num String) arising from a use of '+'
    • In the expression: "hello" + "world"
```

**思考题答案**：

字符串不能用 `+` 连接是因为 `+` 是 `Num` 类型类的操作符，用于数字相加。字符串应该用 `++` 连接。

**关键错误类型**：
1. **运行时错误**：`head []` - 对空列表调用 head
2. **特殊值**：`5 / 0` - 返回 `Infinity`（浮点数特性）
3. **类型错误**：`"hello" + "world"` - 编译期就会被捕获

---

## 完成检查清单

完成后，检查你是否：

- [x] 能够启动 GHCi
- [x] 能够在 GHCi 中进行基本计算
- [x] 能够使用 `:type` 查看类型
- [x] 能够使用 `:info` 查看信息
- [x] 能够在 GHCi 中定义简单函数（使用 `let`）
- [x] 能够加载外部 `.hs` 文件
- [x] 能够使用 `:reload` 重新加载文件
- [x] 理解基本的错误信息
- [x] 能够退出 GHCi

---

## 学习要点总结

从这个练习中你应该掌握：

1. **GHCi 是学习 Haskell 的最佳工具**
   - 即时反馈
   - 类型查询
   - 快速实验

2. **常用命令**
   - `:load` / `:l` - 加载文件
   - `:reload` / `:r` - 重新加载
   - `:type` / `:t` - 查看类型
   - `:info` / `:i` - 查看详细信息
   - `:quit` / `:q` - 退出

3. **类型系统的力量**
   - 类型错误在编译期捕获
   - 类型签名是最好的文档
   - 多态让代码更灵活

4. **错误是学习的机会**
   - 读懂错误信息很重要
   - 不要害怕实验和犯错

## 额外练习建议

如果你还想继续练习，尝试：

1. 在 GHCi 中实现一个函数，判断一个数是否是 3 的倍数
2. 创建一个函数，返回列表中的最后一个元素（提示：使用 `last`）
3. 探索 `map` 函数：`map (* 2) [1, 2, 3, 4]`
4. 探索 `filter` 函数：`filter (> 5) [1, 3, 5, 7, 9]`

---

恭喜你完成了 Week 0 的所有练习！准备进入 [Week 1: Haskell 基础语法](../../week-01-basics/)！

记住：**在 Haskell 中，类型是你的朋友，GHCi 是你的实验室！** 🚀

