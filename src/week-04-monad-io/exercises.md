# Week 4: 练习作业

> Monad 与 IO 实战

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week04Exercises.hs](../../exercises/week-04/tasks/Week04Exercises.hs)** - 主练习文件（30 道题）
- **[挑战题: Week04Challenges.hs](../../exercises/week-04/tasks/Week04Challenges.hs)** - 进阶挑战（选做）
- **[参考答案](../../exercises/week-04/solutions/)** - 完成后查看

### 如何使用

```bash
# 1. 下载练习文件到本地
# 2. 用编辑器打开（VS Code 推荐）
# 3. 完成每个 TODO 标记的函数
# 4. 在 GHCi 中测试：
ghci> :load Week04Exercises.hs
ghci> testFunction 参数

# 对于 IO 练习，可以在 GHCi 中直接运行：
ghci> exercise1
ghci> exercise2
```

---

## 练习 1: Monad 基础（5 题）

**文件**: `Week04Exercises.hs` (第 1-5 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 理解 `>>=` 的工作原理
- 熟练使用 do-notation
- 掌握 `return` 的作用
- 在 Maybe 和 Either 中使用 Monad

### 内容预览

```haskell
-- 1.1 使用 >>= 链接操作
chain :: Maybe Int -> Maybe Int
chain mx = undefined  -- TODO: mx >>= (\x -> ...) >>= (\y -> ...)

-- 1.2 do-notation 转换
-- 给定 do 代码，用 >>= 重写

-- 1.3 实现 sequence
sequenceMaybe :: [Maybe a] -> Maybe [a]
sequenceMaybe = undefined  -- TODO

-- 1.4 使用 Either 处理错误链
safeComputation :: Int -> Either String Int
safeComputation = undefined  -- TODO
```

---

## 练习 2: Maybe Monad 实战（5 题）

**文件**: `Week04Exercises.hs` (第 6-10 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 Maybe 避免 null 错误
- 链接多个可能失败的操作
- 实现安全的数学运算
- 处理嵌套的 Maybe

### 内容预览

```haskell
-- 2.1 安全的除法和平方根
safeDivide :: Double -> Double -> Maybe Double
safeSqrt :: Double -> Maybe Double

compute :: Double -> Double -> Maybe Double
compute x y = undefined  -- TODO: 链接 safeDivide 和 safeSqrt

-- 2.2 从字典查询并计算
type Dict = [(String, Int)]

lookupAndAdd :: String -> String -> Dict -> Maybe Int
lookupAndAdd key1 key2 dict = undefined  -- TODO

-- 2.3 验证用户输入
data User = User { name :: String, age :: Int }

validateUser :: String -> String -> Maybe User
validateUser nameStr ageStr = undefined  -- TODO
```

---

## 练习 3: Either Monad 错误处理（5 题）

**文件**: `Week04Exercises.hs` (第 11-15 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 Either 携带错误信息
- 定义自定义错误类型
- 组合多个 Either 操作
- 理解错误短路

### 内容预览

```haskell
-- 3.1 定义错误类型
data MathError = DivByZero | NegativeLog | Overflow
  deriving (Show, Eq)

-- 3.2 安全运算（带错误信息）
safeDivE :: Double -> Double -> Either MathError Double
safeDivE x y = undefined  -- TODO

safeLog :: Double -> Either MathError Double
safeLog x = undefined  -- TODO

-- 3.3 复杂计算
calculate :: Double -> Double -> Either MathError Double
calculate x y = undefined  -- TODO: log(x / y)

-- 3.4 解析和验证
data ParseError = EmptyString | InvalidFormat | OutOfRange

parseAge :: String -> Either ParseError Int
parseAge = undefined  -- TODO
```

---

## 练习 4: List Monad（4 题）

**文件**: `Week04Exercises.hs` (第 16-19 题)  
**难度**: ⭐⭐⭐⭐☆

### 目标

- 理解 List Monad 的非确定性
- 使用 List Monad 生成组合
- 实现列表推导式
- 解决组合问题

### 内容预览

```haskell
-- 4.1 所有可能的配对
pairs :: [a] -> [b] -> [(a, b)]
pairs xs ys = undefined  -- TODO: 用 do-notation

-- 4.2 生成所有可能的三元组
triples :: [a] -> [b] -> [c] -> [(a, b, c)]
triples = undefined  -- TODO

-- 4.3 毕达哥拉斯三元组
pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n = undefined  -- TODO: a^2 + b^2 = c^2

-- 4.4 骑士走棋
type Pos = (Int, Int)
moveKnight :: Pos -> [Pos]
moveKnight = undefined  -- TODO
```

---

## 练习 5: IO 基础（6 题）

**文件**: `Week04Exercises.hs` (第 20-25 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 使用基本 IO 操作
- 组合多个 IO 动作
- 处理用户输入
- 格式化输出

### 内容预览

```haskell
-- 5.1 问候用户
greetUser :: IO ()
greetUser = undefined  -- TODO: 询问姓名并问候

-- 5.2 简单计算器
calculator :: IO ()
calculator = undefined  -- TODO: 读取两个数字并计算

-- 5.3 重复操作
repeatAction :: Int -> IO () -> IO ()
repeatAction n action = undefined  -- TODO

-- 5.4 读取多行输入
readLines :: Int -> IO [String]
readLines n = undefined  -- TODO

-- 5.5 交互式菜单
showMenu :: [String] -> IO Int
showMenu options = undefined  -- TODO

-- 5.6 猜数字游戏（简化版）
guessNumber :: Int -> IO ()
guessNumber secret = undefined  -- TODO
```

---

## 练习 6: 文件操作（6 题）

**文件**: `Week04Exercises.hs` (第 26-31 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 读写文件
- 处理文件内容
- 实现文件工具
- 处理目录

### 内容预览

```haskell
-- 6.1 统计文件行数
countFileLines :: FilePath -> IO Int
countFileLines = undefined  -- TODO

-- 6.2 查找并替换
replaceInFile :: FilePath -> String -> String -> IO ()
replaceInFile path old new = undefined  -- TODO

-- 6.3 文件内容反转
reverseFile :: FilePath -> FilePath -> IO ()
reverseFile input output = undefined  -- TODO

-- 6.4 合并多个文件
mergeFiles :: [FilePath] -> FilePath -> IO ()
mergeFiles inputs output = undefined  -- TODO

-- 6.5 按大小过滤文件
filterBySize :: FilePath -> Integer -> IO [FilePath]
filterBySize dir minSize = undefined  -- TODO

-- 6.6 简单日志系统
appendLog :: FilePath -> String -> IO ()
appendLog logFile message = undefined  -- TODO: 带时间戳
```

---

## 练习 7: 综合项目（3 题）

**文件**: `Week04Exercises.hs` (第 32-34 题)  
**难度**: ⭐⭐⭐⭐☆

### 目标

- 综合运用 IO 和纯函数
- 构建完整的小程序
- 处理用户交互
- 文件持久化

### 项目 1: TODO 清单 CLI

```haskell
-- 实现一个命令行 TODO 应用
-- 功能：添加、列出、删除、标记完成

data Todo = Todo { task :: String, done :: Bool }

loadTodos :: FilePath -> IO [Todo]
saveTodos :: FilePath -> [Todo] -> IO ()
addTodo :: FilePath -> String -> IO ()
listTodos :: FilePath -> IO ()
toggleTodo :: FilePath -> Int -> IO ()
mainLoop :: FilePath -> IO ()
```

### 项目 2: 文本文件分析器

```haskell
-- 分析文本文件，输出统计信息
-- 统计：字符数、单词数、行数、最常见单词

data FileStats = FileStats
  { charCount :: Int
  , wordCount :: Int
  , lineCount :: Int
  , topWords :: [(String, Int)]
  }

analyzeFile :: FilePath -> IO FileStats
displayStats :: FileStats -> IO ()
```

### 项目 3: 交互式文件浏览器

```haskell
-- 简单的文件浏览器
-- 功能：列出目录、进入目录、查看文件内容、搜索

browseDirectory :: FilePath -> IO ()
showFileContent :: FilePath -> IO ()
searchFiles :: FilePath -> String -> IO [FilePath]
```

---

## 挑战题：进阶项目

完成主练习后，可以挑战以下项目（在 `Week04Challenges.hs` 中）：

### 挑战 1: 命令行文本编辑器 ⭐⭐⭐⭐⭐

实现一个简单的文本编辑器，支持：
- 加载文件
- 编辑内容（插入、删除行）
- 保存文件
- 撤销/重做

### 挑战 2: CSV 解析器 ⭐⭐⭐⭐☆

实现 CSV 文件的解析和处理：
- 解析 CSV 文件
- 过滤和排序数据
- 导出为新 CSV
- 计算统计信息

### 挑战 3: 文件加密工具 ⭐⭐⭐⭐☆

实现简单的文件加密/解密工具：
- 读取文件
- 使用简单加密算法（如 XOR）
- 加密并保存
- 解密并验证

### 挑战 4: HTTP 客户端 ⭐⭐⭐⭐⭐

实现一个简单的 HTTP 客户端：
- 发起 GET/POST 请求
- 解析 JSON 响应
- 错误处理
- 实现简单的 API 封装

**⚠️ 特别说明：外部库依赖**

此挑战需要安装额外的 Haskell 包。这是可选练习，适合想要学习实际 HTTP 请求的学生。

**所需库：**
- `http-conduit` 或 `req` - HTTP 客户端
- `aeson` - JSON 解析

**安装方式：**

使用 Cabal:
```bash
cabal install http-conduit aeson
```

使用 Stack:
```bash
stack install http-conduit aeson
```

或在项目的 `.cabal` 文件中添加依赖：
```cabal
build-depends: base >=4.7 && <5
             , http-conduit
             , aeson
             , text
             , bytestring
```

**学习路径：**
1. 如果你是初学者，可以先跳过此挑战
2. 完成 Week 5（模块管理）后再回来做
3. 参考讲义中的 Section 5（网络请求基础）
4. 查看 `req` 库的官方文档：https://hackage.haskell.org/package/req

**替代方案：**
- 如果暂时不想配置外部库，可以先完成其他挑战
- Week 7（Cardano 实践）会更深入地使用外部库

### 挑战 5: 日志分析工具 ⭐⭐⭐⭐☆

分析日志文件，提取有用信息：
- 解析不同格式的日志
- 统计各级别日志数量
- 查找错误模式
- 生成报告

---

## 学习建议

### 完成顺序

1. **先理解理论** - 阅读 [lecture.md](lecture.md) 的 Monad 部分
2. **练习 Monad** - 完成练习 1-4（纯函数部分）
3. **掌握 IO** - 完成练习 5-6
4. **综合应用** - 完成练习 7 的项目
5. **挑战自己** - 尝试挑战题

### 调试技巧

```haskell
-- 在 GHCi 中测试 IO 操作
ghci> :load Week04Exercises.hs
ghci> greetUser
What's your name?
Alice
Hello, Alice!

-- 查看类型帮助理解
ghci> :type (>>=)
(>>=) :: Monad m => m a -> (a -> m b) -> m b

-- 测试 Maybe/Either
ghci> Just 5 >>= \x -> Just (x * 2)
Just 10
```

### 常见错误

1. **忘记 <- 提取值**
```haskell
-- ❌ 错误
do
  name = getLine  -- 类型错误！
  putStrLn name

-- ✅ 正确
do
  name <- getLine
  putStrLn name
```

2. **混淆 return**
```haskell
-- ❌ return 不是退出函数
do
  putStrLn "A"
  return ()  -- 这不会退出！
  putStrLn "B"  -- 仍然执行

-- ✅ return 只是包装值
do
  putStrLn "A"
  putStrLn "B"
  return ()  -- 作为最后的值
```

3. **类型不匹配**
```haskell
-- ❌ 不能混合 IO 和纯值
add :: Int -> Int -> Int
add x y = do  -- 错误！add 返回 Int，不是 IO Int
  return (x + y)

-- ✅ 保持纯函数纯
add :: Int -> Int -> Int
add x y = x + y
```

---

## 完成标准

完成本周练习后，你应该能够：

- [ ] 流畅使用 `>>=` 和 do-notation
- [ ] 理解 Monad 三大定律
- [ ] 使用 Maybe/Either 处理错误
- [ ] 理解 List Monad 的非确定性
- [ ] 编写交互式 IO 程序
- [ ] 进行文件的读写操作
- [ ] 处理目录和文件系统
- [ ] 组合纯函数和 IO 操作
- [ ] 构建完整的命令行工具

**全部完成？** 恭喜！你已经掌握了 Monad 和 IO 编程的核心知识！

继续前进：[Week 5: 模块与项目管理](../../week-05-modules/README.md) →

---

## 📚 参考答案

完成练习后，可以查看参考答案：

- [Week04Exercises.hs 答案](../../exercises/week-04/solutions/Week04Exercises.hs)
- [Week04Challenges.hs 答案](../../exercises/week-04/solutions/Week04Challenges.hs)

**重要**：先独立完成练习，再查看答案！只有自己动手写代码才能真正掌握。

有问题？查看 [README](README.md) 中的社区资源，或在 [Issues](https://github.com/mauyin/haskell-101-cn/issues) 提问。

