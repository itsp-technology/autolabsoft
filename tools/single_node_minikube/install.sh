#!/bin/bash

# Script to install and set up Minikube with Kubernetes single-node cluster

# Exit on any error
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get install -y curl wget apt-transport-https

# Install Docker (as the container runtime)
echo "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify installations
echo "Verifying installations..."
docker --version
kubectl version --client
minikube version

# Start Minikube with Docker driver
echo "Starting Minikube with Docker driver..."
minikube start --driver=docker

# Enable Minikube addons (optional, e.g., dashboard)
echo "Enabling Minikube dashboard..."
minikube addons enable dashboard

# Verify cluster status
echo "Checking Kubernetes cluster status..."
kubectl get nodes

# Display cluster info
echo "Displaying cluster info..."
kubectl cluster-info

echo "Minikube single-node Kubernetes setup completed successfully!"
echo "To access the Kubernetes dashboard, run: 'minikube dashboard'"