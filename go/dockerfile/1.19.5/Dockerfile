# 3.07G
FROM king011/dev-go-base:22.04

# 安裝 golang
# 3.53G - 3.07G = 460M
RUN set -eux; \
	# golang
    curl -#Lo /a.tar.gz https://go.dev/dl/go1.19.5.linux-amd64.tar.gz; \
    mkdir /opt/google; \
    tar -zxvf /a.tar.gz -C /opt/google; \
    rm /a.tar.gz; \
	mkdir /opt/google/golib

# 爲 golang 設置環境變量
ENV GOROOT=/opt/google/go \
    GOPATH=/opt/google/golib \
    PATH=$PATH:/opt/google/go/bin:/opt/google/golib/bin

# 安裝 code-server 用於編寫代碼
# 3.93G - 3.53G = 400 M
RUN set -eux; \
    curl -#Lo /a.tar.gz https://github.com/coder/code-server/releases/download/v4.9.1/code-server-4.9.1-linux-amd64.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/; \
    mv /opt/code-server-4.9.1-linux-amd64 /opt/code-server;\
    rm /a.tar.gz;




# 項目根路徑
VOLUME ["/home/dev/project"]
# code-server 默認端口
EXPOSE 80

WORKDIR /home/dev

# 設置環境變量
ENV \
	# 開發者用戶 uid
	PUID=1000 \
	# 開發者組 gid
	PGID=1000 \
    # 監聽地址 127.0.0.1:8080
    BIND_ADDR= \
    # 監聽端口 8080，bind 127.0.0.1，這會覆蓋掉 BIND_ADDR 設置的端口
    BIND_PORT= \
    # 網頁驗證方式 [password, none]
    AUTH= \
    # 密碼
    PASSWORD= \
    # argon2 hash 密碼
    HASHED_PASSWORD=

# 啓動腳本
COPY docker-entrypoint.temp /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]