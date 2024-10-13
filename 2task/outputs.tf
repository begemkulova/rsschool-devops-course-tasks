# VPC Output
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC"
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


