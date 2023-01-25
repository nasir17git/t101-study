resource "tfe_variable_set" "dev_nw" {
  name         = "dev network output"
  description  = "dev network outpu"
  global       = true
  organization = "org-test-221226"
}

resource "tfe_variable" "dev_vpc" {
  key             = "dev_vpc"
  value           = aws_vpc.dev.id
  description     = "dev vpc id"
  category        = "terraform"
  hcl             = true
  variable_set_id = tfe_variable_set.dev_nw.id
}

resource "tfe_variable" "dev_sbn1" {
  key             = "dev_sbn1"
  value           = aws_subnet.dev["1"].id
  description     = "dev subnet1 id"
  category        = "terraform"
  hcl             = true
  variable_set_id = tfe_variable_set.dev_nw.id
}

resource "tfe_variable" "dev_sbn2" {
  key             = "dev_sbn2"
  value           = aws_subnet.dev["2"].id
  description     = "dev subnet2 id"
  category        = "terraform"
  hcl             = true
  variable_set_id = tfe_variable_set.dev_nw.id
}

# resource "tfe_variable" "dev_sbn" {
#   key = "dev_sbn"
#   value = {
#     1 = aws_subnet.dev["1"]
#     2 = aws_subnet.dev["2"]
#     3 = aws_subnet.dev["3"]
#   }
#   description     = "dev subnet id"
#   category        = "terraform"
#   hcl             = true
#   variable_set_id = tfe_variable_set.dev_nw.id
# }

