#!/bin/bash 

VERSION=$(curl -s https://github.com/derailed/k9s/releases | grep 'Release v' | head -1 | sed -e 's|<h1>||' -e 's|</h1>||' | awk '{print $2}')
#curl -L https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_x86_64.tar.gz | tar -xz
#dnf install https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_linux_amd64.rpm -y
curl -L "https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_amd64.tar.gz" | tar -xz
sudo mv k9s /bin

# next hit the k9s inside sever machine you will get k9s console

#https://github.com/derailed/k9s/releases/download/v0.40.5/k9s_Linux_amd64.tar.gz