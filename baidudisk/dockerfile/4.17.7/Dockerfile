FROM ubuntu:22.04

RUN set -eux; \
    apt-get update; \
    # 安裝 gosu
    apt-get install -y --no-install-recommends gosu; \
    # 驗證 gosu 可以正常工作
        gosu --version; \
        gosu nobody true; \
    # 安裝額外工具和依賴
    apt-get install -y --no-install-recommends curl tzdata ca-certificates \
        libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libsecret-1-0 \
        libx11-xcb1 libdrm2 libgbm-dev libasound2;\
    # 安裝中文字體
    apt-get install -y --no-install-recommends ttf-wqy-zenhei; \
    # 刪除緩存
    rm -rf /var/lib/apt/lists/*; \
    # 創建用戶
    useradd -m -U -s /bin/bash dev;

# 安裝 baidudisk
RUN set -eux;\
    curl -#Lo /baidunetdisk.deb https://db215d-704917776.antpcdn.com:19001/b/pkg-ant.baidu.com/issue/netdisk/LinuxGuanjia/4.17.7/baidunetdisk_4.17.7_amd64.deb; \
    dpkg -i /baidunetdisk.deb; \
    rm /baidunetdisk.deb; \
    mkdir -p /data;

Copy root/ /

WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]