# 모듈 작동을 위해 필요한 값을 받아오는 변수들
variable "name_prefix" {}
variable "env" {}
variable "ec2_amount" {}
variable "instance_type" {}
variable "volume_size" {}

# 모듈 작동을 위해 필요한 값을 받아오는 data들

# env VPC 조회
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-${var.name_prefix}-vpc"
  }
}

# [env 프라이빗 서브넷 id 조회](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)
data "aws_subnets" "pri_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-pri*"
  }
}


# EC2 보안그룹에 접근을 허용할 ALB의 보안그룹 조회
data "aws_security_group" "alb" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.name_prefix}-alb"]
  }
}

# 생성된 EC2가 지정될 ALB 대상그룹 조회
data "aws_lb_target_group" "alb" {
  name = "${var.env}-${var.name_prefix}-target-grp"
}

# amazon linux 
data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# userdata
locals {
  userdata = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
}

# -------- 모듈 작동 결과 전달을 위한 output

# EC2 Private IP
output "ec2_private_ips" { value = values(aws_instance.ec2)[*].private_ip }
