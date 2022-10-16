#!/bin/bash
printf "\nInstallation of Php\n"

# Ask wich version of php the user wants to install
printf "\nWhich version of php do you want to install?\n"
printf "1 : 7.4\n"
printf "2 : 8.0\n"
printf "3 : 8.1\n"
printf "4 : Latest version\n"
printf "\n"
read -p "Enter the number of the version you want to install: " num

# Check if the user entered a valid number
if [ $num -lt 1 ] || [ $num -gt 4 ]; then
  echo "Invalid number"
  exit 1
fi

# Install the version of php the user wants
if [ $num -eq 1 ]; then
  apt install php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-zip -y
elif [ $num -eq 2 ]; then
  apt install php8.0 php8.0-cli php8.0-common php8.0-curl php8.0-gd php8.0-intl php8.0-json php8.0-mbstring php8.0-mysql php8.0-opcache php8.0-readline php8.0-xml php8.0-zip -y
elif [ $num -eq 3 ]; then
  apt install php8.1 php8.1-cli php8.1-common php8.1-curl php8.1-gd php8.1-intl php8.1-json php8.1-mbstring php8.1-mysql php8.1-opcache php8.1-readline php8.1-xml php8.1-zip -y
elif [ $num -eq 4 ]; then
    apt install curl
    curl -sSL https://packages.sury.org/php/README.txt | bash -x
    apt install php php-cli php-common php-curl php-gd php-intl php-json php-mbstring php-mysql php-sqlite3 php-readline php-xml php-zip -y
fi

apt install libapache2-mod-php -y

printf "\nPhp is installed.\n"
exit 0