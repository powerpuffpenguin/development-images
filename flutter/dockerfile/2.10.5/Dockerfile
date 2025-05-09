FROM king011/dev:22.04

# 創建開發者用戶
RUN set -eux; \
	useradd -m -U -s /bin/bash dev; \
	echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers;

# 安裝 依賴工具
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends file libglu1-mesa; \
    # linu 桌面開發環境
    apt-get install -y --no-install-recommends clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev; \
    # 中文字體
    apt-get install -y --no-install-recommends ttf-wqy-zenhei ; \
    # android 開發環境
    apt-get install -y --no-install-recommends openjdk-18-jdk; \
    rm -rf /var/lib/apt/lists/*; 

# 安裝 android emulator 依賴
RUN set -eux; \
    apt-get update; \
    # emulator 依賴
    apt-get install -y --no-install-recommends libpulse0; \
    # kvm 
    apt-get install -y --no-install-recommends qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils; \
    rm -rf /var/lib/apt/lists/*; 

# 安裝 android sdkmanager
RUN set -eux;\
    curl -#Lo /latest.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip?hl=zh-tw; \
    mkdir /.android; \
    unzip /latest.zip -d /.android; \
    mv /.android/cmdline-tools /.android/latest; \
    mkdir /.android/cmdline-tools; \
    mv /.android/latest /.android/cmdline-tools/; \
    rm /latest.zip;

# 安裝 android 平臺工具
    RUN set -eux;\
    yes | /.android/cmdline-tools/latest/bin/sdkmanager --install "platform-tools" "platforms;android-29" "build-tools;29.0.2"; \
    yes |  /.android/cmdline-tools/latest/bin/sdkmanager --licenses;

# 更換舊的 jdk，jdk11無法安裝 "build-tools;29.0.2"，但 flutter 2需要 jdk 11 編譯
RUN set -eux; \
    apt-get remove -y openjdk-18-jdk openjdk-18-jdk-headless openjdk-18-jre openjdk-18-jre-headless; \
    apt-get autoremove -y;\
    apt-get update; \
    # android 開發環境
    apt-get install -y --no-install-recommends openjdk-11-jdk; \
    rm -rf /var/lib/apt/lists/*; 

# 設置環境變量
ENV  PATH=$PATH:/opt/flutter/bin:/opt/android/cmdline-tools/latest/bin:/opt/android/emulator:/opt/android/platform-tools \
    ANDROID_SDK_ROOT=/opt/android

# 安裝 AppImage 和 patchelf 用於 linux 打包
RUN set -eux;\
    curl -#Lo /appimagetool-x86_64.AppImage https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage; \
    chmod a+x /appimagetool-x86_64.AppImage; \
    cd / && /appimagetool-x86_64.AppImage --appimage-extract; \
    mv /squashfs-root /opt/appimagetool-x86_64; \
    ln -s /opt/appimagetool-x86_64/AppRun /usr/bin/appimagetool-x86_64; \
    rm /appimagetool-x86_64.AppImage; \
    curl -#Lo /a.tar.gz https://github.com/NixOS/patchelf/releases/download/0.18.0/patchelf-0.18.0-x86_64.tar.gz; \
    mkdir /patchelf; \
    tar -zxvf /a.tar.gz -C /patchelf; \
    mv /patchelf/bin/patchelf /usr/bin/patchelf; \
    rm -rf /patchelf; \
    rm /a.tar.gz

# 安裝 flutter
RUN set -eux; \
    curl -#Lo /a.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.5-stable.tar.xz; \
    gosu dev tar -Jxvf /a.xz -C /home/dev/; \
    mv /home/dev/flutter /opt/flutter; \
    rm /a.xz; \
    # 安裝 flutter
    gosu dev flutter doctor -v; \
    # flutter 代碼提示
    echo 'source <(flutter bash-completion)' >> /home/dev/.bashrc;

# 安裝 code-server 用於代碼編寫
# https://github.com/coder/code-server/releases/latest
RUN set -eux; \
    curl -#Lo /a.tar.gz https://github.com/coder/code-server/releases/download/v4.96.4/code-server-4.96.4-linux-amd64.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/; \
    mv /opt/code-server-4.96.4-linux-amd64 /opt/code-server;\
    rm /a.tar.gz; 

# 安裝 code-server 插件
RUN set -eux; \
    gosu dev /opt/code-server/bin/code-server --install-extension Dart-Code.flutter; 



# code-server 用戶設定
RUN set -eux; \
    echo '{' > /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "files.associations": {' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "*.json": "jsonc",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "*.arb": "json"' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    },' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "editor.formatOnSave": true,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "editor.fontSize": 24,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "workbench.colorTheme": "Default Dark+",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "[dart]": {' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.formatOnSave": true,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.formatOnType": true,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.rulers": [' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '            80' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        ],' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.selectionHighlight": false,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.suggestSelection": "first",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.tabCompletion": "onlySnippets",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '        "editor.wordBasedSuggestions": "off"' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    },' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "remote.autoForwardPortsSource": "hybrid",' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "editor.stickyScroll.enabled": false,' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '    "workbench.tree.enableStickyScroll": false' >> /home/dev/.local/share/code-server/User/settings.json; \
    echo '}' >> /home/dev/.local/share/code-server/User/settings.json; \
    chown dev.dev  /home/dev/.local/share/code-server/User/settings.json; \
    # 備份初始化用戶數據
    mkdir /.data; \
    chown dev.dev /.data; \
    gosu dev cp /home/dev /.data/dev -r;


# 項目根路徑
VOLUME ["/home/dev/project"]
# code-server 默認端口
EXPOSE 80

WORKDIR /home/dev

# 設置環境變量
ENV \
    PATH=$PATH:/opt/android-studio/bin \
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