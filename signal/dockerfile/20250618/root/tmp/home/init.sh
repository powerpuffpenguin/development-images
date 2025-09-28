#!/bin/bash

ifs=$IFS
IFS="
"
files=(`find /home/dev -maxdepth 1 -type f`)
IFS=$ifs
for file in "${files[@]}";do
    echo "cp '$file' '/tmp/home/'"
    cp "$file" /tmp/home/
done