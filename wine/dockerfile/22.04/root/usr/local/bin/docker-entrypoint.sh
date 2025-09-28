#!/bin/bash
set -e

if [ `id -u` = 0 ];then
    grep -vw "^dev" /etc/group > /tmp/fix
    echo "dev:x:$PGID:" >> /tmp/fix
    mv /tmp/fix /etc/group
    grep -vw "^dev" /etc/passwd > /tmp/fix
    echo "dev:x:$PUID:$PGID::/home/dev:/bin/bash" >> /tmp/fix
    mv /tmp/fix /etc/passwd
fi
case "$@" in
    default-command)
        while true; do
            sleep 3600
        done
    ;;
    *)
        exec "$@"
    ;;
esac
