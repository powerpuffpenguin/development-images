#!/bin/bash

echo_error(){
    echo -en "\e[31m"
    echo "${@}"
    echo -en "\e[0m"
    exit 1
}
echo_info(){
    echo -en "\e[33m"
    echo "${@}"
    echo -en "\e[0m"
}
# 設置存儲請求的檔案夾路徑
CERTBOT_REQUEST_ID_DIR="/data/id/$CERTBOT_DOMAIN"

# 驗證 api token 已經設定
if [ "$API_TOKEN" == "" ];then
    echo_error "API_TOKEN not set"
fi

# 由 CERTBOT_DOMAIN 獲取 cloudflare 主域名
# CERTBOT_DOMAIN 會由 certbot 設定

# xx.yy CERTBOT_DOMAIN 本身就是主域名
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '\([^\.]\+\.[^\.]\+\)$')
if [ "$DOMAIN" == "" ];then
    # XXX.xx.yy CERTBOT_DOMAIN 這是一個子域名
    DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\([^\.]\+\.[^\.]\+\)$')
fi
if [ "$DOMAIN" == "" ];then
    echo_error "CERTBOT_DOMAIN invalid"
fi

echo_info "domain: $DOMAIN"
echo_info "certbot domain: $CERTBOT_DOMAIN"
echo_info "id dir: $CERTBOT_REQUEST_ID_DIR"

set -e
# 刪除 dns 記錄
if [ -f "$CERTBOT_REQUEST_ID_DIR/ZONE_ID" ];then
    ZONE_ID=$(cat "$CERTBOT_REQUEST_ID_DIR/ZONE_ID")
    if [ -f "$CERTBOT_REQUEST_ID_DIR/RECORD_ID" ]; then
        RECORD_ID=$(cat "$CERTBOT_REQUEST_ID_DIR/RECORD_ID")
        if [[ "$ZONE_ID" != "" && "$RECORD_ID" != "" ]]; then
            curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
                -H "Authorization: Bearer $API_TOKEN" \
                -H "Content-Type: application/json"
        fi
        rm -f "$CERTBOT_REQUEST_ID_DIR/RECORD_ID"
    fi
    rm -f "$CERTBOT_REQUEST_ID_DIR/ZONE_ID"
fi