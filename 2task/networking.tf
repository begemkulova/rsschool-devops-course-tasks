resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
# Private route table & association 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(
    tomap({
      Name = "${var.project}-private-rt",
      type = "network"
    }),
    local.tags
  )
}

resource "aws_route_table_association" "private_association" {
  route_table_id = aws_route_table.private.id
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

# Public route table & association 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    tomap({
      Name = "${var.project}-public-rt",
      type = "network"
    }),
    local.tags
  )
}

resource "aws_route_table_association" "public_association" {
  route_table_id = aws_route_table.public.id
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
}


