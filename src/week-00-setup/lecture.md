# Week 0: 环境搭建详细讲义

## 📚 课程概览

欢迎来到 Haskell 入门课程！在开始学习 Haskell 之前，我们需要先搭建开发环境。

> 💡 **自学提示**: 这一周可能需要 2-3 小时完成。如果遇到问题，不要气馁！安装过程中遇到一些小问题是很正常的。慢慢来，每一步都检查清楚。

本讲义将带你逐步完成以下工具的安装和配置：

- **GHCup** - Haskell 工具链管理器
- **GHC** - Glasgow Haskell Compiler（编译器）
- **Cabal** - 包管理和构建工具
- **HLS** - Haskell Language Server（提供 IDE 功能）
- **VS Code** - 代码编辑器及 Haskell 扩展

---

## 🚀 快速参考（给已安装的用户）

如果你已经完成安装，这里是快速验证命令：

```bash
# 验证所有工具
ghcup --version  # 应输出: 0.1.50.x
ghc --version    # 应输出: 9.6.7
cabal --version  # 应输出: 3.12.x
haskell-language-server-wrapper --version  # 应输出: 2.x

# 测试 GHCi
ghci
# 在 ghci> 提示符中输入：2 + 2
# 应输出：4
# 输入 :quit 退出
```

**遇到问题？** 跳转到 [故障排查](#6-故障排查) 部分。

**首次安装？** 继续阅读下面的详细步骤。

---

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

#### 常见问题解决方案

##### 问题 A: PATH 未自动配置

如果安装后运行 `ghcup --version` 显示 "command not found"，说明 PATH 未自动添加。

**解决方案：手动添加 PATH**

**macOS / Linux:**

```bash
# 添加 GHCup 到 PATH
echo '' >> ~/.zshrc  # macOS 使用 zsh
# 或
echo '' >> ~/.bashrc  # Linux 通常使用 bash

# 添加配置
echo '# GHCup PATH' >> ~/.zshrc  # macOS
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.zshrc

# 或者对于 Linux
echo '# GHCup PATH' >> ~/.bashrc
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.bashrc

# 重新加载配置
source ~/.zshrc   # macOS
source ~/.bashrc  # Linux

# 验证
ghcup --version
```

**Windows (PowerShell):**

PATH 应该已自动配置。如果没有，手动添加 `%APPDATA%\ghcup\bin` 到系统环境变量，然后重启 PowerShell。

##### 问题 B: 下载失败或网络中断

如果安装过程中遇到网络错误（如 "Connection reset by peer" 或 "Download failed"），这通常是网络连接问题。

**解决方案：使用手动分步安装**

按照下面的"方法 2：手动分步安装"进行。

### 安装方法总结

我们提供两种安装方法：

- **方法 1（推荐）**：一键安装脚本（适合网络稳定的情况）
- **方法 2**：手动分步安装（适合网络不稳定或需要更多控制）

#### 方法 1：一键安装（上面已介绍）

这是最简单的方法，但如果遇到网络问题，使用方法 2。

#### 方法 2：手动分步安装

如果一键安装失败，或者你想要更多控制，按以下步骤操作：

**Step 1: 安装 GHCup（仅安装管理器）**

首先确保 GHCup 本身已安装：

```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# 如果安装中断，至少 GHCup 本身应该已安装
# 检查 GHCup 目录
ls ~/.ghcup/bin/ghcup  # 应该存在
```

**Step 2: 配置 PATH（如果未自动配置）**

```bash
# macOS
echo '' >> ~/.zshrc
echo '# GHCup PATH' >> ~/.zshrc
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.zshrc
source ~/.zshrc

# Linux (Bash)
echo '' >> ~/.bashrc
echo '# GHCup PATH' >> ~/.bashrc
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.bashrc
source ~/.bashrc

# 验证 GHCup 可用
ghcup --version
# 应输出: The GHCup Haskell installer, version x.x.x
```

**Step 3: 查看可用版本**

```bash
ghcup list
# 这会显示所有可用的工具和版本
# 找到标记为 "recommended" 的版本
```

**Step 4: 安装 GHC（编译器）**

```bash
# 安装推荐版本的 GHC
ghcup install ghc recommended

# 或安装特定版本（更稳定，适合本课程）
ghcup install ghc 9.6.7

# 如果下载中断，重新运行相同命令即可继续
```

**Step 5: 设置默认 GHC 版本**

```bash
# 设置为默认版本
ghcup set ghc 9.6.7

# 验证安装
ghc --version
# 应输出: The Glorious Glasgow Haskell Compilation System, version 9.6.7
```

**Step 6: 安装 Cabal（构建工具）**

```bash
# 安装推荐版本
ghcup install cabal recommended

# 验证安装
cabal --version
# 应输出: cabal-install version 3.12.x.x
```

**Step 7: 安装 HLS（语言服务器，可选但推荐）**

```bash
# 安装推荐版本
ghcup install hls recommended

# 验证安装
haskell-language-server-wrapper --version
# 应输出: haskell-language-server version: 2.x.x.x
```

**Step 8: 更新 Cabal 包索引**

```bash
cabal update
# 这会下载最新的包列表，可能需要几分钟
```

**Step 9: 完整验证**

运行以下命令确认所有工具都已安装：

```bash
echo "=== GHCup ==="
ghcup --version

echo -e "\n=== GHC ==="
ghc --version

echo -e "\n=== Cabal ==="
cabal --version

echo -e "\n=== HLS ==="
haskell-language-server-wrapper --version

echo -e "\n=== GHCi 测试 ==="
echo "2 + 2" | ghci 2>&1 | grep "^4$"
```

如果所有命令都正常输出，恭喜安装成功！🎉

### 🪟 Windows 安装

有两种方法：

#### 方法 1：WSL2（推荐）

1. 启用 WSL2：打开 PowerShell（管理员），运行：
   ```powershell
   wsl --install
   ```

2. 重启电脑后，在 WSL2 Ubuntu 中按照上面的 **Linux 方法**安装 GHCup

3. 在 WSL2 中完成上述所有手动分步安装步骤

#### 方法 2：原生 Windows

**一键安装：**

在 PowerShell 中运行：

```powershell
# 以管理员身份运行 PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { Invoke-Command -ScriptBlock ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -ArgumentList $true } catch { Write-Error $_ }
```

**手动分步安装（Windows）：**

如果一键安装失败：

**Step 1: 下载并运行 GHCup 安装器**

1. 访问 https://www.haskell.org/ghcup/install.html
2. 下载 Windows 安装程序（.exe）
3. 运行安装程序
4. **重要**：确保安装路径和用户名中没有空格和中文字符

**Step 2: 打开新的 PowerShell 窗口**

安装完成后，关闭旧的 PowerShell，打开新的 PowerShell 窗口。

**Step 3: 验证 GHCup**

```powershell
ghcup --version
# 应输出: The GHCup Haskell installer, version x.x.x
```

**Step 4-9: 与 macOS/Linux 相同**

从 Step 4 开始，使用与 macOS/Linux 相同的命令：

```powershell
# 查看可用版本
ghcup list

# 安装 GHC
ghcup install ghc 9.6.7
ghcup set ghc 9.6.7
ghc --version

# 安装 Cabal
ghcup install cabal recommended
cabal --version

# 安装 HLS
ghcup install hls recommended
haskell-language-server-wrapper --version

# 更新 Cabal 包索引
cabal update
```

**Step 10: Windows 完整验证**

```powershell
Write-Host "=== GHCup ===" -ForegroundColor Green
ghcup --version

Write-Host "`n=== GHC ===" -ForegroundColor Green
ghc --version

Write-Host "`n=== Cabal ===" -ForegroundColor Green
cabal --version

Write-Host "`n=== HLS ===" -ForegroundColor Green
haskell-language-server-wrapper --version
```

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

### 🔧 推荐版本

根据实际安装测试，以下版本组合稳定可靠：

| 工具 | 推荐版本 | 说明 |
|------|---------|------|
| **GHC** | 9.6.7 | GHCup 标记为 "recommended" 的版本，非常稳定 |
| **Cabal** | 3.12.1.0+ | 最新推荐版本 |
| **HLS** | 2.10.0.0+ | 与 GHC 9.6.7 完美兼容 |

查看当前安装的版本：

```bash
# 查看所有工具版本
ghcup list

# 查看当前 GHC 版本
ghc --version
```

**为什么使用 GHC 9.6.7 而不是最新的 9.12.x？**

- ✅ GHC 9.6.7 是 GHCup 标记的 "recommended" 版本
- ✅ 有更好的库和工具兼容性
- ✅ HLS 对其支持更成熟
- ✅ 更少的边缘问题，适合学习

**如需切换到其他版本：**

```bash
# 列出可用的 GHC 版本
ghcup list

# 安装最新版本（如果你想尝试新特性）
ghcup install ghc 9.12.2
ghcup set ghc 9.12.2

# 或切换回稳定版本
ghcup set ghc 9.6.7

# 验证当前版本
ghc --version
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

### 问题 1: 命令找不到 (command not found)

**症状**：
- `bash: ghc: command not found` 
- `zsh: command not found: ghcup`
- `ghc --version` 无输出

**原因**：PATH 环境变量未正确配置

**解决方案（按顺序尝试）**：

**方案 A: 重启终端**（最简单）
1. 关闭所有终端窗口
2. 打开新的终端
3. 测试：`ghcup --version`

**方案 B: 手动重新加载配置文件**

```bash
# macOS (zsh)
source ~/.zshrc

# Linux (bash)
source ~/.bashrc

# 测试
ghcup --version
```

**方案 C: 手动添加 PATH**（如果上述方法都失败）

**macOS:**
```bash
# 检查 GHCup 是否已安装
ls ~/.ghcup/bin/ghcup

# 如果存在，添加到 PATH
echo '' >> ~/.zshrc
echo '# GHCup PATH' >> ~/.zshrc
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.zshrc

# 重新加载
source ~/.zshrc

# 验证
ghcup --version
```

**Linux:**
```bash
# 检查 GHCup 是否已安装
ls ~/.ghcup/bin/ghcup

# 如果存在，添加到 PATH
echo '' >> ~/.bashrc
echo '# GHCup PATH' >> ~/.bashrc
echo '[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"' >> ~/.bashrc

# 重新加载
source ~/.bashrc

# 验证
ghcup --version
```

**Windows:**
1. 检查 `%APPDATA%\ghcup\bin\ghcup.exe` 是否存在
2. 打开"系统属性" → "环境变量"
3. 在用户变量的 `Path` 中添加：`%APPDATA%\ghcup\bin`
4. 重启 PowerShell
5. 测试：`ghcup --version`

**方案 D: 完全重新安装**

如果以上都失败，参考前面的"方法 2：手动分步安装"重新安装。

### 问题 2: 网络下载失败或中断

**症状**：
- `Connection reset by peer`
- `Download failed`
- `curl: (56) Recv failure`
- 下载到一半就停止

**原因**：网络连接不稳定，大文件（如 GHC 192MB+）下载中断

**解决方案**：

**方案 A: 重试下载**（推荐）

```bash
# GHCup 会自动从中断处继续，直接重试：
ghcup install ghc recommended

# 或指定版本
ghcup install ghc 9.6.7
```

**方案 B: 使用手动分步安装**

不要使用一键安装脚本，而是：
1. 先确保 GHCup 本身已安装（通常已安装）
2. 配置 PATH（参考前面的步骤）
3. 手动安装每个组件（GHC、Cabal、HLS）
4. 每个组件安装完成后再安装下一个

详细步骤参考前面的"方法 2：手动分步安装"。

**方案 C: 尝试不同的网络**

- 切换 WiFi 网络
- 使用手机热点
- 使用 VPN（如果在中国大陆）
- 换个时间段（凌晨网络通常更稳定）

**方案 D: 安装较小的 GHC 版本**

```bash
# 某些旧版本文件更小，更容易下载成功
ghcup install ghc 9.4.8
ghcup set ghc 9.4.8
```

### 问题 3: HLS 在 VS Code 中不工作

**症状**：没有代码补全和类型提示

**解决方案**：
1. 检查 HLS 是否安装：`haskell-language-server-wrapper --version`
2. 检查 GHC 和 HLS 版本兼容性：
   ```bash
   ghc --version  # 应为 9.6.7
   haskell-language-server-wrapper --version  # 应为 2.10.0+
   ```
3. 查看 VS Code 输出面板（查看 → 输出 → Haskell）的错误信息
4. 尝试重启 VS Code
5. 确保文件是 `.hs` 扩展名
6. 如果项目有 `.cabal` 文件，在项目根目录打开 VS Code
7. 重新安装 HLS：
   ```bash
   ghcup install hls recommended --force
   ```

### 问题 4: Cabal 安装包失败

**症状**：`cabal install` 报错

**解决方案**：
1. 运行 `cabal update` 更新包列表
2. 删除缓存重试：
   ```bash
   rm -rf ~/.cabal/packages  # macOS/Linux
   rmdir /s %APPDATA%\cabal\packages  # Windows
   ```
3. 检查网络连接
4. 尝试添加 `--allow-newer` 标志：
   ```bash
   cabal install <package> --allow-newer
   ```

### 问题 5: Windows 路径包含空格或中文

**症状**：安装或编译失败，路径相关错误

**解决方案**：
1. **最佳方案**：使用 WSL2（推荐，避免所有 Windows 路径问题）
2. 或创建不含空格和中文的用户账户
3. 或手动指定安装路径到 `C:\ghcup`

### 问题 6: GHC 版本冲突

**症状**：编译时出现奇怪的类型错误或库不兼容

**解决方案**：

```bash
# 查看所有已安装的版本
ghcup list

# 查看当前使用的版本
ghc --version

# 切换到推荐的稳定版本
ghcup set ghc 9.6.7

# 验证切换成功
ghc --version

# 如果需要，重新安装 HLS 以匹配 GHC 版本
ghcup install hls recommended
```

### 问题 7: macOS 上的 Xcode 错误

**症状**：`xcrun: error: invalid active developer path`

**解决方案**：

```bash
# 安装 Xcode 命令行工具
xcode-select --install

# 同意许可协议
sudo xcodebuild -license accept

# 重新运行 GHCup 安装
```

### 完全重新安装（最后手段）

如果所有方法都失败，可以完全清理并重新开始：

```bash
# 1. 删除 GHCup 及所有已安装的工具
ghcup nuke

# 2. 手动删除目录（确保清理干净）
rm -rf ~/.ghcup  # macOS/Linux
# Windows: 删除 %APPDATA%\ghcup 目录

# 3. 清理配置文件中的 PATH 设置
# macOS: 编辑 ~/.zshrc，删除 GHCup 相关行
# Linux: 编辑 ~/.bashrc，删除 GHCup 相关行
# Windows: 从系统环境变量中删除 GHCup 路径

# 4. 重新开始安装（使用方法 2：手动分步安装）
```

### 仍然有问题？

- 📖 查阅 [GHCup 官方文档](https://www.haskell.org/ghcup/)
- 💬 在本仓库的 GitHub Issues 中提问
- 🗨️ 访问 [Haskell Discourse](https://discourse.haskell.org/)
- 📧 联系课程维护者

---

## ✅ 安装完成检查清单

完成安装后，请确认以下所有项目：

### 已安装的工具及版本

| 工具 | 验证命令 | 期望输出 | 状态 |
|------|---------|---------|------|
| **GHCup** | `ghcup --version` | 0.1.50.x | ⬜ |
| **GHC** | `ghc --version` | 9.6.7 | ⬜ |
| **Cabal** | `cabal --version` | 3.12.x | ⬜ |
| **HLS** | `haskell-language-server-wrapper --version` | 2.10.x | ⬜ |
| **GHCi** | `echo "2+2" \| ghci` | 输出包含 `4` | ⬜ |

### 一键验证脚本

**macOS/Linux:**
```bash
#!/bin/bash
echo "======================================"
echo "  Haskell 环境安装验证"
echo "======================================"
echo ""

check_cmd() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1: $($1 --version 2>&1 | head -n1)"
    else
        echo "❌ $1: 未安装或不在 PATH 中"
    fi
}

check_cmd ghcup
check_cmd ghc
check_cmd cabal
check_cmd haskell-language-server-wrapper

echo ""
echo "测试 GHCi..."
if echo "2 + 2" | ghci 2>&1 | grep -q "4"; then
    echo "✅ GHCi: 工作正常"
else
    echo "❌ GHCi: 可能有问题"
fi

echo ""
echo "======================================"
echo "  验证完成！"
echo "======================================"
```

将上述脚本保存为 `check-haskell.sh`，然后运行：
```bash
chmod +x check-haskell.sh
./check-haskell.sh
```

**Windows (PowerShell):**
```powershell
Write-Host "======================================"
Write-Host "  Haskell 环境安装验证"
Write-Host "======================================"
Write-Host ""

function Check-Command($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $version = & $cmd --version 2>&1 | Select-Object -First 1
        Write-Host "✅ $cmd : $version" -ForegroundColor Green
    } else {
        Write-Host "❌ $cmd : 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

Check-Command ghcup
Check-Command ghc
Check-Command cabal
Check-Command haskell-language-server-wrapper

Write-Host ""
Write-Host "======================================"
Write-Host "  验证完成！"
Write-Host "======================================"
```

### 常用命令快速参考

```bash
# GHCup 管理
ghcup list                    # 列出所有可用和已安装的版本
ghcup install ghc <version>   # 安装特定 GHC 版本
ghcup set ghc <version>       # 切换 GHC 版本
ghcup rm ghc <version>        # 删除 GHC 版本
ghcup upgrade                 # 升级 GHCup 本身

# Cabal 包管理
cabal update                  # 更新包索引
cabal install <package>       # 安装包
cabal list <package>          # 搜索包

# GHCi 交互式环境
ghci                          # 启动 GHCi
:load file.hs                 # 加载文件
:reload                       # 重新加载
:type expr                    # 查看类型
:quit                         # 退出

# 编译和运行
ghc file.hs                   # 编译文件
runghc file.hs                # 直接运行（不编译）
```

## 7. 下一步

完成环境搭建后，你应该：

1. ✅ 能够启动 GHCi 并进行基本计算
2. ✅ 在 VS Code 中打开 .hs 文件并看到语法高亮
3. ✅ 使用 GHC 编译简单的 Haskell 程序

现在完成本周的练习：

- [练习 1: Hello Haskell](../../exercises/week-00/tasks/exercise-01-hello.hs)
- [练习 2: GHCi 操作](../../exercises/week-00/tasks/exercise-02-ghci.md)

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

