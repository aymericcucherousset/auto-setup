#!/bin/bash
printf "\nInstallation of Docker\n"

# Check if docker is already installed
if [ -f /usr/bin/docker ]; then
  echo "Docker is already installed"
  exit 0
fi

# Install docker
apt install docker.io docker-compose -y
systemctl start docker
systemctl enable docker
printf "\nDocker is installed.\n"
exit 0