#!/bin/bash

# Check Internet Connection
ping -c 2 google.com &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Internet connection is not working. Check your network settings.\e[0m"
    exit 1
fi

# Ensure script is run as root
if [ $(id -u) -ne 0 ]; then
    echo -e "\e[1;31mError: You must be a root/sudo user to run this script.\e[0m"
    exit 1
fi

# Update System Packages
echo -e "\e[1;32mUpdating system packages...\e[0m"
apt update -y && apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to update system packages.\e[0m"
    exit 1
fi

# Install Essential Packages
echo -e "\e[1;32mInstalling essential packages...\e[0m"
PACK_LIST="wget zip unzip gzip vim net-tools git curl jq python3-pip"
for package in $PACK_LIST; do
    apt install -y $package &>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Failed to install package: $package\e[0m"
        exit 1
    fi
done

# Disable Firewall (ufw)
echo -e "\e[1;32mDisabling firewall...\e[0m"
systemctl stop ufw &>/dev/null
systemctl disable ufw &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to disable ufw.\e[0m"
    exit 1
fi

# Fix SSH Timeouts
echo -e "\e[1;32mConfiguring SSH for better connectivity...\e[0m"
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to configure SSH settings.\e[0m"
    exit 1
fi

# Enable Password Login and Root Login
echo -e "\e[1;32mEnabling SSH password authentication and root login...\e[0m"
sed -i -e 's/^#PermitRootLogin.*/PermitRootLogin yes/' \
       -e 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' \
       -e 's/^PermitRootLogin.*/PermitRootLogin yes/' \
       -e 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service
systemctl restart ssh
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to restart SSH service.\e[0m"
    exit 1
fi

# Set Default Passwords
echo -e "\e[1;32mSetting default password for root user...\e[0m"
ROOT_PASS="DevOps321"
echo -e "$ROOT_PASS\n$ROOT_PASS" | passwd root
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to set root password.\e[0m"
    exit 1
fi

# Install AWS CLI
echo -e "\e[1;32mInstalling AWS CLI...\e[0m"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to download AWS CLI.\e[0m"
    exit 1
fi
unzip /tmp/awscliv2.zip -d /tmp
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to unzip AWS CLI.\e[0m"
    exit 1
fi
/tmp/aws/install
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Failed to install AWS CLI.\e[0m"
    exit 1
fi

# Clean Up
echo -e "\e[1;32mCleaning up temporary files...\e[0m"
apt autoremove -y
apt clean -y
rm -rf /tmp/*

echo -e "\e[1;32mAMI setup completed successfully!\e[0m"