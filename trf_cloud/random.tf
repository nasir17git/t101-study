resource "random_string" "tcl_branch" {
  length  = 10
  special = true
}

resource "random_string" "action_trigger" {
  length  = 10
  special = true
}
