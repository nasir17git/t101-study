#-------------VPC and Internet Gateway------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.env}-${var.name_prefix}-vpc" }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.env}-${var.name_prefix}-igw" }
}

#-------------Public Subnets and Routing----------------------------------------
resource "aws_subnet" "pub" {
  for_each          = var.pub_subnet_cidrs
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[each.key - 1]
  cidr_block        = each.value
  tags              = { Name = "${var.env}-${var.name_prefix}-pub${each.key}" }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.env}-${var.name_prefix}-pub-rt" }
}

resource "aws_route_table_association" "pub-rta" {
  for_each       = aws_subnet.pub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pubrt.id
}

#-------------Outputs----------------------------------------
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet1_id" {
  value = aws_subnet.pub["1"].id
}