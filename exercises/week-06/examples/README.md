# Week 6 Examples

Week 6 错误处理与测试的示例代码。

## 文件说明

### error-handling-examples.hs
演示各种错误处理模式：
- Maybe 模式
- Either 模式
- ExceptT Transformer
- 异常处理
- 错误转换

**运行**:
```bash
runhaskell error-handling-examples.hs
```

### quickcheck-examples.hs
QuickCheck 属性测试完整示例：
- 基础属性
- 条件属性
- 自定义生成器
- 常见属性模式
- 调试技巧

**运行**:
```bash
cabal install --lib QuickCheck
runhaskell quickcheck-examples.hs
```

### hspec-examples.hs（可选，未创建）
Hspec 单元测试示例，请参考 calculator 项目中的测试。

## 快速开始

### 1. 错误处理模式

```haskell
-- Maybe: 简单的可选值
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

-- Either: 携带错误信息
parseAge :: String -> Either String Int
parseAge s = case reads s of
  [(n, "")] -> Right n
  _ -> Left "Invalid number"

-- ExceptT: IO 中的错误处理
readFileE :: FilePath -> ExceptT Error IO String
readFileE path = do
  exists <- liftIO $ doesFileExist path
  if exists
    then liftIO $ readFile path
    else throwError $ FileNotFound path
```

### 2. QuickCheck 属性测试

```haskell
-- 简单属性
prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = reverse (reverse xs) == xs

-- 运行
ghci> quickCheck prop_reverseReverse
+++ OK, passed 100 tests.

-- 条件属性
prop_divide :: Int -> Int -> Property
prop_divide x y = y /= 0 ==> x `div` y * y + x `mod` y == x
```

### 3. Hspec 单元测试

请参考 `calculator` 项目中的 `CalculatorSpec.hs`。

## 学习路径

### 初学者
1. 先运行 `error-handling-examples.hs`
2. 理解每个示例的输出
3. 修改代码实验不同情况

### 进阶
1. 学习 `quickcheck-examples.hs`
2. 为自己的函数编写属性测试
3. 完成 calculator TDD 项目

### 高级
1. 组合使用 Maybe/Either/ExceptT
2. 编写自定义 QuickCheck 生成器
3. 实践 TDD 开发流程

## 常见问题

### Q: Maybe 和 Either 什么时候用？
A: 
- Maybe: 失败原因显而易见（如列表为空）
- Either: 需要详细错误信息（如解析失败）

### Q: QuickCheck 怎么想属性？
A: 思考数学性质：
- 恒等性：`f . g = id`
- 交换律：`f x y = f y x`
- 结合律：`(x op y) op z = x op (y op z)`
- 不变量：某个性质总是成立

### Q: TDD 真的要先写测试吗？
A: 是的！这是 TDD 的核心。先写测试：
1. 帮助你思考需求
2. 确保测试能失败（避免永远通过的测试）
3. 防止过度设计

## 进一步学习

### 错误处理
- [Haskell Wiki: Error Handling](https://wiki.haskell.org/Error_handling)
- [24 Days of Hackage: errors](https://ocharles.org.uk/blog/posts/2012-12-19-24-days-of-hackage-errors.html)

### QuickCheck
- [QuickCheck Manual](http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html)
- [Property-Based Testing](https://hypothesis.works/articles/what-is-property-based-testing/)

### Hspec
- [Hspec User Guide](https://hspec.github.io/)
- [Testing in Haskell](https://www.fpcomplete.com/haskell/tutorial/testing/)

## 练习建议

完成示例后，尝试：

1. **错误处理练习**
   - 为自己的项目添加错误处理
   - 实现一个安全的配置文件解析器
   - 使用 ExceptT 重构 IO 代码

2. **测试练习**
   - 为 Week 5 的代码添加测试
   - 用 TDD 实现一个新功能
   - 编写自定义类型的 Arbitrary 实例

3. **综合项目**
   - 参考 calculator 项目
   - 用 TDD 开发自己的项目
   - 达到 80% 以上测试覆盖率

祝学习愉快！🚀

