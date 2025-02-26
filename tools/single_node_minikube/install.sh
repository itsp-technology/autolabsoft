#!/bin/bash

# Exit script on any error
set -e

echo "Starting Minikube installation..."

# Step 1: Check if Docker is installed
if command -v docker &> /dev/null && [ -f /var/lib/docker ]; then
    echo "Docker is already installed. Skipping installation."
else
    echo "Updating package list and installing Docker dependencies..."
    sudo apt update -y
    sudo apt install -y curl apt-transport-https ca-certificates software-properties-common docker.io
    echo "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Adding user to Docker group..."
    sudo usermod -aG docker $USER
    echo "Please log out and log back in to apply Docker group changes."
fi

# Step 2: Check if Minikube is installed
if command -v minikube &> /dev/null && [ -f /usr/local/bin/minikube ]; then
    echo "Minikube is already installed. Skipping installation."
else
    echo "Downloading Minikube binary..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    echo "Making Minikube binary executable..."
    chmod +x minikube-linux-amd64
    echo "Moving Minikube binary to /usr/local/bin..."
    sudo mv minikube-linux-amd64 /usr/local/bin/minikube
fi

# Step 3: Check if kubectl is installed
if command -v kubectl &> /dev/null && [ -f $(which kubectl) ]; then
    echo "kubectl is already installed. Skipping installation."
else
    echo "Downloading and installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

# Step 4: Start Minikube
if minikube status &> /dev/null; then
    echo "Minikube is already running. Skipping start."
else
    echo "Starting Minikube with Docker driver..."
    minikube start --force --driver=docker
fi

# Step 5: Verify installation
echo "Verifying Minikube installation..."
minikube status

echo "Minikube installation completed successfully!"
