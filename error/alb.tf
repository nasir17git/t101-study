# resource "aws_lb" "alb" {
#   name                       = "${var.env}-${var.name_prefix}-alb"
#   internal                   = false
#   load_balancer_type         = "application"
#   subnets                    = tolist([aws_subnet.pub[1].id, aws_subnet.pub[2].id, aws_subnet.pub[3].id])
#   security_groups            = [aws_security_group.alb.id]
#   enable_deletion_protection = false
#   tags = {
#     Name = "${var.env}-${var.name_prefix}-alb"
#   }
# }

# resource "aws_security_group" "alb" {
#   name        = "${var.env}-${var.name_prefix}-alb"
#   description = "${var.env}-${var.name_prefix}-alb"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = var.server_port
#     to_port     = var.server_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${var.env}-${var.name_prefix}-alb"
#   }
# }
