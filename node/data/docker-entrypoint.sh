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
function exec_serve
{
    local args=(
        gosu dev
        /opt/code-server/bin/code-server --disable-update-check
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

    exec "${args[@]}"
}
function exec_init 
{
    if [[ -f /etc/init_success_flag_if_not_exists_retry_init ]];then
        # has been executed and is not being executed 
        return 0
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

    # set success flag
    touch /etc/init_success_flag_if_not_exists_retry_init
}
if [[ "$@" == "default-command" ]];then    
    exec_init
    exec_serve
else
    exec "$@"
fi