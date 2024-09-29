terraform {
  backend "s3" {
    bucket = "begemkulov-rs-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
