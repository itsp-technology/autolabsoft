#!/bin/bash

## Supported OS Check (Ubuntu Only)
OS=$(lsb_release -is 2>/dev/null)
if [[ "$OS" != "Ubuntu" ]]; then
    echo -e "\e[1;31mThis script only supports Ubuntu 20.04 / 22.04\e[0m"
    exit 1
fi

## Cleanup Mode (if executed with 'clean' argument)
if [ "$1" == "clean" ]; then
    cd /tmp
    rm -rf labautomation
    echo -e "\e[1;35m Cleanup Succeeded \e[0m"
    exit 0
fi

## Install Required Packages
sudo apt update -y && sudo apt install -y git curl

## Clone or Update Lab Automation Repository
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

## Check if Setup Script Exists
if [ ! -f /tmp/labautomation/setup.sh ]; then
    echo -e "\e[1;33m💡 Hint! Try using \e[0m\e[1m'sudo labauto clean'\e[0m"
    exit 1
fi

## Check if Running as Root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\e[1;31mYou must run this script as root!\e[0m"
    exit 1
fi

## Run the Main Setup Script
bash /tmp/labautomation/setup.sh $*
