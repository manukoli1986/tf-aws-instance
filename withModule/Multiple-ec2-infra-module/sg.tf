
variable "ingress_ports" {
  type = list(number)
  description = "List of Ingress Port"
  default = [22,8080,80]
}

module "sg" {
  source = "./modules/sg/"
  name        = "All_traffic"
  description = "Allow all inbound traffic for 22,80 and 8080."
  vpc_id      = "${aws_vpc.new_vpc.id}"
}

# resource "aws_network_interface" "foo" {
#   subnet_id   = "${aws_subnet.my_subnet.id}"
#   private_ips = ["172.16.10.100"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }

# resource "aws_network_interface" "foo" {
#   subnet_id   = "${aws_subnet.my_subnet.id}"
#   private_ips = ["172.16.10.100"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }