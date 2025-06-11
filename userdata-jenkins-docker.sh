#!/bin/bash

set -e  # Exit on error

# Ensure non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" != "22.04" && "$UBUNTU_VERSION" != "24.04" ]]; then
    echo "This script supports Ubuntu 22.04 or 24.04 only" >&2
    exit 1
fi

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y openjdk-17-jdk curl gnupg2 software-properties-common apt-transport-https

# install java and nodejs
sudo apt install -y fontconfig openjdk-21-jre nodejs


# Install Jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins
if ! systemctl is-active --quiet jenkins; then
    echo "Jenkins failed to start" >&2
    exit 1
fi


# INSTALL DOCKER
# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add ubuntu user to docker group
newgrp docker
sudo usermod -aG docker ubuntu

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
if ! systemctl is-active --quiet docker; then
    echo "Docker failed to start" >&2
    exit 1
fi



# Give me a nice echo final message, with the jenkins url, echo the initial password, echo the setup complete message
echo "Jenkins admin pass: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
echo "Setup complete. Access Jenkins at http://<server-ip>:8080"
