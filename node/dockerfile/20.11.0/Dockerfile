FROM king011/dev:22.04

RUN set -eux; \
    # 創建開發者用戶
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    # 安裝 node
    curl -#Lo /a.tar.xz https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.xz; \
    tar -Jxvf /a.tar.xz -C /opt/; \
    rm /a.tar.xz; \
    mv /opt/node-v20.11.0-linux-x64 /opt/node; \
    # 安裝 code-server 用於編寫代碼
    curl -#Lo /a.tar.gz https://github.com/coder/code-server/releases/download/v4.9.1/code-server-4.9.1-linux-amd64.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/; \
    mv /opt/code-server-4.9.1-linux-amd64 /opt/code-server;\
    rm /a.tar.gz;

# 爲 node 設置環境變量
ENV PATH=$PATH:/opt/node/bin

# typescript
# @angular/cli
# qunit
RUN set -eux; \
    npm install -g npm@10.3.0; \
    npm install -g typescript @angular/cli qunit;

# 爲 code-server 安裝插件
RUN set -eux; \
    gosu dev /opt/code-server/bin/code-server --install-extension Angular.ng-template

# code-server 用戶設定
RUN set -eux; \
    # 設定 angular
    gosu dev ng analytics disable --global; \
    ng completion script > /etc/bash_completion.d/ng; \
    # 設定 code-server
    gosu dev mkdir -p /home/dev/.local/share/code-server/User; \
    echo '{' > /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "jsonnet.outputFormat": "json",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "files.associations": {' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "*.json": "jsonc"' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    },' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "editor.formatOnSave": true,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "editor.fontSize": 24,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "workbench.colorTheme": "Default Dark+"' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '}' >> /home/dev/.local/share/code-server/User/settings.json; \
    chown dev.dev  /home/dev/.local/share/code-server/User/settings.json;

# 項目根路徑
VOLUME ["/home/dev/project"]
# code-server 默認端口
EXPOSE 80

WORKDIR /home/dev

# 設置環境變量
ENV \
	# 開發者用戶 uid
	PUID=1000 \
	# 開發者組 gid
	PGID=1000 \
    # 監聽地址 127.0.0.1:8080
    BIND_ADDR= \
    # 監聽端口 8080，bind 127.0.0.1，這會覆蓋掉 BIND_ADDR 設置的端口
    BIND_PORT= \
    # 網頁驗證方式 [password, none]
    AUTH= \
    # 密碼
    PASSWORD= \
    # argon2 hash 密碼
    HASHED_PASSWORD=

# 啓動腳本
COPY docker-entrypoint.temp /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]