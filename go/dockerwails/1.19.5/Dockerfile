FROM king011/dev-go:1.19.5

# 爲 node 設置環境變量
ENV PATH=$PATH:/opt/node/bin

RUN set -eux; \
    # 安裝 node
    curl -#Lo /a.tar.xz https://nodejs.org/dist/v18.14.0/node-v18.14.0-linux-x64.tar.xz; \
    tar -Jxvf /a.tar.xz -C /opt/; \
    rm /a.tar.xz; \
    mv /opt/node-v18.14.0-linux-x64 /opt/node; \
    # 安裝 typescript angular
    npm install -g npm@9.5.1; \
    npm install -g typescript @angular/cli;

# 爲 code-server 安裝插件
RUN set -eux; \
    gosu dev /opt/code-server/bin/code-server --install-extension Angular.ng-template

# 安裝 wails 依賴
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libgtk-3-dev libwebkit2gtk-4.0-dev nsis; \
    rm -rf /var/lib/apt/lists/*; 
# 安裝 wails
RUN set -eux; \
    gosu dev go install github.com/wailsapp/wails/v2/cmd/wails@latest