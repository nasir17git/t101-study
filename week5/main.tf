# ---------- Provider 및 Backend 설정 ----------

# provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# backend 설정
terraform {
  backend "s3" {
    bucket         = "nasir-t101study-tfstate"
    key            = "t101study/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate_lock"
    # encrypt        = true
  }
}

# ---------- conditionals ----------
resource "aws_instance" "bastion_server" {
  count         = var.create_bastion == "YES" ? 1 : 0
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t3.micro"
  tags = {
    Name = "Bastion Server"
  }
}

# ---------- count ----------
resource "aws_instance" "dev_server" {
  count         = var.dev_server
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t2.micro"
  tags = {
    Name = "dev-${count.index + 1}"
  }
}

# ---------- for_each ----------
resource "aws_instance" "prod_server" {
  for_each      = var.prod_server
  ami           = each.value["ami"]
  instance_type = each.value["instance_type"]

  root_block_device {
    volume_size = each.value["volume_size"]
  }

  tags = {
    Name = "prod-${each.key}"
  }
}