#!/bin/bash
set -o errexit   
set -o nounset   
set -o pipefail  
hostnamectl set-hostname "master-node"
sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https
sudo ufw disable
curl -sfL https://get.k3s.io | sh -
sudo mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
kubectl create namespace jenkins
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update -y
sudo apt-get install -y helm
helm repo add jenkins https://charts.jenkins.io
helm repo update
mkdir -p /tmp/jenkins-volume
chown -R 1000:1000 /tmp/jenkins-volume            
helm install jenkins jenkins/jenkins --namespace jenkins \
  --set controller.serviceType=LoadBalancer \
  --set persistence.enabled=true \
  --set persistence.size=8Gi \
  --set persistence.existingClaim=jenkins-pvc \
  --set controller.installPlugins="cloudbees-credentials,git,workflow-aggregator,jacoco,jacoco,configuration-as-code"
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo systemctl status k3s
kubectl get all -n kube-system
kubectl get nodes
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
kubectl get pods


