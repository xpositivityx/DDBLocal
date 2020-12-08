# Local Dynamo Dev

### Includes:
* docker-compose setup for persistent local dynamodb with docker
* configuration for running terraform in docker against local AWS resources
* make target for running aws cli in docker against local dynamodb

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

