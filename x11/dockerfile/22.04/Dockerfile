FROM ubuntu:22.04
# # 102M
# RUN set -eux; \
#     apt-get update; \
#     # 安裝 gosu, 80.9M - 77.8M = 3.1 M 
#     apt-get install -y --no-install-recommends gosu; \
#     # 驗證 gosu 可以正常工作
# 	gosu --version; \
# 	gosu nobody true; \
#     # 安裝其它開發和測試工具
#     apt-get install -y --no-install-recommends \
#         # 87.7M - 80.9M = 6.8M, dnsutils 太大沒有打包大概 50m 左右 \
#         tzdata ca-certificates bash-completion net-tools iputils-ping \
#         # 96.2M - 87.7M = 8.5M , p7zip-full 大概有 5M 左右
#         upx zip unzip xz-utils p7zip-full \
#         # 102M - 96.2M = 5.8M, vim(60M) git(66M) 太大 不在此處打包
#         # * sudo 2M
#         # * proxychains 2M
#         # * curl 5M
#         # * wget 2M
#         sudo proxychains curl wget \
#         ; \
#     # 刪除緩存
#     rm -rf /var/lib/apt/lists/* ; \
#     # 配置 proxy
#     grep -v -w '^socks4' /etc/proxychains.conf > /tmp/conf; \
#     echo 'socks5	127.0.0.1	1080' >> /tmp/conf; \
#     mv /tmp/conf /etc/proxychains.conf

# # 創建 命令執行 用戶
# RUN set -eux; \
# 	useradd -m -U -s /bin/bash dev; \
# 	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

# Copy root/ /

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]