FROM ubuntu:22.04

# 安裝基礎工具
RUN set -eux; \
    apt-get update; \
    # 基礎工具
    apt-get install -y --no-install-recommends sudo tzdata curl gpg ca-certificates vim; \
    # 中文支持
    apt-get install -y --no-install-recommends fonts-noto-cjk language-pack-zh-hans; \
    rm -rf /var/lib/apt/lists/* ; \
    # 創建用戶
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

# 設置環境變量
ENV PUID=1000 PGID=1000 \
    DISPLAY=:0 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

# 安裝 wine
RUN set -eux; \
    dpkg --add-architecture i386; \
    mkdir -pm755 /etc/apt/keyrings; \
    curl -#Lo /winehq.key https://dl.winehq.org/wine-builds/winehq.key; \
    gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key /winehq.key; \
    rm /winehq.key; \
    curl -#Lo /etc/apt/sources.list.d/winehq-jammy.sources https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources; \
    apt-get update; \
    apt-get install -y --no-install-recommends --install-recommends winehq-stable winbind libgl1-mesa-glx; \
    rm -rf /var/lib/apt/lists/* ;

# 安裝 wine 擴展
RUN set -eux; \
    # https://gitlab.winehq.org/wine/wine/-/wikis/Wine-Mono
    mkdir /usr/share/wine/mono -p; \
    curl -#Lo /usr/share/wine/mono/wine-mono-9.4.0-x86.msi https://dl.winehq.org/wine/wine-mono/9.4.0/wine-mono-9.4.0-x86.msi; \
    # https://gitlab.winehq.org/wine/wine/-/wikis/Gecko
    mkdir /usr/share/wine/gecko -p; \
    curl -#Lo /usr/share/wine/gecko/wine-gecko-2.47.4-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi; \
    curl -#Lo /usr/share/wine/gecko/wine-gecko-2.47.4-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi;

Copy root/ /

WORKDIR /home/dev

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]
