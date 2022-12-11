output "db_password" {
  value     = data.aws_ssm_parameter.params_password.value
  sensitive = true
}
