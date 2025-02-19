#!/bin/bash
set -e
exec_default_uid_gid(){
    if [ `id -u` = 0 ];then
        grep -vw "^abc" /etc/group > /tmp/fix
        echo "abc:x:$PGID:" >> /tmp/fix
        mv /tmp/fix /etc/group
        grep -vw "^abc" /etc/passwd > /tmp/fix
        echo "abc:x:$PUID:$PGID::$PHOME:/bin/bash" >> /tmp/fix
        mv /tmp/fix /etc/passwd

        if [ "$PHOME" = "" ];then
            return 0
        fi
        if [ -d "$PHOME" ];then
            chown "$PUID:$PGID" "$PHOME"
        else
            mkdir -p "$PHOME"
            chown "$PUID:$PGID" "$PHOME"
        fi
    fi
}
exec_default_step(){
    if [ -d /etc/init.setup.d ];then
        local ifs=$IFS
        IFS="
"
        local files=(`find /etc/init.setup.d/ -maxdepth 1 -type f | sort`)
        IFS=$ifs

        local file
        for file in "${files[@]}";do
            "$file"
        done
    fi
}
exec_default_run(){
    if [ -d /etc/init.run.d ];then
        local ifs=$IFS
        IFS="
"
        local files=(`find /etc/init.run.d/ -maxdepth 1 -type f | sort`)
        IFS=$ifs

        local file
        local i=0
        for file in "${files[@]}";do
            i=$((i+1))
        done
        case $i in
            0)
                return 0
            ;;
            1)
                set +e
                for file in "${files[@]}";do
                    while true; do
                        "$file"
                        if [ "$?" = 0 ];then
                            return
                        fi
                        sleep $RESTART_INTERVAL_SECOND
                    done
                done
            ;;
            *)
                local pid
                local index=0
                for file in "${files[@]}";do
                    index=$((index+1))
                    if [ $index = $i ];then
                        set +e
                        while true; do
                        "$file"
                        if [ "$?" = 0 ];then
                            return
                        fi
                        sleep $RESTART_INTERVAL_SECOND
                    done
                    else
                        0-docker-entrypoint-run.sh "$file" &
                        pid="$pid $!"
                    fi
                done
                for file in $pid;do
                    wait $file
                done
            ;;
        esac
    fi
}
exec_default_uid_gid
case "$@" in
    default-command)
        exec_default_step
        exec_default_run
    ;;
    default-setup)
        exec_default_step
    ;;
    default-run)
        exec_default_run
    ;;
    *)
        exec "$@"
    ;;
esac
