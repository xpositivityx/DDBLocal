# DdbImporter

**Import CSV files to DDB using the power of streams!**

## Installation
* Add priv/obsessions.csv
* build the runtime for elixir:
```bash
make ddb-build
make iex
```
* in the shell run:
```elixir
DdbImporter.csv_to_ddb
```