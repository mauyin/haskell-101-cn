# JSON Parser - 完整实现说明

## Config.hs 关键实现

```haskell
defaultConfig :: AppConfig
defaultConfig = AppConfig
  { appName = "MyApp"
  , version = "1.0.0"
  , server = ServerConfig 8080 "localhost" False
  , database = DatabaseConfig "localhost" 5432 "mydb" 10
  , logging = LoggingConfig "info" "app.log"
  }

loadConfig :: FilePath -> IO (Either String AppConfig)
loadConfig path = do
  content <- BL.readFile path
  return $ eitherDecode content

saveConfig :: FilePath -> AppConfig -> IO ()
saveConfig path config = BL.writeFile path (encodePretty config)
```

## Validation.hs 完整实现

```haskell
validateConfig :: AppConfig -> [ValidationError]
validateConfig config = 
  validateServer (server config)
  ++ validateDatabase (database config)
  ++ validateLogging (logging config)
  ++ validateApp config
  where
    validateServer srv =
      if port srv < 1 || port srv > 65535
        then [InvalidPort (port srv)]
        else []
      ++ if T.null (host srv)
           then [InvalidHost (host srv)]
           else []
    
    validateDatabase db =
      if T.null (dbName db)
        then [InvalidDbName (dbName db)]
        else []
    
    validateLogging log =
      if not (isValidLogLevel (level log))
        then [InvalidLogLevel (level log)]
        else []
    
    validateApp app =
      if T.null (appName app)
        then [EmptyAppName]
        else []
      ++ if not (isValidVersion (version app))
           then [InvalidVersion (version app)]
           else []
```

## CLI.hs 完整实现

```haskell
parseCommand :: [String] -> Either String Command
parseCommand ["init", path] = Right (Init path)
parseCommand ["show", path] = Right (Show path)
parseCommand ["validate", path] = Right (Validate path)
parseCommand ["help"] = Right Help
parseCommand [] = Right Help
parseCommand _ = Left "无效的命令"

runCommand :: Command -> IO ()
runCommand (Init path) = do
  saveConfig path defaultConfig
  putStrLn $ "已创建默认配置: " ++ path

runCommand (Show path) = do
  result <- loadConfig path
  case result of
    Left err -> putStrLn $ "加载错误: " ++ err
    Right config -> print config

runCommand (Validate path) = do
  result <- loadConfig path
  case result of
    Left err -> putStrLn $ "加载错误: " ++ err
    Right config -> do
      let errors = validateConfig config
      if null errors
        then putStrLn "配置有效！"
        else do
          putStrLn "发现以下错误："
          mapM_ print errors

runCommand Help = printHelp
```

## Main.hs 完整实现

```haskell
main :: IO ()
main = do
  args <- getArgs
  case parseCommand args of
    Left err -> do
      putStrLn $ "错误: " ++ err
      putStrLn ""
      runCommand Help
    Right cmd -> runCommand cmd
```

## 使用示例

```bash
# 初始化
cabal run json-parser init config.json

# 查看
cabal run json-parser show config.json

# 验证
cabal run json-parser validate config.json
```

