resource "aws_lb" "alb" {
  name               = "${var.env}-${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.pub[*].id]
  security_groups    = [aws_security_group.alb.id]
  tags = {
    Name = "${var.env}-${var.name_prefix}-alb"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.name_prefix}-alb"
  description = "${var.env}-${var.name_prefix}-alb"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-alb"
  }
}
