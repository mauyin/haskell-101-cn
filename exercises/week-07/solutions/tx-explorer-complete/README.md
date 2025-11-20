# Transaction Explorer - Complete Solution

Week 7 Project 2 - Full working implementation of a Cardano transaction explorer.

## Features

- ✅ Parse Cardano transactions from JSON
- ✅ Beautiful tree-view display
- ✅ Transaction validation
- ✅ Export to JSON, CSV, or text summary
- ✅ Error handling and reporting
- ✅ Modular architecture

## Building

```bash
cabal build
```

## Running

### Basic Usage

Display a transaction:
```bash
cabal run tx-explorer -- transaction.json
```

Using sample data:
```bash
cd exercises/week-07/tasks/sample-data
cabal run tx-explorer -- transaction.json
```

### Export Features

Export to CSV:
```bash
cabal run tx-explorer -- transaction.json --export csv output.csv
```

Export to JSON:
```bash
cabal run tx-explorer -- transaction.json --export json output.json
```

Export summary:
```bash
cabal run tx-explorer -- transaction.json --export summary summary.txt
```

### Example Output

```
Loading transaction from: transaction.json

╔═══════════════════════════════════════════════════════╗
║           Transaction Details                         ║
╠═══════════════════════════════════════════════════════╣
║ ID: a1b2c3d4e5f6a7b8...f0a1b2                         ║
╚═══════════════════════════════════════════════════════╝

Inputs (2):
  ├─ Input #0
  │  └─ f0e1d2c3b4a5968778...#0
  ├─ Input #1
  │  └─ b2a19081726354b5c6...#1

Outputs (2):
  ├─ Output #0
  │  ├─ Address: addr_test1qr5eqq7vusq...
  │  └─ Amount: 60.0 ADA (60000000 Lovelace)
  ├─ Output #1
  │  ├─ Address: addr_test1qz2fxv2umy...
  │  └─ Amount: 19.83 ADA (19830000 Lovelace)

Summary:
  Inputs:  2 UTxOs
  Outputs: 2 UTxOs
  Total Output: 79.83 ADA (79830000 Lovelace)
  Fee:          0.17 ADA (170000 Lovelace)
  Status: ✓ Balanced

✓ Transaction validation passed
```

## Module Structure

- **Types**: Core transaction data types
- **Parser**: JSON parsing logic
- **Validator**: Transaction validation rules
- **Display**: Pretty printing and formatting
- **Export**: Export to various formats
- **Main**: CLI interface

## Sample Data

Test with the provided sample data in `exercises/week-07/tasks/sample-data/`:
- `simple-tx.json` - Minimal transaction
- `transaction.json` - Complete transaction
- `tx-with-metadata.json` - Transaction with metadata

## Learning Points

This solution demonstrates:
- JSON parsing with `aeson`
- Data validation
- Pretty printing with box-drawing characters
- File I/O operations
- Command-line argument parsing
- Multiple export formats
- Modular design patterns
- Error handling with `Either`

## Extensions

Ideas for extending this project:
- Add interactive mode (REPL)
- Add color support (using `ansi-terminal`)
- Support for metadata display
- Support for multi-asset transactions
- Fetch transaction from Blockfrost API by hash
- Add transaction comparison feature
- Support for batch processing multiple transactions
- Add transaction statistics and analytics
- Support for script validation visualization

## Testing

Run with all sample transactions:
```bash
for f in exercises/week-07/tasks/sample-data/*.json; do
  echo "Testing $f"
  cabal run tx-explorer -- "$f"
  echo "---"
done
```

## Notes

- Transaction validation is simplified (doesn't verify signatures)
- Input amounts require UTxO lookup in real scenarios
- This is an educational tool, not production-ready

