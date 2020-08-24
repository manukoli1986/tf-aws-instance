
resource "aws_instance" "manual_ec2" {
  instance_type          = "t2.micro"
  ami                    = "ami-02354e95b39ca8dec"
  vpc_security_group_ids = ["sg-0f68d11781aa0c0ac"]
  key_name               = "amar"
  subnet_id              = "subnet-565f5368"
  tags = {
    Name = "manual"
  }

}
