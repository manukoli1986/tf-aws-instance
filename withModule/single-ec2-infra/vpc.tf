
#Creating New single VPC then its subnet
resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name= "new_vpc"
  }
}


#Attach IGW to attach vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.new_vpc.id}"
  tags = {
    Name = "new_gw"
  }
}

#Create Subnet for new VPC
resource "aws_subnet" "new_subnet-1" {
  vpc_id = "${aws_vpc.new_vpc.id}"
  tags = {
    Name= "new_subnet"
  }
  availability_zone = "us-east-1a"
  cidr_block       = "10.0.1.0/24"
}

#Create New Public Route and attach with VPC
resource "aws_route_table" "new_public_route" {
  vpc_id = "${aws_vpc.new_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "new_public_route"
  }
}

#Associate subnet to route table
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.new_subnet-1.id}"
  route_table_id = "${aws_route_table.new_public_route.id}"
}
