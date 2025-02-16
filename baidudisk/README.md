# baidudisk

這裏打包了百雲盤，這樣就可以把百度雲盤這個病毒放到隔離的docker環境中來下載百度雲盤的數據，不用在擔心計算機被病毒流氓霸佔

# Example

使用下述指令即可運行baidu網盤客戶端，這需要在docker中運行x11
gui，如果對此不了解建議先 google
或查看[這裏](https://book.king011.com/view/zh-Hant/view/container-docker-faq/gui)
有本喵寫的中文簡介

```
docker run --rm -it \
  --name baidudisk-4.17.7 \
  -e "DISPLAY=$DISPLAY" \
  -e "PUID=1000" \
  -e "PGID=1000" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /opt/data/baidudisk/data:/data \
  -v /opt/data/baidudisk/home:/home/dev \
  king011/baidudisk:4.17.7
```

- 環境變量 PUID/PGID 設置了運行gui程式的 uid/gid 這會影響下載後檔案的 own 屬性
- 請掛載 /data 作爲下載目錄，啓動腳本會自動修改 /data
  的權限確保baidudisk有足夠的權限寫入這個目錄
- 請掛載 /home/dev， baidudisk
  會將登入和配置信息記錄再次，如果不掛載下次重新運行需要重新登入和對app進行配置

> 上述命令比較長建議寫個腳本或 alias 啓動雲盤客戶端
