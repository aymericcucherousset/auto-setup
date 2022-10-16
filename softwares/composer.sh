#!/bin/bash
printf "\nInstallation of Composer\n"

# Check if composer is already installed
if [ -f /usr/local/bin/composer ]; then
  echo "Composer is already installed"
  exit 0
fi

# Check if php is already installed
if ! command -v php &> /dev/null
then
    printf "\nPhp is not installed. Do you want to install it now? (y/n)\n"
    read -p "Enter your answer: " answer
    if [ $answer = "y" ]; then
        bash softwares/php.sh
    else
        printf "\nPhp is required to install composer\n"
        exit 1
    fi
fi

# Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
chmod +x /usr/local/bin/composer
composer self-update
printf "\nComposer is installed.\n"
exit 0