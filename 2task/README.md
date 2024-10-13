# Documentation - Task 2: Basic Infrastructure Configuration 
### Student:  Bekaiym Egemkulova.

The project is a part of the RS School tasks. This Terraform configuration provisions a Virtual Private Cloud (VPC) with public and private subnets, security groups, and EC2 instances in AWS. It includes a bastion host in the public subnet and a main application host in the private subnet. The configuration also sets up NAT gateways, Internet Gateways, Route Tables, and Network ACLs. Additionally, a GitHub Actions workflow is included to automate the deployment process via Reusable Workflow.

## GitHub Secrets

Before running the workflows, make sure to set the following GitHub Secrets in your repository settings:

- **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
- **AWS_REGION**: The AWS region to deploy resources in.
- **AWS_ACCOUNT_ID**: Your AWS account ID (optional but recommended). /

## GitHub Actions Workflow

### Main Workflow

The main workflow triggers on push to the `main` branch or through manual dispatch. It runs the reusable Terraform workflow defined in `main.yml`.

#### Job: terraform-deploy
- **uses**: Calls the reusable workflow located in `./.github/workflows/main.yml`.
- **with**: Passes the destroy input value to the reusable workflow.
- **secrets**: Passes AWS credentials and region from GitHub Secrets.

### Reusable Terraform Workflow

The reusable workflow defines jobs to initialize, check, plan, apply, and etc  located in `./.github/workflows/2task.yml`..

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

## Prerequisites

- AWS Account
- Terraform installed
- AWS CLI configured with the appropriate access and permissions
- SSH Key for EC2 instances created in AWS
- GitHub repository with access to AWS secrets stored in GitHub Actions.


## Resources Provisioned
- VPC: A Virtual Private Cloud with DNS support and hostnames enabled.
- Subnets: Public and private subnets spread across availability zones.
- Internet Gateway: Allows public internet access for instances in public subnets.
- NAT Gateway: Enables instances in private subnets to access the internet.
- Route Tables: Separate route tables for public and private subnets.
- Security Groups:
- Bastion security group with SSH and ICMP access.
- Main instance security group for internal communication.
- Network ACL: Configured for private subnets.
- EC2 Instances: A bastion host in the public subnet and a main host in the private subnet.

## Variable Definitions
region: AWS region for resource creation (default: us-east-1).
vpc_name: Name of the VPC (default: task2-vpc).
vpc_cidr: CIDR block for the VPC (default: 10.0.0.0/16).
public_subnets: List of CIDR blocks for public subnets (default: ["10.0.1.0/24", "10.0.2.0/24"]).
private_subnets: List of CIDR blocks for private subnets (default: ["10.0.3.0/24", "10.0.4.0/24"]).
bastion_instance_type: EC2 instance type for the Bastion host (default: t2.micro).
instance_type: EC2 instance type for the main host (default: t2.micro).
ssh_key_name: SSH key name for EC2 instances.
enable_nat_gateway: Whether to enable NAT Gateway (default: true).
project: Project name used in tags (default: task2).
environment: Environment name for tagging (default: dev).

## Backend Configuration
The Terraform state is stored remotely in an S3 bucket:

Bucket: begemkulov-rs-terraform-state
Key: task2/terraform.tfstate
Region: us-east-1
Data Sources
AWS Availability Zones: Retrieves available availability zones.
AWS AMI: Uses the most recent Ubuntu 22.04 AMI for EC2 instances.
  



