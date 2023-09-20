# 63.1M
FROM ubuntu:18.04 
# 92.2M
RUN set -eux; \
    apt-get update; \
    # 安裝 gosu
    apt-get install -y --no-install-recommends gosu; \
    # 驗證 gosu 可以正常工作
	gosu nobody true; \
    # 安裝其它開發和測試工具
    apt-get install -y --no-install-recommends \
        tzdata ca-certificates bash-completion net-tools iputils-ping \
        # p7zip-full 大概有 5M 左右
        upx zip unzip xz-utils p7zip-full \
        # vim(60M) git(66M) 太大 不在此處打包
        # * sudo 2M
        # * proxychains 2M
        # * curl 5M
        # * wget 2M
        sudo proxychains curl wget \
        ; \
    # 刪除緩存
    rm -rf /var/lib/apt/lists/* ; \
    # 配置 proxy
    grep -v -w '^socks4' /etc/proxychains.conf > /tmp/conf; \
    echo 'socks5	127.0.0.1	1080' >> /tmp/conf; \
    mv /tmp/conf /etc/proxychains.conf

# 261M
# 安裝其它幾個常用的大件
# * dnsutils 測試 dns
# * vim 編輯容器中的配置等
# * git 使用容器提交代碼
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends dnsutils vim git openssh-client; \
    rm -rf /var/lib/apt/lists/*