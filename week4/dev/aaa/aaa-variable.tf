# ------ 프로젝트 공통 설정 ------
variable "name_prefix" {}
variable "env" {}

# ------ Network 설정 ------
variable "vpc_cidr" {}
variable "subnet_cidrs" {}

#  ------ ALB 설정 ------
variable "alb_ports" {}
variable "alb_cidr_blocks" {}
variable "alb_security_groups" {}

# ------ EC2 설정 ------
variable "ec2_amount" {}
variable "instance_type" {}
variable "volume_size" {}