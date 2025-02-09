#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then 
  echo "You should be a root user / sudo user to perform this script"
  exit 1
fi 

# Install required packages
apt update -y && apt install -y curl unzip

# Get the latest Maven version dynamically
VERSION=$(curl -s https://maven.apache.org/download.cgi | grep -oP 'apache-maven-\K[\d.]+' | head -1)

# Define installation directory
INSTALL_DIR="/opt/maven"

# Remove previous versions if they exist
rm -rf ${INSTALL_DIR} /tmp/apache-maven-*
# Download and extract Maven
curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip
unzip /tmp/apache-maven-${VERSION}-bin.zip -d /opt
mv /opt/apache-maven-${VERSION} ${INSTALL_DIR}

# Create a symbolic link for easy use
ln -sf ${INSTALL_DIR}/bin/mvn /usr/bin/mvn

# Set up environment variables
echo 'export M2_HOME=/opt/maven' | tee -a /etc/profile.d/maven.sh
echo 'export PATH=$M2_HOME/bin:$PATH' | tee -a /etc/profile.d/maven.sh
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Verify installation
mvn -version

echo "✅ Apache Maven ${VERSION} installed successfully!"
