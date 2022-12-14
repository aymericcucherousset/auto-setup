#!/bin/bash
printf "\nInstallation of LAMP stack\n"

cd "$(dirname "$0")"

# Check if apache2 is already installed
if [ -f /usr/sbin/apache2 ]; then
  echo "Apache2 is already installed"
else
  # Install apache2
  bash apache2.sh
  printf "\nApache2 is installed.\n"
fi

# Check if mariadb is already installed
if [ -f /usr/bin/mariadb ]; then
  echo "MariaDB is already installed"
else
  # Install mariadb
  bash mariadb.sh
  printf "\nMariaDB is installed.\n"
fi

# Check if php is already installed
if [ -f /usr/bin/php ]; then
  echo "PHP is already installed"
else
  # Install php
  bash php.sh
  printf "\nPHP is installed.\n"
fi

# Check if phpmyadmin is already installed
if [ -f /usr/share/phpmyadmin ]; then
  echo "PhpMyAdmin is already installed"
else
  # Install phpmyadmin
  bash phpmyadmin.sh
  printf "\nPhpMyAdmin is installed.\n"
fi

printf "\nLAMP stack is installed.\n"
exit 0