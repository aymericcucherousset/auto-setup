#!/bin/bash
printf "\nInstallation of MariaDB\n"

# Check if mariadb is already installed
if [ -f /usr/bin/mariadb ]; then
  echo "MariaDB is already installed"
  exit 0
fi

# Install mariadb
apt install mariadb-server mariadb-client -y
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
printf "\nMariaDB is installed.\n"
exit 0