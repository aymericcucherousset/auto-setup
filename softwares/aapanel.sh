#!/bin/bash

# Check if sudo is installed
if [ -f /usr/bin/sudo ]
then
  echo "Sudo is already installed"
  # Install Aapanel
  wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh aapanel
else
  # Check if user is root
    if [ "$EUID" -ne 0 ]
    then
        echo "Please run as root"
        exit
    else
        # Install Aapanel without sudo
        wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
    fi
fi

echo "Aapanel is installed"

# getting Aapanel credentials
echo "Getting Aapanel credentials"
cat /root/.aapanel_info.txt