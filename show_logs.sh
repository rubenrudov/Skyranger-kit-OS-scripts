#!/bin/bash

# Assign the filename to a variable
filename="/{HOME_PATH}/skyranger/syslog.log"

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi

# Read and display the contents of the file
while IFS= read -r line; do
    echo "$line"
done < "$filename"
