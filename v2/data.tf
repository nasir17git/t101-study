# data "aws_rds_cluster" "rds" {
#   cluster_identifier = "db-instance-identifier"
# }

data "aws_db_instance" "database" {
  db_instance_identifier = "db-instance-identifier"
}