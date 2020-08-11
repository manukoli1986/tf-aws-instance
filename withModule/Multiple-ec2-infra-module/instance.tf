


# resource "aws_key_pair" "deployer" {
#   key_name = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

#Creating new EC2 in new vpc with new subnets
module "ec2module" {
  source = "./modules/ec2"
  instance_type = "t2.small"
}


