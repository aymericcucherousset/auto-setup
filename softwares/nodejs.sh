#!/bin/bash
printf "\nInstallation of NodeJS\n"

# Check if nodejs is already installed
if [ -f /usr/bin/nodejs ]; then
  echo "NodeJS is already installed"
  exit 0
fi

# Install nodejs
apt install nodejs -y
printf "\nNodeJS is installed.\n"
exit 0