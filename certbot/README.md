# certbot

既然使用瀏覽器寫代碼，https 必不可少

certbot 是 Let's Encrypt 提供的證書驗證工具，官方提供了 docker
容器，但是官網容器沒有提供對通配符域名自動驗證的腳本和工具環境，本喵爲此自己進行了打包

如果使用 code-server 作爲代碼編輯器強烈建議使用打開 https，https
不但更加安全，補齊 code-server 少數功能必須在 https 下才能使用

# cloudflare

tag [cloudflare](https://www.cloudflare.com/) 容器提供了對 cloudflare
管理的域名自動化驗證的腳本

下面是一個申請證書的例子:

- EMAIL: 你的郵箱地址
- API_TOKEN: cloudflare 設置的一個擁有更改 dns 權限的 token
- CERTBOT_DOMAIN: 你要申請證書的域名(比如 abc.com *.abc.com ...)
- /data: 這個檔案夾用於存儲 與 cloudflare 請求的 id
- /etc/letsencrypt: 用於存儲 letsencrypt 的證書信息

```
sudo docker run --rm \
    --name "letsencrypt-auth" \
    -e EMAIL="$EMAIL" \
    -e API_TOKEN="$API_TOKEN" \
    -e CERTBOT_DOMAIN="$2" \
    -v "/data:/data" \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -it  king011/certbot:cloudflare auth.sh
```

下面是續簽證書的例子

```
sudo docker run --rm \
    --name "letsencrypt-auth" \
    -e EMAIL="$EMAIL" \
    -e API_TOKEN="$API_TOKEN" \
    -e CERTBOT_DOMAIN="$2" \
    -v "/data:/data" \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    king011/certbot:cloudflare renew --dry-run
```
