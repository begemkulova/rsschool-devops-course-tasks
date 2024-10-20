#!/bin/bash
set -o pipefail  
sudo apt-get update
sudo ufw disable
swapoff -a
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
systemctl enable k3s
sudo systemctl status k3s
echo "K3s token:"
cat /var/lib/rancher/k3s/server/token
kubectl get all -n kube-system
kubectl get nodes
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
kubectl get pods