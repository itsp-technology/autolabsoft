#!/bin/bash

## Supported OS's
# Check for Ubuntu 20.04 (focal), 22.04 (jammy), or 24.04 (noble)
OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep 'VERSION_CODENAME=' /etc/os-release | cut -d= -f2)

SUPPORTED_VERSIONS="focal jammy noble"

if [ "$OS_ID" != "ubuntu" ] || [[ ! " $SUPPORTED_VERSIONS " =~ " $OS_VERSION " ]]; then
  echo -e "\e[1;31mError: Currently this setup works only for Ubuntu 20.04 (focal), 22.04 (jammy), or 24.04 (noble)\e[0m"
  exit 1
fi

# Cleanup option
if [ "$1" == "clean" ]; then
  cd /tmp
  rm -rf labautomation
  echo -e "\e[1;35mCleanup Succeeded\e[0m"
  exit 0
fi

# Repository URL (can be dynamically fetched from a file if needed)
REPO_URL="https://github.com/itsp-technology/autolabsoft.git"

# Clone or update the repository
if [ -d /tmp/labautomation ]; then
  cd /tmp/labautomation
  git pull &>/dev/null
  if [ $? -ne 0 ]; then
    cd /tmp
    rm -rf /tmp/labautomation
    git clone "$REPO_URL" /tmp/labautomation &>/dev/null
  fi
else
  git clone "$REPO_URL" /tmp/labautomation &>/dev/null
fi

# Ensure setup.sh exists before proceeding
if [ ! -f /tmp/labautomation/setup.sh ]; then
  echo -e "\e[1;33m💡💡 Hint! Try Using \e[0m\e[1m'sudo labauto clean'\e[0m"
  exit 1
fi

# Load common functions
source /tmp/labautomation/dry/common-functions.sh

# Checking Root User
CheckRoot

# Run setup.sh with all passed arguments
bash /tmp/labautomation/setup.sh "$@"
