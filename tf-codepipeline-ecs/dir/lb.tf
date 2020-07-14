resource "aws_security_group" "lb" {
  name   = "allow-http"
  vpc_id = "${aws_vpc.flask.id}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "flask" {
  name               = "flask-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${aws_subnet.flask.*.id}"]

  tags {
    Name = "flask"
  }
}

locals {
  target_groups = [
    "green",
    "blue",
  ]
}

resource "aws_lb_target_group" "flask" {
  count = "${length(local.target_groups)}"

  name = "flask-tg-${
    element(local.target_groups, count.index)
  }"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.flask.id}"
  target_type = "ip"

  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_listener" "flask" {
  load_balancer_arn = "${aws_lb.flask.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.flask.0.arn}"
  }
}

resource "aws_lb_listener_rule" "flask" {
  listener_arn = "${aws_lb_listener.flask.arn}"

  "action" {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.flask.0.arn}"
  }

  "condition" {
    field  = "path-pattern"
    values = ["/*"]
  }
}
