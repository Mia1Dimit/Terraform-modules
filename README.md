# Terraform Modules

Reusable Terraform modules for AWS infrastructure.

## What Is In This Repository

This repository contains independent AWS modules that can be composed in environment-specific Terraform stacks.

Current module coverage includes:

- Networking: `vpc`, `route-table`, `security-group`
- Compute and serverless: `ec2-instance`, `lambda-function`, `lambda-layer`, `lambda-permission`
- API Gateway v2: `api-gatewayv2-api`, `api-gatewayv2-authorizer`, `api-gatewayv2-integration`, `api-gatewayv2-route`, `api-gatewayv2-stage`
- Storage and content delivery: `s3-bucket`, `s3-bucket-policy`, `s3-bucket-cors-config`, `s3-bucket-notification`, `s3-bucket-sse-config`, `s3-bucket-website-config`, `cloudfront`
- Data and messaging: `dynamodb`, `sqs`, `ssm-parameter`
- Identity and access: `iam-role`, `iam-role-policy`, `cognito-user-pool`, `kms-key`
- Observability and operations: `cloudwatch-alarm`, `cloudwatch-log-group`, `eventbridge-scheduler`, `backup-vault`, `budgets`

## Repository Structure

Each module lives in its own folder and typically contains:

- `main.tf`: resources and data sources
- `variables.tf`: module input variables
- `outputs.tf` or `output.tf`: module outputs

## Usage Pattern

Use modules from another Terraform root module with a local source path:

```hcl
module "vpc" {
  source = "../Terraform-modules/vpc"

  name            = "example-vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "eu-west-1a"

  environment     = "dev"
  applicationid   = "app-001"
  applicationname = "example"
  specifictags    = {}
}
```

For remote usage, publish and reference this repository through your preferred module source strategy.

## Conventions

- Tags are standardized across modules and usually include `Application_ID`, `Application_Name`, `Environment`, and `Name`.
- Keep module defaults generic; set environment-specific values in consuming stacks.
- When resource names change in `main.tf`, update all references in outputs and internal dependencies.

## Contributing

1. Make changes in a dedicated module folder.
2. Keep module interfaces stable unless a breaking change is intentional.
3. Validate formatting and plans in your consumer stack before merging.
4. Commit changes module-by-module to keep history clear.
