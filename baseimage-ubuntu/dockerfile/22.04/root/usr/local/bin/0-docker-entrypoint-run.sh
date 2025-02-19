#!/bin/sh
while true; do
    "$1"
    if [ "$?" = 0 ];then
        break
    fi
    sleep $RESTART_INTERVAL_SECOND
done