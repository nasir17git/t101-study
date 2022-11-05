variable "nickname" {
  description = "nickname for tags:Name"
  default     = "nasir"
}

variable "subnet_cidrs" {
  type        = map(any)
  description = "subnet cidr"
  default = {
    mysubnet1 = "10.10.1.0/24"
    mysubnet2 = "10.10.2.0/24"
  }
}

variable "port" {
  description = "EC2 sg inbound port number"
  default     = "8080"
}
