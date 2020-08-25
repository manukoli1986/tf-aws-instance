# variable "instance_type" {
#     type = "map"
#     default = {
#       default = "t2.medium"
#       dev     = "t2.micro"
#       prod    = "t2.large"
#     }
# }


variable "security_group_ids" {
    type = "list"
    default = []
}