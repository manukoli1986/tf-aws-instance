
variable "instance_type" {
    default = "t2.nano"
}


resource "aws_instance" "node" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = var.instance_type
  key_name = "amar"
  tags = {
    Name        = "Node1"
    Environment = "prod"
  }
}