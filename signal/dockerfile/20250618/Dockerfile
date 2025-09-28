FROM ubuntu:22.04

# 安裝基礎工具
RUN set -eux; \
    apt-get update; \
    # 安裝 gosu
    apt-get install -y --no-install-recommends gosu; \
    # 驗證 gosu 可以正常工作
	gosu nobody true; \
    # 基礎工具
    apt-get install -y --no-install-recommends sudo tzdata curl wget gpg ca-certificates vim proxychains; \
    # 中文支持
    apt-get install -y --no-install-recommends fonts-noto-cjk language-pack-zh-hans language-pack-zh-hant; \
    rm -rf /var/lib/apt/lists/* ; \
    # 創建用戶
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

# 安裝 signal
RUN set -eux; \
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg; \
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null; \
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' >> /etc/apt/sources.list.d/signal-xenial.list;\
    apt update; \
    apt install -y --no-install-recommends signal-desktop; \
    rm -rf /var/lib/apt/lists/* ;

Copy root/ /
RUN set -eux; \
    /tmp/home/init.sh;


# 設置默認環境變量
ENV PUID=1000 PGID=1000 \
    DISPLAY=:0 \
    TZ=Asia/Taipei \
    LANG=zh_TW.UTF-8 \
    LC_ALL=zh_TW.UTF-8 

WORKDIR /home/dev

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]
