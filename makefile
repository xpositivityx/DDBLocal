DDB_ENDPOINT=http://localhost:8000
.PHONY: ddb
ddb:
	docker-compose up -d ddb

.PHONY: terraform-init
terraform-init:
	docker run --rm --network="host" -it -e TF_LOG=DEBUG -v ${PWD}:/app -w /app/terraform hashicorp/terraform init

.PHONY: apply
apply:
	docker run --rm --network="host" -it -e TF_LOG=DEBUG -v ${PWD}:/app -w /app/terraform hashicorp/terraform apply

.PHONY: destroy
destroy:
	docker run --rm --network="host" -it -e TF_LOG=DEBUG -v ${PWD}:/app -w /app/terraform hashicorp/terraform destroy

.PHONY: list-tables
list-tables:
	docker run --rm --network="host" -it -e AWS_REGION=us-east-1 -e AWS_SECRET_ACCESS_KEY=xxxxxxxx -e AWS_ACCESS_KEY_ID=yyyyyyyyyy amazon/aws-cli dynamodb list-tables --endpoint-url ${DDB_ENDPOINT}

.PHONY: scan-items
scan-items:
	docker run --rm --network="host" -it -e AWS_REGION=us-east-1 -e AWS_SECRET_ACCESS_KEY=xxxxxxxx -e AWS_ACCESS_KEY_ID=yyyyyyyyyy amazon/aws-cli dynamodb scan --table-name Obsessions --endpoint-url ${DDB_ENDPOINT}

.PHONY: iex 
iex:
	docker run --rm -it --network="host" -v ${PWD}:/app -w /app/ddb_importer elixir iex -S mix

.PHONY: import 
import:
	docker run --rm -it --network="host" -v ${PWD}:/app -w /app/ddb_importer elixir mix run -e "DdbImporter.csv_to_ddb('$(path)')"

.PHONY: ddb-build 
ddb-build:
	docker run --rm -it -v ${PWD}:/app -w /app/ddb_importer elixir mix deps.get