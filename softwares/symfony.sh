#!/bin/bash
printf "\nInstallation of Symfony\n"

# Check if php is already installed
if ! command -v php &> /dev/null
then
    printf "\nPhp is not installed. Do you want to install it now? (y/n)\n"
    read -p "Enter your answer: " answer
    if [ $answer = "y" ]; then
        bash softwares/php.sh
    else
        printf "\nPhp is required to install symfony\n"
        exit 1
    fi
fi

# Check if composer is already installed
if ! command -v composer &> /dev/null
then
    printf "\nComposer is not installed. Do you want to install it now? (y/n)\n"
    read -p "Enter your answer: " answer
    if [ $answer = "y" ]; then
        bash softwares/composer.sh
    else
        printf "\nComposer is required to install symfony\n"
        exit 1
    fi
fi

# Install symfony
echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list
apt update
apt install symfony-cli -y
printf "\nSymfony is installed.\n"
exit 0