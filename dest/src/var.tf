resource "tfe_variable_set" "rnd_str" {
  name          = "Random String"
  description   = "Random String"
  global       = true
  organization  = "org-test-221226"
}

resource "tfe_variable" "ccc" {
  key             = "ccc"
  value           = random_string.ccc.id
  category        = "terraform"
  description     = "ccc string"
  variable_set_id = tfe_variable_set.rnd_str.id
}

resource "tfe_variable" "ddd" {
  key             = "ddd"
  value           = random_string.ddd.id
  category        = "terraform"
  description     = "ddd string"
  variable_set_id = tfe_variable_set.rnd_str.id
}