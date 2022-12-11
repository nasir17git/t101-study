resource "aws_instance" "ec2" {
  for_each               = local.amount
  ami                    = var.ami
  subnet_id              = var.ec2_subnets == "pub" ? var.ec2_pub_subnets[(each.key + 1) % 2] : var.ec2_pri_subnets[(each.key + 1) % 2]
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.ec2.id]
  user_data              = var.userdata
  root_block_device {
    volume_type = "gp3"
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = merge(
    { Name = "${var.amount == 1 ? "${var.name_prefix}" : "${var.name_prefix}-${each.key}"}" },
    var.tags
  )

}

resource "aws_security_group" "ec2" {
  name        = "${var.env}-${var.name_prefix}-ec2"
  description = "${var.env}-${var.name_prefix}-ec2"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.ec2_ingress_rules)
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
    Name = "${var.env}-${var.name_prefix}-ec2"
  }
}
