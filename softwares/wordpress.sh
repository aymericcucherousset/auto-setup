#!/bin/bash
printf "\nInstallation of Wordpress\n"

cd "$(dirname "$0")"
# Get the local IP address of the server:
ip=ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'

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

# Choose the path where wordpress will be installed
printf "\nChoose the path where wordpress will be installed (default: /var/www/html): "
read -r path
if [ -z "$path" ]; then
  path="/var/www/html"
fi

# Choose the name of wordpress folder
printf "\nChoose the name of wordpress folder (default: wordpress): "
read -r folder
if [ -z "$folder" ]; then
  folder="wordpress"
fi

# Download wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
rm latest.tar.gz
mv wordpress "$path"
mv $path/wordpress $path/$folder

# Create the database
printf "\nCreate the database for wordpress\n"
printf "Enter the name of the database (default: wordpress): "
read -r database
if [ -z "$database" ]; then
  database="wordpress"
fi

printf "Enter the name of the user (default: wordpress): "
read -r user
if [ -z "$user" ]; then
  user="wordpress"
fi

printf "Enter the password of the user (default: wordpress): "
read -r password
if [ -z "$password" ]; then
  password="wordpress"
fi

mysql -u root -p -e "CREATE DATABASE $database;"
mysql -u root -p -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $database.* TO '$user'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
mysql -u root -p -e "exit"

# Create the wp-config.php file
cd "$path"/"$folder" || exit
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$database/g" wp-config.php
sed -i "s/username_here/$user/g" wp-config.php
sed -i "s/password_here/$password/g" wp-config.php

# Create the .htaccess file
touch .htaccess
cat > .htaccess << EOF
# BEGIN WordPress
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF

# Create the virtual host
printf "\nCreate the virtual host for wordpress\n"
printf "Enter the name of the virtual host (default: wordpress): "
read -r virtualhost
if [ -z "$virtualhost" ]; then
  virtualhost="wordpress"
fi

printf "Enter the port of the virtual host (default: 80): "
read -r port
if [ -z "$port" ]; then
  port="80"
fi

printf "Enter the server name of the virtual host (default: $i): "
read -r servername
if [ -z "$servername" ]; then
  servername="$ip"
fi

printf "Enter the server alias of the virtual host (default: www.$i): "
read -r serveralias
if [ -z "$serveralias" ]; then
  serveralias="www.$ip"
fi

printf "Enter the document root of the virtual host (default: $path/$folder): "
read -r documentroot
if [ -z "$documentroot" ]; then
  documentroot="$path"/"$folder"
fi

printf "Enter the error log of the virtual host (default: /var/log/apache2/$virtualhost-error.log): "
read -r errorlog
if [ -z "$errorlog" ]; then
  errorlog="/var/log/apache2/$virtualhost-error.log"
fi

printf "Enter the access log of the virtual host (default: /var/log/apache2/$virtualhost-access.log): "
read -r accesslog
if [ -z "$accesslog" ]; then
  accesslog="/var/log/apache2/$virtualhost-access.log"
fi

touch /etc/apache2/sites-available/"$virtualhost".conf
cat > /etc/apache2/sites-available/"$virtualhost".conf << EOF
<VirtualHost *:$port>
    ServerAdmin webmaster@localhost
    ServerName $servername
    ServerAlias $serveralias
    DocumentRoot $documentroot
    ErrorLog $errorlog
    CustomLog $accesslog combined
</VirtualHost>
EOF

# Enable the virtual host
a2ensite "$virtualhost".conf
systemctl restart apache2

# Change the owner of the wordpress folder
chown -R www-data:www-data "$path"/"$folder"

# Restart apache2
systemctl restart apache2

printf "\nWordpress is installed.\n"

printf "You can access to wordpress at http://$ip/$folder\n"
exit 0