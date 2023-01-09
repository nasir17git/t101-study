variable "name_prefix" { default = "aaa" }
variable "env" { default = "dev" }
variable "server_port" { default = "80" }

# --- remote state ---
data "terraform_remote_state" "trf" {
  backend = "remote"
  config = {
    organization = "org-test-221226"
    workspaces = {
      name = "trf_cloud"
    }
  }
}

# --- var_set ---

variable "vpc_id" { default = null }
variable "subnet1_id" { default = null }

locals {
  web = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "WebServer with PrivateIP: $MYIP. Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
}

# amazon linux 
data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
