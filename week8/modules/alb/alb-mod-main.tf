resource "aws_lb" "alb" {
  name               = "${var.env}-${var.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.alb_subnets == "pub" ? var.alb_pub_subnets : var.alb_pri_subnets
  security_groups    = concat([aws_security_group.alb.id], var.more_alb_sg)
  tags = {
    Name = "${var.env}-${var.name_prefix}-alb"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.name_prefix}-alb"
  description = "${var.env}-${var.name_prefix}-alb"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      from_port       = ingress.value["ports"]
      to_port         = ingress.value["ports"]
      protocol        = "tcp"
      cidr_blocks     = ingress.value["cidr_blocks"]
      security_groups = ingress.value["security_groups"]
      description     = ingress.value["sg_description"]
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


resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.target_port
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
  listener_arn = aws_lb_listener.default.arn
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
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = var.health_check.health_check_path
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.health_check_timeout
    interval            = var.health_check.health_check_interval
    matcher             = var.health_check.health_check_matcher
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  for_each         = var.target_id != null ? tomap(var.target_id) : tomap([]) //
  target_group_arn = aws_lb_target_group.albtg.arn
  target_id        = each.value.id
  port             = var.target_port
}