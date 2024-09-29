# Terraform Project

This repository contains a Terraform project for managing AWS resources using GitHub Actions for CI/CD. The setup includes workflows for initializing, planning, applying, and optionally destroying Terraform resources.

## GitHub Secrets

Before running the workflows, make sure to set the following GitHub Secrets in your repository settings:

- **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
- **AWS_REGION**: The AWS region to deploy resources in.
- **AWS_ACCOUNT_ID**: Your AWS account ID (optional but recommended).

## GitHub Actions Workflow

### Main Workflow

The main workflow triggers on push to the `main` branch or through manual dispatch. It runs the reusable Terraform workflow defined in `terraform.yml`. 

#### Inputs
- **destroy**: A boolean input that indicates whether to destroy the Terraform resources. Default is `false`.

#### Job: terraform-deploy
- **uses**: Calls the reusable workflow located in `./.github/workflows/terraform.yml`.
- **with**: Passes the destroy input value to the reusable workflow.
- **secrets**: Passes AWS credentials and region from GitHub Secrets.

### Reusable Terraform Workflow

The reusable workflow defines jobs to initialize, check, plan, apply, and destroy resources.

#### Jobs
1. **terraform-init**: 
   - Checks out the repository.
   - Sets up Terraform.
   - Configures AWS credentials.
   - Initializes Terraform.

2. **terraform-check**: 
   - Runs after `terraform-init`.
   - Checks for formatting issues using `terraform fmt`.

3. **terraform-plan**: 
   - Runs after `terraform-check`.
   - Generates an execution plan.

4. **terraform-apply**: 
   - Runs after `terraform-plan`.
   - Applies the changes required to reach the desired state of the infrastructure.

5. **terraform-destroy**: 
   - Runs after `terraform-apply` if `destroy` input is true.
   - Destroys the resources created by Terraform.

## Directory Structure

The `1task` directory contains the following files for your Terraform configuration:
-- README.md
-- backend.tf
-- data.tf
-- iamrole.tf
-- main.tf
-- terraform.tfvars 
-- variables.tf


## Requirements

- [Terraform](https://www.terraform.io/downloads.html) version 1.6.0 or higher.
- AWS account with appropriate permissions for the resources being created.

## Usage

1. Ensure the directory structure and GitHub Secrets are correctly set up.
2. Trigger the workflow manually or push to the `main` branch.
3. Monitor the Actions tab in GitHub for workflow execution and logs.
4. To destroy resources, trigger the workflow with `destroy` input set to `true`.

## Notes

- Modify `backend.tf` and `terraform.tfvars` to set up your backend and define your variables accordingly.
- Ensure your AWS credentials have the necessary permissions to create and manage the resources defined in your Terraform scripts.

