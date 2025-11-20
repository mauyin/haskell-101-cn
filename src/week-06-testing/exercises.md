# Week 6: 练习作业

> 错误处理与测试实战

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week06Exercises.hs](../../exercises/week-06/tasks/Week06Exercises.hs)** - 主练习文件（25 道题）
- **[测试练习: Week06Tests.hs](../../exercises/week-06/tasks/Week06Tests.hs)** - QuickCheck 和 Hspec 练习
- **[TDD 项目: calculator/](../../exercises/week-06/tasks/calculator/)** - 测试驱动开发项目
- **[参考答案](../../exercises/week-06/solutions/)** - 完成后查看
- **[示例代码](../../exercises/week-06/examples/)** - 额外学习材料

### 如何使用

```bash
# 1. 基础练习
cd exercises/week-06/tasks
ghci Week06Exercises.hs
# 完成 TODO 标记的函数

# 2. 测试练习
cd exercises/week-06/tasks
cabal test  # 或
runhaskell Week06Tests.hs

# 3. TDD 项目
cd exercises/week-06/tasks/calculator
cabal test --test-show-details=streaming
```

---

## 练习 1: Maybe 与 Either（5 题）

**文件**: `Week06Exercises.hs` (第 1-5 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 使用 Maybe 处理可选值
- 使用 Either 携带错误信息
- 链接多个可能失败的操作
- 错误恢复和默认值

### 内容预览

```haskell
-- 1.1 安全的列表索引
safeIndex :: [a] -> Int -> Maybe a
safeIndex = undefined  -- TODO

-- 1.2 安全的除法（返回 Either）
data DivError = DivByZero | Overflow deriving (Show, Eq)

safeDivide :: Int -> Int -> Either DivError Int
safeDivide = undefined  -- TODO

-- 1.3 链式查询（Maybe Monad）
getUserEmail :: Int -> Map Int User -> Map String String -> Maybe String
getUserEmail userId userDB emailDB = undefined  -- TODO

-- 1.4 解析并验证年龄
parseAge :: String -> Either String Int
parseAge = undefined  -- TODO
-- 应该检查：非空、是数字、在 0-150 范围

-- 1.5 组合 Either 计算
calculateTotal :: String -> String -> Either String Double
calculateTotal priceStr qtyStr = undefined  -- TODO
-- 解析价格和数量，计算总价
```

---

## 练习 2: ExceptT Transformer（5 题）

**文件**: `Week06Exercises.hs` (第 6-10 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 ExceptT 处理 IO 中的错误
- 组合多个 ExceptT 操作
- 错误恢复和重试
- 类型转换

### 内容预览

```haskell
import Control.Monad.Except

data FileError 
  = FileNotFound FilePath
  | ParseError String
  | EmptyFile
  deriving (Show, Eq)

-- 2.1 读取文件（使用 ExceptT）
readFileE :: FilePath -> ExceptT FileError IO String
readFileE = undefined  -- TODO

-- 2.2 解析文件内容
parseNumbers :: String -> ExceptT FileError IO [Int]
parseNumbers = undefined  -- TODO

-- 2.3 处理文件流水线
processNumbersFile :: FilePath -> ExceptT FileError IO Int
processNumbersFile = undefined  -- TODO
-- 读取 -> 解析 -> 求和

-- 2.4 错误恢复
processWithFallback :: FilePath -> FilePath -> ExceptT FileError IO [Int]
processWithFallback primary fallback = undefined  -- TODO
-- 尝试主文件，失败则用备用文件

-- 2.5 批量处理
processMultipleFiles :: [FilePath] -> ExceptT FileError IO [Int]
processMultipleFiles = undefined  -- TODO
-- 处理多个文件，遇到错误继续处理其他文件
```

---

## 练习 3: 异常处理（5 题）

**文件**: `Week06Exercises.hs` (第 11-15 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 try/catch 处理异常
- 自定义异常类型
- 资源管理（bracket、finally）
- 异常与 Either 转换

### 内容预览

```haskell
import Control.Exception

-- 3.1 捕获特定异常
safeReadFile :: FilePath -> IO (Either IOException String)
safeReadFile = undefined  -- TODO

-- 3.2 带超时的操作
withTimeout :: Int -> IO a -> IO (Maybe a)
withTimeout seconds action = undefined  -- TODO

-- 3.3 资源安全操作
withFileHandle :: FilePath -> (Handle -> IO a) -> IO a
withFileHandle = undefined  -- TODO
-- 确保文件句柄被正确关闭

-- 3.4 重试机制
retryOnError :: Int -> IO a -> IO (Either SomeException a)
retryOnError maxRetries action = undefined  -- TODO

-- 3.5 自定义异常
data AppException = NetworkError String | DataError String
  deriving (Show, Typeable)

instance Exception AppException

throwNetworkError :: String -> IO a
throwNetworkError = undefined  -- TODO
```

---

## 练习 4: QuickCheck 属性测试（5 题）

**文件**: `Week06Tests.hs` (第 1-5 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 编写属性测试
- 理解测试属性模式
- 使用条件属性
- 自定义生成器

### 内容预览

```haskell
import Test.QuickCheck

-- 4.1 列表反转属性
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse = undefined  -- TODO

prop_reverseLength :: [Int] -> Bool
prop_reverseLength = undefined  -- TODO

-- 4.2 排序属性
prop_sortIdempotent :: [Int] -> Bool
prop_sortIdempotent = undefined  -- TODO

prop_sortPreservesLength :: [Int] -> Bool
prop_sortPreservesLength = undefined  -- TODO

-- 4.3 Map 操作属性
prop_mapPreservesLength :: [Int] -> Bool
prop_mapPreservesLength = undefined  -- TODO

prop_mapComposition :: [Int] -> Property
prop_mapComposition xs = undefined  -- TODO
-- map f . map g = map (f . g)

-- 4.4 条件属性
prop_divideCorrect :: Int -> Int -> Property
prop_divideCorrect x y = undefined  -- TODO
-- 当 y /= 0 时，(x `div` y) * y + (x `mod` y) == x

-- 4.5 自定义生成器
newtype PositiveInt = PositiveInt Int deriving Show

instance Arbitrary PositiveInt where
  arbitrary = undefined  -- TODO

prop_positiveSum :: PositiveInt -> PositiveInt -> Bool
prop_positiveSum = undefined  -- TODO
```

---

## 练习 5: Hspec 单元测试（5 题）

**文件**: `Week06Tests.hs` (第 6-10 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 编写 Hspec 测试规格
- 使用各种断言
- 组织测试套件
- 测试 IO 代码

### 内容预览

```haskell
import Test.Hspec

-- 5.1 基础函数测试
-- TODO: 为 factorial 函数编写 Hspec 测试
factorialSpec :: Spec
factorialSpec = undefined

-- 5.2 边界情况测试
-- TODO: 测试 safeHead 函数的各种情况
safeHeadSpec :: Spec
safeHeadSpec = undefined

-- 5.3 错误处理测试
-- TODO: 测试 safeDivide 的成功和失败情况
safeDivideSpec :: Spec
safeDivideSpec = undefined

-- 5.4 列表操作测试
-- TODO: 测试自定义的 myFilter 函数
myFilterSpec :: Spec
myFilterSpec = undefined

-- 5.5 IO 操作测试
-- TODO: 测试文件读写函数
fileOpsSpec :: Spec
fileOpsSpec = undefined
```

---

## 项目 1: TDD Calculator（必做）

**目录**: `exercises/week-06/tasks/calculator/`  
**难度**: ⭐⭐⭐⭐☆

### 项目描述

使用测试驱动开发（TDD）构建一个支持基本运算和错误处理的计算器。

### 功能要求

1. **基本运算**
   - 加法、减法、乘法、除法
   - 支持负数
   - 支持浮点数

2. **错误处理**
   - 除零检测
   - 无效输入检测
   - 溢出检测

3. **高级功能**（可选）
   - 括号支持
   - 运算符优先级
   - 变量支持

### TDD 步骤

#### 第 1 轮：加法

```haskell
-- Step 1: 写测试
describe "add" $ do
  it "adds two positive numbers" $
    add 2 3 `shouldBe` 5

-- Step 2: 最简实现
add :: Double -> Double -> Double
add _ _ = 5  -- 硬编码，但测试通过

-- Step 3: 更多测试
it "adds negative numbers" $
  add (-2) 3 `shouldBe` 1

-- Step 4: 正确实现
add x y = x + y
```

#### 第 2 轮：除法带错误处理

```haskell
-- 测试
describe "divide" $ do
  it "divides two numbers" $
    divide 10 2 `shouldBe` Right 5.0
  
  it "rejects division by zero" $
    divide 10 0 `shouldBe` Left DivisionByZero

-- 实现
data CalcError = DivisionByZero deriving (Show, Eq)

divide :: Double -> Double -> Either CalcError Double
divide _ 0 = Left DivisionByZero
divide x y = Right (x / y)
```

### 项目结构

```
calculator/
├── src/
│   ├── Calculator.hs      -- 计算器逻辑
│   └── Parser.hs          -- 表达式解析（可选）
├── test/
│   └── CalculatorSpec.hs -- 测试套件
├── app/
│   └── Main.hs            -- 命令行接口
└── calculator.cabal       -- 项目配置
```

### 测试要求

- [ ] 所有基本运算有单元测试
- [ ] 边界情况有测试（0、负数、最大值）
- [ ] 错误情况有测试
- [ ] 属性测试（交换律、结合律等）
- [ ] 测试覆盖率 > 80%

### 验收标准

```bash
cd calculator
cabal test

# 预期输出：
# Calculator
#   add
#     ✓ adds positive numbers
#     ✓ adds negative numbers
#   subtract
#     ✓ subtracts numbers
#   multiply
#     ✓ multiplies numbers
#   divide
#     ✓ divides numbers
#     ✓ rejects division by zero
# 
# Finished in 0.0123 seconds
# 6 examples, 0 failures
```

---

## 项目 2: 输入验证器（必做）

**目录**: `exercises/week-06/tasks/validator/`  
**难度**: ⭐⭐⭐⭐☆

### 项目描述

创建一个通用的输入验证库，带完整的测试套件。

### 功能要求

1. **基本验证器**
   ```haskell
   validateEmail :: String -> Either ValidationError String
   validateAge :: Int -> Either ValidationError Int
   validatePassword :: String -> Either ValidationError String
   ```

2. **组合验证器**
   ```haskell
   -- 组合多个验证规则
   validateUser :: UserInput -> Either [ValidationError] User
   ```

3. **验证规则**
   - 非空
   - 长度限制
   - 正则匹配
   - 范围检查
   - 自定义规则

### TDD 开发流程

```haskell
-- 1. 测试：邮箱验证
describe "validateEmail" $ do
  it "accepts valid email" $
    validateEmail "user@example.com" `shouldBe` Right "user@example.com"
  
  it "rejects email without @" $
    validateEmail "userexample.com" `shouldSatisfy` isLeft
  
  it "rejects empty email" $
    validateEmail "" `shouldSatisfy` isLeft

-- 2. 实现
data ValidationError 
  = EmptyInput
  | InvalidFormat String
  | TooShort Int
  | TooLong Int
  deriving (Show, Eq)

validateEmail :: String -> Either ValidationError String
validateEmail "" = Left EmptyInput
validateEmail s
  | '@' `notElem` s = Left $ InvalidFormat "missing @"
  | otherwise = Right s

-- 3. 重构（添加更严格的规则）
validateEmail s = do
  nonEmpty s
  mustContain '@' s
  mustContainDomain s
  where
    nonEmpty "" = Left EmptyInput
    nonEmpty x = Right x
    -- ... 更多规则
```

### 测试类型

1. **单元测试**：每个验证规则
2. **属性测试**：验证器不改变有效输入
3. **集成测试**：组合验证器

---

## 挑战题：扩展项目（选做）

### 挑战 1: CSV 解析器 with 错误处理 ⭐⭐⭐⭐☆

构建健壮的 CSV 解析器：

- 详细的错误信息（行号、列号）
- 类型安全的解析
- 完整的测试套件
- 支持自定义分隔符

### 挑战 2: HTTP 客户端 with 重试 ⭐⭐⭐⭐⭐

构建可靠的 HTTP 客户端：

- 自动重试机制
- 指数退避
- 超时处理
- 连接池
- 完整的异常处理

### 挑战 3: 属性测试生成器库 ⭐⭐⭐⭐⭐

创建自定义的属性测试框架：

- 自定义生成器组合子
- Shrinking 策略
- 测试结果统计
- 反例最小化

---

## 学习建议

### 完成顺序

1. **理解概念** - 阅读 [lecture.md](lecture.md)
2. **Maybe/Either练习** - 练习 1-2
3. **异常处理** - 练习 3
4. **QuickCheck** - 练习 4
5. **Hspec** - 练习 5
6. **TDD 项目** - 完成两个必做项目
7. **挑战题** - 根据兴趣选择

### 调试技巧

```haskell
-- QuickCheck 调试
ghci> quickCheck prop_reverseReverse
*** Failed! Falsifiable (after 5 tests):  
[0,1]

-- 显示反例
ghci> quickCheckWith stdArgs { chatty = True } prop

-- Hspec 只运行特定测试
cabal test --test-options="--match 'Calculator/add'"

-- 显示详细输出
cabal test --test-show-details=streaming
```

### 常见错误

1. **忘记处理 Nothing/Left**
```haskell
-- ❌ 部分函数
getUser id = fromJust $ M.lookup id db

-- ✅ 完整函数
getUser id = M.lookup id db
```

2. **测试不够全面**
```haskell
-- ❌ 只测试正向
it "adds numbers" $ add 2 3 `shouldBe` 5

-- ✅ 也测试边界和错误
it "handles negatives" $ add (-2) 3 `shouldBe` 1
it "handles zero" $ add 0 0 `shouldBe` 0
```

3. **属性测试条件过严**
```haskell
-- ❌ 丢弃太多测试用例
prop x y = y > 0 && y < 10 ==> ...  -- 90% 被丢弃

-- ✅ 使用 forAll
prop = forAll (choose (1, 9)) $ \y -> ...
```

---

## 完成标准

完成本周练习后，你应该能够：

- [ ] 熟练使用 Maybe 和 Either 处理错误
- [ ] 使用 ExceptT 组合 IO 和错误处理
- [ ] 正确使用异常和资源管理
- [ ] 编写有意义的属性测试
- [ ] 组织完整的测试套件
- [ ] 实践测试驱动开发
- [ ] 调试和定位问题

**全部完成？** 恭喜！你已经掌握了错误处理和测试的核心技能！

继续前进：[Week 7: Cardano 实践](../../week-07-cardano/README.md) →

---

## 📚 参考答案

完成练习后，可以查看参考答案：

- [Week06Exercises.hs 答案](../../exercises/week-06/solutions/Week06Exercises.hs)
- [Week06Tests.hs 答案](../../exercises/week-06/solutions/Week06Tests.hs)
- [Calculator 完整实现](../../exercises/week-06/solutions/calculator/)
- [Validator 完整实现](../../exercises/week-06/solutions/validator/)

**重要**：先独立完成练习，再查看答案！TDD 的精髓是自己写测试、自己实现。

有问题？查看 [README](README.md) 中的社区资源，或在 [Issues](https://github.com/mauyin/haskell-101-cn/issues) 提问。

