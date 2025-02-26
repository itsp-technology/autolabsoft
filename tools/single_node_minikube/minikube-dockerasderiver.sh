#!/bin/bash

# Script to install and set up Minikube with Kubernetes single-node cluster

# Exit on any error
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# Install Docker (official method)
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

# Ensure Docker is in PATH and running
if ! docker --version &> /dev/null; then
    echo "Docker installation failed or not available. Please check your system and try again."
    exit 1
fi

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo chown root:root /usr/local/bin/kubectl

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64
sudo chown root:root /usr/local/bin/minikube

# Verify installations
echo "Verifying installations..."
docker --version || { echo "Docker not found! Exiting."; exit 1; }
kubectl version --client || { echo "kubectl not found! Exiting."; exit 1; }
minikube version || { echo "Minikube not found! Exiting."; exit 1; }

# Manual step: Inform user to apply group changes
echo -e "\n==== IMPORTANT STEP ===="
echo "You've been added to the 'docker' group."
echo "Please run the following command manually to apply the changes:"
echo -e "\n    newgrp docker\n"
echo "Then, start Minikube without sudo using:"
echo -e "\n    minikube start --driver=docker\n"
echo "========================"
exit 1
