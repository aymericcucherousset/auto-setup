#!/bin/bash
printf "\nInstallation of GLPI\n"

cd "$(dirname "$0")"
# Get the local IP address of the server:
ip=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')

# Check if apache2 is already installed
if [ -f /usr/sbin/apache2 ]; then
  echo "Apache2 is already installed"
else
  # Install apache2
  bash apache2.sh
fi

# Check if mariadb is already installed
if [ -f /usr/bin/mariadb ]; then
  echo "MariaDB is already installed"
else
  # Install mariadb
  bash mariadb.sh
fi

# Check if php is already installed
if [ -f /usr/bin/php ]; then
  echo "PHP is already installed"
else
  # Install php
  bash php.sh
fi

# Choose the path where glpi will be installed
printf "\nChoose the path where glpi will be installed (default: /var/www/html): "
read -r path
if [ -z "$path" ]; then
  path="/var/www/html"
fi

# Choose the name of glpi folder
printf "\nChoose the name of glpi folder (default: glpi): "
read -r folder
if [ -z "$folder" ]; then
  folder="glpi"
fi

# installing dependencies
apt-get install apcupsd php-apcu php-cas php-curl wget -y

# Download glpi
wget https://github.com/glpi-project/glpi/releases/download/10.0.3/glpi-10.0.3.tgz
tar -xvzf glpi-10.0.3.tgz -C "$path"
chown -R www-data:www-data "$path/glpi"

# Ask for the database name
printf "\nCreate the database for glpi\n"
printf "Enter the name of the database (default: glpi): "
read -r database
if [ -z "$database" ]; then
  database="glpi"
fi

# Ask to create new user
printf "Enter the name of the user (default: glpi): "
read -r user
if [ -z "$user" ]; then
  user="glpi"
fi

# Ask for the password of the user
printf "Enter the password of the user (default: glpi): "
read -r password
if [ -z "$password" ]; then
  password="glpi"
fi

# Create the database
mysql -u root -p -e "CREATE DATABASE $database;"
mysql -u root -p -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"

# Grant privileges to the user
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $database.* TO '$user'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
mysql -u root -p -e "USE $database;"

printf "\nGLPI is installed\n"
printf "You can access it at http://$ip/$folder\n"
exit 0