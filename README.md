# auto-setup

This Bash script setup software in Debian Distribution.   

## Requirements ##

Install git with root account
```apt update && apt install git -y```

Install git with sudo
```sudo apt update && sudo apt install git -y```

## Installation ## 

This bash line install on your computer the portable version of auto-setup :   

``` git clone https://github.com/aymericcucherousset/auto-setup.git && cd auto-setup && chmod +x ./start.sh && ./start.sh```   

Made for Debian 11

## Softwares Supported ##   
   
| Softwares   | Debian|
| :---------: | ----- |
| Aapanel     | Yes   |
| AdGuardHome | Yes   |
| Apache2     | Yes   |
| Composer    | Yes   |
| Docker      | Yes   |
| Glpi        | Yes   |
| Mariadb     | Yes   |
| NodeJs      | Yes   |
| Php         | Yes   |
| PhpMyAdmin  | Yes   |
| Sqlite3     | Yes   |
| Symfony     | Yes   |
| Wordpress   | Yes   |   
   
## Unistall ## 

This software is a portable version, so to remove it, just remove the folder called "auto-setup" :   
    
```rm -rf auto-setup```