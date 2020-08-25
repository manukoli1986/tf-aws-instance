

variable "CIDR" {
    default = "0.0.0.0"
}

resource "aws_security_group" "sg" {
    name        = "All_traffic"
    vpc_id      = "${aws_vpc.new_vpc.id}"
    tags        = {
        name: "common"
    }

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${var.CIDR}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
