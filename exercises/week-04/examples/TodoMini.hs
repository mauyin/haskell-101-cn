{- |
TodoMini - 迷你 TODO 应用示例

本程序演示：
1. 完整的 CRUD 操作
2. 文件持久化
3. 交互式程序循环
4. 数据类型设计
5. IO 与纯函数组合

学习要点：
- 数据持久化（Read/Show）
- 交互式循环
- 列表操作
- 完整应用程序结构

运行方式：
  ghci> :load TodoMini.hs
  ghci> main
  
  程序会创建 todos.txt 文件保存数据
-}

module TodoMini where

import System.IO (hFlush, stdout)
import Data.List (intercalate)

-- ============================================================================
-- 数据类型定义
-- ============================================================================

-- | TODO 项目
data Todo = Todo
  { task :: String    -- 任务描述
  , done :: Bool      -- 是否完成
  } deriving (Show, Read, Eq)

-- | 应用程序状态
type TodoList = [Todo]

-- 文件路径常量
todoFilePath :: FilePath
todoFilePath = "todos.txt"

-- ============================================================================
-- 纯函数部分（业务逻辑）
-- ============================================================================

-- | 创建新的 TODO 项
createTodo :: String -> Todo
createTodo taskName = Todo taskName False

-- | 标记 TODO 为完成/未完成（切换状态）
toggleTodo :: Int -> TodoList -> Maybe TodoList
toggleTodo index todos
  | index < 1 || index > length todos = Nothing
  | otherwise =
      let (before, target:after) = splitAt (index - 1) todos
          newTodo = target { done = not (done target) }
      in Just (before ++ [newTodo] ++ after)

-- | 删除 TODO 项
deleteTodo :: Int -> TodoList -> Maybe TodoList
deleteTodo index todos
  | index < 1 || index > length todos = Nothing
  | otherwise =
      let (before, _:after) = splitAt (index - 1) todos
      in Just (before ++ after)

-- | 添加 TODO 项
addTodo :: String -> TodoList -> TodoList
addTodo taskName todos = todos ++ [createTodo taskName]

-- | 获取未完成的任务数量
countPending :: TodoList -> Int
countPending = length . filter (not . done)

-- | 获取已完成的任务数量
countCompleted :: TodoList -> Int
countCompleted = length . filter done

-- ============================================================================
-- IO 部分（持久化和交互）
-- ============================================================================

-- | 从文件加载 TODO 列表
loadTodos :: FilePath -> IO TodoList
loadTodos path = do
  content <- readFile path
  if null content
    then return []
    else return (read content :: TodoList)
  -- 注意：实际应用应该使用 try/catch 处理文件不存在的情况

-- | 保存 TODO 列表到文件
saveTodos :: FilePath -> TodoList -> IO ()
saveTodos path todos = do
  -- 使用 show 将数据结构序列化为字符串
  writeFile path (show todos)

-- | 安全加载（处理文件不存在）
safeLoadTodos :: FilePath -> IO TodoList
safeLoadTodos path = do
  -- 简化版：假设文件可以读取或为空
  -- 实际应用应使用 System.Directory.doesFileExist
  result <- loadTodos path
  return result

-- | 显示所有 TODO 项
displayTodos :: TodoList -> IO ()
displayTodos todos = do
  putStrLn "\n=== 我的任务清单 ==="
  if null todos
    then putStrLn "暂无任务"
    else mapM_ printTodo (zip [1..] todos)
  
  -- 显示统计信息
  let pending = countPending todos
      completed = countCompleted todos
  putStrLn $ "\n总计: " ++ show (length todos) 
          ++ " | 待完成: " ++ show pending 
          ++ " | 已完成: " ++ show completed
  where
    printTodo (i, todo) =
      let checkbox = if done todo then "[✓]" else "[ ]"
          taskText = task todo
      in putStrLn $ show i ++ ". " ++ checkbox ++ " " ++ taskText

-- | 显示菜单
displayMenu :: IO ()
displayMenu = do
  putStrLn "\n=== 菜单 ==="
  putStrLn "1. 查看所有任务"
  putStrLn "2. 添加任务"
  putStrLn "3. 完成/取消任务"
  putStrLn "4. 删除任务"
  putStrLn "5. 清除所有已完成任务"
  putStrLn "0. 退出"
  putStr "\n请选择: "
  hFlush stdout

-- | 提示输入
prompt :: String -> IO String
prompt message = do
  putStr message
  hFlush stdout
  getLine

-- | 处理菜单选择
handleChoice :: String -> TodoList -> IO (Maybe TodoList)
handleChoice choice todos = case choice of
  "1" -> do
    displayTodos todos
    return (Just todos)
  
  "2" -> do
    taskName <- prompt "输入任务描述: "
    if null taskName
      then do
        putStrLn "任务描述不能为空！"
        return (Just todos)
      else do
        let newTodos = addTodo taskName todos
        putStrLn "✓ 任务已添加"
        return (Just newTodos)
  
  "3" -> do
    displayTodos todos
    if null todos
      then return (Just todos)
      else do
        indexStr <- prompt "输入任务编号: "
        case reads indexStr of
          [(index, "")] ->
            case toggleTodo index todos of
              Just newTodos -> do
                putStrLn "✓ 任务状态已更新"
                return (Just newTodos)
              Nothing -> do
                putStrLn "✗ 无效的任务编号"
                return (Just todos)
          _ -> do
            putStrLn "✗ 请输入有效的数字"
            return (Just todos)
  
  "4" -> do
    displayTodos todos
    if null todos
      then return (Just todos)
      else do
        indexStr <- prompt "输入要删除的任务编号: "
        case reads indexStr of
          [(index, "")] ->
            case deleteTodo index todos of
              Just newTodos -> do
                putStrLn "✓ 任务已删除"
                return (Just newTodos)
              Nothing -> do
                putStrLn "✗ 无效的任务编号"
                return (Just todos)
          _ -> do
            putStrLn "✗ 请输入有效的数字"
            return (Just todos)
  
  "5" -> do
    let newTodos = filter (not . done) todos
        removed = length todos - length newTodos
    putStrLn $ "✓ 已清除 " ++ show removed ++ " 个已完成的任务"
    return (Just newTodos)
  
  "0" -> return Nothing
  
  _ -> do
    putStrLn "✗ 无效的选择，请重试"
    return (Just todos)

-- | 主循环
mainLoop :: TodoList -> IO ()
mainLoop todos = do
  displayMenu
  choice <- getLine
  result <- handleChoice choice todos
  
  case result of
    Nothing -> do
      -- 退出前保存
      saveTodos todoFilePath todos
      putStrLn "\n已保存。再见！"
    Just newTodos -> do
      -- 保存并继续
      saveTodos todoFilePath newTodos
      mainLoop newTodos

-- | 主程序入口
main :: IO ()
main = do
  putStrLn "=== 迷你 TODO 应用 ==="
  putStrLn "正在加载任务列表..."
  
  -- 加载现有任务
  todos <- safeLoadTodos todoFilePath
  
  putStrLn $ "已加载 " ++ show (length todos) ++ " 个任务"
  
  -- 进入主循环
  mainLoop todos

-- ============================================================================
-- 测试和演示
-- ============================================================================

-- | 创建示例数据
createSampleTodos :: IO ()
createSampleTodos = do
  let samples = 
        [ Todo "学习 Haskell Monad" True
        , Todo "完成 Week 4 练习" False
        , Todo "阅读 LYAH 第 8 章" False
        , Todo "编写 TODO 应用" True
        ]
  saveTodos todoFilePath samples
  putStrLn "已创建示例数据"

-- | 快速测试
quickTest :: IO ()
quickTest = do
  putStrLn "=== 快速测试 ==="
  
  -- 测试纯函数
  let todo1 = createTodo "Test task"
  print todo1
  
  let todos = [createTodo "Task 1", createTodo "Task 2"]
  print todos
  
  -- 测试切换
  case toggleTodo 1 todos of
    Just newTodos -> print newTodos
    Nothing -> putStrLn "Toggle failed"
  
  putStrLn "测试完成"

{-
使用说明：

1. 运行主程序：
   ghci> main
   
2. 创建示例数据：
   ghci> createSampleTodos
   ghci> main

3. 快速测试纯函数：
   ghci> quickTest

4. 手动操作：
   ghci> todos <- safeLoadTodos "todos.txt"
   ghci> displayTodos todos

程序特性：
- 自动保存：每次操作后自动保存到文件
- 持久化：使用 Read/Show 序列化数据
- 错误处理：验证用户输入，防止越界
- 统计功能：显示待完成和已完成任务数量

学习要点：
1. 数据持久化：使用 Read/Show 类型类
2. 纯函数业务逻辑：toggleTodo, deleteTodo, addTodo
3. IO 与纯函数分离：逻辑函数返回 Maybe TodoList
4. 交互式循环：使用递归实现主循环
5. 完整应用结构：菜单 -> 输入 -> 处理 -> 保存 -> 循环

扩展练习：
1. 添加任务优先级
2. 添加任务截止日期
3. 支持任务分类/标签
4. 添加搜索功能
5. 实现任务排序（按优先级、日期等）
6. 添加撤销/重做功能
-}



