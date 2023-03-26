# httptest

這裏打包了一個 http 服務器，它唯一的用處是將收到的 http 請求返回，這對於調試 envoy 等反向代理很有用

# websocket

此外服務器也支持以 websocket 訪問，服務器會在第一幀返回請求的信息，此後沒幀只是將受到的幀返回

也帶了一個 websocket 客戶端，可以用於測試 websocket，執行 `httptest -url 'ws://xxx'` 就會連接 websocekt 服務器，成功了化可以輸入 `h` 或者 `help` 指令查看具體用法
