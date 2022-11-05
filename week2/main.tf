# 2주차 과제 
# Cpt2. 닉네임을 리소스 이름으로 한 ALB/ASG 생성 후 연동
# Cpt3. 생성된 리소스를 S3 버킷에 저장후 DynamoDB를 통한 Locking 

# ---------- Provider 및 Backend 설정 ----------

# provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# backend 설정
terraform {
  backend "s3" {
    bucket         = "nasir-t101study-tfstate"
    key            = "t101study/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate_lock"
    # encrypt        = true
  }
}

# ---------- AWS Network 설정(VPC, Subnet, 보안그룹 등) ----------

# vpc 생성
resource "aws_vpc" "nasir_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "101_vpc"
  }
}

# public subnet 생성
resource "aws_subnet" "nasir_pub1" {
  vpc_id                  = aws_vpc.nasir_vpc.id
  cidr_block              = var.pub1_cidr
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "101_pub1"
  }
}

resource "aws_subnet" "nasir_pub2" {
  vpc_id                  = aws_vpc.nasir_vpc.id
  cidr_block              = var.pub2_cidr
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "101_pub2"
  }
}


# igw 생성
resource "aws_internet_gateway" "nasir_igw" {
  vpc_id = aws_vpc.nasir_vpc.id

  tags = {
    Name = "101_igw"
  }
}

# public route table 생성 및 igw로의 라우팅 설정
resource "aws_route_table" "nasir_pubrt" {
  vpc_id = aws_vpc.nasir_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nasir_igw.id
  }

  tags = {
    Name = "101_pubrt"
  }
}

# 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "nasir_prta" {
  subnet_id      = aws_subnet.nasir_pub1.id
  route_table_id = aws_route_table.nasir_pubrt.id
}

resource "aws_route_table_association" "nasir_prta-2" {
  subnet_id      = aws_subnet.nasir_pub2.id
  route_table_id = aws_route_table.nasir_pubrt.id
}

resource "aws_security_group" "nasir_sg" {
  vpc_id      = aws_vpc.nasir_vpc.id
  name        = "101_sg"
  description = "Security group for 101_VPC instance"

  tags = {
    Name = "101_sg"
  }
}

resource "aws_security_group_rule" "nasir_sginbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nasir_sg.id
}

resource "aws_security_group_rule" "nasir_sgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nasir_sg.id
}

# ---------- ASG 설정(시작 템플릿, ASG) ----------

# 시작 템플릿 (시작 구성 > 시작 템플릿)
resource "aws_launch_template" "nasir_launch_template" {
  name                   = "101_ec2_template"
  image_id               = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  key_name               = "nasirk17"
  user_data              = filebase64("userdata.sh")

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = aws_subnet.nasir_pub1.id
    security_groups = [aws_security_group.nasir_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "101_ec2_template"
    }
  }
}

# AutoScaling Group 설정

resource "aws_autoscaling_group" "nasir_asg" {
  availability_zones = ["ap-northeast-2a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1
  health_check_type  = "ELB"
  target_group_arns  = [aws_lb_target_group.nasir_albtg.arn]

  launch_template {
    id      = aws_launch_template.nasir_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "101_asg_ec2"
    propagate_at_launch = true
  }
}

# ---------- ALB 설정(ALB, 리스너, 대상 그룹) ----------

# ALB 생성
resource "aws_lb" "nasir_alb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.nasir_pub1.id, aws_subnet.nasir_pub2.id]
  security_groups    = [aws_security_group.nasir_sg.id]

  tags = {
    Name = "t101_alb"
  }
}

resource "aws_lb_listener" "nasir_http" {
  load_balancer_arn = aws_lb.nasir_alb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "nasir_albtg" {
  name     = "t101-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nasir_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "nasir_albrule" {
  listener_arn = aws_lb_listener.nasir_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nasir_albtg.arn
  }
}
