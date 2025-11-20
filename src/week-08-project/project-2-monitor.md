# 项目 2: Cardano 余额监控器 📊

## 项目概述

构建一个自动化工具，定期检查 Cardano 地址余额变化并发送通知。

### 目标用户

- 需要监控多个地址的用户
- DApp 开发者（监控合约地址）
- 交易所或钱包服务商
- 普通用户（监控自己的地址）

### 关键特性

- 📋 地址监控列表管理
- 🔄 定期自动余额检查
- 🔔 余额变化检测和通知
- 📈 历史数据记录
- 💾 数据持久化
- ⚙️ 配置文件管理

### 技术栈

- **语言**: Haskell
- **库**: aeson, req, bytestring, time, containers
- **API**: Blockfrost (测试网)
- **构建**: Cabal

---

## 功能需求

### 必需功能 (Must-Have)

#### 1. 监控列表管理 (15%)

**功能描述**:
- 添加地址到监控列表
- 删除监控地址
- 查看所有监控地址
- 为地址添加备注/标签

**命令**:
```bash
monitor add <addr> [label]      # 添加地址
monitor remove <addr>           # 删除地址
monitor list                    # 列出所有监控地址
monitor info <addr>             # 查看地址详情
```

**验收标准**:
- [ ] 可以添加至少 20 个地址
- [ ] 删除操作有确认提示
- [ ] 列表显示地址、标签、当前余额、最后检查时间
- [ ] 地址验证（testnet 格式）

**实现提示**:
```haskell
data MonitoredAddress = MonitoredAddress
  { address      :: Address
  , label        :: Maybe String
  , addedAt      :: UTCTime
  , lastChecked  :: Maybe UTCTime
  , lastBalance  :: Maybe Lovelace
  } deriving (Generic, ToJSON, FromJSON)

type MonitorList = [MonitoredAddress]

addAddress :: Address -> Maybe String -> MonitorList -> MonitorList
removeAddress :: Address -> MonitorList -> MonitorList
```

#### 2. 定期余额检查 (25%)

**功能描述**:
- 按设定间隔自动查询所有地址余额
- 支持配置检查间隔（如每5分钟）
- 并发查询多个地址
- 处理 API 限流

**命令**:
```bash
monitor start                   # 启动监控
monitor start --interval 300    # 自定义间隔（秒）
monitor stop                    # 停止监控
monitor status                  # 查看监控状态
```

**验收标准**:
- [ ] 能够按设定间隔自动查询
- [ ] 显示查询进度
- [ ] 正确处理 API 错误和重试
- [ ] Ctrl+C 优雅退出

**实现提示**:
```haskell
import Control.Concurrent (threadDelay)
import Control.Monad (forever)

monitorLoop :: Config -> MonitorList -> IO ()
monitorLoop config addrs = forever $ do
  putStrLn $ formatTime "Checking balances..."
  results <- checkAllAddresses config addrs
  processResults results
  threadDelay (interval config * 1000000)  -- 秒转微秒

checkAllAddresses :: Config -> MonitorList -> IO [BalanceResult]
checkAllAddresses config addrs = do
  forM addrs $ \addr -> do
    result <- queryBalance (apiKey config) (address addr)
    threadDelay 100000  -- 避免速率限制
    return result
```

#### 3. 余额变化检测 (20%)

**功能描述**:
- 检测余额增加或减少
- 计算变化金额
- 记录变化时间
- 分类变化类型（增加/减少）

**命令**:
```bash
monitor changes                 # 查看所有变化
monitor changes <addr>          # 查看特定地址变化
monitor changes --recent        # 最近的变化
```

**验收标准**:
- [ ] 准确检测余额变化
- [ ] 计算正确的变化金额
- [ ] 记录变化时间戳
- [ ] 区分增加/减少

**实现提示**:
```haskell
data BalanceChange = BalanceChange
  { changeAddress :: Address
  , changeTime    :: UTCTime
  , oldBalance    :: Lovelace
  , newBalance    :: Lovelace
  , changeDelta   :: Integer      -- 正数=增加，负数=减少
  } deriving (Generic, ToJSON, FromJSON)

detectChange :: MonitoredAddress -> Lovelace -> Maybe BalanceChange
detectChange monitored newBalance =
  case lastBalance monitored of
    Nothing -> Nothing  -- 首次查询，无变化
    Just oldBal ->
      if oldBal /= newBalance
        then Just $ BalanceChange
          { changeAddress = address monitored
          , changeTime = getCurrentTime
          , oldBalance = oldBal
          , newBalance = newBalance
          , changeDelta = getLovelace newBalance - getLovelace oldBal
          }
        else Nothing
```

#### 4. 控制台通知 (15%)

**功能描述**:
- 检测到变化时立即显示
- 清晰的格式化输出
- 颜色标识（增加=绿色，减少=红色）
- 声音提示（可选）

**验收标准**:
- [ ] 变化立即显示在控制台
- [ ] 显示地址、变化类型、金额
- [ ] 格式美观易读
- [ ] 可选的颜色输出

**实现提示**:
```haskell
-- 使用 ansi-terminal 库（可选）
import System.Console.ANSI

notifyChange :: BalanceChange -> IO ()
notifyChange change = do
  let delta = changeDelta change
  let (color, symbol) = if delta > 0
        then (Green, "↑")
        else (Red, "↓")
  
  -- 设置颜色（可选）
  setSGR [SetColor Foreground Vivid color]
  
  putStrLn $ unlines
    [ "═══ Balance Change Detected ═══"
    , "Address: " ++ show (changeAddress change)
    , "Change:  " ++ symbol ++ " " ++ formatLovelace (abs delta)
    , "Old:     " ++ formatLovelace (getLovelace $ oldBalance change)
    , "New:     " ++ formatLovelace (getLovelace $ newBalance change)
    , "Time:    " ++ formatTime (changeTime change)
    ]
  
  -- 重置颜色
  setSGR [Reset]
```

#### 5. 历史数据持久化 (15%)

**功能描述**:
- 保存所有余额变化到文件
- 保存监控列表
- 支持数据导出
- 定期备份

**命令**:
```bash
monitor history                 # 查看完整历史
monitor history <addr>          # 特定地址历史
monitor export <file>           # 导出为 CSV/JSON
```

**验收标准**:
- [ ] 所有变化都被记录
- [ ] 数据正确保存和加载
- [ ] 支持至少一种导出格式
- [ ] 文件损坏时有恢复机制

**实现提示**:
```haskell
data MonitorState = MonitorState
  { monitorList  :: MonitorList
  , changeHistory :: [BalanceChange]
  , lastSaved    :: UTCTime
  } deriving (Generic, ToJSON, FromJSON)

saveState :: FilePath -> MonitorState -> IO ()
saveState path state = do
  -- 备份旧文件
  exists <- doesFileExist path
  when exists $ copyFile path (path ++ ".bak")
  
  -- 保存新数据
  BSL.writeFile path (encodePretty state)

loadState :: FilePath -> IO (Either String MonitorState)
loadState path = do
  exists <- doesFileExist path
  if exists
    then eitherDecode <$> BSL.readFile path
    else return $ Right defaultState

-- CSV 导出
exportCSV :: [BalanceChange] -> FilePath -> IO ()
exportCSV changes path = do
  let csv = "Time,Address,Old Balance,New Balance,Change\n" ++
            unlines (map formatChangeCSV changes)
  writeFile path csv
```

#### 6. 配置文件管理 (10%)

**功能描述**:
- YAML 配置文件
- 配置检查间隔、API Key 等
- 配置通知选项
- 配置数据存储路径

**文件**: `config.yaml`
```yaml
api:
  key: testnetXXXXXXXXXXXX
  endpoint: https://cardano-testnet.blockfrost.io

monitor:
  interval: 300              # 检查间隔（秒）
  retry_count: 3            # API 失败重试次数
  retry_delay: 5            # 重试延迟（秒）

storage:
  data_dir: ~/.cardano-monitor
  backup_count: 5           # 保留备份数

notification:
  console: true
  color: true               # 彩色输出
  sound: false              # 声音提示
```

**验收标准**:
- [ ] 成功加载配置文件
- [ ] 配置项都能正常工作
- [ ] 配置错误有清晰提示
- [ ] 提供默认配置

**实现提示**:
```haskell
{-# LANGUAGE DeriveGeneric #-}

import Data.Yaml

data Config = Config
  { cfgAPI          :: APIConfig
  , cfgMonitor      :: MonitorConfig
  , cfgStorage      :: StorageConfig
  , cfgNotification :: NotificationConfig
  } deriving (Generic, FromJSON, ToJSON)

data APIConfig = APIConfig
  { apiKey      :: String
  , apiEndpoint :: String
  } deriving (Generic, FromJSON, ToJSON)

-- 加载配置
loadConfig :: FilePath -> IO (Either String Config)
loadConfig path = do
  exists <- doesFileExist path
  if exists
    then first show <$> decodeFileEither path
    else return $ Left "Config file not found"
```

### 可选功能 (Optional)

#### 1. 统计报告 (Extra 5%)
- 每日/每周统计报告
- 余额趋势图（ASCII）
- 最活跃的地址

#### 2. 条件通知 (Extra 5%)
- 只通知超过阈值的变化
- 自定义通知规则
- 邮件通知（高级）

#### 3. 多种通知方式 (Extra 5%)
- 日志文件
- Webhook
- 桌面通知

#### 4. 性能优化 (Extra 5%)
- 并发查询
- 智能缓存
- 增量更新

---

## 技术要求

### 依赖库

```cabal
build-depends:
    base ^>=4.18
  , aeson ^>=2.1
  , text ^>=2.0
  , bytestring ^>=0.11
  , req ^>=3.13
  , time ^>=1.12
  , containers ^>=0.6
  , yaml ^>=0.11
  , directory ^>=1.3
  , filepath ^>=1.4
```

### 模块结构

```
src/
├── Monitor/
│   ├── Types.hs          -- 数据类型
│   ├── Query.hs          -- 余额查询
│   ├── Tracker.hs        -- 变化追踪
│   ├── Notify.hs         -- 通知系统
│   ├── Storage.hs        -- 数据持久化
│   ├── Config.hs         -- 配置管理
│   └── CLI.hs            -- 命令行接口
└── Monitor.hs            -- 主模块
```

### 错误处理

```haskell
data MonitorError
  = APIError String
  | ConfigError String
  | StorageError IOException
  , ValidationError String
  | NetworkError String
  deriving (Show, Typeable)

instance Exception MonitorError

type MonitorM = ExceptT MonitorError IO
```

---

## 实施路线图

### Phase 1: 基础结构 (2小时)

**任务**:
1. 设置 Cabal 项目
2. 定义核心数据类型
3. 实现配置文件加载
4. 创建基本 CLI

**检查点**:
- [ ] 项目编译成功
- [ ] 配置文件正确加载
- [ ] 基本命令可以运行

### Phase 2: API 集成 (2小时)

**任务**:
1. 实现 Blockfrost API 查询
2. 余额查询功能
3. 错误处理和重试
4. 测试 API 调用

**检查点**:
- [ ] 能够查询地址余额
- [ ] API 错误被正确处理
- [ ] 重试机制工作正常

### Phase 3: 监控核心 (2-3小时)

**任务**:
1. 实现监控列表管理
2. 实现定期检查循环
3. 实现变化检测逻辑
4. 实现控制台通知

**检查点**:
- [ ] 监控循环正常运行
- [ ] 变化被正确检测
- [ ] 通知及时显示

### Phase 4: 数据持久化 (1-2小时)

**任务**:
1. 实现状态保存/加载
2. 实现历史记录
3. 实现数据导出
4. 添加备份机制

**检查点**:
- [ ] 数据正确保存
- [ ] 程序重启后恢复状态
- [ ] 历史记录完整

### Phase 5: 完善 (1-2小时)

**任务**:
1. 优化用户界面
2. 改进错误消息
3. 添加进度提示
4. 编写文档
5. 测试边界情况

**检查点**:
- [ ] 用户体验良好
- [ ] 所有功能测试通过
- [ ] 文档完整

---

## 评估标准

### 功能完整性 (60分)

| 功能 | 分值 | 评分标准 |
|------|------|----------|
| 监控列表管理 | 9 | 添加、删除、查看都正常工作 |
| 定期检查 | 15 | 自动循环、间隔准确、错误处理 |
| 变化检测 | 12 | 检测准确、计算正确 |
| 控制台通知 | 9 | 及时、清晰、格式好 |
| 数据持久化 | 9 | 保存/加载、历史记录 |
| 配置管理 | 6 | 配置加载、应用正确 |

### 代码质量 (20分)

- **模块组织** (8分): 结构清晰，职责分明
- **命名** (4分): 变量、函数名清晰
- **类型签名** (4分): 所有导出函数有签名
- **注释** (4分): 关键部分有说明

### 测试 (10分)

- **单元测试** (5分): 至少 3-5 个测试
- **手动测试** (5分): 测试文档或演示

### 用户体验 (10分)

- **启动体验** (3分): 清晰的启动信息
- **运行状态** (3分): 实时状态显示
- **错误处理** (2分): 友好的错误消息
- **文档** (2分): README 完整

---

## 起步代码

起步代码位于：`exercises/week-08/projects/balance-monitor/`

包含：
- 完整的 Cabal 配置
- 所有模块的框架
- 数据类型定义
- TODO 标记的实现位置
- 示例配置文件

**开始步骤**:
```bash
cd exercises/week-08/projects/balance-monitor
cabal build
cabal run balance-monitor -- help
```

查看 `TASKS.md` 获取详细的任务清单。

---

## 示例用法

### 基本流程

```bash
# 1. 添加监控地址
$ monitor add addr_test1q...abc123 "My Wallet"
Added: addr_test1q...abc123
Label: My Wallet

$ monitor add addr_test1q...def456 "Exchange Deposit"
Added: addr_test1q...def456
Label: Exchange Deposit

# 2. 查看监控列表
$ monitor list
Monitoring 2 addresses:

1. addr_test1q...abc123  [My Wallet]
   Balance: 100.000000 ADA
   Last checked: 2025-01-20 15:30:45
   
2. addr_test1q...def456  [Exchange Deposit]
   Balance: 50.000000 ADA
   Last checked: 2025-01-20 15:30:46

# 3. 启动监控
$ monitor start --interval 300
Starting monitor (interval: 5 minutes)...
Press Ctrl+C to stop

[15:30:45] Checking 2 addresses...
[15:30:47] All balances checked. No changes.

[15:35:45] Checking 2 addresses...
═══ Balance Change Detected ═══
Address: addr_test1q...abc123
Change:  ↑ 10.000000 ADA
Old:     100.000000 ADA
New:     110.000000 ADA
Time:    2025-01-20 15:35:46
════════════════════════════════

[15:40:45] Checking 2 addresses...
[15:40:47] All balances checked. No changes.

^C
Stopping monitor...
Saving state...
Goodbye!

# 4. 查看变化历史
$ monitor history
Balance Change History:

2025-01-20 15:35:46
  addr_test1q...abc123 [My Wallet]
  ↑ 10.000000 ADA (100.000000 → 110.000000)

2025-01-20 14:20:30
  addr_test1q...def456 [Exchange Deposit]
  ↓ 5.000000 ADA (55.000000 → 50.000000)

Total changes: 2

# 5. 导出数据
$ monitor export history.csv
Exported 2 changes to history.csv
```

---

## 常见问题

**Q: 检查间隔最短可以设置多少？**  
A: 建议不少于 60 秒，以避免触发 API 速率限制。

**Q: 能监控主网地址吗？**  
A: 可以，但需要主网 API Key 并修改配置文件。

**Q: 程序崩溃后数据会丢失吗？**  
A: 不会。每次检测到变化都会保存，且有自动备份。

**Q: 可以在后台运行吗？**  
A: 可以使用 `nohup` 或 `screen`，或者实现为系统服务。

---

## 资源链接

- [Implementation Guide](guide.md)
- [Evaluation Criteria](evaluation.md)
- [Showcase Guide](showcase.md)
- [Week 7 API Examples](../week-07-cardano/exercises.md)

---

**准备好开始了吗？** 🚀

1. 阅读 [Implementation Guide](guide.md)
2. 进入 `exercises/week-08/projects/balance-monitor/`
3. 查看 `TASKS.md`
4. 开始编码！

祝你成功！💪

