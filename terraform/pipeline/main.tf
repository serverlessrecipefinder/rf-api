terraform {
  backend "s3" {}
}
provider "aws" {
    region = "${var.aws_region}"
}
data "aws_ssm_parameter" "github_oauth_token" {
  name = "github_oauth_token"
}

# data "terraform_remote_state" "artefact_bucket" {
#   backend = "s3"
#   config {
#     bucket = "recipe-finder-tf-state"
#     key = "globals/terraform.tfstate"
#     region = "${var.aws_region}"
#   }
# }
