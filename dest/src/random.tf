resource "random_string" "aaa" {
  length  = 10
  special = true
}

resource "random_string" "bbb" {
  length  = 10
  special = true
}

resource "random_string" "ccc" {
  length  = 10
  special = true
}

output "value" {
  value = random_string.aaa
}