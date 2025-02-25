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
# echo "Installing Docker..."
# if ! command -v docker &> /dev/null; then
#     sudo apt-get install -y docker.io
#     sudo systemctl enable docker
#     sudo systemctl start docker
#     sudo usermod -aG docker $USER
# else
#     echo "Docker is already installed."
# fi

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

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify installations
echo "Verifying installations..."
docker --version || { echo "Docker not found! Exiting."; exit 1; }
kubectl version --client || { echo "kubectl not found! Exiting."; exit 1; }
minikube version || { echo "Minikube not found! Exiting."; exit 1; }

# Check if the user is in the docker group and prompt if a relogin is needed
if ! groups | grep -q docker; then
    echo "Note: You’ve been added to the 'docker' group. Please log out and log back in (or reboot) for this to take effect."
    echo "After relogin, run 'minikube start --driver=docker' manually to start the cluster."
    exit 1
fi

# Start Minikube with Docker driver (without sudo)
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