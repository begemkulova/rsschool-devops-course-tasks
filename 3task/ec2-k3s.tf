# k3s master in the first private subnet
resource "aws_instance" "k3s_master" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.k3s_private_sg.id]
  key_name               = var.ssh_key_name
  user_data              = file("${path.module}/setup.sh")
  tags = {
    Name = "${var.project}-master"
  }
}

# k3s bastion in the first private subnet
resource "aws_instance" "k3s_bastion" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.k3s_public_sg.id]
  key_name               = var.ssh_key_name
  user_data              = file("${path.module}/bastion.sh")
  tags = {
    Name = "${var.project}-bastion"
  }
}
