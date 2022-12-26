# resource "aws_security_group" "remote" {
#   name        = "${var.env}-${var.name_prefix}-remote"
#   description = "${var.env}-${var.name_prefix}-remote"
#   vpc_id      = data.terraform_remote_state.trf.outputs.vpc_id

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
#     Name = "${var.env}-${var.name_prefix}-remote"
#   }
# }

# resource "aws_instance" "remote" {
#   ami                    = data.aws_ami.amazonlinux2.id
#   instance_type          = "t2.micro"
#   associate_public_ip_address = true
#   subnet_id              = data.terraform_remote_state.trf.outputs.subnet1_id
#   vpc_security_group_ids = [aws_security_group.remote.id]
#   user_data              = local.web
# }

# output "remote_ip" {
#   value = aws_instance.remote.public_ip
# }




