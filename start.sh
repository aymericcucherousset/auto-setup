#!/bin/bash
FILES='softwares/*.sh'
i=1

printf "\nChose the software you want to install:\n\n"

for f in $FILES
do
  echo "$i : $f "
  i=$((i+1))
done

printf "\n"
read -p "Enter the number of the software you want to install: " num

# Getting the file name
file=$(ls $FILES | sed -n "$num"p)

# Check if the file exists
if [ -f "$file" ]; then
  # Execute the file
  bash $file
else
  echo "File not found"
  exit 1
fi

# Execute the software installation script
apt update
sh $file