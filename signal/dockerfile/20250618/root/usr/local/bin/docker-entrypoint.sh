#!/bin/bash
set -e

init_conf(){
    if [ -f /tmp/signal_init_conf ];then
        return
    fi

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

        chown dev:dev /home/dev
    else
        sudo chown root:root /tmp/fix
        sudo mv /tmp/fix /etc/passwd

        sudo chown dev:dev /home/dev
    fi

    if [ -d /tmp/home/ ];then
        local ifs=$IFS
        IFS="
        "
        local files=(`find /home/dev -maxdepth 1 -type f `)
        IFS=$ifs
        local file
        local name
        for file in "${files[@]}";do
            name=${file##*/}
            if [[ "$name" == "init.sh" ]];then
                continue
            fi
            name="/home/dev/$name"
            if [ ! -f "$name" ];then
                if [ `id -u` = 0 ];then
                    cp "$file" "$name"
                    chown dev:dev "$name"
                else
                    sudo cp "$file" "$name"
                    sudo chown dev:dev "$name"
                fi
            fi
        done
    fi


    if [[ "$USE_PROXY" != "" ]];then
        echo "strict_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
$USE_PROXY" > /tmp/proxychains.conf
        if [ `id -u` = 0 ];then
            mv /tmp/proxychains.conf /etc/proxychains.conf
        else
            sudo chown root:root /tmp/proxychains.conf
            sudo mv /tmp/proxychains.conf /etc/proxychains.conf
        fi
    fi

    touch /tmp/signal_init_conf
}
init_conf
case "$@" in
    default-command)
        if [ `id -u` = 0 ];then
            if [[ "$USE_PROXY" == "" ]];then
                gosu dev signal-desktop
            else
                gosu dev proxychains signal-desktop
            fi
        else
            if [[ "$USE_PROXY" == "" ]];then
                signal-desktop
            else
                proxychains signal-desktop
            fi
        fi
    ;;
    sleep)
        while true; do
            echo "`date`"
            sleep 3600
        done
    ;;
    *)
        exec "$@"
    ;;
esac
