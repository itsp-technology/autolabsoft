#!/bin/bash

# Check Internet Connection
ping -c 2 google.com &>/dev/null
if [ $? -ne 0 ]; then
    echo "Internet connection is not working.. Check it .. !!"
    exit 1
fi

# Ensure script is run as root
if [ $(id -u) -ne 0 ]; then
    echo "You should be a root/sudo user to perform this script"
    exit 1
fi

# Update System Packages (Use `apt` instead of `yum/dnf`)
apt update -y && apt upgrade -y

# Install Essential Packages
PACK_LIST="wget zip unzip gzip vim net-tools git curl jq python3-pip"
for package in $PACK_LIST; do
    apt install -y $package &>/dev/null
done

# Disable Firewall (Use `ufw` instead of `firewalld`)
systemctl stop ufw &>/dev/null
systemctl disable ufw &>/dev/null

# Fix SSH Timeouts
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config

# Enable Password Login
sed -i -e '/^PasswordAuthentication/ c PasswordAuthentication yes' -e '/^PermitRootLogin/ c PermitRootLogin yes' /etc/ssh/sshd_config
systemctl restart ssh

# Set Default Passwords
ROOT_PASS="DevOps321"
echo -e "$ROOT_PASS\n$ROOT_PASS" | passwd root

# Install AWS CLI (Ubuntu doesn't come with AWS CLI pre-installed)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
apt install -y unzip
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Clean Up
apt autoremove -y
apt clean -y
rm -rf /tmp/*
