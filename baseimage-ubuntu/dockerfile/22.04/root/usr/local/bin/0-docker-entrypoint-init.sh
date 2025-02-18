#!/bin/bash
set -e

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
                        sleep 1
                    done
                done
            ;;
            *)
                local pid
                for file in "${files[@]}";do
                    0-docker-entrypoint-run.sh "$$" "$file" &
                    pid="$pid $!"
                done
                for file in $pid;do
                    wait $file
                done
            ;;
        esac
    fi
}
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
