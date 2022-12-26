resource "aws_security_group" "var" {
  name        = "${var.env}-${var.name_prefix}-var"
  description = "${var.env}-${var.name_prefix}-var"
  vpc_id      = var.vpc_id

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
    Name = "${var.env}-${var.name_prefix}-var"
  }
}

resource "aws_instance" "var" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  associate_public_ip_address = true
  subnet_id              = var.subnet1_id
  vpc_security_group_ids = [aws_security_group.var.id]
  user_data              = local.web
}

output "var_ip" {
  value = aws_instance.var.public_ip
}




