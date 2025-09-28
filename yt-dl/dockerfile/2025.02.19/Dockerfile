FROM ubuntu:22.04

# 安裝必備的基礎工具 和 ffmpeg
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    apt-get install -y --no-install-recommends tzdata ca-certificates \
        sudo curl ffmpeg; \
    rm -rf /var/lib/apt/lists/* ;


# 創建下載用戶 dev 並安裝最新的  yt-dlp
RUN set -eux; \
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    echo 'PATH="/home/dev/.local/bin:$PATH"' >> /home/dev/.bashrc; \
    apt-get update; \
    apt-get install -y --no-install-recommends python3 python3-pip; \
    gosu dev python3 -m pip install -U yt-dlp; \
    rm -rf /var/lib/apt/lists/* ;

# 設置默認環境變量
ENV PUID=1000 PGID=1000 \
    TZ=Asia/Taipei \
    LANE=C.UTF-8 LC_ALL=C.UTF-8

Copy root/ /

# 設置下載目錄，啓動腳本會自動將此目錄所有者修改爲 dev:dev
VOLUME /data
WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sleep"]
