config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  disabled_by_default = true
}

plugin "aws" {
    enabled = true
    version = "0.21.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_type" {
  enabled = true
}