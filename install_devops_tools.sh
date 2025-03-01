#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Constants for tool versions
KUBECTL_VERSION="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
TERRAFORM_VERSION="0.14.9"
JENKINS_REPO="https://pkg.jenkins.io"
AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
GOOGLE_CLOUD_SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-346.0.0-linux-x86_64.tar.gz"
HELM_SCRIPT="https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
GRAFANA_RPM_URL="https://packages.grafana.com/oss/rpm/grafana-7.3.1-1.x86_64.rpm"
PACKER_VERSION="1.7.2"
VAGRANT_VERSION="2.2.14"
ISTIO_VERSION="1.9.5"

# Welcome Message
clear
echo "****************************************************************************"
echo "#                                                                          #"
echo "#          DevOps Tool Installer/Uninstaller by VIVEK          #"
echo "#                                                                          #"
echo "****************************************************************************"


# Function to prompt user for their Linux distribution
get_linux_distribution() {
  echo "Select your Linux distribution:"
  echo "1. Ubuntu/Debian"
  echo "2. CentOS/RHEL optional"
  echo "3. Fedora"
  read -p "Enter the number corresponding to your distribution: " distro_choice

  case $distro_choice in
    1) DISTRO="ubuntu";;
    2) DISTRO="centos";;
    3) DISTRO="fedora";;
    *) echo "Invalid Linux distribution choice. Exiting." && exit 1;;
  esac
}

# Function to handle installations
install_tool() {
  local tool_name="$1"
  local install_cmd="$2"

  echo "Installing $tool_name..."
  eval "$install_cmd"
  echo "$tool_name installed successfully."
}

# Function to handle uninstallation
uninstall_tool() {
  local tool_name="$1"
  local uninstall_cmd="$2"

  echo "Uninstalling $tool_name..."
  eval "$uninstall_cmd"
  echo "$tool_name uninstalled successfully."
}

# Installation Commands
declare -A install_commands=(
  [docker]="sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
  [kubectl]="curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/"
  [ansible]="sudo apt-get update && sudo apt-get install -y ansible"
  [terraform]="curl -LO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip && unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && rm terraform_$TERRAFORM_VERSION_linux_amd64.zip"
 )

# Uninstallation Commands
declare -A uninstall_commands=(
  [docker]="sudo apt-get remove -y docker-ce docker-ce-cli containerd.io && sudo apt-get purge -y docker-ce docker-ce-cli containerd.io && sudo rm -rf /var/lib/docker"
  [kubectl]="sudo rm /usr/local/bin/kubectl"
  [ansible]="sudo apt-get remove -y ansible && sudo apt-get purge -y ansible"
  [terraform]="curl -LO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip && unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && rm terraform_$TERRAFORM_VERSION_linux_amd64.zip"

 )

# Prompt user for action
read -p "Do you want to install or uninstall tools? (install/uninstall): " action

if [[ "$action" != "install" && "$action" != "uninstall" ]]; then
  echo "Invalid action selected. Exiting."
  exit 1
fi

get_linux_distribution

# Prompt user for tool selection
echo "Select tools to $action (separate with spaces):"
for tool in "${!install_commands[@]}"; do
  echo "- $tool"
done
read -p "Your selection: " selected_tools

# Process each selected tool
for tool in $selected_tools; do
  if [[ "$action" == "install" ]]; then
    if [[ -v install_commands["$tool"] ]]; then
      install_tool "$tool" "${install_commands[$tool]}"
    else
      echo "No installation command found for $tool."
    fi
  elif [[ "$action" == "uninstall" ]]; then
    if [[ -v uninstall_commands["$tool"] ]]; then
      uninstall_tool "$tool" "${uninstall_commands[$tool]}"
    else
      echo "No uninstallation command found for $tool."
    fi
  fi
done

echo "Operation completed successfully."
