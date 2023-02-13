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
echo_success(){
    echo -en "\e[32m"
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
# 刪除 dns 記錄，以免存在多條歷史記錄導致驗證失敗
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

# 獲取 zone id
ZONE_EXTRA_PARAMS="status=active&page=1&per_page=20&order=status&direction=desc&match=all"
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN&$ZONE_EXTRA_PARAMS" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type:application/json" | python -c "import sys,json;print(json.load(sys.stdin)['result'][0]['id'])")
if [ ! -n "${ZONE_ID}" ]; then
    echo_error "GET ZONE ID FAIL"
fi
echo_info "zone id: $ZONE_ID"

# 添加 dns 記錄
# CERTBOT_VALIDATION 會由 certbot 設定
RECORD_NAME="_acme-challenge.$CERTBOT_DOMAIN"
echo_info "dns name: $RECORD_NAME"
echo_info "dns content: $CERTBOT_VALIDATION"
RECORD_ID=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H     "Content-Type: application/json" \
    --data '{"type":"TXT","name":"'"$RECORD_NAME"'","content":"'"$CERTBOT_VALIDATION"'","ttl":120}' \
            | python -c "import sys,json;print(json.load(sys.stdin)['result']['id'])")
if [ ! -n "${RECORD_ID}" ]; then
    echo_error "SET DNS FAIL"
fi
echo_info "record id: $RECORD_ID"

# 記錄 id，以便後續刪除 dns 記錄
mkdir -m 0700 "$CERTBOT_REQUEST_ID_DIR" -p
echo $RECORD_ID > "$CERTBOT_REQUEST_ID_DIR/RECORD_ID"
echo $ZONE_ID > "$CERTBOT_REQUEST_ID_DIR/ZONE_ID"

echo_success "dns success"
# 等待一會兒以便 dns 更改能夠有足夠的傳播時間
sleep 130