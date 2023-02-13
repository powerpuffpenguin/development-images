#!/bin/bash
echo_error(){
    echo -en "\e[31m"
    echo "${@}"
    echo -en "\e[0m"
    exit 1
}

if [ "$API_TOKEN" == "" ];then
    echo_error "API_TOKEN not set"
fi
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '\([^\.]\+\.[^\.]\+\)$')
if [ "$DOMAIN" == "" ];then
    # XXX.xx.yy CERTBOT_DOMAIN 這是一個子域名
    DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\([^\.]\+\.[^\.]\+\)$')
fi
if [ "$DOMAIN" == "" ];then
    echo_error "CERTBOT_DOMAIN invalid"
fi
set -eux
certbot certonly \
    -m "$EMAIL" \
    --agree-tos \
    --preferred-challenges dns \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --manual \
    --manual-auth-hook /scripts/cloudflare_auth.sh \
    --manual-cleanup-hook /scripts/cloudflare_cleanup.sh \
    -d "$CERTBOT_DOMAIN"