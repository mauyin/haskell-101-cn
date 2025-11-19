# Week 2: 练习作业

> 实践 ADT 和模式匹配

## 📥 下载练习文件

你可以直接下载这些练习文件，在本地编辑并运行：

- **[练习文件: Week02Exercises.hs](../../exercises/week-02/tasks/Week02Exercises.hs)** - 主练习文件（20 道题）
- **[挑战题: Week02Challenges.hs](../../exercises/week-02/tasks/Week02Challenges.hs)** - 进阶挑战（选做）
- **[示例: CardGame.hs](../../exercises/week-02/examples/CardGame.hs)** - 完整扑克牌示例
- **[参考答案](../../exercises/week-02/solutions/)** - 完成后查看

### 如何使用

```bash
# 1. 下载练习文件到本地
# 2. 用编辑器打开（VS Code 推荐）
# 3. 完成每个 TODO 标记的函数
# 4. 在 GHCi 中测试：
ghci> :load Week02Exercises.hs
ghci> testFunction 参数
```

---

## 练习 1: 元组操作（4 题）

**文件**: `Week02Exercises.hs` (第 1-4 题)  
**难度**: ⭐☆☆☆☆

### 目标

- 使用元组打包数据
- 模式匹配提取元组值
- 理解元组与列表的区别

### 内容预览

```haskell
-- 1.1 创建坐标点
makePoint :: Int -> Int -> (Int, Int)
makePoint x y = undefined  -- TODO

-- 1.2 计算两点中点
midpoint :: (Double, Double) -> (Double, Double) -> (Double, Double)
midpoint p1 p2 = undefined  -- TODO

-- 1.3 提取三元组的第三个元素
thirdElement :: (a, b, c) -> c
thirdElement triple = undefined  -- TODO
```

---

## 练习 2: 简单 ADT（5 题）

**文件**: `Week02Exercises.hs` (第 5-9 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 定义自己的数据类型
- 使用模式匹配处理不同构造器
- 理解 ADT 的威力

### 内容预览

```haskell
-- 2.1 定义星期枚举
data Weekday = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday

-- 判断是否为工作日
isWeekday :: Weekday -> Bool
isWeekday day = undefined  -- TODO

-- 2.2 定义温度类型
data Temperature = Celsius Double | Fahrenheit Double

-- 转换为摄氏度
toCelsius :: Temperature -> Double
toCelsius temp = undefined  -- TODO
```

---

## 练习 3: Maybe 类型（5 题）

**文件**: `Week02Exercises.hs` (第 10-14 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 使用 Maybe 处理可选值
- 理解 Maybe 比 null 更安全
- 组合 Maybe 值

### 内容预览

```haskell
-- 3.1 安全的列表最后一个元素
safeLast :: [a] -> Maybe a
safeLast xs = undefined  -- TODO

-- 3.2 安全的查找
safeLookup :: Eq a => a -> [(a, b)] -> Maybe b
safeLookup key pairs = undefined  -- TODO

-- 3.3 组合两个 Maybe
combineMaybe :: Maybe Int -> Maybe Int -> Maybe Int
combineMaybe mx my = undefined  -- TODO
```

---

## 练习 4: Either 类型（4 题）

**文件**: `Week02Exercises.hs` (第 15-18 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 使用 Either 处理错误
- 返回有意义的错误信息
- 理解 Either vs Maybe

### 内容预览

```haskell
-- 4.1 安全除法（带错误信息）
divideWithError :: Int -> Int -> Either String Int
divideWithError x y = undefined  -- TODO

-- 4.2 解析年龄
parseAge :: String -> Either String Int
parseAge str = undefined  -- TODO

-- 4.3 验证邮箱
validateEmail :: String -> Either String String
validateEmail email = undefined  -- TODO
```

---

## 练习 5: 记录语法（2 题）

**文件**: `Week02Exercises.hs` (第 19-20 题)  
**难度**: ⭐⭐☆☆☆

### 目标

- 定义带记录的类型
- 使用记录访问器
- 更新记录字段

### 内容预览

```haskell
-- 5.1 定义学生记录
data Student = Student
  { studentName :: String
  , studentAge :: Int
  , studentGrade :: Char
  }

-- 更新学生成绩
updateGrade :: Student -> Char -> Student
updateGrade student newGrade = undefined  -- TODO
```

---

## 练习 6: 树结构（5 题）

**文件**: `Week02Exercises.hs` (第 21-25 题)  
**难度**: ⭐⭐⭐☆☆

### 目标

- 定义和操作二叉树
- 递归处理树结构
- 理解递归数据类型

### 内容预览

```haskell
-- 6.1 定义二叉树
data Tree a = EmptyTree | Node a (Tree a) (Tree a)

-- 计算树的节点数
treeSize :: Tree a -> Int
treeSize tree = undefined  -- TODO

-- 计算树的深度
treeDepth :: Tree a -> Int
treeDepth tree = undefined  -- TODO

-- 查找元素
treeContains :: Eq a => a -> Tree a -> Bool
treeContains x tree = undefined  -- TODO
```

---

## 🚀 挑战题（选做）

**文件**: `Week02Challenges.hs`  
**难度**: ⭐⭐⭐⭐☆

这些题目更有挑战性，适合学有余力的同学：

1. **表达式求值器** - 实现简单的算术表达式 AST 和求值器
2. **JSON 数据类型** - 定义简化版 JSON 类型
3. **迷宫求解** - 用 ADT 表示迷宫并实现路径查找
4. **红黑树** - 实现红黑树的插入操作
5. **解析器组合子** - 实现简单的解析器

---

## ✅ 自我检查

完成练习后，检查以下内容：

### 基本要求
- [ ] 所有 ADT 都有明确的构造器
- [ ] 模式匹配覆盖所有情况
- [ ] 优先使用 Maybe/Either 而不是异常
- [ ] 代码可以在 GHCi 中加载

### 理解程度
- [ ] 能解释 ADT 与面向对象类的区别
- [ ] 理解 Maybe 如何防止 null 引用错误
- [ ] 知道何时使用 Either 而不是 Maybe
- [ ] 能画出树结构的递归定义

### 代码质量
- [ ] 类型名和构造器命名清晰
- [ ] 记录字段使用有意义的前缀
- [ ] 递归函数有明确的基础情况

---

## 📊 评分标准

如果这是带导师的课程，评分标准如下（自学可作为参考）：

- ✅ **正确性** (60%) - 函数实现正确
- ✅ **类型设计** (20%) - ADT 设计合理
- ✅ **模式匹配** (10%) - 覆盖所有情况
- ✅ **代码风格** (10%) - 代码清晰易读

---

## 需要帮助？

- 参考本章的 [详细讲义](lecture.md)
- 查看 `exercises/week-02/solutions/` 中的参考答案
- 查看 `exercises/week-02/examples/CardGame.hs` 完整示例
- 在 [GitHub Issues](https://github.com/mauyin/haskell-101-cn/issues) 中提问
- 在 [Stack Overflow](https://stackoverflow.com/questions/tagged/haskell+adt) 搜索相关问题

---

## 💡 自学建议

### 完成这些练习后，你应该能够：

- ✅ 定义适合问题域的 ADT
- ✅ 熟练使用模式匹配分解数据
- ✅ 用 Maybe 替代 null/None
- ✅ 用 Either 返回有意义的错误
- ✅ 使用记录语法组织复杂数据
- ✅ 实现和操作递归数据结构（如树）

### 如果觉得困难

**这很正常！** ADT 是 Haskell 的核心概念，需要改变思维方式。建议：

1. **从简单开始** - 先做元组和枚举类型，再做树
2. **画图** - 特别是树结构，画出来更容易理解
3. **对比其他语言** - 想想 Rust 的 enum、TypeScript 的 union type
4. **多看示例** - CardGame.hs 提供了完整的实战例子
5. **给自己时间** - ADT 的威力会在后续章节逐渐显现

### 学习建议

- **不要一次性做完所有题** - 分几天完成，每天 4-5 题
- **做题顺序**: 元组 → 简单 ADT → Maybe → Either → 记录 → 树
- **遇到树的题目**: 先在纸上画出树的结构
- **卡住 15 分钟**: 就可以看提示或答案，不要死磕

### ADT 设计提示

好的 ADT 设计应该：

1. **让非法状态无法表示** - 类型系统防止错误
2. **构造器有意义** - 名字清楚表达语义
3. **小而精** - 每个类型只做一件事
4. **易于扩展** - 添加新构造器不影响现有代码

### 准备好了吗？

完成这些标准后就可以进入 Week 3 了：

- ✅ 完成至少 **80% (16道题)** 的练习
- ✅ 能定义自己的 ADT
- ✅ 熟练使用 Maybe 和 Either
- ✅ 理解递归数据类型的概念
- ✅ 代码能在 GHCi 中正常运行

即使树的题目有些困难也没关系，Week 3 会继续使用这些概念。

---

**完成练习后，你就准备好进入 Week 3 了！** 🎉

**下一步：** [Week 3 - 类型类](../week-03-typeclasses/README.md) →

---

## 💬 练习反馈

完成练习后，欢迎在 Issues 中分享：

- ADT 的哪个概念最难理解？
- Maybe/Either 的使用是否清晰？
- 树的练习难度如何？
- 你觉得哪里可以改进？

你的反馈会帮助我们改进课程内容！

---

## 🎯 Week 2 vs Week 1

| 方面 | Week 1 | Week 2 |
|------|--------|--------|
| **核心概念** | 函数、列表、递归 | 类型、ADT、模式匹配 |
| **抽象层次** | 处理数据 | 定义数据 |
| **难度** | ⭐⭐ | ⭐⭐⭐ |
| **思维转变** | 递归代替循环 | 类型建模问题 |

Week 2 引入了更抽象的概念，给自己时间适应！

