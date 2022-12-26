# resource "aws_instance" "this" {
#   ami = data.aws_ami.amazonlinux2.id
#   instance_type = "t2.micro"
#   subnet_id = 
#   vpc_security_group_ids = [aws_security_group.ec2.id]
#   user_data              = local.web
# }

# resource "aws_security_group" "ec2" {
#   name        = "${var.env}-${var.name_prefix}-ec2"
#   description = "${var.env}-${var.name_prefix}-ec2"
#   vpc_id      = 

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
#     Name = "${var.env}-${var.name_prefix}-ec2"
#   }
# }




