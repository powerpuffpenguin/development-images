# node

這裏打包了 flutter 開發環境，使用 code-server 進行代碼編輯

它可用於開發 android/linux 平臺的程式

# example

```
services:
  code:
    image: king011/dev-flutter:3.16.8
    restart: always
    ports:
      # 訪問 http://127.0.0.1:9090 設置啓動 xray 更新代理等 ...
      - "9090:80/tcp"
      # 訪問 http://127.0.0.1:9000 打開 code-server 進行代碼編寫
      - "9000:8080/tcp"
    devices:
      # 將硬件映射到容器 以便  emulator 可以使用 kvm
       - /dev/kvm:/dev/kvm
    volumes:
      # 如果要使用 usb 調試 android 真實設備
      - /dev/bus:/dev/bus

      # 將 x11 映射，以便運行 gui 程式
      - /tmp/.X11-unix:/tmp/.X11-unix

      # 可選的將 android-studio 安裝到 容器
      - $HOME/volumes/flutter/android-studio:/opt/android-studio

      # 持久化 存儲 android sdk
      - $HOME/volumes/flutter/android:/opt/android
      # 持久化 存儲用戶數據
      - $HOME/volumes/flutter/home:/home/dev

      # 將本地項目目錄 掛接到容器中 
      - ./project:/project
    environment:
      # 設置 X11
      - DISPLAY=$DISPLAY
      - BIND_ADDR=0.0.0.0:8080
      # 設置上密碼驗證，這樣即時你不在自己電腦旁邊也可以打開瀏覽器遠程開發
      - AUTH=password
      # 如果要遠程開發將密碼設置複雜點，並且推薦設置 https，這裏只是演示設置了很簡單的密碼
      - PASSWORD=123
  xray: # xray 容器用於管理網路，設置透明代理，突破朝鮮網路封鎖
    image: king011/xray-webui:v0.0.7
    restart: always
    environment:
     - XRAY_ADDR=:80
    volumes:
      # 存儲代理設定 
      - ./xray:/data
    cap_add: # 設置上這兩個特權才能在容器中使用 iptables 設置透明代理
      - NET_ADMIN
      - NET_RAW
    # 接管 code 的網路
    network_mode: service:code
```

# android emulator

- 對於 linux 宿主機可以直接將 kvm 映射到容器來啓動 android
  emulator，但這無法使用硬件加速，速度會比較慢
- 對於 windows 宿主機，無法在容器中啓用 android emulator

對於這一問題最好的解決方法是在宿主機中啓動 android emulator，容器中建立 tcp
隧道直接在遠程 emulator 中進行調試。

emulator 啓動會創建兩個 tcp 隧道

- 監聽 :5555(默認) 端口供 adb 連接測試
- 向 127.0.0.1:5037(默認) 的 adb 服務註冊自己

所以只需要把宿主機的 127.0.0.1:5037 映射到容器(emulator
向容器中的adb服務註冊)，並把容器的 :5555
端口映射到宿主機(容器adb將連接宿主機的emulator)。

你可以在容器中使用下述指令創建端口映射

```
ssh -N -R 127.0.0.1:5037:127.0.0.1:5037 -L 127.0.0.1:5555:127.0.0.1:5555 Your_Host_User@Your_Host_IP
```

你可以使用下述兩個指令，來驗證 adb 是否識別到了遠程的 emulator

```
# 查詢 android 設備
adb devices

# 查詢 flutter 支持的設備
flutter devices
```
