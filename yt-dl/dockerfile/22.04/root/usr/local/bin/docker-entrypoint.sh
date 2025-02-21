#!/bin/bash
set -e

grep -vw "^dev" /etc/group > /tmp/fix
echo "dev:x:$PGID:" >> /tmp/fix
if [ `id -u` = 0 ];then
    mv /tmp/fix /etc/group
else
    sudo chown root:root /tmp/fix
    sudo mv /tmp/fix /etc/group
fi
grep -vw "^dev" /etc/passwd > /tmp/fix
echo "dev:x:$PUID:$PGID::/home/dev:/bin/bash" >> /tmp/fix
if [ `id -u` = 0 ];then
    mv /tmp/fix /etc/passwd
    chown dev:dev /data
else
    sudo chown root:root /tmp/fix
    sudo mv /tmp/fix /etc/passwd
    sudo chown dev:dev /data
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
