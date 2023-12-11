#!/bin/bash

#Create variables for the directories
current_dir=$(pwd)
current_dir_name=$(basename $(pwd))
parent_dir=$(dirname $(pwd))
current_user=$(whoami)
user_dir="/home/$current_user"
backups_dir="/home/$current_user/BACKUPS"

#Create a general backup directory
echo "-----[Checking for backups directory]-----"
if [ -d "$backups_dir" ]; then
        echo "$backups_dir does exist."
else
        echo "$backups_dir does not exist."
        mkdir "$backups_dir"
        if [ -d "$backups_dir" ]; then
                echo "$backups_dir has been created."
        else
                echo "ERROR: The directory could not be created."
                exit 1
        fi
fi

#create directory for this directory
echo "-----[Checking for backups location.]-----"
if [ -d "$backups_dir"/"$current_dir_name" ]; then
        echo "$backups_dir/$current_dir_name does exist."
else
        echo "$backups_dir/$current_dir_name does not exist."
        mkdir "$backups_dir"/"$current_dir_name"
        if [ -d "$backups_dir"/"$current_dir_name" ]; then
                echo "$backups_dir/$current_dir_name has been created."
        else
                echo "ERROR: The directory could not be created."
                exit 1
        fi
fi

#for loop containing all .txt files in the current directory
for file in *.txt; do
        backup_file_location="$backups_dir/$current_dir_name/$file"
        echo "-----[Creating backup for $file.]-----"
        if [ -e "$backup_file_location" ]; then
                rm "$backups_dir/$current_dir_name/$file"
                echo "Previous backup removed."
        fi
        cp "$file" "$backup_file_location"
        if [ -e "$backups_dir"/"$current_dir_name"/"$file" ]; then
                echo "Backup created for $file."
        else
                echo "ERROR: Failed to create backup for $file"
                exit 1
        fi
done

echo "-----[Back-ups created at location:]-----"
echo "$backups_dir/$current_dir_name"
echo "-----------------------------------------"
exit 0
