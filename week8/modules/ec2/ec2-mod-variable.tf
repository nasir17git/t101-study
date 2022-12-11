# 모듈 작동을 위해 필요한 값을 받아오는 변수들
variable "name_prefix" {}
variable "env" {}
variable "vpc_id" {}
variable "ec2_subnets" {}
variable "ec2_pub_subnets" {}
variable "ec2_pri_subnets" {}
variable "amount" {}
variable "ec2_ingress_rules" {}
variable "more_ec2_sg" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "userdata" {}
variable "volume_size" {}
variable "tags" {}

# -------- 연산을 수행하는 locals

locals {
  amount = toset(formatlist("%d", range(1, var.amount + 1))) // number > sets(strings)
}