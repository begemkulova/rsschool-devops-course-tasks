# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    tomap({
      Name = "${var.project}-eip-nat",
      type = "network"
    }),
    local.tags
  )
}

# NAT Gateway placed in public networks
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(
    tomap({
      Name = "${var.project}-nat-gw",
      type = "network"
    }),
    local.tags
  )
}
