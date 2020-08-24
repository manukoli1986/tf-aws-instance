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
  # instance_type = var.ec2_env
}

# output "ec2" {
#   value = "${modules.ec2.ec2_public_ip}"
#   #module.<MODULE NAME>.<OUTPUT NAME>
# }
