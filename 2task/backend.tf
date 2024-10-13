provider "aws" {
  region = var.region
}
# terraform {
#   backend "s3" {
#     bucket = "begemkulov-rs-terraform-state"
#     key    = "task2/terraform.tfstate"
#     region = "us-east-1"
#   }
# }
