#!/bin/bash

# Move the the script directory
cd "$(dirname "$0")"

FILES='softwares/*.sh'
i=1

printf "\nChose the software you want to install:\n\n"

for f in $FILES
do
  echo "$i : $f "
  i=$((i+1))
done
printf "\n0 : Exit\n"
printf "\n"
read -p "Enter the number of the software you want to install: " num

# If the number is 0, exit the script
if [ $num = 0 ]; then
  exit 0
fi

# Getting the file name
file=$(ls $FILES | sed -n "$num"p)

# Check if the file exists & Execute the software installation script
if [ -f "$file" ]; then
    apt update
    # Execute the file
    bash $file
else
    echo "File not found"
    exit 1
fi