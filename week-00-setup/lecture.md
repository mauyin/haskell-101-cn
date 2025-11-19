# Week 0: 环境搭建详细讲义

## 📚 课程概览

欢迎来到 Haskell 入门课程！在开始学习 Haskell 之前，我们需要先搭建开发环境。本讲义将带你逐步完成以下工具的安装和配置：

- **GHCup** - Haskell 工具链管理器
- **GHC** - Glasgow Haskell Compiler（编译器）
- **Cabal** - 包管理和构建工具
- **HLS** - Haskell Language Server（提供 IDE 功能）
- **VS Code** - 代码编辑器及 Haskell 扩展

## 1. 安装 GHCup

GHCup 是 Haskell 生态系统的统一安装器，它会自动帮你安装 GHC、Cabal 和 HLS。

### 🐧 Linux / 🍎 macOS 安装

打开终端，运行以下命令：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

**安装过程中的交互提示：**

1. **按 ENTER 继续** - 阅读欢迎信息后按回车
2. **选择安装选项** - 推荐选择 `A`（安装所有工具）
3. **是否添加到 PATH** - 选择 `Yes`（或按回车使用默认值）
4. **是否安装 Stack** - 可选择 `No`（本课程使用 Cabal）

安装完成后，**重启终端**使环境变量生效。

#### macOS 特别注意

如果遇到 `xcrun: error: invalid active developer path` 错误，需要先安装 Xcode 命令行工具：

```bash
xcode-select --install
```

### 🪟 Windows 安装

有两种方法：

#### 方法 1：WSL2（推荐）

1. 启用 WSL2：打开 PowerShell（管理员），运行：
   ```powershell
   wsl --install
   ```

2. 重启电脑后，在 WSL2 Ubuntu 中按 Linux 方法安装 GHCup

#### 方法 2：原生 Windows

1. 访问 https://www.haskell.org/ghcup/install.html
2. 下载 Windows 安装程序（.exe）
3. 运行安装程序，按提示操作
4. **重要**：确保安装路径和用户名中没有空格和中文字符

安装完成后，打开新的 PowerShell 或 Command Prompt 窗口。

### ✅ 验证安装

运行以下命令检查安装是否成功：

```bash
ghcup --version
# 应输出: The GHCup Haskell installer, version ...

ghc --version
# 应输出: The Glorious Glasgow Haskell Compilation System, version 9.x.x

cabal --version
# 应输出: cabal-install version 3.x.x.x

haskell-language-server-wrapper --version
# 应输出: haskell-language-server version: x.x.x.x
```

如果所有命令都正常输出版本号，恭喜你安装成功！🎉

### 🔧 推荐 GHC 版本

本课程推荐使用 **GHC 9.10.x** 或更高版本。查看当前版本：

```bash
ghc --version
```

如需切换版本：

```bash
# 列出可用的 GHC 版本
ghcup list

# 安装特定版本（例如 9.10.1）
ghcup install ghc 9.10.1

# 设置为默认版本
ghcup set ghc 9.10.1
```

## 2. 配置 Cabal

Cabal 是 Haskell 的包管理器和构建工具。初次使用需要更新包列表：

```bash
# 更新 Hackage 包索引
cabal update
```

这个命令会下载 Hackage（Haskell 的包仓库）的最新包列表，可能需要几分钟。

### Cabal 配置文件（可选）

Cabal 的配置文件位于：
- Linux/macOS: `~/.cabal/config`
- Windows: `%APPDATA%\cabal\config`

如果遇到下载慢的问题，可以考虑配置镜像源（国内用户）。

## 3. 安装和配置 VS Code

### 安装 VS Code

访问 https://code.visualstudio.com/ 下载并安装适合你操作系统的版本。

### 安装 Haskell 扩展

1. 打开 VS Code
2. 点击左侧扩展图标（或按 `Ctrl+Shift+X` / `Cmd+Shift+X`）
3. 搜索 "Haskell"
4. 安装 **Haskell**（由 Haskell 官方提供）扩展

### 验证 HLS 工作

1. 创建一个测试文件 `test.hs`：

```haskell
-- test.hs
main :: IO ()
main = putStrLn "Hello, Haskell!"

add :: Int -> Int -> Int
add x y = x + y
```

2. 在 VS Code 中打开该文件
3. 你应该看到：
   - ✅ 语法高亮
   - ✅ 鼠标悬停在 `add` 上会显示类型信息
   - ✅ 自动补全（输入代码时）

如果没有这些功能，检查 VS Code 右下角是否显示 "Haskell Language Server" 正在加载。

### 推荐的 VS Code 设置

在 VS Code 设置（`Ctrl+,` / `Cmd+,`）中添加：

```json
{
  "haskell.manageHLS": "GHCup",
  "editor.formatOnSave": true,
  "files.autoSave": "afterDelay"
}
```

## 4. 使用 GHCi 交互式解释器

GHCi（GHC interactive）是 Haskell 的 REPL（读取-求值-输出循环），非常适合学习和实验。

### 启动 GHCi

在终端中运行：

```bash
ghci
```

你会看到类似这样的提示符：

```
GHCi, version 9.10.1: https://www.haskell.org/ghc/  :? for help
ghci>
```

### 基本计算

尝试一些简单的表达式：

```haskell
ghci> 2 + 2
4

ghci> 10 * 5
50

ghci> 2 ^ 10
1024

ghci> div 10 3    -- 整数除法
3

ghci> 10 / 3      -- 浮点数除法
3.3333333333333335

ghci> sqrt 16
4.0
```

### 字符串和列表

```haskell
ghci> "Hello, " ++ "Haskell!"
"Hello, Haskell!"

ghci> [1, 2, 3] ++ [4, 5]
[1,2,3,4,5]

ghci> length [1, 2, 3, 4, 5]
5

ghci> reverse "Haskell"
"lleksaH"
```

### 定义函数

在 GHCi 中可以直接定义简单函数：

```haskell
ghci> let double x = x * 2
ghci> double 5
10

ghci> let isEven n = n `mod` 2 == 0
ghci> isEven 4
True
ghci> isEven 7
False
```

### 查看类型

使用 `:type`（或简写 `:t`）查看表达式的类型：

```haskell
ghci> :type 5
5 :: Num p => p

ghci> :type "hello"
"hello" :: String

ghci> :type True
True :: Bool

ghci> :type (1, "hello")
(1, "hello") :: Num a => (a, String)
```

### 加载文件

创建一个文件 `hello.hs`：

```haskell
-- hello.hs
greet :: String -> String
greet name = "Hello, " ++ name ++ "!"

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

在 GHCi 中加载：

```haskell
ghci> :load hello.hs
[1 of 1] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.

ghci> greet "Haskell"
"Hello, Haskell!"

ghci> factorial 5
120
```

修改文件后，使用 `:reload`（或 `:r`）重新加载：

```haskell
ghci> :reload
```

### 常用 GHCi 命令

| 命令 | 简写 | 说明 |
|------|------|------|
| `:quit` | `:q` | 退出 GHCi |
| `:load file.hs` | `:l file.hs` | 加载 Haskell 文件 |
| `:reload` | `:r` | 重新加载当前文件 |
| `:type expr` | `:t expr` | 显示表达式的类型 |
| `:info thing` | `:i thing` | 显示类型类或函数的详细信息 |
| `:browse Module` | `:bro Module` | 列出模块中的所有定义 |
| `:help` | `:?` | 显示帮助信息 |
| `:set +s` | - | 显示执行时间和内存使用 |

### 练习 GHCi

尝试以下操作：

```haskell
-- 1. 数学运算
ghci> (5 + 3) * 2
16

-- 2. 布尔运算
ghci> True && False
False

ghci> not True
False

-- 3. 比较运算
ghci> 5 > 3
True

ghci> "abc" == "abc"
True

-- 4. 列表操作
ghci> head [1, 2, 3]
1

ghci> tail [1, 2, 3]
[2,3]

ghci> take 3 [1..10]
[1,2,3]

-- 5. 查看信息
ghci> :info Bool
type Bool :: *
data Bool = False | True
...

ghci> :type head
head :: GHC.Stack.Types.HasCallStack => [a] -> a
```

## 5. 编译和运行 Haskell 程序

除了在 GHCi 中交互式运行，你也可以编译 Haskell 程序为可执行文件。

### 创建程序

创建文件 `Main.hs`：

```haskell
-- Main.hs
module Main where

main :: IO ()
main = do
    putStrLn "欢迎来到 Haskell 世界！"
    putStrLn "你叫什么名字？"
    name <- getLine
    putStrLn ("你好，" ++ name ++ "!")
```

### 方法 1：使用 GHC 直接编译

```bash
ghc Main.hs
```

这会生成可执行文件（Linux/macOS 上是 `Main`，Windows 上是 `Main.exe`）。运行它：

```bash
./Main        # Linux/macOS
Main.exe      # Windows
```

### 方法 2：使用 runghc（解释执行）

不编译直接运行：

```bash
runghc Main.hs
```

### 清理编译产物

GHC 会生成 `.hi` 和 `.o` 文件，可以手动删除：

```bash
rm Main.hi Main.o Main   # Linux/macOS
del Main.hi Main.o Main.exe  # Windows
```

## 6. 故障排查

### 问题 1: 命令找不到

**症状**：`bash: ghc: command not found`

**解决方案**：
1. 确认 GHCup 安装成功
2. 重启终端（使环境变量生效）
3. 手动添加到 PATH（如果自动添加失败）：
   
   Linux/macOS 在 `~/.bashrc` 或 `~/.zshrc` 中添加：
   ```bash
   export PATH="$HOME/.ghcup/bin:$PATH"
   ```
   
   Windows 在系统环境变量中添加 `%APPDATA%\ghcup\bin`

### 问题 2: HLS 在 VS Code 中不工作

**症状**：没有代码补全和类型提示

**解决方案**：
1. 检查 HLS 是否安装：`haskell-language-server-wrapper --version`
2. 查看 VS Code 输出面板（查看 → 输出 → Haskell）的错误信息
3. 尝试重启 VS Code
4. 确保文件是 `.hs` 扩展名
5. 如果项目有 `.cabal` 文件，在项目根目录打开 VS Code

### 问题 3: Cabal 安装包失败

**症状**：`cabal install` 报错

**解决方案**：
1. 运行 `cabal update` 更新包列表
2. 删除缓存重试：`rm -rf ~/.cabal/packages`（Linux/macOS）
3. 检查网络连接
4. 尝试添加 `--allow-newer` 标志

### 问题 4: Windows 路径包含空格

**症状**：安装或编译失败，路径相关错误

**解决方案**：
1. 使用 WSL2（推荐）
2. 或创建不含空格的用户账户
3. 或手动指定安装路径到 `C:\ghcup`

### 问题 5: GHC 版本冲突

**症状**：编译时出现奇怪的类型错误

**解决方案**：
```bash
# 查看当前版本
ghcup list

# 切换到推荐版本
ghcup set ghc 9.10.1

# 验证
ghc --version
```

### 仍然有问题？

- 查阅 [GHCup 官方文档](https://www.haskell.org/ghcup/)
- 在本仓库的 GitHub Issues 中提问
- 访问 [Haskell Discourse](https://discourse.haskell.org/)

## 7. 下一步

完成环境搭建后，你应该：

1. ✅ 能够启动 GHCi 并进行基本计算
2. ✅ 在 VS Code 中打开 .hs 文件并看到语法高亮
3. ✅ 使用 GHC 编译简单的 Haskell 程序

现在完成本周的练习：

- [练习 1: Hello Haskell](exercises/exercise-01-hello.hs)
- [练习 2: GHCi 操作](exercises/exercise-02-ghci.md)

完成后，准备进入 [Week 1: Haskell 基础语法](../week-01-basics/)！

---

## 📚 扩展资源

### 官方文档
- [GHC 用户指南](https://downloads.haskell.org/ghc/latest/docs/users_guide/)
- [Cabal 用户指南](https://cabal.readthedocs.io/)
- [Haskell Language Server 文档](https://haskell-language-server.readthedocs.io/)

### 在线资源
- [Haskell Wiki](https://wiki.haskell.org/)
- [Hackage - Haskell 包仓库](https://hackage.haskell.org/)
- [Hoogle - Haskell 函数搜索](https://hoogle.haskell.org/)

### 社区
- [Haskell Discourse](https://discourse.haskell.org/)
- [r/haskell on Reddit](https://www.reddit.com/r/haskell/)
- [Cardano Forum 中文板块](https://forum.cardano.org/c/chinese/204)

祝学习顺利！🚀

