# Weather Tool - 完整实现说明

这里提供关键部分的完整实现。完整代码结构已在 tasks/ 中，学生需要填充 TODO 部分。

## Types.hs 关键实现

```haskell
instance FromJSON WeatherResponse where
  parseJSON = withObject "WeatherResponse" $ \v -> WeatherResponse
    <$> v .: "weather"
    <$> v .: "main"
    <$> v .: "name"
```

## Weather.hs 完整实现

```haskell
import Control.Exception (try, SomeException)

getWeather :: String -> String -> IO (Either WeatherError WeatherResponse)
getWeather apiKey city = do
  result <- try $ runReq defaultHttpConfig $ do
    let params = "q" =: city
              <> "appid" =: apiKey
              <> "units" =: ("metric" :: String)
              <> "lang" =: ("zh_cn" :: String)
    
    response <- req
      GET
      apiBase
      NoReqBody
      jsonResponse
      params
    
    return $ responseBody response
  
  case result of
    Left (err :: SomeException) -> return $ Left (NetworkError $ show err)
    Right wr -> return $ Right wr
```

## Display.hs 完整实现

```haskell
displayWeather :: WeatherResponse -> IO ()
displayWeather wr = do
  TIO.putStrLn $ "城市：" <> name wr
  
  case weather wr of
    [] -> putStrLn "无天气数据"
    (w:_) -> do
      TIO.putStrLn $ "天气：" <> main w
      TIO.putStrLn $ "描述：" <> description w
  
  let m = mainInfo wr
  putStrLn $ "温度：" ++ show (temp m) ++ "°C"
  putStrLn $ "体感：" ++ show (feels_like m) ++ "°C"
  putStrLn $ "湿度：" ++ show (humidity m) ++ "%"

displayError :: WeatherError -> IO ()
displayError (NetworkError msg) = putStrLn $ "网络错误: " ++ msg
displayError (ParseError msg) = putStrLn $ "解析错误: " ++ msg
displayError (APIError msg) = putStrLn $ "API 错误: " ++ msg
```

## Main.hs 完整实现

```haskell
main :: IO ()
main = do
  args <- getArgs
  case args of
    [apiKey, city] -> do
      result <- getWeather apiKey city
      case result of
        Left err -> displayError err
        Right wr -> displayWeather wr
    
    _ -> die "用法: weather-tool <API_KEY> <城市名>\n\
             \示例: weather-tool abc123 Beijing"
```

## 测试说明

1. 获取免费 API key from OpenWeatherMap
2. 构建: `cabal build`
3. 运行: `cabal run weather-tool YOUR_KEY Beijing`

## 预期输出

```
城市：北京
天气：晴
描述：万里无云
温度：25.5°C
体感：27.0°C
湿度：60%
```

