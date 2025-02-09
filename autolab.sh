#!/bin/bash

## Supported OS's
# Check for Ubuntu 20.04 (focal), 22.04 (jammy), or 24.04 (noble)
OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep 'VERSION_CODENAME=' /etc/os-release | cut -d= -f2)

SUPPORTED_VERSIONS="focal jammy noble"

if [ "$OS_ID" != "ubuntu" ] || [[ ! "$SUPPORTED_VERSIONS" =~ "$OS_VERSION" ]]; then
  echo -e "\e[1;31mError: Currently this setup works only for Ubuntu 20.04 (focal), 22.04 (jammy), or 24.04 (noble)\e[0m"
  exit 1
fi

if [ "$1" == "clean" ]; then
  cd /tmp
  rm -rf labautomation
  echo -e "\e[1;35m Cleanup Succeeded\e[0m"
  exit 0
else
  if [ -d /tmp/labautomation ]; then
    cd /tmp/labautomation
    git pull &>/dev/null
    if [ $? -ne 0 ]; then
      cd /tmp
      rm -rf /tmp/lab*
      git clone https://github.com/itsp-technology/autolabsoft.git /tmp/labautomation &>/dev/null
    fi
  else
    git clone https://github.com/itsp-technology/autolabsoft.git /tmp/labautomation &>/dev/null
  fi
fi

if [ ! -f /tmp/labautomation/setup.sh ]; then
  echo -e "\e[1;33m💡💡 Hint! Try Using \e[0m\e[1m'sudo labauto clean'\e[0m"
  exit 1
fi

source /tmp/labautomation/dry/common-functions.sh

## Checking Root User or not.
CheckRoot

bash /tmp/labautomation/setup.sh $*