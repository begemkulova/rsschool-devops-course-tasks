# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, {
    Name = "${var.project}-igw"
  })
}

# Route Tables for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.tags, {
    Name = "${var.project}-public-rt"
  })
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_association" {
  for_each = module.vpc.public_subnets

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Route Tables for Private Subnets (NAT Gateway/Instance)
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, {
    Name = "${var.project}-private-rt"
  })
}

resource "aws_route_table_association" "private_association" {
  for_each = module.vpc.private_subnets

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.vpc.public_subnets[0]

  tags = merge(local.tags, {
    Name = "${var.project}-nat-gw"
  })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  #   vpc = true ###deprecated

  tags = merge(local.tags, {
    Name = "${var.project}-nat-eip"
  })
}

# Route from Private Subnet to NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

