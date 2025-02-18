#!/bin/bash
set -e

function set_gid
{
    echo "fix PGID=$PGID"
    grep -vw "^dev" /etc/group > /tmp/fix
    echo "dev:x:$PGID:" >> /tmp/fix
    mv /tmp/fix /etc/group
}
function set_uid
{
    echo "fix PUID=$PUID"
    grep -vw "^dev" /etc/passwd > /tmp/fix
    echo "dev:x:$PUID:$PGID::/home/dev:/bin/bash" >> /tmp/fix
    mv /tmp/fix /etc/passwd
}
function change_owner_dir
{
    if [[ -d "$1" ]];then
        if ! ls "$1" -l | egrep -wq "dev[ ]+dev";then
            chown dev.dev "$1" -R
        fi
    fi
}
function change_owner 
{
    # home
    local dirs=(
        .cache
        .config
        .local
        .ssh
    )
    local dir
    for dir in "${dirs[@]}"; do
        change_owner_dir "/home/dev/$dir"
    done

    find /home/dev -maxdepth 1 -type f,d | while read file
    do
        chown dev.dev "$file"
    done
}

function exec_init 
{
    if [[ "$PUID" == "" ]];then
        PUID=1000
    fi
    if [[ "$PGID" == "" ]];then
        PGID=1000
    fi

    # fix uid gid
    if ! grep -wq "^dev:x:$PGID:" /etc/group;then
        set_gid
    fi
    if ! grep -wq "^dev:x:$PUID:$PGID:" /etc/passwd;then
        set_uid
    fi
    # change owner
    change_owner
}
if [[ "$@" == "default-command" ]];then    
    exec_init
    gosu dev /main.sh
else
    exec_init
    exec "$@"
fi