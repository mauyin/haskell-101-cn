# Balance Checker - Complete Solution

Week 7 Project 1 - Full working implementation of a Cardano address balance checker.

## Features

- ✅ Query single or multiple addresses
- ✅ Display balances in formatted table
- ✅ Support for both testnet and mainnet
- ✅ Caching support (optional)
- ✅ Error handling and reporting
- ✅ Environment variable configuration
- ✅ Beautiful CLI output

## Building

```bash
cabal build
```

## Running

### Setup

1. Register at [Blockfrost.io](https://blockfrost.io)
2. Create a testnet project
3. Copy your API key
4. Set environment variable:

```bash
export BLOCKFROST_API_KEY=testnetXXXXXXXXXXXXXXXX
```

### Usage

Query single address:
```bash
cabal run balance-checker -- addr_test1q...
```

Query multiple addresses:
```bash
cabal run balance-checker -- addr_test1q... addr_test1q... addr_test1q...
```

### Example Output

```
Querying balances...

╔════════════════════════════════════════════════════════╗
║         Cardano Address Balance Checker               ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════╤════════════╤═══════╗
║ Address                                        │ Balance    │ UTxOs ║
╠════════════════════════════════════════════════╪════════════╪═══════╣
║ addr_test1qz2fx...jjxtwq2ytjqp                │ 100.523    │     3 ║
║ addr_test1qr5eq...50gxqn0tzsz                 │  50.0      │     1 ║
╠════════════════════════════════════════════════╪════════════╪═══════╣
║ TOTAL                                          │ 150.523    │       ║
╚════════════════════════════════════════════════╧════════════╧═══════╝

Summary:
  Total addresses: 2
  Successful: 2
  Failed: 0
  Total balance: 150.523 ADA
```

## Module Structure

- **Types**: Core data types
- **API**: Blockfrost API interaction
- **Cache**: Caching mechanism (optional)
- **Display**: Pretty printing and formatting
- **Main**: CLI interface

## Testing

To test without a real API key, you can use the sample data:

```bash
cd exercises/week-07/tasks/sample-data
cat address-info.json
```

## Learning Points

This solution demonstrates:
- Modular Haskell project structure
- HTTP API consumption with `req`
- JSON parsing with `aeson`
- Error handling with `Either` and `Maybe`
- IO operations and effects
- Command-line argument parsing
- Environment variable handling
- Pretty printing and formatting

## Extensions

Ideas for extending this project:
- Add watch mode (continuous monitoring)
- Add notifications for balance changes
- Support for reading addresses from file
- Export results to CSV/JSON
- Add address validation before querying
- Implement advanced caching with TTL
- Add parallel API requests for faster queries
- Support for stake address rewards query

