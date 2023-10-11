#!/bin/bash
set -e

if [[ "$@" == "default-command" ]];then    
    case "$FRP_APP" in
        c|C)
            cd /opt/frp
            gosu frp /opt/frp/frpc -c /opt/frp/frpc.toml
        ;;
        *)
            cd /opt/frp
            gosu frp /opt/frp/frps -c /opt/frp/frps.toml
        ;;
    esac
else
    exec "$@"
fi