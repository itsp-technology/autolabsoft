#!/bin/bash

# Exit script on any error
set -e

echo "Starting uninstallation of Docker, Minikube, and kubectl..."

# Step 1: Stop Minikube
if command -v minikube &> /dev/null; then
    echo "Stopping Minikube..."
    minikube stop
    minikube delete
fi

# Step 2: Remove Minikube binary
if [ -f /usr/local/bin/minikube ]; then
    echo "Removing Minikube binary..."
    sudo rm -f /usr/local/bin/minikube
fi

# Step 3: Remove kubectl binary
if command -v kubectl &> /dev/null; then
    echo "Removing kubectl binary..."
    sudo rm -f $(which kubectl)
fi

# Step 4: Uninstall Docker
if command -v docker &> /dev/null; then
    echo "Stopping Docker service..."
    sudo systemctl stop docker
    echo "Removing Docker packages..."
    sudo apt remove -y docker.io docker-ce docker-ce-cli containerd.io
    sudo apt autoremove -y
    sudo rm -rf /var/lib/docker
    sudo rm -rf /etc/docker
fi

# Step 5: Remove any remaining Kubernetes configurations
echo "Removing Kubernetes configuration files..."
sudo rm -rf ~/.kube ~/.minikube

# Step 6: Remove user from Docker group
if groups $USER | grep -q "docker"; then
    echo "Removing user from Docker group..."
    sudo gpasswd -d $USER docker
fi

echo "Docker, Minikube, and kubectl have been successfully removed!"
