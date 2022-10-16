#!/bin/bash
printf "\nInstallation of Sqlite3\n"

# Check if sqlite3 is already installed
if [ -f /usr/bin/sqlite3 ]; then
  echo "Sqlite3 is already installed"
  exit 0
fi

# Install sqlite3
apt install sqlite3 -y
printf "\nSqlite3 is installed.\n"
exit 0