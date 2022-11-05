# ------ Backend 설정 (S3 버킷, DDB 테이블) ------

terraform {
  backend "s3" {
    bucket         = "nasir-week3"
    key            = "dev/services/webserver-cluster/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "s3_lock"
  }
}

# ------ Provider 및 Data 설정 ------

provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "nasir-week3"
    key    = "dev/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "vault_generic_secret" "db_creds" {
  path = "secret/db"
}

# ------ AWS Network 설정(서브넷, 게이트웨이, 라우팅테이블, 보안그룹 등) ------

resource "aws_subnet" "mysubnet1" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = var.subnet_cidrs["mysubnet1"]

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${var.nickname}-subnet1"
  }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = var.subnet_cidrs["mysubnet2"]

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${var.nickname}-subnet2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "${var.nickname}-igw"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "${var.nickname}-rt"
  }
}

resource "aws_route_table_association" "myrtassociation1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "myrtassociation2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route" "mydefaultroute" {
  route_table_id         = aws_route_table.myrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

resource "aws_security_group" "mysg" {
  vpc_id      = data.terraform_remote_state.db.outputs.vpcid
  name        = "${var.nickname}-T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "mysginbound" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysg.id
}

resource "aws_security_group_rule" "mysgoutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysg.id
}

# ------ ASG 생성 (data, 리소스 등) ------

data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    server_port = var.port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    db_name     = data.vault_generic_secret.db_creds.data["db_name"]
    db_username = data.vault_generic_secret.db_creds.data["db_username"]
  }
}

data "aws_ami" "my_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "mylauchconfig" {
  name_prefix                 = "t101-lauchconfig-"
  image_id                    = data.aws_ami.my_amazonlinux2.id
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.mysg.id]
  associate_public_ip_address = true

  # Render the User Data script as a template
  user_data = templatefile("user-data.sh", {
    server_port = var.port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    db_name     = data.vault_generic_secret.db_creds.data["db_name"]
    db_username = data.vault_generic_secret.db_creds.data["db_username"]
  })

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "myasg" {
  name                 = "${var.nickname}-myasg"
  launch_configuration = aws_launch_configuration.mylauchconfig.name
  vpc_zone_identifier  = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  min_size             = 2
  max_size             = 10
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.myalbtg.arn]
  tag {
    key                 = "Name"
    value               = "${var.nickname}-terraform-asg"
    propagate_at_launch = true
  }
}

# ------ ALB 생성 ------

resource "aws_lb" "myalb" {
  name               = "${var.nickname}-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  security_groups    = [aws_security_group.mysg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "myhttp" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 8080
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

resource "aws_lb_target_group" "myalbtg" {
  name     = "${var.nickname}-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.db.outputs.vpcid

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

resource "aws_lb_listener_rule" "myalbrule" {
  listener_arn = aws_lb_listener.myhttp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myalbtg.arn
  }
}

output "myalb_dns" {
  value       = aws_lb.myalb.dns_name
  description = "The DNS Address of the ALB"
}

