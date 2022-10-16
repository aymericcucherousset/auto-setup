#!/bin/bash
printf "\nInstallation of PhpMyAdmin\n"

cd "$(dirname "$0")"
ip=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')

# Check if phpmyadmin is already installed
if [ -f /usr/share/phpmyadmin ]; then
  echo "PhpMyAdmin is already installed"
  exit 0
fi

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

# Install phpmyadmin
apt install curl wget -y

# Download phpmyadmin
DATA="$(wget https://www.phpmyadmin.net/home_page/version.txt -q -O-)"
URL="$(echo $DATA | cut -d ' ' -f 3)"
VERSION="$(echo $DATA | cut -d ' ' -f 1)"
wget https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz

# Extract phpmyadmin
tar -xvzf phpMyAdmin-${VERSION}-all-languages.tar.gz
rm phpMyAdmin-${VERSION}-all-languages.tar.gz
mv phpMyAdmin-${VERSION}-all-languages phpmyadmin
mv phpmyadmin /usr/share/

cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php

# Changes the owner of the phpmyadmin folder
chown -R www-data:www-data /usr/share/phpmyadmin

mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin

# Setting a blowfish secret
# generate a random string
random_string=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 | xargs)
# replace the blowfish secret
sed -i "s/blowfish_secret'] = ''/blowfish_secret'] = '$random_string'/g" /usr/share/phpmyadmin/config.inc.php

# Adding Temporary Directory
sed -i "s/\$cfg\['TempDir'\] = ''/\$cfg\['TempDir'\] = '\/var\/lib\/phpmyadmin\/tmp'/g" /usr/share/phpmyadmin/config.inc.php

# Create the Apache configuration file
touch /etc/apache2/conf-enabled/phpmyadmin.conf
cat > /etc/apache2/conf-enabled/phpmyadmin.conf  << EOF
Alias /phpmyadmin /usr/share/phpmyadmin
<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>
        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>
        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
</Directory>
# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName "phpMyAdmin Setup"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>
# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
EOF

systemctl restart apache2

# Ask if the user want to create a phpmyadmin user
printf "\nDo you want to create a phpmyadmin user? (y/n) "
read -r create_user

# if create_user is empty set it to y
if [ -z "$create_user" ]; then
  create_user="y"
fi

if [ "$create_user" = "y" ]; then
    # Ask for the username
    printf "\nUsername: "
    read -r username

    # Ask for the password
    printf "\nPassword: "
    read -r password

    # Create the mariadb user
    mysql -u root -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost' WITH GRANT OPTION;"
    mysql -u root -e "FLUSH PRIVILEGES;"
    printf "\nUser created.\n"
fi

printf "\nPhpMyAdmin is installed.\n Open it in your browser: http://your-ip/phpmyadmin\n"
exit 0