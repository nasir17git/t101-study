# secrets manager의 암호를 사용한 RDS 인스턴스 생성
resource "aws_db_instance" "t101_secrets" {
  identifier           = "t101-mysql-rds-secrets"
  allocated_storage    = 8
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "t101_nasir_secrets"
  password             = data.aws_secretsmanager_secret_version.secrets_password.secret_string
}

# ------ passwd ------

# 10자리의 무작위 암호생성 
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "secrets" {
  length           = 10      # 암호 자리수
  special          = true    # 암호 생성 시 특수 문자 포함여부, 기본값 허용 및 !@#$%&*()-_=+[]{}<>:?
  override_special = "#!()_" # 해당 특수문자만 사용하도록 설정
}

# ------ secrets manager ------

# 생성된 암호가 저장될 secrets 생성
resource "aws_secretsmanager_secret" "secrets_password" {
  name                    = "/t101_mysql_rds/secrets_password"
  recovery_window_in_days = 0 # 삭제 대기 일수, 0 설정 시 바로 삭제
}

# 생성된 secrets에 암호 저장
resource "aws_secretsmanager_secret_version" "secrets_password" {
  secret_id     = aws_secretsmanager_secret.secrets_password.id
  secret_string = random_password.secrets.result
}

# 생성이 완료된 이후, secrets manager에 저장된 암호 조회
data "aws_secretsmanager_secret_version" "secrets_password" {
  secret_id  = aws_secretsmanager_secret.secrets_password.id
  depends_on = [aws_secretsmanager_secret_version.secrets_password]
}

# ------ 결과 조회 ------
output "secrets_address" {
  value = aws_db_instance.t101_secrets.address
}

output "secrets_username" {
  value = aws_db_instance.t101_secrets.username
}

output "secrets_password" {
  value     = data.aws_secretsmanager_secret_version.secrets_password.secret_string
  sensitive = true
}

