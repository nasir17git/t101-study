# ------ 프로젝트 공통 설정 ------
variable "name_prefix" {}
variable "env" {}

# ------ Network 설정 ------
variable "vpc_cidr" {}
variable "pub_subnet_cidrs" {}
variable "pri_subnet_cidrs" {}
