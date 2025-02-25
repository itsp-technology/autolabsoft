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
if ! command -v docker &> /dev/null; then
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    echo "Docker installed. User added to 'docker' group."
else
    echo "Docker is already installed."
fi

# Ensure Docker is running
if ! sudo systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube

# Cleanup temporary files
rm -f kubectl minikube-linux-amd64

# Verify installations
echo "Verifying installations..."
docker --version || { echo "Docker not found! Exiting."; exit 1; }
kubectl version --client || { echo "kubectl not found! Exiting."; exit 1; }
minikube version || { echo "Minikube not found! Exiting."; exit 1; }

# Check if the user is in the docker group and prompt if a relogin is needed
if ! groups | grep -q docker; then
    echo "You’ve been added to the 'docker' group. Please log out and back in (or reboot)."
    echo "After relogin, run 'minikube start --driver=docker' manually."
    exit 1
fi

# Start Minikube with Docker driver
echo "Starting Minikube with Docker driver..."
minikube start --driver=docker

# Enable Minikube addons (optional)
echo "Enabling Minikube dashboard..."
minikube addons enable dashboard

# Verify cluster status
echo "Checking Kubernetes cluster status..."
kubectl get nodes

# Display cluster info
echo "Displaying cluster info..."
kubectl cluster-info

echo "Minikube setup completed successfully!"
echo "To access the Kubernetes dashboard, run: 'minikube dashboard'"