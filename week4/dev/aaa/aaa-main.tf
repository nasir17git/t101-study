# provider 설정
terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }

  # backend 설정
  backend "s3" {
    bucket         = "tfstate221101"
    key            = "terraform-backend/module"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate221101"
  }
}

# aaa의 네트워크 설정
module "aaa-network" {
  source       = "../../_modules/00network"
  name_prefix  = var.name_prefix
  env          = var.env
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

# aaa의 ALB 설정
module "aaa-alb" {
  source              = "../../_modules/01alb"
  name_prefix         = var.name_prefix
  env                 = var.env
  alb_ports           = var.alb_ports
  alb_cidr_blocks     = var.alb_cidr_blocks
  alb_security_groups = var.alb_security_groups
  depends_on          = [module.aaa-network]
}

# aaa의 EC2 설정
module "aaa-ec2" {
  source        = "../../_modules/02ec2"
  name_prefix   = var.name_prefix
  env           = var.env
  ec2_amount    = var.ec2_amount
  instance_type = var.instance_type
  volume_size   = var.volume_size
  depends_on    = [module.aaa-alb]
}

# outputs

output "alb_dns_name" { value = module.aaa-alb.alb_dns_name }
output "ec2_private_ips" { value = module.aaa-ec2.ec2_private_ips }