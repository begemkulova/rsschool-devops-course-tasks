output "bastion_security_group_ingress_rules" {
  description = "Ingress rules for the bastion security group"
  value       = aws_security_group.bastion_sg.ingress
}

output "main_security_group_ingress_rules" {
  description = "Ingress rules for the main application security group"
  value       = aws_security_group.main_sg.ingress
}

output "main_private_ip" {
  value = aws_instance.main.private_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_cidr_block
}
