# RecipeFinder UI-API

Front-end API for the RecipeFinder project.

## Bootstrap

Initialise build pipeline. Currently this Terraform is managed from your dev machine.

```
cd terraform
terragrunt init
terragrunt plan -out plan.tf
terragrunt apply plan.tf
```

## CI/CD

Changes to the project will be deployed first to the `staging` environment and then the `production` environment.

## Local Development

See `buildspec.yml` for deployment commands.
