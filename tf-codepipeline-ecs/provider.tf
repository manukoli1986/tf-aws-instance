## Specifies the Region your Terraform Provider will server
provider "aws" {
  region = "var.aws_region"
}


## Specifies the S3 Bucket and DynamoDB table used for the durable backend and state locking
terraform {
  backend "s3" {
    region     = "us-east-1"
    bucket     = "tf-remote-codepipeline-ecs"
#    dynamodb_table = "my_dynamo_table_name"
    key        = "terraform.tfstate"
    encrypt    = true
         }
}

