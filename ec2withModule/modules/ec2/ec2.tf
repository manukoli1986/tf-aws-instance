
variable "instance_type" {
    type = "map"
    default = {
      default = "t2.nano"
      dev     = "t2.micro"
      prod    = "t2.large"
    }
}




resource "aws_instance" "node" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = lookup(var.instance_type,terraform.workspace)
  key_name = "amar"
  tags = {
    Name        = "Node1"
  }
}