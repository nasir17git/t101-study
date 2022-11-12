# -------- 모듈 입력값을 받아주기 위해 설정된 변수들
variable "name_prefix" {}
variable "env" {}
variable "alb_ports" {}
variable "alb_cidr_blocks" {}
variable "alb_security_groups" {}

# -------- 모듈 작동을 위해 필요한 데이터

# env VPC 조회
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-${var.name_prefix}-vpc"
  }
}

# [env 퍼블릭 서브넷 id 조회](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)
data "aws_subnets" "pub_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-pub*"
  }
}

# -------- 모듈 작동 결과 전달을 위한 output

# ALB DNS
output "alb_dns_name" { value = aws_lb.alb.dns_name }