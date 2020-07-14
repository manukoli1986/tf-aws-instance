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
    default = "mayank"
    }
variable "user" { 
    default = "ec2-user"
    }
variable "public_key_path" {
  default = "/vagrant/mayank-user.pub"
    }
variable "priv_key_path" {
  default = "/vagrant/mayank-user"
    }
variable "owner" {
  description = "Infra Owner"
  default = "Mayank Koli"
    } 
variable "environment" {
  description = "Prod"
  default = "prodApp"
    }
variable "connection_timeout" {
  default = "120s"
}
variable "github_token" {
  description = "The GitHub Token to be used for the CodePipeline"
  type        = "string"
}
variable "account_id" {
  description = "id of the active account"
  type        = "string"
}
