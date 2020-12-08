# Local Dynamo Dev

### Includes:
* docker-compose setup for persistent local dynamodb with docker
* configuration for running terraform in docker against local AWS resources
* make target for running aws cli in docker against local dynamodb
* elixir project for ingesting csv -> dynamodb using ex_aws_dynamodb and nimble_csv

### Setup:
```bash 
make ddb
make terraform-init
make apply
```
Verify table creation:
```bash
make list-tables
```

### Import data:
* Add priv/obsessions.csv
* build the runtime for elixir:
```bash
make ddb-build
make import
```

* verify data:
```bash
make scan-items
```