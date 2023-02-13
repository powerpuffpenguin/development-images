#!/bin/bash
if [[ "$@" == "auth.sh" ]];then
    exec /scripts/auth.sh
elif [[ "$@" == "bash" ]];then
    exec bash
elif [[ "$@" == "sh" ]];then    
    exec sh
else
    exec certbot "$@"
fi