# baseimage-ubuntu

這是一個 ubuntu 的基礎鏡像，靈感來自 linuxserver 的
[baseimage-ubuntu](https://github.com/linuxserver/docker-baseimage-ubuntu)，感覺
[baseimage-ubuntu](https://github.com/linuxserver/docker-baseimage-ubuntu)
太大了故本喵精簡了內容並只使用 bash 實現初始化和進程管理

# ENTRYPOINT

ENTRYPOINT 默認被指定爲 0-docker-entrypoint-init.sh，CMD 默認被指定爲
default-command

0-docker-entrypoint-init.sh 實現會依次執行 /etc/init.setup.d
中的腳本，之後會併發加載 /etc/init.run.d 中的腳本

通常子鏡像不需要修改 ENTRYPOINT 和 CMD，在 **etc/init.setup.d**
中放入初始化腳本，在 **/etc/init.run.d** 中放入進程啓動腳本即可

如果你修改了 ENTRYPOINT，可以調用 `0-docker-entrypoint-init.sh default-setup`
來僅執行初始化工作。調用 `0-docker-entrypoint-init.sh default-run`
來跳過初始化直接執行啓動腳本

# 安裝的內容

- **gosu** 用於切換進程用戶
- **tzdata** 支持時區，請設置環境變量 TZ，(例如 TZ=Asia/Shanghai)
- **curl** 方便子鏡像使用 curl 下載套件
- **ca-certificates** 確保 tls 通信正常

# abc

默認創建了一個 abc 用戶 和 組，設置環境變量 PUID 來改變 uid 值，設置環境變量
PGID 來改變 gid 值，設置 PHOME 來設置與 abc 用戶的 HOME 目錄(默認沒有 HOME)
