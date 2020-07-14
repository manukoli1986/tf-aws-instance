
resource "aws_security_group" "sg" {
  name        = "All_traffic"
  description = "Allow all inbound traffic for 22,80 and 8080."
  vpc_id      = "${aws_vpc.new_vpc.id}"
  tags = {
    name: "common"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # add your IP address here
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