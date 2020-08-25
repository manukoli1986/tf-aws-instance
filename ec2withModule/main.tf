provider "aws" {
  region = "us-east-1"
}

##### Creation of S3 #############
# module "website_s3_bucket" {
#   source = "./modules/s3"

#   bucket_name = "amar-static-website2020-01-15"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# variable "ec2_env" {}

module "sg_import" {
  source = "./modules/sg"
}

module "ec2instance" {
  source = "./modules/ec2"
  security_group_ids = [module.sg_import.sg_output]
}

