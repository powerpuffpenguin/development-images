#!/bin/bash
set -e

# $1 group name
# $2 device path
function fix_group() {
    if [[ -c "$2" ]];then
        local vals=(`ls "$2" -n`)
        local val=${vals[3]}

        echo "fix gid=$val device=$2"
        grep -vw "^$1" /etc/group > /tmp/fix
        echo "$1:x:$val:dev" >> /tmp/fix
        mv /tmp/fix /etc/group
    fi
}
# $1 dst
# $2 src
function exec_restore {
    local dst="$1"
    local src="$2"

    if [[ ! -d "$dst" ]];then
        mkdir "$dst" -p
    fi
    chown dev:dev "$dst"
    
    local name
    local to
    find "$2" -maxdepth 1 -type f | while read file
    do
        name=${file##*/}
        to="$dst/$name"
        if [[ -f "$to" ]];then
            chown dev:dev "$to"
        else
            gosu dev cp "$file" "$to"
        fi
    done

    find "$2" -maxdepth 1 -type d | while read file
    do
        if [[ "$2" == "$file" ]];then
            continue
        fi
        name=${file##*/}
        to="$dst/$name"
        if [[ -d "$to" ]];then
            chown dev:dev "$to"
        else
            gosu dev cp "$file" "$to" -r
        fi
    done
}

function set_gid
{
    echo "fix PGID=$PGID"
    grep -Ev '^(ubuntu|dev)' /etc/group > /tmp/fix
    echo "dev:x:$PGID:" >> /tmp/fix
    mv /tmp/fix /etc/group
}
function set_uid
{
    echo "fix PUID=$PUID"
    grep -Ev '^(ubuntu|dev)' /etc/passwd > /tmp/fix
    echo "dev:x:$PUID:$PGID::/home/dev:/bin/bash" >> /tmp/fix
    mv /tmp/fix /etc/passwd
}
function change_owner_dir
{
    if [[ -d "$1" ]];then
        if ! ls "$1" -l | egrep -wq "dev[ ]+dev";then
            chown dev:dev "$1" -R
        fi
    fi
}
function change_owner 
{
    # home
    local dirs=(
        .ssh
    )
    local dir
    for dir in "${dirs[@]}"; do
        change_owner_dir "/home/dev/$dir"
    done

    find /home/dev -maxdepth 1 -type f,d | while read file
    do
        chown dev:dev "$file"
    done
    chown dev:dev /opt/flutter -R
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

    exec_restore /opt/android /.android
    exec_restore /home/dev /.data/dev

    # change owner
    change_owner

    fix_group kvm /dev/kvm
    fix_group video /dev/dri/card0
    fix_group video /dev/dri/renderD128

    # set success flag
    touch /etc/init_success_flag_if_not_exists_retry_init
}

if [[ "$@" == "default-command" ]];then    
    exec_init
    if [[ -f /configure/config.yaml ]];then
        gosu dev mkdir /home/dev/.config/code-server -p
        gosu dev cp /configure/config.yaml /home/dev/.config/code-server/config.yaml
    fi
    exec_serve
else
    exec "$@"
fi