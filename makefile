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

.PHONY: list-tables
list-tables:
	docker run --rm --network="host" -it -e AWS_REGION=us-east-1 -e AWS_SECRET_ACCESS_KEY=xxxxxxxx -e AWS_ACCESS_KEY_ID=yyyyyyyyyy amazon/aws-cli dynamodb list-tables --endpoint-url ${DDB_ENDPOINT}