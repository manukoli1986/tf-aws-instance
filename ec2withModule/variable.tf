variable "AWS_ACCESS_KEY_ID" {
  default = "$(aws configure get aws_access_key_id)"
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = "$(aws configure get aws_secret_access_key)"
}
variable "aws_region" {
  default = "$(aws configure get region)"
}
# variable "region_number" {
#    default = {
#    us-east-1a = 1
#    us-east-1b = 2
#    us-east-1c = 3
#        }
#  }

variable "key_name" {
  default = "amar"
}
variable "user" {
  default = "ec2-user"
}
variable "public_key_path" {
  default = "../../../../../Downloads/amar.pem"
}
variable "owner" {
  description = "Infra Owner"
  default     = "Mayank Koli"
}
variable "environment" {
  description = "Test Infra"
  default     = "Test-VM"
}
variable "connection_timeout" {
  default = "120s"
}


#terraform {
#  backend "s3" {
#    region     = "us-east-1"
#    bucket     = "tf-remote-state-test123-eu-east-1"
#    key        = "terraform.tfstate"
#    encrypt    = true
#	 }
#}
