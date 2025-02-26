#!/bin/bash

# Exit script on any error
set -e

echo "Starting Minikube installation..."

# Step 1: Update and install dependencies
echo "Updating package list and installing dependencies..."
sudo apt update -y
sudo apt install -y curl apt-transport-https ca-certificates software-properties-common docker.io

# Step 2: Download Minikube binary
echo "Downloading Minikube binary..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Step 3: Make Minikube binary executable
echo "Making Minikube binary executable..."
chmod +x minikube-linux-amd64

# Step 4: Move Minikube binary to /usr/local/bin
echo "Moving Minikube binary to /usr/local/bin..."
sudo mv minikube-linux-amd64 /usr/local/bin/minikube

# Step 5: Start Docker
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Step 6: Add user to the Docker group
echo "Adding user to Docker group..."
sudo usermod -aG docker $USER
echo "Please log out and log back in to apply Docker group changes."

# Step 7: Start Minikube as non-root user
echo "Starting Minikube with Docker driver (non-root)..."
newgrp docker <<EOF
minikube start --driver=docker
EOF

# Step 8: Verify installation
echo "Verifying Minikube installation..."
minikube status

echo "Minikube installation completed successfully!"
