#!/bin/bash
printf "\nInstallation of MariaDB\n"

# Check if mariadb is already installed
if [ -f /usr/bin/mariadb ]; then
  echo "MariaDB is already installed"
  exit 0
fi

# Install mariadb
apt install mariadb-server mariadb-client -y
systemctl enable mariadb
systemctl start mariadb

mariadb-secure-installation

printf "\nMariaDB is installed.\n"
exit 0