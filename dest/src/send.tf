resource "local_file" "str" {
  content  = <<EOF
## generated terraform file
locals {
  aaa = "${random_string.aaa}"
  bbb = "${random_string.bbb}"
}
EOF
  filename = "../output.tf"
}