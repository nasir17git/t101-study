variable "name_prefix" { default = "aaa" }
variable "env" { default = "dev" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "pub_subnet_cidrs" {
  default = {
    1 = "10.0.15.0/24"
    2 = "10.0.25.0/24"
  3 = "10.0.35.0/24" }
}
variable "pri_subnet_cidrs" {
  default = {
    1 = "10.0.40.0/24"
    2 = "10.0.50.0/24"
  3 = "10.0.60.0/24" }
}

# 작동을 위해 필요한 값을 받아오는 data들
data "aws_availability_zones" "available" { state = "available" }
