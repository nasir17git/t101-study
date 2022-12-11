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
    key            = "tfstate/aaa-app1"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-678678"
  }
}

# ---------- ALB Module ----------
module "alb" {
  source               = "../../../../modules/alb"
  name_prefix          = var.name_prefix
  env                  = var.env
  vpc_id               = data.aws_vpc.vpc.id
  internal             = var.internal
  alb_subnets          = var.alb_subnets
  alb_pub_subnets      = local.alb_pub
  alb_pri_subnets      = local.alb_pri
  alb_ingress_rules    = var.alb_ingress_rules
  more_alb_sg          = var.more_alb_sg
  idle_timeout         = var.idle_timeout
  target_id            = module.ec2.instance
  target_port          = var.target_port
  deregistration_delay = var.deregistration_delay
  health_check         = var.health_check
}

# ---------- EC2 Module ----------
module "ec2" {
  source               = "../../../../modules/ec2"
  name_prefix          = var.name_prefix
  env                  = var.env
  vpc_id               = data.aws_vpc.vpc.id
  ec2_subnets          = var.ec2_subnets
  ec2_pub_subnets      = local.ec2_pub
  ec2_pri_subnets      = local.ec2_pri
  amount               = var.amount
  ec2_ingress_rules    = var.ec2_ingress_rules
  more_ec2_sg          = var.more_ec2_sg
  ami                  = data.aws_ami.amazonlinux2.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  userdata             = local.web
  volume_size          = var.volume_size
  tags                 = var.tags
}
