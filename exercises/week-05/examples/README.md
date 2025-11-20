# Week 5 Examples

这个目录包含 Week 5 的示例代码。

## 文件说明

### simple-http-client.hs
演示如何使用 `req` 库发起 HTTP 请求。

**运行**:
```bash
ghc simple-http-client.hs -package req -package aeson -package text
./simple-http-client
```

或使用 runghc:
```bash
runghc -package req -package aeson -package text simple-http-client.hs
```

### json-examples.hs
演示 `aeson` 库的各种 JSON 处理技巧。

**运行**:
```bash
ghc json-examples.hs -package aeson -package aeson-pretty -package text -package bytestring
./json-examples
```

### module-demo/
演示如何组织多模块 Haskell 项目。

**结构**:
```
module-demo/
├── Main.hs
├── Data/
│   └── Types.hs
└── Utils/
    ├── Math.hs
    └── String.hs
```

**编译**:
```bash
cd module-demo
ghc Main.hs
./Main
```

## 学习建议

1. 先阅读代码，理解每个示例的目的
2. 运行示例，观察输出
3. 修改代码，实验不同参数
4. 将概念应用到练习题中

## 依赖

所有示例需要以下包：
- aeson
- aeson-pretty
- req
- text
- bytestring

如果在 GHCi 中运行，使用：
```bash
cabal repl --build-depends="aeson, req, text, bytestring, aeson-pretty"
```

