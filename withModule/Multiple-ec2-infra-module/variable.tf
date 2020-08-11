variable "AWS_ACCESS_KEY_ID" {
    default = "$(aws configure get aws_access_key_id)"
    }
variable "AWS_SECRET_ACCESS_KEY" {
    default = "$(aws configure get aws_secret_access_key)"
    }
variable "aws_region" {
    default = "$(aws configure get region)"
    }

variable "key_name" {
    default = "vinay"
    }
variable "user" { 
    default = "ec2-user"
    }
variable "public_key_path" {
  default = "/vagrant/vinay.pub"
    }
variable "priv_key_path" {
  default = "/vagrant/vinay"
    }
variable "aws_existed_key_name" {
  default = "../../../../../../Downloads/vinay.pem"
}

variable "CIDR" {
  default = "112.196.159.23"  # add your IP address here
}

variable "owner" {
  description = "Infra Owner"
  default = "Me"
    } 
variable "environment" {
  description = "Test Infra"
  default = "Test-VM"
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
