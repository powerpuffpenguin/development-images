# 3.07G
FROM king011/dev-go-base:22.04

# 3.93G
RUN set -eux; \
    # 安裝 code-server 用於編寫代碼
    curl -#Lo /a.tar.gz https://github.com/coder/code-server/releases/download/v4.12.0/code-server-4.12.0-linux-amd64.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/; \
    mv /opt/code-server-4.12.0-linux-amd64 /opt/code-server;\
    rm /a.tar.gz;


# # 安裝開發用到的庫和工具
# RUN set -eux; \
#     # 安裝 vscode 插件
#     gosu dev /opt/code-server/bin/code-server --install-extension heptio.Jsonnet; \
#     gosu dev /opt/code-server/bin/code-server --install-extension zxh404.vscode-proto3; \
#     gosu dev /opt/code-server/bin/code-server --install-extension golang.Go; \
#     # 刪除安裝緩存
#     rm /home/dev/.cache -rf; 

# code-server 用戶設定
RUN set -eux; \
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