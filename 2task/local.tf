locals {
  subnet_types = {
    public  = { cidr_block = local.subnet_cidr_blocks.public, map_public_ip = true }
    private = { cidr_block = local.subnet_cidr_blocks.private, map_public_ip = false }
  }

  subnet_cidr_blocks = {
    public  = cidrsubnets(module.vpc.cidr_block, 8, 8)[0]
    private = cidrsubnets(module.vpc.cidr_block, 8, 8)[1]
  }

  tags = {
    owner = "begemkulova"
  }
}

