# ------ 프로젝트 공통 설정 ------
name_prefix = "aaa" // 프로젝트 명 입력
env         = "dev" // 생성환경 입력

# ------ ALB 설정 ------
# ALB의 Network 설정
internal    = false # true/false, Internal/Public facing 여부
alb_subnets = "pub" # pub/pri, ALB의 서브넷 매핑

# ALB의 Security group 설정, 필요시 블록 추가
alb_ingress_rules = [
  {
    ports           = 80
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
    sg_description  = "HTTP inbound"
  },
  {
    ports           = 443
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
    sg_description  = "HTTPS inbound"
  },
]
more_alb_sg = [] # ALB에 추가로 부여할 보안그룹, 필요시 주석해제하고 입력

# ALB 추가 설정
# idle_timeout = "300" # ALB의 idle_timeout, 필요시 주석해제하고 입력

# target group 관련 설정
target_port          = 80  # EC2와 동일한 target_port 입력
# deregistration_delay = 300 # ALB 타겟 그룹의 deregistration delay 지정, 필요시 주석해제하고 입력
health_check = {
  health_check_path     = "/health_check" # ALB 타겟 그룹의 health_check 경로 입력
  healthy_threshold     = "3"             # ALB 타겟 그룹의 health_check
  unhealthy_threshold   = "3"             # ALB 타겟 그룹의 unhealth_check
  health_check_timeout  = "4"             # ALB 타겟 그룹의 timeout
  health_check_interval = "5"             # ALB 타겟 그룹의 interval
  health_check_matcher  = "200"           # ALB 타겟 그룹의 성공값으로 간주할 응답 코드
}

# ------ EC2 설정 ------

# EC2의 수량 및 Network 설정
ec2_subnets = "pri" # pub/pri, EC2가 번갈아 생성될 서브넷(az1/az3)
amount      = 2     # EC2 수량 입력

# EC2의 Security group 설정, 필요시 블록 추가
ec2_ingress_rules = [
  # {
  #   ports           = 80
  #   cidr_blocks     = []
  #   security_groups = [module.alb.alb_sg.id] > auto.tfvars에서는 variable, local 사용불가
  #   sg_description  = "ALB inbound"
  # },
  {
    ports           = 80
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
    sg_description  = "ALB inbound"
  },
]
more_ec2_sg = [] # EC2에 추가로 부여할 보안그룹, 필요시 주석해제하고 입력

# EC2 관련 설정 
instance_type        = "t3.micro"          # 필요한 인스턴스 유형 입력
# key_name             = "nasirk17"          # EC2 접속을 위한 키페어 이름, 필요시 주석해제하고 입력
# iam_instance_profile = "nasir-ec2-profile" # EC2에 부여할 role, 필요시 주석해제하고 입력
# userdata             = local.web           # data.tf 의 userdata 입력 > auto.tfvars에서는 variable, local 사용불가
volume_size = "8" # 필요한 루트 볼륨 사이즈 입력 (최소8)

tags = { # Name은 모듈 내에서 자체생성
  OS           = "amazonlinux2"
  ENV          = "development"
  MONITORING   = "true"
  SERVICE_PORT = "80"
  SERVICE_APP  = "web"
  DESCRIPTION  = "개발-개인모듈테스트"
}