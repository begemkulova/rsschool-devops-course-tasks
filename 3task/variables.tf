variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "task2-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type for Bastion Host"
  default     = "t2.micro"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH key"
  default     = "key1234"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway"
  default     = true
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "task3"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t2.micro"
}

# variable "token" {
#   description = "k3s Server token for k3s Agents"
#   type        = string
# }

variable "ec2_amazon_linux_ami" {
  description = "EC2 Instance Image for EC2 instances in us-east-1 Region"
  default     = "ami-06b21ccaeff8cd686"
}


variable "ssh_key_path" {
  description = "Path to the SSH private key file"
  default     = "key1234.pem"
}

variable "private_key" {
  description = "The private key used for SSH access to the private instance"
  type        = string
  sensitive   = true
}
