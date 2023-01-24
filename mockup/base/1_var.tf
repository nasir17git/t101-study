variable "name_prefix" { default = "aaa" }
# variable "network_config" {
#   type = list(object({
#     name     = string
#     vpc_cidr = string
#     pub_cidr = map(any)
#     }
#   ))
# }

variable "network_config" {
  type = list(any)
}
# 작동을 위해 필요한 값을 받아오는 data들
data "aws_availability_zones" "available" { state = "available" } # result slient