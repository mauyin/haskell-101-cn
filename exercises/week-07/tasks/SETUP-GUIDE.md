# Week 7 设置指南

本指南介绍三种学习路径的环境设置。根据你的学习目标和时间选择合适的路径。

---

## 路径选择建议

| 路径 | 适合人群 | 优点 | 缺点 | 时间投入 |
|------|---------|------|------|----------|
| **A: 示例数据** | Haskell 初学者、时间有限 | 零设置、专注编程 | 无真实体验 | 0 分钟 |
| **B: Blockfrost API** | 想体验真实数据 | 真实区块链、无需节点 | 需要注册、有请求限制 | 5 分钟 |
| **C: 本地节点** | 区块链开发者、高级学习者 | 完全控制、可提交交易 | 复杂设置、需要同步 | 2+ 小时 |

---

## 路径 A: 使用示例数据 ✨

### 推荐指数: ⭐⭐⭐⭐⭐ (初学者首选)

### 概述

所有练习使用预先准备的 JSON 示例数据，无需安装任何 Cardano 工具或注册 API。

### 设置步骤

1. **验证示例数据**

```bash
cd exercises/week-07/tasks/sample-data
ls
```

应该看到：
- simple-tx.json
- transaction.json
- tx-with-metadata.json
- address-info.json
- utxos.json
- block.json

2. **加载练习文件**

```bash
cd ..
ghci Week07Exercises.hs
```

3. **开始练习**

```haskell
ghci> testSimpleTx
ghci> testExtractInputs
```

### 完成度

使用路径 A 可以完成：
- ✅ Set 1: JSON 解析（100%）
- ✅ Set 2: 地址操作（100%）
- ✅ Set 4: 交易构建（100%）
- ✅ 项目 1: 余额查询器（使用模拟数据）
- ✅ 项目 2: 交易浏览器（100%）
- ❌ Set 3: Blockfrost API（需要路径 B）

### 学习成果

即使只用示例数据，你也能：
- 掌握 JSON 解析技巧
- 理解 Cardano 交易结构
- 学会交易验证逻辑
- 构建实用工具

**结论**：路径 A 已经足够完成大部分学习目标！

---

## 路径 B: Blockfrost API 🚀

### 推荐指数: ⭐⭐⭐⭐☆ (推荐)

### 概述

通过 Blockfrost API 查询真实的 Cardano 测试网数据，无需运行本地节点。

### 设置步骤

#### 1. 注册 Blockfrost

访问：https://blockfrost.io

点击 "Sign Up"（免费）

#### 2. 创建项目

登录后：
1. 点击 "Add Project"
2. 选择 "Cardano Testnet"（重要！）
3. 输入项目名称（如 "Haskell Learning"）
4. 点击 "Create Project"

#### 3. 获取 API Key

在项目页面找到 "Project ID"（即 API Key）

格式类似：`testnetXXXXXXXXXXXXXXXX`

**复制并保存这个 Key！**

#### 4. 配置练习文件

编辑 `Week07API.hs`：

```haskell
testConfig :: BlockfrostConfig
testConfig = testnetConfig "testnetXXXXXXXXXXXXXXXX"
--                          ^^^^^^^^^^^^^^^^^^^^^^^^
--                          替换为你的 API Key
```

#### 5. 安装 req 库

```bash
cabal install --lib req aeson text bytestring
```

#### 6. 测试连接

```bash
ghci Week07API.hs
```

```haskell
ghci> testQueryBlock
```

应该看到最新区块信息！

### API 使用限制

Blockfrost 免费额度：
- **请求数**：50,000 请求/天
- **速率**：10 请求/秒
- **数据**：测试网 + 主网

**足够完成所有练习！**

### 注意事项

1. **保护 API Key**
   - 不要提交到 Git
   - 不要公开分享

2. **避免速率限制**
   ```haskell
   -- 在循环中添加延迟
   threadDelay 100000  -- 100ms
   ```

3. **处理错误**
   - 网络问题：重试
   - 429 错误：等待后重试
   - 404 错误：地址可能无效

### 测试地址

使用这个测试网地址进行测试：

```
addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp
```

这是一个有余额的公开测试地址。

### 完成度

使用路径 B 可以完成：
- ✅ Set 1-5: 所有练习（100%）
- ✅ 两个项目（完整功能）

---

## 路径 C: 本地 Cardano 节点 ⚡

### 推荐指数: ⭐⭐⭐☆☆ (可选，高级)

### 概述

运行完整的 Cardano 测试网节点，完全控制，可以提交真实交易。

### 警告

⚠️ **这是高级路径，需要：**
- 至少 20GB 磁盘空间
- 稳定的网络连接
- 2+ 小时同步时间
- 较强的技术能力

**初学者建议先完成路径 A 和 B！**

### 系统要求

- **操作系统**：Linux, macOS, or Windows (WSL2)
- **内存**：至少 4GB RAM（建议 8GB）
- **磁盘**：20GB+ 可用空间
- **网络**：稳定的宽带连接

### 安装步骤

#### 方法 1: 使用 Daedalus 测试网钱包（最简单）

1. 下载 Daedalus Testnet
   - https://testnets.cardano.org/en/testnets/cardano/get-started/wallet/

2. 安装并启动

3. 等待区块链同步（可能需要几小时）

4. 使用 cardano-cli（包含在 Daedalus 中）

#### 方法 2: 编译 cardano-node（推荐开发者）

**前置条件**：

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y automake build-essential curl git \
  jq libffi-dev libgmp-dev libncursesw5 libssl-dev \
  libsystemd-dev libtinfo-dev libtool make pkg-config \
  wget zlib1g-dev

# macOS
brew install automake coreutils libsodium libtool
```

**安装 GHC 和 Cabal**（如果尚未安装）：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghcup install ghc 9.6.3
ghcup install cabal 3.10.2.0
ghcup set ghc 9.6.3
ghcup set cabal 3.10.2.0
```

**克隆并编译 cardano-node**：

```bash
git clone https://github.com/IntersectMBO/cardano-node.git
cd cardano-node
git checkout tags/8.7.3  # 使用稳定版本

# 编译（需要 30-60 分钟）
cabal configure
cabal build cardano-node cardano-cli
```

**复制可执行文件**：

```bash
cp $(find dist-newstyle -name cardano-node -type f) ~/.local/bin/
cp $(find dist-newstyle -name cardano-cli -type f) ~/.local/bin/
```

**验证安装**：

```bash
cardano-cli --version
# 应该显示版本号
```

### 配置测试网节点

#### 1. 获取配置文件

```bash
mkdir -p ~/cardano-testnet
cd ~/cardano-testnet

# 下载 Preview 测试网配置
wget https://book.world.dev.cardano.org/environments/preview/config.json
wget https://book.world.dev.cardano.org/environments/preview/topology.json
wget https://book.world.dev.cardano.org/environments/preview/byron-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/shelley-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/alonzo-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/conway-genesis.json
```

#### 2. 创建数据库目录

```bash
mkdir -p ~/cardano-testnet/db
```

#### 3. 启动节点

```bash
cardano-node run \
  --config config.json \
  --topology topology.json \
  --database-path db/ \
  --socket-path db/node.socket \
  --port 3001
```

**注意**：节点需要同步区块链，可能需要几小时。

#### 4. 检查同步状态

在另一个终端：

```bash
export CARDANO_NODE_SOCKET_PATH=~/cardano-testnet/db/node.socket

cardano-cli query tip --testnet-magic 2
```

输出示例：
```json
{
  "epoch": 432,
  "hash": "abc123...",
  "slot": 115678945,
  "block": 8234567,
  "era": "Babbage",
  "syncProgress": "100.00"
}
```

当 `syncProgress` 达到 100%，节点已同步！

### 使用 cardano-cli

#### 生成密钥对

```bash
# 生成支付密钥
cardano-cli address key-gen \
  --verification-key-file payment.vkey \
  --signing-key-file payment.skey

# 生成地址
cardano-cli address build \
  --payment-verification-key-file payment.vkey \
  --out-file payment.addr \
  --testnet-magic 2

# 查看地址
cat payment.addr
```

#### 获取测试 ADA

1. 复制你的地址
2. 访问水龙头：https://docs.cardano.org/cardano-testnet/tools/faucet/
3. 粘贴地址并请求测试 ADA
4. 等待 1-2 分钟

#### 查询余额

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --testnet-magic 2
```

#### 构建简单交易

```bash
# 1. 查询 UTxO
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --testnet-magic 2 \
  --out-file utxo.json

# 2. 构建交易
cardano-cli transaction build \
  --testnet-magic 2 \
  --tx-in <UTXO_TX_HASH>#<IX> \
  --tx-out <RECIPIENT_ADDR>+<AMOUNT> \
  --change-address $(cat payment.addr) \
  --out-file tx.raw

# 3. 签名交易
cardano-cli transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --testnet-magic 2 \
  --out-file tx.signed

# 4. 提交交易
cardano-cli transaction submit \
  --tx-file tx.signed \
  --testnet-magic 2
```

### 与 Haskell 集成

使用 Haskell 的 `System.Process` 调用 cardano-cli：

```haskell
import System.Process

queryCLI :: String -> IO String
queryCLI addr = readProcess "cardano-cli" 
  [ "query", "utxo"
  , "--address", addr
  , "--testnet-magic", "2"
  ] ""
```

### 完成度

使用路径 C 可以完成：
- ✅ 所有练习（100%）
- ✅ 提交真实交易到测试网
- ✅ 完整的 Cardano 开发体验

---

## 故障排除

### Blockfrost API 问题

**问题：403 Forbidden**
- 检查 API Key 是否正确
- 确认使用的是测试网 Key（不是主网）

**问题：429 Too Many Requests**
- 达到速率限制
- 添加延迟：`threadDelay 200000`

**问题：404 Not Found**
- 地址无效或不存在
- 确认使用测试网地址

### 本地节点问题

**问题：同步很慢**
- 正常现象，测试网约需 1-2 小时
- 确保网络连接稳定
- 检查磁盘空间

**问题：端口已被占用**
- 修改配置中的端口号
- 或停止其他 Cardano 服务

**问题：无法连接节点**
- 检查 `CARDANO_NODE_SOCKET_PATH` 环境变量
- 确认节点正在运行
- 检查socket 文件权限

### 一般问题

**问题：找不到 sample-data**
- 确认在 `exercises/week-07/tasks/` 目录
- 检查文件是否存在

**问题：解析 JSON 失败**
- 检查 JSON 格式
- 使用 `eitherDecode` 查看错误信息

---

## 推荐学习路径

### 第 1 天：路径 A
1. 完成 Set 1-2（JSON 和地址）
2. 熟悉 Cardano 数据结构

### 第 2 天：路径 B（可选）
1. 注册 Blockfrost
2. 完成 Set 3（API 练习）
3. 查询真实数据

### 第 3 天：项目
1. 完成项目 1 或项目 2
2. 应用所学知识

### 第 4 天：路径 C（可选，高级）
1. 设置本地节点
2. 实验 cardano-cli
3. 提交测试交易

---

## 总结

- **初学者**：从路径 A 开始，专注 Haskell 编程
- **想体验真实数据**：添加路径 B，用 5 分钟注册
- **区块链开发者**：挑战路径 C，获得完整体验

**记住**：路径 A 已经足够学习本周的核心内容！

祝学习愉快！🚀

