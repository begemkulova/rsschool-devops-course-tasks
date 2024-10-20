#!/bin/bash
sudo apt-get update -y
sudo ufw disable
mkdir -p /home/ubuntu/.ssh
echo "${var.private_key}" > /home/ubuntu/.ssh/k8s-cluster.pem
chmod 600 /home/ubuntu/.ssh/k8s-cluster.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/k8s-cluster.pem