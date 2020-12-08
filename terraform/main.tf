provider "aws" {
    access_key                  = "mock_access_key"
    region                      = "us-east-1"
    secret_key                  = "mock_secret_key"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    endpoints {
        dynamodb       = "http://localhost:8000"
        apigateway     = "http://localhost:4567"
        cloudformation = "http://localhost:4581"
        cloudwatch     = "http://localhost:4582"
        es             = "http://localhost:4578"
        firehose       = "http://localhost:4573"
        iam            = "http://localhost:4593"
        kinesis        = "http://localhost:4568"
        lambda         = "http://localhost:4574"
        route53        = "http://localhost:4580"
        redshift       = "http://localhost:4577"
        s3             = "http://localhost:4572"
        secretsmanager = "http://localhost:4584"
        ses            = "http://localhost:4579"
        sns            = "http://localhost:4575"
        sqs            = "http://localhost:4576"
        ssm            = "http://localhost:4583"
        stepfunctions  = "http://localhost:4585"
        sts            = "http://localhost:4592"
    }
}

resource "aws_dynamodb_table" "obsessions" {
    name = "Obsessions"
    hash_key= "user_id"
    range_key= "created_at"
    billing_mode   = "PROVISIONED"
    read_capacity  = 1
    write_capacity = 1

    attribute {
        name = "user_id"
        type = "S"
    }

    attribute {
        name = "created_at"
        type = "S"
    }

    tags = {
        Name = "dynamo-poc",
        Environment = "dev"
    }
}