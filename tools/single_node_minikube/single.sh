#!/bin/bash
set -e  # Exit script on error

apt-get update -y
apt-get upgrade -y

# Install Docker prerequisites
apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Setup Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
systemctl enable docker
systemctl restart docker

# Add ubuntu user to Docker group
usermod -aG docker ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD: /usr/bin/dockerd" | tee /etc/sudoers.d/docker
chmod 0440 /etc/sudoers.d/docker

# Fix permissions for Docker socket
chmod 666 /var/run/docker.sock

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

# Restart user session to apply Docker group changes
su - ubuntu -c "newgrp docker && minikube start --driver=docker"

# Verify installation
su - ubuntu -c "kubectl get nodes"
