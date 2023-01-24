#------------- VPC ------------------------------------------
resource "aws_vpc" "dev" {
  cidr_block           = var.network_config[0].vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.network_config[0].name}-vpc" }
}

resource "aws_vpc" "prod" {
  cidr_block           = var.network_config[1].vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.network_config[1].name}-vpc" }
}

#------------- Public Subnets ----------------------------------------
resource "aws_subnet" "dev" {
  for_each          = var.network_config[0].pub_cidr
  vpc_id            = aws_vpc.dev.id
  availability_zone = data.aws_availability_zones.available.names[each.key - 1]
  cidr_block        = each.value
  tags              = { Name = "${var.network_config[0].name}-pub${each.key}" }
}

resource "aws_subnet" "prod" {
  for_each          = var.network_config[1].pub_cidr
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.available.names[each.key - 1]
  cidr_block        = each.value
  tags              = { Name = "${var.network_config[0].name}-pub${each.key}" }
}
