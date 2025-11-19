# Week 1: 练习作业

> 动手实践，巩固本周所学

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week01Exercises.hs](../../exercises/week-01/tasks/Week01Exercises.hs)** - 主练习文件（15 道题）
- **[挑战题: Week01Challenges.hs](../../exercises/week-01/tasks/Week01Challenges.hs)** - 进阶挑战（选做）
- **[参考答案](../../exercises/week-01/solutions/)** - 完成后查看

### 如何使用

```bash
# 1. 下载练习文件到本地
# 2. 用编辑器打开（VS Code 推荐）
# 3. 完成每个 TODO 标记的函数
# 4. 在 GHCi 中测试：
ghci> :load Week01Exercises.hs
ghci> testFunction 参数
```

---

## 练习 1: 基础函数（5 题）

**文件**: `Week01Exercises.hs` (第 1-5 题)  
**难度**: ⭐☆☆☆☆

### 目标

- 编写简单函数
- 理解类型签名
- 使用基本运算符

### 内容预览

```haskell
-- 1.1 计算圆的面积
circleArea :: Double -> Double
circleArea radius = undefined  -- TODO

-- 1.2 判断是否为成年人
isAdult :: Int -> Bool
isAdult age = undefined  -- TODO

-- 1.3 计算两点之间的距离
distance :: Double -> Double -> Double -> Double -> Double
distance x1 y1 x2 y2 = undefined  -- TODO
```

---

## 练习 2: 列表操作（5 题）

**文件**: `Week01Exercises.hs` (第 6-10 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 使用列表基本函数
- 理解列表操作符
- 处理空列表情况

### 内容预览

```haskell
-- 2.1 获取列表的第二个元素
secondElement :: [a] -> a
secondElement xs = undefined  -- TODO

-- 2.2 检查列表是否包含某个元素
contains :: Eq a => a -> [a] -> Bool
contains x xs = undefined  -- TODO

-- 2.3 移除列表的第一个和最后一个元素
removeFirstLast :: [a] -> [a]
removeFirstLast xs = undefined  -- TODO
```

---

## 练习 3: 递归（5 题）

**文件**: `Week01Exercises.hs` (第 11-15 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 用递归解决问题
- 识别基础情况和递归情况
- 理解递归调用栈

### 内容预览

```haskell
-- 3.1 计算列表中所有元素的乘积
productList :: [Int] -> Int
productList xs = undefined  -- TODO

-- 3.2 复制列表元素 n 次
replicateN :: Int -> a -> [a]
replicateN n x = undefined  -- TODO

-- 3.3 取列表的前 n 个元素
takeN :: Int -> [a] -> [a]
takeN n xs = undefined  -- TODO
```

---

## 练习 4: 高阶函数（5 题）

**文件**: `Week01Exercises.hs` (第 16-20 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 map、filter、fold
- 理解函数作为参数
- 组合多个高阶函数

### 内容预览

```haskell
-- 4.1 将列表中所有数字加 1
incrementAll :: [Int] -> [Int]
incrementAll xs = undefined  -- TODO: 使用 map

-- 4.2 保留所有正数
onlyPositive :: [Int] -> [Int]
onlyPositive xs = undefined  -- TODO: 使用 filter

-- 4.3 计算所有奇数的和
sumOdds :: [Int] -> Int
sumOdds xs = undefined  -- TODO: 使用 filter 和 sum
```

---

## 练习 5: Lambda 表达式（5 题）

**文件**: `Week01Exercises.hs` (第 21-25 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 使用 lambda 表达式
- 理解匿名函数
- 在高阶函数中使用 lambda

### 内容预览

```haskell
-- 5.1 使用 lambda 将列表中所有数字平方
squareAll :: [Int] -> [Int]
squareAll xs = undefined  -- TODO: 使用 map 和 lambda

-- 5.2 使用 lambda 过滤长度大于 3 的字符串
longStrings :: [String] -> [String]
longStrings xs = undefined  -- TODO: 使用 filter 和 lambda
```

---

## 🚀 挑战题（选做）

**文件**: `Week01Challenges.hs`  
**难度**: ⭐⭐⭐⭐☆

这些题目更有挑战性，适合学有余力的同学：

1. **快速排序** - 用 Haskell 实现经典排序算法
2. **斐波那契数列** - 生成前 n 个斐波那契数
3. **回文判断** - 判断字符串是否为回文
4. **素数筛选** - 找出 1-100 内的所有素数
5. **数字金字塔** - 打印数字金字塔图案

---

## ✅ 自我检查

完成练习后，检查以下内容：

### 基本要求
- [ ] 所有函数都有类型签名
- [ ] 代码可以在 GHCi 中加载（无编译错误）
- [ ] 每个函数都通过了测试用例

### 理解程度
- [ ] 能解释每个函数的工作原理
- [ ] 理解递归的执行过程
- [ ] 知道何时使用 map/filter/fold

### 代码质量
- [ ] 变量命名有意义
- [ ] 代码格式整齐
- [ ] 有必要的注释

---

## 📊 评分标准

如果这是带导师的课程，评分标准如下（自学可作为参考）：

- ✅ **正确性** (60%) - 函数实现正确
- ✅ **类型签名** (15%) - 所有函数都有正确的类型签名
- ✅ **代码风格** (15%) - 代码清晰易读
- ✅ **测试** (10%) - 在 GHCi 中测试过所有函数

---

## 需要帮助？

- 参考本章的 [详细讲义](lecture.md)
- 查看 `exercises/week-01/solutions/` 中的参考答案
- 在 [GitHub Issues](https://github.com/mauyin/haskell-101-cn/issues) 中提问
- 在 [Stack Overflow](https://stackoverflow.com/questions/tagged/haskell) 搜索相关问题

---

## 💡 自学建议

### 完成这些练习后，你应该能够：

- ✅ 独立编写带类型签名的函数
- ✅ 用模式匹配处理列表的不同情况
- ✅ 用递归解决简单到中等难度的问题
- ✅ 熟练使用 map、filter、fold
- ✅ 在适当的场景使用 lambda 表达式
- ✅ 理解部分应用的概念

### 如果觉得困难

**这很正常！** 递归和高阶函数的思维方式可能需要时间适应。建议：

1. **多看几遍讲义** - 特别是递归部分，第一遍不理解很正常
2. **在 GHCi 中多实验** - 改变函数参数，观察输出
3. **画图理解递归** - 用纸笔画出递归调用的每一步
4. **先模仿，再理解** - 先按照示例写，慢慢就会理解原理
5. **给自己时间** - 函数式编程需要建立新的思维模式

### 学习建议

- **不要一次性做完所有题** - 分几天完成，每天 5-8 题
- **做题顺序**: 基础函数 → 列表操作 → 递归 → 高阶函数 → Lambda
- **遇到难题**: 先跳过，做完简单的再回来
- **查看答案**: 卡住 15 分钟就可以看提示或答案，不要死磕

### 准备好了吗？

完成这些标准后就可以进入 Week 2 了：

- ✅ 完成至少 **80% (20道题)** 的练习
- ✅ 理解递归的基本原理
- ✅ 能使用 map/filter 处理列表
- ✅ 代码能在 GHCi 中正常运行

即使有些练习没有完全理解也没关系，Week 2 会继续强化这些概念。

---

**完成练习后，你就准备好进入 Week 2 了！** 🎉

**下一步：** [Week 2 - 数据类型与模式匹配](../week-02-datatypes/README.md) →

---

## 💬 练习反馈

完成练习后，欢迎在 Issues 中分享：

- 哪些题目最有帮助？
- 哪些概念最难理解？
- 你有什么学习心得？

你的反馈会帮助我们改进课程内容！

