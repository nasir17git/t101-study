terraform {
  cloud {
    organization = "org-test-221226"
    workspaces {
      name = "trf_cloud"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
    tfe = {
      version = "~> 0.38.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}