#!/bin/bash
sudo apt-get update -y
sudo ufw disable
mkdir -p /home/ubuntu/.ssh
echo "${var.private_key}" > /home/ubuntu/.ssh/key1234.pem
chmod 600 /home/ubuntu/.ssh/key1234.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/key1234.pem