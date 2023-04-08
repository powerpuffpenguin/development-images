# auto

這裏打包了一些腳本運行環境，通常可以使用它們來完成一些自動化的功能

# bash

在 ubuntu 中打包了 bash 腳本常用的工作環境 wget/curl

同時會創建一個 dev 用戶作爲默認的命令執行用戶，它的 uid 和 pid 都是 1000
你可以指定環境變量 來改變 uid/gid
