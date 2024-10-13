# Bastion Host
resource "aws_instance" "bastion" {
  ami             = data.aws_ami.ubuntu_22.id
  instance_type   = var.bastion_instance_type
  key_name        = var.ssh_key_name
  subnet_id       = aws_subnet.public_subnets[0].id
  security_groups = [aws_security_group.bastion_sg.id]

  tags = merge(local.tags, {
    Name = "${var.project}-bastion"
  })
}

# Main Application Host
resource "aws_instance" "main" {
  ami             = data.aws_ami.ubuntu_22.id
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name
  subnet_id       = aws_subnet.private_subnets[0].id
  security_groups = [aws_security_group.main_sg.id]

  tags = merge(local.tags, {
    Name = "${var.project}-main"
  })
}
