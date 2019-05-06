terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "recipe-finder-tf-state"
      key            = "rf-ui-api/terraform.tfstate"
      region         = "eu-west-2"
      encrypt        = true
      dynamodb_table = "recipe-finder-tf-lock"

      s3_bucket_tags {
        Project = "recipe-finder"
      }

      dynamodb_table_tags {
        Project = "recipe-finder"
      }
    }
  }
  terraform {
    source = ".//pipeline/"
    extra_arguments "conditional_vars" {
      commands  = ["${get_terraform_commands_that_need_locking()}"]

      required_var_files = [
        "pipeline.tfvars"
      ]
    }
  }
}