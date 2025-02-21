FROM ubuntu:22.04

# 安裝必備的基礎工具
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    apt-get install -y --no-install-recommends tzdata ca-certificates \
        sudo python3 python3-pip ffmpeg; \
    rm -rf /var/lib/apt/lists/* ;

# 創建用戶 安裝 yt-dlp
RUN set -eux; \
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    gosu dev python3 -m pip install -U yt-dlp; \
    echo 'PATH="/home/dev/.local/bin:$PATH"' >> /home/dev/.bashrc;

Copy root/ /

ENV PUID=1000 PGID=1000 \
    TZ=Asia/Taipei \
    LANE=C.UTF-8 LC_ALL=C.UTF-8

VOLUME /data
WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]
