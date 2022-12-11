# ---------- Provider 및 Backend 설정 ----------
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# backend 설정
terraform {
  backend "s3" {
    bucket         = "tfstate-678678"
    key            = "tfstate/aaa-database"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-678678"
  }
}

# ---------- Database Module ----------
module "databse" {
  source         = "../../../modules/rds"
  name_prefix    = var.name_prefix
  env            = var.env
  subnet_ids     = local.subnet_ids
  storage_amount = var.storage_amount
  instance_class = var.instance_class
  user_name      = var.user_name
}

# ---------- Database Module Output ----------
output "db_password" {
  value     = module.databse.db_password
  sensitive = true
}


# ---------- Database 설정을 위해 필요한 데이터 조회 ----------
# env VPC 조회
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-${var.name_prefix}-vpc"
  }
}

# env Private 서브넷 id 조회
data "aws_subnets" "pri_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "${var.env}-${var.name_prefix}-pri*"
  }
}

locals { subnet_ids = data.aws_subnets.pri_ids.ids }