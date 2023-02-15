# go

這裏打包了 node 開發環境，使用 code-server 進行代碼編輯

# 初始化

linux 檔案權限要設計到 uid 和 gid，容器創建時創建了一個 dev:dev 用戶它的 uid 和
gid 都是 1000，1000 是 linux 默認的第一個用戶 id。如果你在宿主器上的 uid 和 gid
也是 1000 那麼不會有任何問題。

但是當你在宿主機上 uid gid 不是此值時，你掛接到容器的 project
檔案夾以及容器裏面編寫的代碼可能會因爲各種權限問題導致無法互相訪問。這種情況你需要在初次運行容器時設置
PUID 和 PGID 環境變量，這樣容器也會初次運行時自動將容器中 dev 用戶的 uid/gid
修改爲指定的值，並且將開發使用到的檔案所屬的 uid/gid
也修改正確。這個操作可能會花費幾分鐘
這重要是有要修改的檔案多少決定的，但可以放心這只會執行一次，一旦所有操作成功容器會創建一個
**/etc/init_success_flag_if_not_exists_retry_init**
檔案，重啓容器會因爲這個檔案的存在而跳過初始化工作

# 環境變量

容器提供了一些環境變量，你可以定義它們來改變容器的一些工作細節

| 變量名          | 默認值 | 作用                                                                           |
| --------------- | ------ | ------------------------------------------------------------------------------ |
| PUID            | 1000   | 只在初始化容器時有效，將用戶 id 設置爲此值，並將用戶檔案所有者 id 修改爲此值   |
| PGID            | 1000   | 只在初始化容器時有效，將用戶組 id 設置爲此值，並將用戶檔案所有組 id 修改爲此值 |
| BIND_ADDR       |        | code-server 監聽地址 例如 127.0.0.1:8080 或 127.0.0.1                          |
| BIND_PORT       |        | code-server 監聽端口 例如 8080 這個值會覆蓋 BIND_ADDR 中設定的端口             |
| AUTH            |        | code-server 驗證方式可以是 password 或 none                                    |
| PASSWORD        |        | code-server 使用 password 驗證時的登入密碼                                     |
| HASHED_PASSWORD |        | code-server 使用 password 驗證時的登入密碼的 argon2 hash 值                    |

# Example

[example](example) 檔案夾包含了一個使用本容器進行開發的例子

```
services:
```

上面開了 xray 和 code 兩個容器

- code 用於編寫代碼其被映射到宿主機的 http://127.0.0.1:9000
- xray 用於管理容器內的網路設置透明代理，其管理頁面被 映射到宿主機的
  http://127.0.0.1:9090

如果你沒有在朝鮮這種封鎖網路的地方，你可以不用運行 xray 容器

訪問 https://github.com/zuiwuchang/v2ray-web 了解如何使用 xray 容器
