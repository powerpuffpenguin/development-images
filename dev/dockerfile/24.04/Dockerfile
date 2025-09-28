
FROM ubuntu:24.04 

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    apt-get install -y --no-install-recommends \
        tzdata ca-certificates bash-completion net-tools iputils-ping \
        upx zip unzip xz-utils p7zip-full \
        sudo proxychains curl wget \
        dnsutils vim git openssh-client \
        ; \
    rm -rf /var/lib/apt/lists/* ; \
    grep -v -w '^socks4' /etc/proxychains.conf > /tmp/conf; \
    echo 'socks5	127.0.0.1	1080' >> /tmp/conf; \
    mv /tmp/conf /etc/proxychains.conf
