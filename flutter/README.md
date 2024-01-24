# flutter

[github](https://github.com/powerpuffpenguin/development-images/tree/main/flutter)

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
      - ./project:/home/dev/project
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
- 對於 windows 宿主機，無法在容器中使用 android emulator

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

# streamf

除了使用 ssh 映射容器和宿主機也可以使用
[streamf](https://github.com/powerpuffpenguin/streamf)
來映射，它是一個強大靈活的 stream 轉發工具。如果 emulator 運行在 windwos
或遠程服務器上，使用 streamf 可能會比 ssh 更加容易

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
      - ./project:/home/dev/project
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
  streamf:
    image: king011/streamf:v0.0.2
    restart: always
    volumes:
      - ./streamf.jsonnet:/data/streamf.jsonnet:ro
    network_mode: service:code
  host:
    image: king011/streamf:v0.0.2
    restart: always
    volumes:
      - ./host.jsonnet:/data/streamf.jsonnet:ro
    network_mode: host
    depends_on:
      - streamf
```

streamf 使用 service:code 的網路，它用於在容器中創建 tcp 隧道 streamf.jsonnet
定義了它的行爲

```
local ports = std.range(5552, 5555);
local timeout = '1s';
{
  logger: {
    level: 'info',
    source: false,
  },
  pool: {
    size: 1024 * 32,
    cache: 128,
  },
  dialer: [
    {
      tag: 'dialer_android',
      timeout: timeout,
      url: 'basic://',
      network: 'pipe',
      addr: 'pipe-l/android.socket',
      retry: 2,
    },
    {
      tag: 'dialer_adb',
      timeout: timeout,
      url: 'basic://127.0.0.1:5037',
      retry: 2,
    },
  ] + [
    {
      tag: 'dialer_emulator_' + port,
      timeout: timeout,
      url: 'basic://',
      network: 'portal',
      addr: 'portal_' + port,
    }
    for port in ports
  ],
  listener: [
    {
      network: 'tcp',
      addr: ':8000',
      mode: 'http',
      router: [
        {
          method: 'WS',
          pattern: '/dev/android',
          access: 'any token, but listener and dialer must matched. allow empty too.',
          dialer: {
            tag: 'dialer_android',
            close: '1s',
          },
        },
      ],
    },
  ] + [
    {
      network: 'pipe',
      addr: 'pipe-l/android.socket',
      mode: 'http',
      router: [
        {
          method: 'POST',
          pattern: '/adb',
          dialer: {
            tag: 'dialer_adb',
            close: '1s',
          },
        },
      ] + [
        {
          method: 'POST',
          pattern: '/emulator/' + port,
          portal: {
            tag: 'portal_' + port,
            timeout: timeout,
            heart: '40s',
            heartTimeout: '1s',
          },
        }
        for port in ports
      ],
    },
  ] + [
    {
      network: 'tcp',
      addr: ':' + port,
      dialer: {
        tag: 'dialer_emulator_' + port,
        close: '1s',
      },
    }
    for port in ports
  ],
}
```

host 例子中使用了宿主機的網路，如果 emulator 不在宿主機(遠程運行
emulator)或宿主機是 windwos 則可以刪除 host 容器，但需要在運行 emulator
的機器上使用 host.jsonnet 運行 streamf 以建立 tcp 隧道。host.jsonnet 定義如下

```
local ports = std.range(5552, 5555);
local timeout = '1s';
local addr = '10.89.1.20:8000';
{
  logger: {
    level: 'info',
    source: false,
  },
  pool: {
    size: 1024 * 32,
    cache: 128,
  },
  dialer: [
    {
      tag: 'dialer_android',
      timeout: timeout,
      url: 'ws://' + addr + '/dev/android',
      access: 'any token, but listener and dialer must matched. allow empty too.',
      retry: 2,
    },
    {
      tag: 'dialer_adb',
      timeout: timeout,
      url: 'http://abc.com/adb',
      method: 'POST',
      network: 'pipe',
      addr: 'pip-c/android.socket',
      retry: 2,
    },
  ] + [
    {
      tag: 'emulator_' + port,
      timeout: timeout,
      url: 'basic://127.0.0.1:' + port,
      retry: 2,
    }
    for port in ports
  ],
  bridge: [
    {
      timeout: timeout,
      url: 'http://abc.com/emulator/' + port,
      method: 'POST',
      network: 'pipe',
      addr: 'pip-c/android.socket',
      dialer: {
        tag: 'emulator_' + port,
        close: '1s',
      },
    }
    for port in ports
  ],
  listener: [
    {
      network: 'pipe',
      addr: 'pip-c/android.socket',
      dialer: {
        tag: 'dialer_android',
        close: '1s',
      },
    },
    {
      network: 'tcp',
      addr: ':5037',
      dialer: {
        tag: 'dialer_adb',
        close: '1s',
      },
    },
  ],
}
```

> baseURL 應該依據你的真實情況修改爲連接 streamf 容器的 ip
