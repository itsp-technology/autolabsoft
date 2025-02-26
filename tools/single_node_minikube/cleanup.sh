#!/bin/bash

# Exit script on any error
set -e

echo "Starting Minikube and Docker uninstallation..."

# Step 1: Stop Minikube if running
echo "Stopping Minikube..."
minikube stop || true

# Step 2: Delete Minikube cluster
echo "Deleting Minikube cluster..."
minikube delete || true

# Step 3: Remove Minikube binary
echo "Removing Minikube binary..."
sudo rm -f /usr/local/bin/minikube

# Step 4: Remove Minikube configuration and cache
echo "Removing Minikube configuration and cache..."
rm -rf ~/.minikube

# Step 5: Remove Docker
echo "Stopping and removing Docker..."
sudo systemctl stop docker || true
sudo apt purge -y docker.io
sudo apt autoremove -y
sudo rm -rf /var/lib/docker

# Step 6: Remove user from Docker group
echo "Removing user from Docker group..."
sudo gpasswd -d $USER docker || true

# Step 7: Remove additional dependencies
echo "Removing additional dependencies..."
sudo apt purge -y curl apt-transport-https ca-certificates software-properties-common
sudo apt autoremove -y

# Step 8: Cleanup leftover files
echo "Cleaning up leftover files..."
sudo rm -rf /etc/docker
rm -rf ~/.docker

# Step 9: Refresh groups and environment
echo "Refreshing user groups..."
newgrp

echo "Minikube and Docker have been completely removed!"
