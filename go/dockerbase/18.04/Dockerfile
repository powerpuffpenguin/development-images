# 261M
FROM king011/dev:18.04 

# 1.15G
# 安裝 gcc 以支持 cgo
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
		# 481M - 271M = 210M
		g++ gcc libc6-dev make pkg-config \
		# 1.61G-0.481G=1.3G，交叉編譯到 windows
		mingw-w64 \
		# gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
		;\
    rm -rf /var/lib/apt/lists/*

# 1.26G
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
		# 1.79G - 1.61G = 180M，交叉編譯到 arm
		gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
		;\
    rm -rf /var/lib/apt/lists/*

# 交叉編譯到 mac
RUN set -eux; \
    curl -#Lo /a.tar.gz https://gitlab.com/king011_docker/golang-data/-/raw/main/1.16.5/osxcross.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt; \
    rm /a.tar.gz;

ENV PATH=$PATH:/opt/osxcross/bin

# 交叉編譯到 mac
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends clang llvm-dev uuid-dev libssl-dev libbz2-dev; \
    rm -rf /var/lib/apt/lists/*; 


# 創建開發者用戶
# 2.18G
RUN set -eux; \
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;