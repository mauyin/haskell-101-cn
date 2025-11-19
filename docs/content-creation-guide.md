# 内容创作指南

> 为 Haskell 101 课程创建新内容的标准指南

本文档定义了创建课程内容的标准和最佳实践。遵循这些指南可确保整个课程的一致性和质量。

---

## 📚 技术栈

我们使用 **mdbook** 构建课程内容：

- **格式**: Markdown (`.md`)
- **构建工具**: mdbook
- **部署**: GitHub Pages
- **语言**: 简体中文

### 为什么选择 mdbook？

✅ 自动生成导航和搜索  
✅ 移动端友好的响应式设计  
✅ 代码语法高亮（支持 Haskell）  
✅ 打印/PDF 生成  
✅ 零 HTML/CSS 维护成本  
✅ 专注内容创作

---

## 🗂️ 目录结构

```
haskell-101-cn/
├── book.toml                      # mdbook 配置文件
├── src/                           # mdbook 源文件
│   ├── SUMMARY.md                 # 目录（自动生成侧边栏）
│   ├── README.md                  # 课程首页
│   ├── week-00-setup/
│   │   ├── README.md              # Week 概述
│   │   ├── lecture.md             # 详细讲义
│   │   └── exercises.md           # 练习说明
│   ├── week-01-basics/
│   │   └── ...
│   └── appendix/
│       └── teaching-guide.md
│
├── exercises/                     # 所有练习文件集中存放
│   ├── week-00/
│   │   ├── tasks/                 # 练习题（学生下载）
│   │   │   ├── exercise-01-hello.hs
│   │   │   └── exercise-02-ghci.md
│   │   ├── solutions/             # 参考答案
│   │   │   ├── exercise-01-hello.hs
│   │   │   └── exercise-02-ghci.md
│   │   └── examples/              # 额外示例（可选）
│   ├── week-01/
│   │   ├── tasks/
│   │   ├── solutions/
│   │   └── examples/
│   └── ...
└── docs/
    └── ...
```

### 关键原则

1. **mdbook 内容在 `src/` 目录** - 这是 mdbook 编译的源
2. **练习文件在 `exercises/` 目录** - 按周组织，便于管理
3. **清晰的分类**：
   - `tasks/` - 学生下载的练习题
   - `solutions/` - 参考答案
   - `examples/` - 额外示例代码（可选）
4. **双重用途**：
   - `src/` 中的 markdown 用于阅读和浏览
   - `exercises/` 中的文件用于下载和实践

---

## ✍️ 内容创作流程

### 新建一周的内容

假设你要创建 **Week 1: Haskell 基础语法**：

#### 步骤 1: 创建 mdbook 源文件

```bash
# 在 src/ 目录创建内容
cd src/week-01-basics/

# 创建以下文件：
# - README.md       (概述页面)
# - lecture.md      (详细讲义)
# - exercises.md    (练习说明)
```

#### 步骤 2: 创建实际练习文件

```bash
# 在 exercises 目录创建本周文件
cd exercises/week-01/

# 在 tasks/ 创建练习文件
# - tasks/exercise-01-functions.hs
# - tasks/exercise-02-lists.hs

# 在 solutions/ 创建参考答案
# - solutions/exercise-01-functions.hs
# - solutions/exercise-02-lists.hs

# 可选：在 examples/ 创建示例代码
# - examples/recursion-demo.hs
```

#### 步骤 3: 更新 SUMMARY.md

编辑 `src/SUMMARY.md`，添加新章节：

```markdown
# Week 1: Haskell 基础语法

- [概述](week-01-basics/README.md)
- [详细讲义](week-01-basics/lecture.md)
- [练习作业](week-01-basics/exercises.md)
```

#### 步骤 4: 本地预览

```bash
# 启动本地服务器
mdbook serve

# 在浏览器打开 http://localhost:3000
# 实时查看你的更改
```

---

## 📝 Markdown 编写规范

### 文件模板

#### README.md 模板（每周概述）

```markdown
# Week X: 章节标题

> 一句话概括本周主题

## 📋 本周目标

- 学习目标 1
- 学习目标 2
- 学习目标 3

## ⏱️ 预计时长

- **学习时间**：X 小时
- **练习时间**：Y 小时

## 📚 学习材料

1. **[详细讲义](lecture.md)** - 核心内容
2. **[练习作业](exercises.md)** - 实践练习

## 🎯 前置知识

- 需要掌握的前置内容

---

**完成本周后，继续学习下一章节** →
```

#### lecture.md 模板（详细讲义）

```markdown
# Week X: 章节标题 - 详细讲义

## 1. 主题 A

### 1.1 子主题

解释概念...

**示例**：

​```haskell
-- 代码示例
add :: Int -> Int -> Int
add x y = x + y
​```

### 1.2 子主题

更多内容...

## 2. 主题 B

...

## 练习时间

现在该做 [练习作业](exercises.md) 了！
```

#### exercises.md 模板（练习说明）

```markdown
# Week X: 练习作业

## 📥 下载练习文件

- **[练习 1: 标题](../../exercises/week-01/tasks/exercise-01.hs)** - 下载链接
- **[练习 2: 标题](../../exercises/week-01/tasks/exercise-02.hs)** - 下载链接
- **[参考答案](../../exercises/week-01/solutions/)** - 完成后查看
- **[示例代码](../../exercises/week-01/examples/)** - 额外学习材料

---

## 练习 1: 标题

**文件**: `exercise-01.hs`  
**难度**: ⭐⭐☆☆☆

### 目标

- 目标 1
- 目标 2

### 内容预览

​```haskell
-- 在练习文件中完成这个函数
functionName :: Type -> Type
functionName = undefined
​```

---

## 练习 2: 标题

...
```

---

## 🎨 格式化规范

### 标题层级

```markdown
# 一级标题（每个文件只有一个）
## 二级标题（主要章节）
### 三级标题（子章节）
#### 四级标题（细节）
```

### 代码块

#### Haskell 代码

```markdown
​```haskell
-- 始终包含类型签名
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)
​```
```

#### 终端命令

```markdown
​```bash
# 安装 GHCup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
​```
```

#### GHCi 会话

```markdown
​```haskell
ghci> 2 + 2
4
ghci> :type "hello"
"hello" :: String
​```
```

### 强调和提示

#### 重要信息

```markdown
> **重要**：这是关键信息

> **注意**：请特别注意这一点

> **提示**：这里有一个有用的技巧
```

#### 表情符号使用

```markdown
📚 学习材料
💻 练习作业
🎯 学习目标
⏱️ 时间估计
✅ 已完成
⚠️ 注意事项
🔧 工具
🚀 快速开始
📖 扩展阅读
💡 提示
```

### 链接规范

#### 内部链接（mdbook 章节）

```markdown
<!-- 链接到其他章节 -->
参见 [Week 2 - 数据类型](../week-02-datatypes/README.md)

<!-- 链接到同一目录的文件 -->
查看 [详细讲义](lecture.md)
```

#### 外部链接

```markdown
[GHCup 官方文档](https://www.haskell.org/ghcup/)
```

#### 下载文件链接

```markdown
<!-- 链接到仓库中的实际文件 -->
下载 [exercise-01.hs](../../exercises/week-01/tasks/exercise-01.hs)
查看 [参考答案](../../exercises/week-01/solutions/exercise-01.hs)
参考 [示例代码](../../exercises/week-01/examples/demo.hs)
```

### 列表

#### 无序列表

```markdown
- 第一项
- 第二项
  - 嵌套项
  - 另一个嵌套项
- 第三项
```

#### 有序列表

```markdown
1. 第一步
2. 第二步
3. 第三步
```

#### 任务列表

```markdown
- [ ] 未完成的任务
- [x] 已完成的任务
```

### 表格

```markdown
| 列 1    | 列 2    | 列 3    |
|---------|---------|---------|
| 内容 A  | 内容 B  | 内容 C  |
| 内容 D  | 内容 E  | 内容 F  |
```

---

## 💻 代码示例最佳实践

### 1. 始终包含类型签名

❌ **不好**：
```haskell
double x = x * 2
```

✅ **好**：
```haskell
double :: Int -> Int
double x = x * 2
```

### 2. 添加有意义的注释

```haskell
-- | 计算列表中所有偶数的和
sumEvens :: [Int] -> Int
sumEvens xs = sum (filter even xs)
```

### 3. 提供完整示例

```haskell
-- 定义
greet :: String -> String
greet name = "Hello, " ++ name ++ "!"

-- 使用示例
main :: IO ()
main = do
  putStrLn (greet "Alice")  -- 输出: Hello, Alice!
  putStrLn (greet "Bob")    -- 输出: Hello, Bob!
```

### 4. 保持示例简洁

- 每个示例不超过 30 行
- 专注于一个概念
- 如果需要更长的代码，考虑拆分

### 5. 渐进式复杂度

```markdown
<!-- 从简单开始 -->
### 基础版本
​```haskell
add :: Int -> Int -> Int
add x y = x + y
​```

<!-- 然后增加复杂度 -->
### 泛型版本
​```haskell
add :: Num a => a -> a -> a
add x y = x + y
​```
```

---

## 🎓 练习文件创作指南

### Haskell 练习文件模板

```haskell
{- |
Week X - 练习 Y: 标题
================================

练习描述...

如何使用：
1. 完成每个 TODO
2. 在 GHCi 中测试：ghci> :load exercise-XX.hs
3. 对照 solutions/ 中的参考答案
-}

module ExerciseXX where

-- ============================================================================
-- 练习 X.1: 小节标题
-- ============================================================================

{- | 
函数描述

示例：
  functionName input1 应该返回 output1
  functionName input2 应该返回 output2
-}

functionName :: InputType -> OutputType
functionName = undefined  -- TODO: 实现这个函数


-- ============================================================================
-- 练习 X.2: 另一个小节
-- ============================================================================

-- ... 更多练习
```

### Markdown 练习指南模板

```markdown
# Week X - 练习 Y: 标题

本练习的目标...

## 前置条件

- [ ] 前置知识 1
- [ ] 前置知识 2

## 练习说明

### 第 1 部分：标题

任务描述...

​```haskell
ghci> -- 在这里输入命令
-- 你的输出：
​```

### 第 2 部分：标题

...

## 自测问题

1. 问题 1？
2. 问题 2？
```

---

## 🧪 本地开发和测试

### 安装 mdbook

```bash
# 使用 Cargo（Rust 包管理器）
cargo install mdbook

# 或下载预编译二进制
# https://github.com/rust-lang/mdBook/releases
```

### 常用命令

```bash
# 构建书籍
mdbook build

# 启动本地服务器（带实时重载）
mdbook serve

# 清理构建产物
mdbook clean

# 测试所有链接
mdbook test
```

### 预览地址

- 本地开发：`http://localhost:3000`
- GitHub Pages：`https://yourusername.github.io/haskell-101-cn/`

---

## 📋 内容检查清单

在提交新内容前，确保：

### 内容质量

- [ ] 所有 Haskell 代码都有类型签名
- [ ] 代码示例已在 GHCi 中测试
- [ ] 中文语法和标点正确
- [ ] 概念解释清晰易懂
- [ ] 渐进式难度（从易到难）

### 文件结构

- [ ] `src/week-XX/README.md` 存在
- [ ] `src/week-XX/lecture.md` 存在
- [ ] `src/week-XX/exercises.md` 存在
- [ ] `week-XX/exercises/*.hs` 练习文件存在
- [ ] `week-XX/exercises/solutions/` 参考答案存在
- [ ] `src/SUMMARY.md` 已更新

### 格式规范

- [ ] 标题层级正确
- [ ] 代码块有语言标签
- [ ] 内部链接可用
- [ ] 外部链接有效
- [ ] 表情符号使用得当

### 可访问性

- [ ] 下载链接指向正确文件
- [ ] mdbook 中的练习内容完整
- [ ] 导航逻辑清晰

---

## 🎯 内容创作原则

### 1. 学生优先

- 使用清晰、简单的语言
- 提供大量示例
- 预期常见错误并提前说明
- 提供多种学习路径（阅读、下载、实践）

### 2. 渐进式学习

- 每周的内容基于前几周
- 不要跳跃式引入概念
- 重复关键概念以加强记忆

### 3. 实践驱动

- 每个概念配有可运行的代码
- 提供动手练习
- 鼓励在 GHCi 中实验

### 4. 真实应用

- 使用实际案例
- Week 7 连接到 Cardano
- 避免过于学术的示例

### 5. 自学友好

- 内容自包含
- 提供足够的上下文
- 清晰的导航和前后关系

---

## 🚀 快速开始清单

开始创建新内容时，按以下顺序进行：

1. **规划内容**
   - [ ] 确定学习目标
   - [ ] 列出主要概念
   - [ ] 设计练习

2. **创建结构**
   - [ ] 在 `src/week-XX/` 创建 README、lecture、exercises
   - [ ] 在 `week-XX/exercises/` 创建练习文件
   - [ ] 更新 `src/SUMMARY.md`

3. **编写内容**
   - [ ] 先写 lecture.md（核心内容）
   - [ ] 然后写 exercises.md（练习说明）
   - [ ] 最后写 README.md（概述）

4. **创建练习**
   - [ ] 编写练习文件（带 TODO）
   - [ ] 编写参考答案
   - [ ] 测试所有代码

5. **本地测试**
   - [ ] `mdbook serve` 查看效果
   - [ ] 检查所有链接
   - [ ] 在 GHCi 测试代码

6. **提交**
   - [ ] 提交前再次检查清单
   - [ ] 编写清晰的 commit 信息

---

## 📚 参考资源

- [mdbook 官方文档](https://rust-lang.github.io/mdBook/)
- [Markdown 指南](https://www.markdownguide.org/)
- [Rust Course (示例)](https://course.rs) - 优秀的 mdbook 中文教程示例
- [Haskell 官方文档](https://www.haskell.org/documentation/)

---

## 💬 需要帮助？

- 查看 `week-00-setup/` 作为完整示例
- 在 GitHub Issues 中提问
- 参考现有章节的实现

---

**祝你内容创作顺利！** 🎉

