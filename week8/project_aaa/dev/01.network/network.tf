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
    key            = "tfstate/aaa-network"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-678678"
  }
}

# ---------- Network Module ----------
module "network" {
  source           = "../../../modules/network"
  name_prefix      = var.name_prefix
  env              = var.env
  vpc_cidr         = var.vpc_cidr
  pub_subnet_cidrs = var.pub_subnet_cidrs
  pri_subnet_cidrs = var.pri_subnet_cidrs
}

# ---------- Network Module Output ----------
output "pri_ids" { value = module.network.pri_ids }
