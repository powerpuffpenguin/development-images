# dev

這裏爲開發環境 打包了 基礎鏡像

主要是安裝了一些通用的工具和設定

```
apt-get install -y --no-install-recommends \
    gosu \
    tzdata ca-certificates bash-completion net-tools iputils-ping \
    upx zip unzip xz-utils p7zip-full \
    dnsutils vim git \
    sudo proxychains curl wget
```
