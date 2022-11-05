# 1주차 과제 -  AWS VPC(Subnet, IGW 등)을 코드로 배포한 환경에서 EC2 웹 서버 배포

# provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# vpc 생성
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "vpc"
  }
}

# public subnet 생성
resource "aws_subnet" "pub1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_cidr
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub1"
  }  
}

# igw 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

# public route table 생성 및 igw로의 라우팅 설정
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pubrt"
  }
}

# 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "prta" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}

# EC2 생성 (Ubuntu, Apache, 닉네임포함 index.html, 포트 50000)
resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub1.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data = <<EOF
#!/bin/bash
apt install -y apache2
echo "Hello nasir, from Terraform 101 Study" > index.html
nohup busybox httpd -f -p ${var.server_port} &
EOF

  tags = {
    Name = "ec2"
  }
}

# EC2 보안그룹 (포트 50000에 대해서만 개방)
resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "ec2-sg"
  }
}

