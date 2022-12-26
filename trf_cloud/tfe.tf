resource "tfe_variable_set" "test" {
  name         = "test_var_set"
  description  = "Some description."
  organization = "org-8YBVYbTqtU8evZeK"
}

resource "tfe_workspace_variable_set" "test" {
  workspace_id    = "ws-VGoCt2CNu7GH6Aox"
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


# ------
# 굳이 상세설정까지 다 terraform으로 만드는건 좀 아닌듯함.. 수동 설정변경
# resource "tfe_organization" "test" {
#   name  = "org-test-221226"
#   email = "nasir17.dev@gmail.com"
# }

# resource "tfe_oauth_client" "test" {
#   name             = "my-github-oauth-client"
#   organization     = tfe_organization.test.name
#   api_url          = "https://api.github.com"
#   http_url         = "https://github.com"
#   oauth_token      = "my-vcs-provider-token"
#   service_provider = "github"
# }

# resource "tfe_workspace" "test" {
#   name              = "ws"
#   organization      = tfe_organization.test.name
#   working_directory = "trf_cloud"
#   vcs_repo {
#     identifier     = "nasir17git/t101-study"
#     oauth_token_id = 
#   }
# }
