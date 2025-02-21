# yt-dl

在 ubuntu 中打包了 yt-dl ffmpeg 以用於下載 youtube 視頻

```
docker run --rm king011/yt-dl:2025.02.19 yt-dlp --version
```

```
services:
  yt-dl:   
    image: king011/yt-dl:2025.02.19
    environment: 
      # 設置時區
      - TZ=Asia/Taipei
      # 設置下載用戶的 uid gid，這會影響下載檔案所屬的 uid/gid
      - PUID=1000 
      - PGID=1000
    volumes:
      # 設置下載的存儲目錄，啓動腳本會保證對它有寫入權限
      - /opt/data:/data
```

上述 docker compose 會創建一個 yt-dl 環境的容器並一致執行 sleep
以避免容器被關鍵。

建議使用 dev 用戶進入容器執行 yt-dl 下載命令
