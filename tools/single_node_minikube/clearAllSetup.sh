sudo systemctl stop docker && \
sudo systemctl disable docker && \
sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
sudo rm -rf /var/lib/docker /var/lib/containerd /etc/docker && \
sudo groupdel docker && \
sudo rm -rf /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.gpg && \
sudo apt-get autoremove -y && \
sudo apt-get autoclean -y && \
sudo rm -f /usr/local/bin/kubectl /usr/local/bin/minikube && \
sudo rm -rf ~/.kube ~/.minikube /root/.kube /root/.minikube && \
echo "Cleanup complete!"
