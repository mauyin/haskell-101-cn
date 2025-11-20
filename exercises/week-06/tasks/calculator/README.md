# TDD Calculator - 测试驱动开发练习

Week 6 TDD 实践项目

## 项目概述

使用测试驱动开发（TDD）方法构建一个支持基本运算和错误处理的计算器。

## 学习目标

- 实践 TDD 开发流程（Red -> Green -> Refactor）
- 编写单元测试和属性测试
- 处理错误情况
- 组织测试套件

## 项目结构

```
calculator/
├── src/
│   ├── Calculator.hs          # 计算器核心逻辑（待实现）
│   └── Calculator/Types.hs    # 类型定义
├── test/
│   └── CalculatorSpec.hs      # 测试套件（从这里开始！）
├── app/
│   └── Main.hs                # 命令行接口
└── calculator.cabal            # 项目配置
```

## TDD 工作流程

### 1. Red（红灯）- 写失败的测试

在 `test/CalculatorSpec.hs` 中，移除 `pending` 并写测试：

```haskell
it "adds two positive numbers" $
  add 2 3 `shouldBe` Right 5
```

运行测试：
```bash
cabal test
# 测试失败！因为 add 返回 undefined
```

### 2. Green（绿灯）- 让测试通过

在 `src/Calculator.hs` 中实现：

```haskell
add :: Double -> Double -> CalcResult
add _ _ = Right 5  -- 硬编码！但测试通过了
```

运行测试：
```bash
cabal test
# ✓ adds two positive numbers
```

### 3. 添加更多测试

```haskell
it "adds different numbers" $
  add 10 20 `shouldBe` Right 30
```

运行测试（现在失败了）：
```bash
cabal test
# ✗ adds different numbers
```

### 4. 正确实现

```haskell
add :: Double -> Double -> CalcResult
add x y = Right (x + y)  -- 现在所有测试都通过！
```

### 5. Refactor（重构）

如果代码可以改进，重构它：
```haskell
-- 在这个简单例子中不需要重构
-- 但在更复杂的代码中，这一步很重要
```

### 6. 重复

继续下一个功能（subtract, multiply, divide...）

## 实践步骤

### 第 1 阶段：加法（简单）

1. 打开 `test/CalculatorSpec.hs`
2. 在 `addSpec` 中移除第一个 `pending`
3. 运行测试（失败）
4. 在 `src/Calculator.hs` 中实现 `add`
5. 运行测试（通过）
6. 继续添加更多加法测试

### 第 2 阶段：减法和乘法（简单）

重复 TDD 循环

### 第 3 阶段：除法（重要！带错误处理）

1. 先写正常情况的测试
2. 然后写错误情况的测试：
   ```haskell
   it "rejects division by zero" $
     divide 10 0 `shouldBe` Left DivisionByZero
   ```
3. 实现错误处理逻辑

### 第 4 阶段：属性测试（进阶）

在 `propertiesSpec` 中添加属性测试：
```haskell
it "add is commutative" $ property $
  \x y -> add x y == add y x
```

## 运行项目

### 运行测试

```bash
# 基本运行
cabal test

# 显示详细输出
cabal test --test-show-details=streaming

# 只运行特定测试
cabal test --test-options="--match add"
```

### 运行计算器

```bash
cabal run calculator
```

示例：
```
> 10 + 5
结果: 15.0

> 20 / 4
结果: 5.0

> 10 / 0
错误：不能除以零
```

## 完成标准

完成以下任务即算完成：

### 必做
- [ ] 实现 add（加法）
- [ ] 实现 subtract（减法）
- [ ] 实现 multiply（乘法）
- [ ] 实现 divide（除法，带除零检测）
- [ ] 所有单元测试通过
- [ ] 至少 3 个属性测试

### 选做
- [ ] 实现 power（幂运算）
- [ ] 实现 sqrt（平方根）
- [ ] 添加更多属性测试
- [ ] 实现更复杂的表达式解析

## 测试覆盖

最终应该有：
- 15+ 个单元测试
- 3+ 个属性测试
- 覆盖正常情况和错误情况

## 常见问题

### Q: 为什么要先硬编码？

A: 这是 TDD 的核心思想！先用最简单的方式让测试通过，然后通过更多测试驱动出正确的实现。这确保你不会过度设计。

### Q: 测试失败了怎么办？

A: 这很正常！TDD 循环就是：失败 -> 修复 -> 通过。查看错误信息，修改实现。

### Q: 需要测试每个函数吗？

A: 是的！每个公开的函数都应该有测试。这是 TDD 的精髓。

### Q: 属性测试有什么用？

A: 属性测试能发现你没想到的边界情况。QuickCheck 会生成 100 个随机测试用例。

## 学习资源

- [Hspec 文档](https://hspec.github.io/)
- [QuickCheck 教程](http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html)
- [TDD in Haskell](https://wiki.haskell.org/Test_Driven_Development)

## 下一步

完成计算器后，尝试：
1. Validator 项目（输入验证）
2. 自己的 TDD 项目

记住：**先写测试，再写代码！** 这是 TDD 的精髓。

祝你编码愉快！🚀

