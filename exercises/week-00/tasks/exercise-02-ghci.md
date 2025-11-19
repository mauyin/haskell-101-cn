# Week 0 - 练习 2: GHCi 操作练习

这个练习旨在让你熟悉 GHCi（Haskell 的交互式环境）。

## 前置条件

- ✅ 已安装 GHC 和 GHCi
- ✅ 能够在终端中启动 GHCi

## 练习说明

按照以下步骤操作，并记录输出结果。你可以直接在这个文件中记录你的答案。

---

## 第 1 部分：基本计算

**任务**：在 GHCi 中启动，然后进行以下计算。

```bash
$ ghci
ghci>
```

### 1.1 算术运算

在 GHCi 中计算以下表达式：

```haskell
ghci> 7 + 3
-- 你的输出：

ghci> 20 - 8
-- 你的输出：

ghci> 6 * 7
-- 你的输出：

ghci> 100 / 4
-- 你的输出：

ghci> div 17 5
-- 你的输出：

ghci> mod 17 5
-- 你的输出：

ghci> 2 ^ 8
-- 你的输出：
```

### 1.2 布尔运算

```haskell
ghci> True && False
-- 你的输出：

ghci> True || False
-- 你的输出：

ghci> not True
-- 你的输出：

ghci> 5 > 3
-- 你的输出：

ghci> 10 == 10
-- 你的输出：

ghci> "hello" == "world"
-- 你的输出：
```

---

## 第 2 部分：类型查询

**任务**：使用 `:type`（或 `:t`）命令查看以下表达式的类型。

```haskell
ghci> :type 42
-- 你的输出：

ghci> :type 3.14
-- 你的输出：

ghci> :type True
-- 你的输出：

ghci> :type 'a'
-- 你的输出：

ghci> :type "Hello"
-- 你的输出：

ghci> :type (1, "hello")
-- 你的输出：

ghci> :type [1, 2, 3]
-- 你的输出：
```

**思考题**：你注意到 `42` 的类型是什么？为什么它不是简单的 `Int`？

你的答案：

---

## 第 3 部分：列表操作

**任务**：尝试以下列表操作。

```haskell
ghci> [1, 2, 3] ++ [4, 5, 6]
-- 你的输出：

ghci> 0 : [1, 2, 3]
-- 你的输出：

ghci> head [1, 2, 3, 4]
-- 你的输出：

ghci> tail [1, 2, 3, 4]
-- 你的输出：

ghci> length [1, 2, 3, 4, 5]
-- 你的输出：

ghci> reverse [1, 2, 3]
-- 你的输出：

ghci> take 3 [1, 2, 3, 4, 5]
-- 你的输出：

ghci> drop 2 [1, 2, 3, 4, 5]
-- 你的输出：
```

---

## 第 4 部分：字符串操作

**任务**：Haskell 中字符串实际上是字符列表。尝试以下操作。

```haskell
ghci> "Hello" ++ " " ++ "World"
-- 你的输出：

ghci> reverse "Haskell"
-- 你的输出：

ghci> head "Haskell"
-- 你的输出：

ghci> tail "Haskell"
-- 你的输出：

ghci> length "你好，世界！"
-- 你的输出：
```

---

## 第 5 部分：函数定义

**任务**：在 GHCi 中使用 `let` 定义函数并测试。

```haskell
ghci> let triple x = x * 3
ghci> triple 5
-- 你的输出：

ghci> let greet name = "Hello, " ++ name
ghci> greet "Haskell"
-- 你的输出：

ghci> let isLarge n = n > 100
ghci> isLarge 50
-- 你的输出：

ghci> isLarge 150
-- 你的输出：
```

---

## 第 6 部分：加载文件

**任务**：加载之前完成的 `exercise-01-hello.hs` 文件。

```haskell
ghci> :load exercise-01-hello.hs
-- 你的输出（应该显示编译信息）：

ghci> sayHello "世界"
-- 你的输出：

ghci> double 7
-- 你的输出：

ghci> isEven 10
-- 你的输出：
```

如果有编译错误，返回修改文件，然后使用 `:reload` 重新加载。

---

## 第 7 部分：信息查询

**任务**：使用 `:info` 命令查看类型类和函数的详细信息。

```haskell
ghci> :info Bool
-- 记录输出的前 5 行：




ghci> :info Int
-- 记录输出的前 3 行：


ghci> :info head
-- 记录输出（完整）：

```

---

## 第 8 部分：浏览模块（可选挑战）

**任务**：探索 Haskell 的 Prelude 模块。

```haskell
ghci> :browse Prelude
-- 这会输出很多内容，请记录前 10 个函数名：
1.
2.
3.
4.
5.
6.
7.
8.
9.
10.
```

---

## 第 9 部分：错误探索

**任务**：故意制造错误，学习理解错误信息。

```haskell
ghci> head []
-- 你的输出（错误信息）：


ghci> 5 / 0
-- 你的输出：


ghci> "hello" + "world"
-- 你的输出（错误信息）：


```

**思考题**：为什么字符串不能用 `+` 连接？应该用什么？

你的答案：

---

## 第 10 部分：退出 GHCi

**任务**：学习如何正确退出 GHCi。

```haskell
ghci> :quit
```

或者简写：

```haskell
ghci> :q
```

---

## 完成检查清单

完成后，检查你是否：

- [ ] 能够启动 GHCi
- [ ] 能够在 GHCi 中进行基本计算
- [ ] 能够使用 `:type` 查看类型
- [ ] 能够使用 `:info` 查看信息
- [ ] 能够在 GHCi 中定义简单函数（使用 `let`）
- [ ] 能够加载外部 `.hs` 文件
- [ ] 能够使用 `:reload` 重新加载文件
- [ ] 理解基本的错误信息
- [ ] 能够退出 GHCi

---

## 下一步

恭喜你完成了 GHCi 操作练习！现在你应该：

1. 对照 `solutions/exercise-02-ghci.md` 检查你的答案
2. 如果有不理解的地方，重新阅读 [lecture.md](../lecture.md)
3. 准备进入 [Week 1: Haskell 基础语法](../../week-01-basics/)

**重要提示**：在接下来的课程中，我们会频繁使用 GHCi 来实验代码。熟练掌握 GHCi 会让你的学习更高效！

祝学习愉快！🚀

