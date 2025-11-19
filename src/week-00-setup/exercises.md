# Week 0: 练习作业

完成这些练习来验证你的 Haskell 环境搭建是否正确。

---

## 📥 下载练习文件

你可以直接在仓库中找到并下载这些练习文件：

- **[练习 1: Hello Haskell](../../exercises/week-00/tasks/exercise-01-hello.hs)** - `.hs` 文件，可下载编辑
- **[练习 2: GHCi 操作](../../exercises/week-00/tasks/exercise-02-ghci.md)** - 交互式练习指南
- **[参考答案](../../exercises/week-00/solutions/)** - 完成练习后查看

---

## 练习 1: Hello Haskell

**文件**: `exercise-01-hello.hs`  
**难度**: ⭐☆☆☆☆

### 目标

- 理解函数定义语法
- 学会编写类型签名
- 在 GHCi 中加载和测试函数

### 如何完成

1. 从仓库下载 `exercises/week-00/tasks/exercise-01-hello.hs`
2. 在文件中完成函数实现（替换 `undefined`）
3. 在 GHCi 中加载文件：
   ```bash
   ghci> :load exercise-01-hello.hs
   ```
4. 测试你的函数
5. 对照 `exercises/week-00/solutions/` 目录中的参考答案

### 练习内容预览

这个练习包含以下部分：

#### 1.1 问候函数

编写一个函数 `sayHello`，接受一个名字（字符串），返回问候语。

```haskell
sayHello :: String -> String
sayHello name = undefined  -- TODO: 实现这个函数
```

**示例**：
```haskell
ghci> sayHello "小明"
"你好，小明！"
```

#### 1.2 简单算术

实现以下函数：
- `addTwo` - 给整数加 2
- `double` - 将整数翻倍
- `square` - 计算整数的平方

```haskell
addTwo :: Int -> Int
double :: Int -> Int
square :: Int -> Int
```

#### 1.3 布尔逻辑

实现以下判断函数：
- `isPositive` - 判断是否为正数
- `isEven` - 判断是否为偶数
- `isAdult` - 判断年龄是否 >= 18

```haskell
isPositive :: Int -> Bool
isEven :: Int -> Bool
isAdult :: Int -> Bool
```

#### 1.4 字符串操作

实现字符串处理函数：
- `greet` - 使用姓和名问候
- `initials` - 获取姓名首字母

```haskell
greet :: String -> String -> String
initials :: String -> String -> String
```

---

## 练习 2: GHCi 操作练习

**文件**: `exercise-02-ghci.md`  
**难度**: ⭐☆☆☆☆

### 目标

- 掌握 GHCi 基本命令
- 学会查看类型和信息
- 能够在 REPL 中实验代码

### 练习概览

这个练习分为 5 个部分，引导你熟悉 GHCi 的各种功能：

#### 第 1 部分：基本计算

在 GHCi 中进行算术和布尔运算：

```haskell
ghci> 7 + 3
ghci> 20 - 8
ghci> div 17 5
ghci> True && False
ghci> 5 > 3
```

#### 第 2 部分：类型查询

使用 `:type` (或 `:t`) 命令查看类型：

```haskell
ghci> :type 42
ghci> :type "Hello"
ghci> :type True
ghci> :type (5, "abc")
```

#### 第 3 部分：列表操作

探索 Haskell 的列表：

```haskell
ghci> [1, 2, 3, 4, 5]
ghci> 1 : [2, 3]
ghci> [1, 2] ++ [3, 4]
ghci> head [10, 20, 30]
ghci> tail [10, 20, 30]
ghci> length [1..10]
```

#### 第 4 部分：GHCi 命令

学习常用的 GHCi 命令：

```haskell
ghci> :help          -- 显示帮助
ghci> :type map      -- 查看函数类型
ghci> :info Bool     -- 查看类型信息
ghci> :set +s        -- 显示执行时间
ghci> :browse Prelude -- 浏览模块
```

#### 第 5 部分：加载文件

练习加载和重新加载 Haskell 文件：

1. 创建一个简单的 `.hs` 文件
2. 使用 `:load` 加载它
3. 修改文件内容
4. 使用 `:reload` 重新加载

---

## 评分标准

- ✅ **功能正确** (60%) - 函数按要求工作
- ✅ **类型签名** (20%) - 所有函数都有正确的类型签名
- ✅ **代码风格** (10%) - 代码清晰易读
- ✅ **测试完整** (10%) - 在 GHCi 中测试过所有函数

---

## 需要帮助？

- 参考本章的 [详细讲义](lecture.md)
- 查看 `exercises/week-00/solutions/` 中的参考答案
- 在 [GitHub Issues](https://github.com/mauyin/haskell-101-cn/issues) 中提问
- 在 [Stack Overflow](https://stackoverflow.com/questions/tagged/haskell) 搜索相关问题

## 💡 自学建议

### 完成这些练习后，你应该能够：

- ✅ 在 GHCi 中测试简单的 Haskell 表达式
- ✅ 理解基本的类型签名
- ✅ 编写和运行简单的 Haskell 函数
- ✅ 使用 `:type`、`:load` 等 GHCi 命令

### 如果觉得困难

**这很正常！** Haskell 的思维方式可能和你之前学习的语言完全不同。建议：

1. **多看几遍讲义** - 第一遍不理解很正常
2. **在 GHCi 中多实验** - 改变代码，观察结果
3. **不要纠结细节** - 有些概念会在后面的章节中逐渐清晰
4. **给自己时间** - 函数式编程需要时间适应

### 准备好了吗？

如果你完成了至少 80% 的练习，就可以进入 Week 1 了！

即使有些练习没有完全理解也没关系，Week 1 会重新讲解这些基础概念。

---

**完成练习后，你就准备好进入 Week 1 了！** 🎉

**下一步：** [Week 1 - Haskell 基础语法](../week-01-basics/README.md) →

