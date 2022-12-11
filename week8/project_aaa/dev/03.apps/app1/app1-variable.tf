# ------ 프로젝트 공통 설정 ------
variable "name_prefix" {}
variable "env" {}

# ------ ALB 설정 ------
# 필수값
variable "internal" {}
variable "alb_subnets" {}
variable "target_port" {}
variable "health_check" {}

# 선택값 
variable "alb_ingress_rules" { default = null }
variable "target_id" { default = null }
variable "more_alb_sg" { default = null }
variable "idle_timeout" { default = null }
variable "deregistration_delay" { default = null }

# ------ EC2 설정 ------
# 필수값
variable "ec2_subnets" {}
variable "amount" {}
variable "instance_type" {}
variable "volume_size" {}
variable "tags" {}

# 선택값 
variable "ec2_ingress_rules" { default = null }
variable "userdata" { default = null }
variable "more_ec2_sg" { default = null }
variable "ami" { default = null }
variable "key_name" { default = null }
variable "iam_instance_profile" { default = null }
