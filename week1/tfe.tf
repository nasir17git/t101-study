resource "tfe_organization" "test" {
  name  = "org-test-221226"
  email = "nasir17.dev@gmail.com"
}

resource "tfe_workspace" "test" {
  name              = "week1"
  organization      = tfe_organization.test.name
  working_directory = "/week1"
  vcs_repo {
    identifier     = "nasir17git/t101-study"
    oauth_token_id = "rTDOCVRFyCCGEw.atlasv1.t1pvZ51CzZCpH8CNZvebwwIGpvGKkcbUY6cLfEQZALOOBVaOCHw0gfshy7oKsYdyrXw"
  }
}

resource "tfe_variable_set" "test" {
  name         = "test_var_set"
  description  = "Some description."
  organization = "example-org-74b427"
}

resource "tfe_workspace_variable_set" "test" {
  workspace_id    = tfe_workspace.test.id
  variable_set_id = tfe_variable_set.test.id
}

resource "tfe_variable" "test-a" {
  key             = "seperate_variable"
  value           = "my_value_name"
  category        = "terraform"
  description     = "a useful description"
  variable_set_id = tfe_variable_set.test.id
}

resource "tfe_variable" "test-b" {
  key             = "another_variable"
  value           = "my_value_name"
  category        = "env"
  description     = "an environment variable"
  variable_set_id = tfe_variable_set.test.id
}

resource "tfe_variable" "network" {
  key             = "another_variable"
  value           = "my_value_name"
  category        = "env"
  description     = "an environment variable"
  variable_set_id = tfe_variable_set.test.id
}