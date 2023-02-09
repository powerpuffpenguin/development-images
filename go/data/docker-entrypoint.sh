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

function change_owner() {
    chown dev.dev /opt/google/golib -R

    # home
    find /home/dev -maxdepth 1 -type f,d | while read file
    do
        chown dev.dev "$file"
    done

    local dirs=(
        .cache
        .config
        .local
        .ssh
    )
    local dir
    for dir in "${dirs[@]}"; do
        if [[ -d "/home/dev/$dir" ]];then
            chown dev.dev "/home/dev/$dir" -R
        fi
    done
}
function exec_serve
{
    local args=(
        gosu dev
        /opt/code-server/bin/code-server
    )

    declare -i i=3
    if [[ "$BIND_ADDR" != "" ]];then
        args[$i]="--bind-addr"
        i=i+1
        args[$i]="$BIND_ADDR"
        i=i+1
    fi
    if [[ "$BIND_PORT" != "" ]];then
        args[$i]="--port"
        i=i+1
        args[$i]="$BIND_PORT"
        i=i+1
    fi
    if [[ "$AUTH" != "" ]];then
        args[$i]="--auth"
        i=i+1
        args[$i]="$AUTH"
        i=i+1
    fi

    "${args[@]}"
}
if [[ "$@" == "default-command" ]];then
    # fix uid gid
    if ! grep -wq "^dev:x:$PGID:" /etc/group;then
        set_gid
    fi
    if ! grep -wq "^dev:x:$PUID:$PGID:" /etc/passwd;then
        set_uid
    fi
    # change owner
    change_owner
    
    exec_serve
else
    exec "$@"
fi