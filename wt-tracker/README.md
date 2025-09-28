# wt-tracker

這裏打包了 wt-tracker 以方便使用 docker 進行部署

# Example

請將
[config.json](https://github.com/Novage/wt-tracker/blob/main/sample/config.json)
修改爲實際的設定

```
services:
  tracker:
    image: king011/wt-tracker:20250514
    restart: always
    ports:
      - 80:80/tcp
    volumes:
      - ./config.json:/app/config.json:ro
```
