# ---------- Variable ----------

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pub1_cidr" {
  default = "10.0.10.0/24"
}

variable "pub2_cidr" {
  default = "10.0.20.0/24"
}


variable "server_port" {
  default = "50000"
}

# ---------- Data ----------

# ubuntu 20.04 latest ami 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

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

# EC2 Data 가져오기 (Public ip 조회)
data "aws_instances" "get_data" {
  filter {
    name   = "tag:Name"
    values = ["101_asg_ec2"]
  }
}