#!/bin/sh
while true; do
    "$2"
    if [ "$?" = 0 ];then
        break
    fi
    sleep 1
done