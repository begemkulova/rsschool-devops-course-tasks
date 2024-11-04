# # k3s master in the first private subnet
# resource "aws_instance" "k3s_master" {
#   ami                    = data.aws_ami.ubuntu_ami.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.private_subnets[0].id
#   vpc_security_group_ids = [aws_security_group.k3s_private_sg.id]
#   key_name               = var.ssh_key_name
#   user_data              = file("${path.module}/setup.sh")
#   tags = {
#     Name = "${var.project}-master"
#   }
# }

# # k3s bastion in the first private subnet
# resource "aws_instance" "k3s_bastion" {
#   ami                    = data.aws_ami.ubuntu_ami.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public_subnets[0].id
#   vpc_security_group_ids = [aws_security_group.k3s_public_sg.id]
#   key_name               = var.ssh_key_name
#   user_data              = file("${path.module}/bastion.sh")
#   tags = {
#     Name = "${var.project}-bastion"
#   }
# }

resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnets[0].id
  availability_zone           = element(data.aws_availability_zones.available.names, 0)
  associate_public_ip_address = true
  key_name                    = var.private_key
  vpc_security_group_ids      = [aws_security_group.k3s_public_sg.id]

  root_block_device {
    volume_size           = var.master_node_disk.size
    volume_type           = var.master_node_disk.type
    delete_on_termination = true
  }

  user_data = <<-EOF
                #!/bin/bash
                echo "test"
                # set -ex
                
                # # Install necessary packages
                # apt-get update -y
                # apt-get install -y curl apt-transport-https

                # # Install k3s
                # curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --tls-san $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
                # hostnamectl set-hostname "master-node"

                # # Configure Kubernetes
                # mkdir -p ~/.kube
                # sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
                # sudo chown $(id -u):$(id -g) ~/.kube/config

                # # Wait for k3s to be ready
                # until kubectl get nodes; do sleep 30; done

                # # Create Jenkins namespace
                # kubectl create namespace jenkins

                # # Install Jenkins using Helm
                # helm repo add jenkins https://charts.jenkins.io
                # helm repo update
                # helm install jenkins jenkins/jenkins --namespace jenkins --set controller.serviceType=LoadBalancer
                EOF

  tags = {
    Name = "Master"
  }
}
