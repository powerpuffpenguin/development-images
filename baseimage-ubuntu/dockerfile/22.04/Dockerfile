FROM ubuntu:22.04

RUN set -eux; \
    apt-get update; \
    # 安裝 gosu
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    # 安裝基本工具
    apt-get install -y --no-install-recommends tzdata ca-certificates curl; \
    # 刪除緩存
    rm -rf /var/lib/apt/lists/* ; \
    # 命令執行 用戶
    useradd -m -U -s /bin/bash abc;

Copy root/ /

ENTRYPOINT ["0-docker-entrypoint-init.sh"]
# CMD ["default-setup"] # 只執行 /etc/init.setup.d 中的配置腳本
# CMD ["default-run"] # 只執行 /etc/init.run.d 中的進程腳本不在返回 非0 時自動重啓
CMD ["default-command"] # default-setup + default-run