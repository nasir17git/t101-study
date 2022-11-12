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
resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub1"]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env}-${var.name_prefix}-pub1" }
}

resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub2"]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env}-${var.name_prefix}-pub2" }
}

resource "aws_subnet" "pub3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub3"]
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env}-${var.name_prefix}-pub3" }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.env}-${var.name_prefix}-pub-rt" }
}

resource "aws_route_table_association" "pub1rta" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pub2rta" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pub3rta" {
  subnet_id      = aws_subnet.pub3.id
  route_table_id = aws_route_table.pubrt.id
}
#-----NAT Gateways with Elastic IPs--------------------------
resource "aws_eip" "eip" {
  vpc  = true
  tags = { Name = "${var.env}-${var.name_prefix}-eip" }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub1.id
  tags          = { Name = "${var.env}-${var.name_prefix}-nat" }
  depends_on    = [aws_internet_gateway.igw]
}

#--------------Private Subnets and Routing-------------------------

resource "aws_subnet" "pri1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pri1"]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.env}-${var.name_prefix}-pri1" }
}

resource "aws_subnet" "pri2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pri2"]
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.env}-${var.name_prefix}-pri2" }
}

resource "aws_route_table" "prirt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.env}-${var.name_prefix}-pri-rt" }
}

resource "aws_route_table_association" "pri1rta" {
  subnet_id      = aws_subnet.pri1.id
  route_table_id = aws_route_table.prirt.id
}

resource "aws_route_table_association" "pri2rta" {
  subnet_id      = aws_subnet.pri2.id
  route_table_id = aws_route_table.prirt.id
}