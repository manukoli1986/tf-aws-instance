variable "ingress_ports" {
  type = list(number)
  description = "List of Ingress Port"
  default = [22,8080,80]
}


resource "aws_security_group" "sg" {
  name        = "All_traffic"
  description = "Allow all inbound traffic for 22,80 and 8080."
#   vpc_id      = "${aws_vpc.new_vpc.id}"
  tags = {
    name: "common"
  }

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["112.196.159.23/32"]
    }
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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