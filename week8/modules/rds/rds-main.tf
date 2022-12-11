resource "aws_db_subnet_group" "mysql" {
  name       = "${var.env}-${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env}-${var.name_prefix}-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "${var.env}-${var.name_prefix}-rds"
  allocated_storage    = var.storage_amount
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance_class
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = var.user_name
  password             = data.aws_ssm_parameter.params_password.value
}

# ------ passwd ------

# 10자리의 무작위 암호생성 
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "params" {
  length           = 10      # 암호 자리수
  special          = true    # 암호 생성 시 특수 문자 포함여부, 기본값 허용 및 !@#$%&*()-_=+[]{}<>:?
  override_special = "#!()_" # 해당 특수문자만 사용하도록 설정
}

# ------ parameter store ------

# 생성된 암호를 parameter store에 저장
resource "aws_ssm_parameter" "params_password" {
  name  = "/t101_mysql_rds/params_password"
  type  = "SecureString"
  value = random_password.params.result
}

# 생성이 완료된 이후, param store에 저장된 암호 조회
data "aws_ssm_parameter" "params_password" {
  name       = "/t101_mysql_rds/params_password"
  depends_on = [aws_ssm_parameter.params_password]
}
