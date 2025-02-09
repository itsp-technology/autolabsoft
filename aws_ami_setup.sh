#!/bin/bash

## Checking Internet 
ping -c 2 google.com &>/dev/null 
if [ $? -ne 0 ]; then 
    echo "Internet connection is not  working vivek. Check it!"
    exit 1
fi

## Ensure script is run as root
if [ $(id -u) -ne 0 ]; then 
    echo "You should be a root/sudo user to perform this script"
    exit 1
fi

## Update and install base packages
apt update -y && apt upgrade -y
apt install -y wget curl unzip git net-tools jq vim

## Disable firewall
systemctl disable --now ufw

## Enable password login for SSH
sed -i -e '/^PasswordAuthentication/ c PasswordAuthentication yes' \
       -e '/^PermitRootLogin/ c PermitRootLogin yes' /etc/ssh/sshd_config
systemctl restart ssh

## Set root password
ROOT_PASS="DevOps321"
echo "root:$ROOT_PASS" | chpasswd

## Fix SSH keepalive settings
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' \
       -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
systemctl restart ssh

## Install AWS CLI
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

## Clean up
rm -rf /var/lib/apt/lists/* /tmp/*

echo "AMI setup for Ubuntu 24 is complete."
