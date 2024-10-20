# Documentation - Task 3: K8s Cluster Configuration and Creation
### Student:  Bekaiym Egemkulova. @begemkulova

The GitHub project is a part of the RS School tasks. 

## GitHub Secrets

Before running the workflows, make sure to set the following GitHub Secrets in your repository settings:

- **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
- **AWS_REGION**: The AWS region to deploy resources in.
- **AWS_ACCOUNT_ID**: Your AWS account ID (optional but recommended). 
- **AWS_EC2_PRIVATE_KEY**: Your AWS's Key Pair (optional but recommended). 

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
project: Project name used in tags (default: task3).

## Backend Configuration
The Terraform state is stored remotely in my S3 bucket (use your own bucket name):
Bucket: begemkulov-rs-terraform-state

  



