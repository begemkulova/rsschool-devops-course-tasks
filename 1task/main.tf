provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = var.bucket_versioning_status
  }
}

terraform {
  backend "s3" {
    bucket = "begemkulov-rs-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

