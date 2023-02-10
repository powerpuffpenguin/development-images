# 3.07G
FROM king011/dev-go-base:22.04

# 3.93G
RUN set -eux; \
    # 安裝 golang
    # 3.53G - 3.07G = 460M
    curl -#Lo /a.tar.gz https://go.dev/dl/go1.19.5.linux-amd64.tar.gz; \
    mkdir /opt/google; \
    tar -zxvf /a.tar.gz -C /opt/google; \
    rm /a.tar.gz; \
	mkdir /opt/google/golib; \
    # 安裝 code-server 用於編寫代碼
    # 3.93G - 3.53G = 400 M
    curl -#Lo /a.tar.gz https://github.com/coder/code-server/releases/download/v4.9.1/code-server-4.9.1-linux-amd64.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/; \
    mv /opt/code-server-4.9.1-linux-amd64 /opt/code-server;\
    rm /a.tar.gz;

# 爲 golang 設置環境變量
ENV GOROOT=/opt/google/go \
    GOPATH=/opt/google/golib \
    PATH=$PATH:/opt/google/go/bin:/opt/google/golib/bin

# 安裝開發用到的庫和工具
RUN set -eux; \
    # jsonnet, googel 開源的 json 的擴展格式很適合作爲配置檔案
    curl -#Lo /a.tar.gz https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz; \
    tar -zxvf /a.tar.gz -C /usr/local/bin; \
    chmod a+x /usr/local/bin/jsonnet; \
    chmod a+x /usr/local/bin/jsonnetfmt; \
    rm /a.tar.gz; \
    # protocol buffer, grpc 依賴
    curl -#Lo /a.zip https://github.com/protocolbuffers/protobuf/releases/download/v21.11/protoc-21.11-linux-x86_64.zip; \
    unzip -d /pb /a.zip;\
    chmod a+x /pb/bin/protoc; \
    cp /pb/bin/protoc /usr/local/bin/; \
    cp /pb/include/google /usr/local/include/ -r; \
    chmod a+rx /usr/local/include -R; \
    chmod a-x /usr/local/include/google/protobuf/*.proto; \
    chmod a-x /usr/local/include/google/protobuf/compiler/*.proto; \
    rm /a.zip; \
    rm /pb -rf; \
    # gateway openapiv2, 自動爲 grpc 生成 http 接口文檔
    curl -#Lo /usr/local/bin/protoc-gen-grpc-gateway https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-grpc-gateway-v2.15.0-linux-x86_64; \
    curl -#Lo /usr/local/bin/protoc-gen-openapiv2 https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v2.15.0/protoc-gen-openapiv2-v2.15.0-linux-x86_64; \
    chmod a+x /usr/local/bin/protoc-gen-grpc-gateway; \
    chmod a+x /usr/local/bin/protoc-gen-openapiv2; \
    # 安裝 vscode 插件
    gosu dev /opt/code-server/bin/code-server --install-extension heptio.Jsonnet; \
    gosu dev /opt/code-server/bin/code-server --install-extension zxh404.vscode-proto3; \
    gosu dev /opt/code-server/bin/code-server --install-extension golang.Go; \
    # golang 開發依賴
    chown dev.dev /opt/google/golib; \
    gosu dev  go install -v github.com/cweill/gotests/gotests@v1.6.0; \
    gosu dev  go install -v github.com/fatih/gomodifytags@v1.16.0; \
    gosu dev  go install -v github.com/josharian/impl@v1.1.0; \
    gosu dev  go install -v github.com/haya14busa/goplay/cmd/goplay@v1.0.0; \
    gosu dev  go install -v github.com/go-delve/delve/cmd/dlv@latest; \
    gosu dev  go install -v honnef.co/go/tools/cmd/staticcheck@latest; \
    gosu dev  go install -v golang.org/x/tools/gopls@latest; \
    # grpc
    gosu dev go install github.com/golang/protobuf/protoc-gen-go@latest; \
    gosu dev go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest; \
    # 刪除安裝緩存
    rm /home/dev/.cache -rf; 

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