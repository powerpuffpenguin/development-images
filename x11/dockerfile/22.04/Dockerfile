FROM ubuntu:22.04

# 安裝必備的基礎工具
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    # net-tools 也是 x11vnc 需要的
    apt-get install -y --no-install-recommends tzdata bash-completion ca-certificates \
        sudo curl \
        upx zip unzip xz-utils p7zip-full \
        vim iputils-ping net-tools; \
    rm -rf /var/lib/apt/lists/* ;

# 安裝虛擬桌面
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends xvfb  x11vnc fluxbox xterm; \
    rm -rf /var/lib/apt/lists/* ;

# 安裝 noVNC
RUN set -eux; \
    curl -#Lo /a.tar.gz https://github.com/novnc/noVNC/archive/refs/tags/v1.5.0.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt; \
    rm /a.tar.gz; \
    mv /opt/noVNC-1.5.0 /opt/noVNC; \
    ln /opt/noVNC/vnc.html /opt/noVNC/index.html -s; \
    rm -rf /opt/noVNC/docs /opt/noVNC/snap /opt/noVNC/tests; \
    curl -#Lo /a.tar.gz https://github.com/powerpuffpenguin/streamf/releases/download/v0.0.7/streamf_linux_amd64.tar.gz; \
    mkdir /opt/streamf; \
    tar -zxvf /a.tar.gz -C /opt/streamf; \
    rm /a.tar.gz; \
    mv /opt/streamf/streamf /usr/local/bin/; \
    rm -rf /opt/streamf;


# 創建用戶
RUN set -eux; \
	useradd -m -U -s /bin/bash abc; \
	echo "abc ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

Copy root/ /

ENV PHOME=/home/abc PUID=1000 PGID=1000 \
    RESTART_INTERVAL_SECOND=5 DISPLAY=:0 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Taipei

WORKDIR /home/abc

ENTRYPOINT ["0-docker-entrypoint-init.sh"]
# CMD ["default-setup"] # 只執行 /etc/init.setup.d 中的配置腳本
# CMD ["default-run"] # 只執行 /etc/init.run.d 中的進程腳本不在返回 非0 時自動重啓
CMD ["default-command"] # default-setup + default-run
