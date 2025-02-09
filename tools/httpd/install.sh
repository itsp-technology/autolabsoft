#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then 
  echo "❌ You should be a root user or use sudo to run this script."
  exit 1
fi 

# Update package lists
apt update -y 

# Install Apache
apt install -y apache2
