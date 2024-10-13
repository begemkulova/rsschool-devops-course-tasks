# VPC Output
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC"
}

# Public Subnets Output
output "public_subnets" {
  value       = aws_subnet.public[*].id
  description = "IDs of the public subnets"
}

# Private Subnets Output
output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "IDs of the private subnets"
}

# NAT Gateways Output
output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat[*].id
  description = "IDs of the NAT Gateways"
}

# Elastic IPs for NAT Gateways Output
output "elastic_ip_allocations" {
  value       = aws_eip.nat[*].allocation_id
  description = "Allocation IDs of Elastic IPs for the NAT Gateways"
}

# Internet Gateway Output
output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "ID of the Internet Gateway"
}

# Route Tables Output
output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the Public Route Table"
}

output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
  description = "IDs of the Private Route Tables"
}

# Bastion Host Outputs
output "bastion_host_instance_id" {
  value       = aws_instance.bastion.id
  description = "ID of the Bastion Host EC2 Instance"
}


output "main_private_ip" {
  value = aws_instance.main.private_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}


