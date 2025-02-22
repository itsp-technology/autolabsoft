#!/bin/bash 

VERSION=$(curl -s https://github.com/derailed/k9s/releases | grep 'Release v' | head -1 | sed -e 's|<h1>||' -e 's|</h1>||' | awk '{print $2}')
#curl -L https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_x86_64.tar.gz | tar -xz
#dnf install https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_linux_amd64.rpm -y
curl -L "https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_amd64.tar.gz" | tar -xz
#sudo mv k9s /bin

#=========================
# 1. Use the Raw GitHub URL to install k9s so change this 
    # Replace github.com with raw.githubusercontent.com in the URL
        # $> curl -s https://raw.githubusercontent.com/itsp-technology/autolabsoft/main/tools/k9s/install.sh | sudo bash
#=========================

# next hit the k9s inside sever machine you will get k9s console

#https://github.com/derailed/k9s/releases/download/v0.40.5/k9s_Linux_amd64.tar.gz

#unistall k9s in machin 

#  1. Find the k9s Binary Location
# Check if it's in your PATH
    # $> which k9s
# If not found, check common locations
    # $> sudo find / -name k9s -type f 2>/dev/null

#2. Remove the Binary
#Once located (common locations shown below), delete it:
# If installed system-wide
    # sudo rm -f /usr/local/bin/k9s
# If installed in your home directory
    # rm -f ~/bin/k9s  # or wherever your find command located it

#3. Remove Configuration Files
    # rm -rf ~/.config/k9s  # Config directory
    # rm -f ~/.k9s/config.yml  # Old config location


#4. Cleanup Temporary Files
    #   rm -f k9s README.md LICENSE
