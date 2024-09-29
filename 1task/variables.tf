variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state"
  type        = string
}

variable "bucket_versioning_status" {
  description = "The versioning status of the S3 bucket (Enabled or Disabled)"
  type        = string
  default     = "Disabled"
}

variable "terraform_backend_key" {
  description = "The key for the Terraform backend state file"
  type        = string
  default     = "terraform.tfstate"
}
