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
              hostnamectl set-hostname "master-node"
              sudo apt-get update -y
              sudo apt-get install -y curl apt-transport-https

              # Install k3s
              curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(curl -s 2ip.io)" sh -

              # Wait for k3s to be ready
              while ! kubectl get nodes; do
                echo "Waiting ..."
                sleep 35
              done

              # Setup kubeconfig
              mkdir -p ~/.kube
              sudo chmod 644 /etc/rancher/k3s/k3s.yaml
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $(id -u):$(id -g) ~/.kube/config

              # Wait for node to be ready
              while [[ $(kubectl get nodes --no-headers 2>/dev/null | grep "Ready" | wc -l) -eq 0 ]]; do
                echo "Waiting..."
                sleep 30
              done

              # Create Jenkins namespace and resources
              kubectl create namespace jenkins

              # Create PV and PVC
              cat <<EOL | kubectl apply -f -
              apiVersion: v1
              kind: PersistentVolume
              metadata:
                name: jenkins-pv
              spec:
                capacity:
                  storage: 8Gi
                accessModes:
                  - ReadWriteOnce
                hostPath:
                  path: "/tmp/jenkins-volume"
              ---
              apiVersion: v1
              kind: PersistentVolumeClaim
              metadata:
                name: jenkins-pvc
                namespace: jenkins
              spec:
                accessModes:
                  - ReadWriteOnce
                resources:
                  requests:
                    storage: 8Gi
              EOL

              # Create RBAC resources with Helm labels and annotations
              cat <<EOL | kubectl apply -f -
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: jenkins
                namespace: jenkins
                labels:
                  app.kubernetes.io/managed-by: Helm
                annotations:
                  meta.helm.sh/release-name: jenkins
                  meta.helm.sh/release-namespace: jenkins
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRole
              metadata:
                name: jenkins
                labels:
                  app.kubernetes.io/managed-by: Helm
                annotations:
                  meta.helm.sh/release-name: jenkins
                  meta.helm.sh/release-namespace: jenkins
              rules:
                - apiGroups: ["*"]
                  resources: ["*"]
                  verbs: ["*"]
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: jenkins
                labels:
                  app.kubernetes.io/managed-by: Helm
                annotations:
                  meta.helm.sh/release-name: jenkins
                  meta.helm.sh/release-namespace: jenkins
              subjects:
                - kind: ServiceAccount
                  name: jenkins
                  namespace: jenkins
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: jenkins
              EOL

              # Install Helm
              curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
              sudo apt-get update -y
              sudo apt-get install -y helm

              # Setup Jenkins volume
              mkdir -p /tmp/jenkins-volume
              chown -R 1000:1000 /tmp/jenkins-volume

              # Add Jenkins repo and update
              helm repo add jenkins https://charts.jenkins.io
              helm repo update

              # Wait for jenkins namespace to be ready
              while ! kubectl get namespace jenkins; do
                echo "Waiting..."
                sleep 15
              done

              # Install Jenkins
              helm install jenkins jenkins/jenkins --namespace jenkins \
                --set controller.serviceType=LoadBalancer \
                --set persistence.enabled=true \
                --set persistence.size=8Gi \
                --set persistence.existingClaim=jenkins-pvc \
                --set 'controller.installPlugins={cloudbees-credentials,git,workflow-aggregator,jacoco,configuration-as-code}'

              # Wait for Jenkins pod to be ready
              while [[ $(kubectl get pods -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[*].status.containerStatuses[*].ready}' 2>/dev/null) != "true" ]]; do
                echo "Waiting..."
                sleep 20
              done
              EOF

  tags = {
    Name = "Master"
  }
}
