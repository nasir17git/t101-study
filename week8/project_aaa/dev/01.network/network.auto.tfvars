# ------ 프로젝트 공통 설정 ------
name_prefix = "aaa" // 프로젝트 명 입력
env         = "dev" // 생성환경 입력

# ------ Network 설정 ------
vpc_cidr = "10.0.0.0/16" // VPC CIDR
pub_subnet_cidrs = {     // Public Subnets CIDR
  1 = "10.0.10.0/24"
  2 = "10.0.20.0/24"
  3 = "10.0.30.0/24"
}
pri_subnet_cidrs = { // Private Subnets CIDR
  1 = "10.0.40.0/24"
  2 = "10.0.50.0/24"
  3 = "10.0.60.0/24"
}

