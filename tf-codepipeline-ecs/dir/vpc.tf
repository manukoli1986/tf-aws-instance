locals {
  subnets = {
    "${var.region}a" = "172.16.0.0/21"
    "${var.region}b" = "172.16.8.0/21"
    "${var.region}c" = "172.16.16.0/21"
  }
}

resource "aws_vpc" "flask" {
  cidr_block = "172.16.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "flask-vpc"
  }
}

resource "aws_internet_gateway" "flask" {
  vpc_id = "${aws_vpc.flask.id}"

  tags = {
    Name = "flask-internet-gateway"
  }
}

resource "aws_subnet" "flask" {
  count      = "${length(local.subnets)}"
  cidr_block = "${element(values(local.subnets), count.index)}"
  vpc_id     = "${aws_vpc.flask.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(local.subnets), count.index)}"

  tags = {
    Name = "${element(keys(local.subnets), count.index)}"
  }
}

resource "aws_route_table" "flask" {
  vpc_id = "${aws_vpc.flask.id}"

  tags = {
    Name = "flask-route-table-public"
  }
}

resource "aws_route" "flask" {
  route_table_id         = "${aws_route_table.flask.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.flask.id}"
}

resource "aws_route_table_association" "flask" {
  count          = "${length(local.subnets)}"
  route_table_id = "${aws_route_table.flask.id}"
  subnet_id      = "${element(aws_subnet.flask.*.id, count.index)}"
}
