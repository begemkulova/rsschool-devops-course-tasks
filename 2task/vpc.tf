resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name        = "${var.project}-vpc"
    Terraform   = "true"
    Environment = var.environment
  })
}
