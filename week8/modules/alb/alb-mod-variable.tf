# -------- 모듈 입력값을 받아주기 위해 설정된 변수들
variable "name_prefix" {}
variable "env" {}
variable "vpc_id" {}
variable "internal" {}
variable "alb_subnets" {}
variable "alb_pub_subnets" {}
variable "alb_pri_subnets" {}
variable "alb_ingress_rules" {}
variable "more_alb_sg" {}
variable "idle_timeout" {}
variable "target_id" {}
variable "target_port" {}
variable "deregistration_delay" {}
variable "health_check" {}