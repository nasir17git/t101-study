# resource "tfe_variable_set" "test" {
#   name         = "test_var_set"
#   description  = "Some description."
#   global       = true
#   organization = "org-test-221226"
# }

# # resource "tfe_workspace_variable_set" "test" {
# #   workspace_id    = "ws-VGoCt2CNu7GH6Aox"
# #   variable_set_id = tfe_variable_set.test.id
# # }

# resource "tfe_variable" "vpc_id" {
#   key             = "vpc_id"
#   value           = aws_vpc.vpc.id
#   category        = "terraform"
#   description     = "vpc_id"
#   variable_set_id = tfe_variable_set.test.id
#   # hcl = true
# }

# resource "tfe_variable" "subnet1_id" {
#   key             = "subnet1_id"
#   value           = aws_subnet.pub["1"].id
#   category        = "terraform"
#   description     = "subnet_id"
#   variable_set_id = tfe_variable_set.test.id
#   # hcl = true
# }

# # ------
# # 굳이 상세설정까지 다 terraform으로 만드는건 좀 아닌듯함.. 수동 설정변경
# # resource "tfe_organization" "test" {
# #   name  = "org-test-221226"
# #   email = "nasir17.dev@gmail.com"
# # }

# # resource "tfe_oauth_client" "test" {
# #   name             = "my-github-oauth-client"
# #   organization     = tfe_organization.test.name
# #   api_url          = "https://api.github.com"
# #   http_url         = "https://github.com"
# #   oauth_token      = "my-vcs-provider-token"
# #   service_provider = "github"
# # }

# # resource "tfe_workspace" "test" {
# #   name              = "ws"
# #   organization      = tfe_organization.test.name
# #   working_directory = "trf_cloud"
# #   vcs_repo {
# #     identifier     = "nasir17git/t101-study"
# #     oauth_token_id = 
# #   }
# # }
