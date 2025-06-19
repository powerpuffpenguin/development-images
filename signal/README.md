# signal

在 ubuntu 中打包了 signal

```
docker run -it --rm \
  --name signal \
  --cap-add=SYS_ADMIN \
  -e DISPLAY=$DISPLAY \
  -e TZ=Asia/Taipei \
  -e LANG=zh_TW.UTF-8 \
  -e LC_ALL=zh_TW.UTF-8 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e "USE_PROXY=socks5 127.0.0.1 1080" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /opt/data/signal:/home/dev \
  --network host \
  king011/signal:20250618
```
