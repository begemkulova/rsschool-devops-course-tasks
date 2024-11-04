# Fetch available availability zones in the us-east-1 region
data "aws_availability_zones" "available" {}

# Get the most recent AMI for Ubuntu 22.04 (Jammy) in the AWS region: us-east-1
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"] # Official Ubuntu account

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

