# 모듈 작동을 위해 필요한 값을 받아오는 변수들
variable "name_prefix" {}
variable "env" {}
variable "vpc_cidr" {}
variable "pub_subnet_cidrs" {}
variable "pri_subnet_cidrs" {}

# 모듈 작동을 위해 필요한 값을 받아오는 data들
data "aws_availability_zones" "available" { state = "available" }
