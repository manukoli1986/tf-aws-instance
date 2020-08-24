
variable "instance_type" {
    type = "map"
    default = {
      default = "t2.medium"
      dev     = "t2.micro"
      prod    = "t2.large"
    }
}


module "sg_import" {
  source = "./modules/sg"
}

resource "aws_instance" "ec2" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = "${lookup(var.instance_type,terraform.workspace)}"
  vpc_security_group_ids = "$(modules.sg.sg_output}"
  key_name = "amar"
  tags = {
    Name        = "ec2"
  }
}
