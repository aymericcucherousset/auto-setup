#!/bin/bash
printf "\nInstallation of Apache2\n"

# Check if apache2 is already installed
if [ -f /usr/sbin/apache2 ]; then
  echo "Apache2 is already installed"
  exit 0
fi

apt install apache2 -y
a2enmod rewrite
systemctl restart apache2
printf "\nApache2 is installed.\n"
exit 0