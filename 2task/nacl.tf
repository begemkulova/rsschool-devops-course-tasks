resource "aws_network_acl" "private_acl" {
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = aws_subnet.public_subnets
    content {
      rule_no    = 100 + ingress.key
      protocol   = "tcp"
      action     = "allow"
      cidr_block = ingress.value.cidr_block
      from_port  = 0
      to_port    = 65535
    }
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "private_acl_association" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  network_acl_id = aws_network_acl.private_acl.id
}

