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

case "$1" in
    yt-dlp)
        export PATH="/home/dev/.local/bin:$PATH"
        gosu dev "$@"
    ;;
    *)
        if [[ "$@" == sleep ]];then
            while true; do
                echo "`date`"
                sleep 3600
            done
        else
            exec "$@"
        fi
    ;;
esac
