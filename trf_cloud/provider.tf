terraform {
  cloud {
    organization = tfe_organization.test.name
    workspaces {
      tags = ["test"]
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