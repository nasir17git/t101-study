resource "aws_lb" "alb" {
  name               = "${var.env}-${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.pub_ids.ids
  security_groups    = [aws_security_group.alb.id]
  tags = {
    Name = "${var.env}-${var.name_prefix}-alb"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.name_prefix}-alb"
  description = "${var.env}-${var.name_prefix}-alb"
  vpc_id      = data.aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.alb_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      cidr_blocks     = var.alb_cidr_blocks
      security_groups = var.alb_security_groups
      description     = ""
    }
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


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "alb-rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg.arn
  }
}

resource "aws_lb_target_group" "albtg" {
  name     = "${var.env}-${var.name_prefix}-target-grp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
