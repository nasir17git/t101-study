resource "aws_instance" "ec2" {
  for_each               = toset(var.ec2_amount)
  ami                    = data.aws_ami.amazonlinux2.id
  subnet_id              = data.aws_subnets.pri_ids.ids[each.key - 1]
  instance_type          = var.instance_type
  key_name               = "nasirk17"
  iam_instance_profile   = "nasir-ec2-profile"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data              = local.userdata
  root_block_device {
    volume_type = "gp3"
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = merge(
    { Name = "${var.env}-${var.name_prefix}-ec2-${each.key}" },
  )

}

resource "aws_security_group" "ec2-sg" {
  name        = "${var.env}-${var.name_prefix}-ec2"
  description = "${var.env}-${var.name_prefix}-ec2"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [data.aws_security_group.alb.id]
    description     = ""
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name_prefix}-ec2"
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  for_each         = toset(var.ec2_amount)
  target_group_arn = data.aws_lb_target_group.alb.arn
  target_id        = aws_instance.ec2[each.key].id
  port             = 80
}
