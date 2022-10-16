#!/bin/bash
printf "\nInstallation of AdGuardHome\n"

# Check if AdGuardHome is already installed
if [ -f /usr/bin/AdGuardHome ]; then
  echo "AdGuardHome is already installed"
  exit 0
fi

# Install AdGuardHome
apt install curl -y

# Download AdGuardHome
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
printf "\nAdGuardHome is installed.\n"
exit 0