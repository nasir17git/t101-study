# ------ 프로젝트 공통 설정 ------
name_prefix = "aaa" // 프로젝트 명 입력
env         = "dev" // 생성환경 입력

# ------ Network 설정 ------
vpc_cidr = "10.0.0.0/16" // VPC CIDR
subnet_cidrs = {         // Subnets CIDR
  pub1 = "10.0.10.0/24"
  pub2 = "10.0.20.0/24"
  pub3 = "10.0.30.0/24"
  pri1 = "10.0.40.0/24"
  pri2 = "10.0.50.0/24"
}

#  ------ ALB 설정 ------

# ALB의 Security group 설정
alb_ports           = [80, 443]     // ALB ingress에 허용될 ports 입력
alb_cidr_blocks     = ["0.0.0.0/0"] // ALB ingress에 허용될 cidr_block 입력
alb_security_groups = []            // ALB ingress에 허용될 security_groups 입력

# ------ EC2 설정 ------

# EC2 관련 설정
ec2_amount    = ["1", "2"] // 생성될 EC2 수량
instance_type = "t2.micro" // 필요한 인스턴스 유형 입력
volume_size   = "8"        // 필요한 루트 볼륨 사이즈 입력 (최소8)

