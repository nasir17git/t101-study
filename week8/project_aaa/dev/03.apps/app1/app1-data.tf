# ---------- App1 설정을 위해 필요한 데이터 조회 ----------

# userdata
locals {
  web = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
}

# env VPC 조회
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-${var.name_prefix}-vpc"
  }
}

# ALB Public 서브넷 ids 조회
data "aws_subnets" "alb_pub_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-pub*"
  }
}

# ALB Private 서브넷 ids 조회
data "aws_subnets" "alb_pri_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-pri*"
  }
}

# EC2 Public 서브넷 ids 조회
data "aws_subnets" "ec2_pub_ids" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.name_prefix}-pub1", "${var.env}-${var.name_prefix}-pub3"]
  }
}

# EC2 Private 서브넷 ids 조회
data "aws_subnets" "ec2_pri_ids" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.name_prefix}-pri1", "${var.env}-${var.name_prefix}-pri3"]
  }
}

# 결과 조회 local로 저장
locals {
  alb_pub = data.aws_subnets.alb_pub_ids.ids
  alb_pri = data.aws_subnets.alb_pri_ids.ids
  ec2_pub = data.aws_subnets.ec2_pub_ids.ids
  ec2_pri = data.aws_subnets.ec2_pri_ids.ids
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
