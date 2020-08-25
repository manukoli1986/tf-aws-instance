
resource "aws_instance" "ec2" {
  ami = "ami-0b69ea66ff7391e80"
  # instance_type = "${lookup(var.instance_type,terraform.workspace)}"
  instance_type = "t2.micro"
  vpc_security_group_ids = var.security_group_ids
  key_name = "amar"
  tags = {
    Name = "ec2"
  }
}
