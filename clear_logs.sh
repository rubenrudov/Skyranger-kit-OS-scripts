#!/bin/bash

# Assign the filename to a variable
filename="/{HOME_PATH}/skyranger/syslog.log"

# Check if the file exists and delete it
if [ -f "$filename" ]; then
    echo "Deleting file: $filename"
    rm "$filename"
else
    echo "File does not exist: $filename"
fi

# Create a new empty file with the same name
touch "$filename"
echo "Created new file: $filename"