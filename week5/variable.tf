# ---------- Variable ----------
variable "create_bastion" {
  description = "Create Bastion Server, YES/NO"
  default     = "NO"
}

variable "dev_server" {
  description = "Quantity of Dev Server, NUMBER"
  default     = "2"
}

variable "prod_server" {
  description = "Quantitiy & Spec of Prod Server, MAP"
  default = {
    service1 = {
      ami           = "ami-06eb68a3c20079122" // amazon linux 2
      instance_type = "t2.micro"
      volume_size   = "8"
    }
    service2 = {
      ami           = "ami-06eb68a3c20079122" // amazon linux 2
      instance_type = "t3.micro"
      volume_size   = "10"
    }
  }

}

# ---------- Data ----------

# amazonlinux2 latest ami 
data "aws_ami" "amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}
