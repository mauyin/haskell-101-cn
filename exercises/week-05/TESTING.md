# Week 5 Testing Guide

## 概述

本文档列出了 Week 5 所有练习和项目的测试步骤。

## 前置准备

确保安装了以下工具：
```bash
ghc --version    # 应显示 9.10.x 或更高
cabal --version  # 应显示 3.12.x 或更高
```

更新 Cabal 包索引：
```bash
cabal update
```

## 测试清单

### ✅ 1. 基础练习文件

#### Week05Exercises.hs
```bash
cd exercises/week-05/tasks
ghci Week05Exercises.hs
# 在 GHCi 中测试：
# > :load Week05Exercises.hs
# > :type parsePerson
# > runTests
```

**注意**: 需要安装依赖：
```bash
cabal install --lib aeson req text bytestring
```

#### MyModule.hs
```bash
ghci MyModule.hs
# 测试：
# > square 5
# > area (Circle 10)
```

### ✅ 2. Weather Tool 项目

```bash
cd exercises/week-05/tasks/weather-tool
cabal build
```

**预期结果**: 应该成功构建（可能有 TODO 警告）

**运行**（需要 API key）:
```bash
cabal run weather-tool YOUR_API_KEY Beijing
```

**测试要点**:
- [ ] Cabal 文件语法正确
- [ ] 所有模块可以加载
- [ ] 依赖版本兼容
- [ ] 类型定义正确

### ✅ 3. JSON Parser 项目

```bash
cd exercises/week-05/tasks/json-parser
cabal build
```

**预期结果**: 应该成功构建（可能有 TODO 警告）

**测试命令**:
```bash
cabal run json-parser init test.json
cabal run json-parser show test.json
cabal run json-parser validate test.json
```

**测试要点**:
- [ ] 配置文件正确创建
- [ ] JSON 格式正确
- [ ] 验证逻辑工作

### ✅ 4. 示例代码

#### simple-http-client.hs
```bash
cd exercises/week-05/examples
runghc -package req -package aeson -package text simple-http-client.hs
```

#### json-examples.hs
```bash
runghc -package aeson -package aeson-pretty -package text -package bytestring json-examples.hs
```

#### module-demo
```bash
cd module-demo
ghc Main.hs
./Main
```

### ✅ 5. 解决方案文件

```bash
cd exercises/week-05/solutions
ghci Week05Exercises.hs
# > runTests
```

## 常见问题

### 问题 1: 依赖缺失
```
Could not find module 'Data.Aeson'
```

**解决**:
```bash
cabal install --lib aeson
```

### 问题 2: 版本冲突
```
rejecting: aeson-2.2.0.0 (conflict: ...)
```

**解决**:
```bash
cabal clean
cabal update
cabal build
```

### 问题 3: API 请求失败
```
NetworkError: ...
```

**原因**: 
- 网络问题
- API key 无效
- 请求限制

**解决**: 检查网络连接和 API key

## 完整测试脚本

创建 `test-all.sh`:
```bash
#!/bin/bash

echo "=== Week 5 测试脚本 ==="

# 测试基础文件
echo "\n1. 测试 Week05Exercises.hs"
cd exercises/week-05/tasks
ghc -fno-code Week05Exercises.hs
if [ $? -eq 0 ]; then
    echo "✓ Week05Exercises.hs 语法正确"
else
    echo "✗ Week05Exercises.hs 有错误"
fi

# 测试 weather-tool
echo "\n2. 测试 weather-tool"
cd ../tasks/weather-tool
cabal build 2>&1 | tee build.log
if grep -q "Build successful" build.log; then
    echo "✓ weather-tool 构建成功"
else
    echo "✗ weather-tool 构建失败"
fi

# 测试 json-parser
echo "\n3. 测试 json-parser"
cd ../json-parser
cabal build 2>&1 | tee build.log
if grep -q "Build successful" build.log; then
    echo "✓ json-parser 构建成功"
else
    echo "✗ json-parser 构建失败"
fi

echo "\n=== 测试完成 ==="
```

运行:
```bash
chmod +x test-all.sh
./test-all.sh
```

## 验收标准

Week 5 内容符合以下标准即可认为完成：

- [x] 所有 Markdown 文件格式正确
- [x] 所有 Haskell 文件语法正确（可能有 undefined TODO）
- [x] Cabal 项目可以构建（即使有 TODO 警告）
- [x] 示例代码可以运行
- [x] 文档清晰完整
- [x] 练习题循序渐进
- [x] 解决方案合理

## 下一步

完成测试后：
1. 修复发现的任何问题
2. 提交代码
3. 继续 Week 6 的内容

