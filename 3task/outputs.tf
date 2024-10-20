output "bastion_host_public_ip" {
  description = "The public IP of the bastion host"
  value       = aws_instance.k3s_bastion.public_ip
}

output "K8s_master_private_ip" {
  description = "The private IP of the private instance K8s master"
  value       = aws_instance.k3s_master.private_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}


