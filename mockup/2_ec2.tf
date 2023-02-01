# resource "aws_instance" "ec2" {
#   ami                    = data.aws_ami.amazonlinux2.id
#   instance_type          = "t2.micro"
#   subnet_id              = var.dev_sbn1
#   tags = {
#     Name = "ec2"
#   }
# }

# #-----------------------------------------------------------------------------------------------------

# # amazonlinux2 latest ami 
# data "aws_ami" "amazonlinux2" {
#   most_recent = true
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#   }

#   owners = ["amazon"]
# }


