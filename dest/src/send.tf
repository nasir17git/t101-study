resource "local_file" "str" {
  content  = <<EOF
## generated terraform file
locals {
  aaa = "${random_string.aaa.id}"
  bbb = "${random_string.bbb.id}"
}
EOF
  filename = "../output.tf"
  #   depends_on = [random_string.aaa, random_string.aaa]
}