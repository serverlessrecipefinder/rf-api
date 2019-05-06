resource "aws_codepipeline" "pipeline" {
  name     = "${var.prefix}codepipeline-${var.name}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${var.artefact_bucket_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["terraform_project"]

      configuration = {
        Owner                = "${var.github_org}"
        Repo                 = "${var.repo}"
        PollForSourceChanges = "true"
        Branch               = "${var.branch}"
        OAuthToken           = "${data.aws_ssm_parameter.github_oauth_token.value}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Apply-Staging"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_terraform_ui-api_staging.name}"
      }
    }
  }

  stage {
    name = "Apply-Production"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_terraform_ui-api_production.name}"
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild_terraform_ui-api_staging" {
  name          = "rf-codebuild-ui-api-staging"
  description   = "Apply terraform for environment module"
  build_timeout = "300"
  service_role  = "${aws_iam_role.iam_code_build_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "RF_ENVIRONMENT"
      value = "staging"
    }

    environment_variable {
      name = "RF_REGION"
      value = "eu-west-2"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }
}

resource "aws_codebuild_project" "codebuild_terraform_ui-api_production" {
  name          = "rf-codebuild-ui-api-production"
  description   = "Apply terraform for environment module"
  build_timeout = "300"
  service_role  = "${aws_iam_role.iam_code_build_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "RF_ENVIRONMENT"
      value = "production"
    }

    environment_variable {
      name = "RF_REGION"
      value = "eu-west-2"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }
}