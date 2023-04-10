# httptest

這裏打包了一個 http 服務器，它唯一的用處是將收到的 http 請求返回，這對於調試
envoy 等反向代理很有用

# websocket

此外服務器也支持以 websocket
訪問，服務器會在第一幀返回請求的信息，此後沒幀只是將受到的幀返回

也帶了一個 websocket 客戶端，可以用於測試 websocket，執行
`httptest -url 'ws://xxx'` 就會連接 websocekt 服務器，成功了化可以輸入 `h` 或者
`help` 指令查看具體用法

# docker

容器會 80 端口開一個支持 h2c 的 http 服務器，在 443 端口開一個支持 h2 的 https
服務器

```
sudo docker run --name httptest --rm \
    -p 8000:80 \
    -p 8443:443 \
    -d king011/httptest:0.0.1
```

https 使用的證書是自簽名的，你可以使用自己的證書進行替換

```
sudo docker run --name httptest --rm \
    -v Your_X509_CRT:/test.crt:ro \
    -v Your_X509_KEY:/test.key:ro \
    -p 8000:80 \
    -p 8443:443 \
    -d king011/httptest:0.0.1
```
