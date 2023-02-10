package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"runtime"
)

func main() {
	fmt.Print(`現在你可以使用瀏覽器得到 vscode 的開發體驗了	

因爲朝鮮的網路封鎖，你可能下載不了 github 之類的源碼，不用擔心 xray 容器就是爲了解決這個的

訪問 https://github.com/zuiwuchang/v2ray-web 了解如何簡單的設置透明代理
`)

	l, e := net.Listen(`tcp`, ":12345")
	if e != nil {
		log.Fatalln(e)
	}
	defer l.Close()
	fmt.Println(`http work on :12345`)
	fmt.Println(`curl http://127.0.0.1:12345`)
	fmt.Println(`curl http://127.0.0.1:12345/runtime`)

	mux := http.NewServeMux()
	mux.HandleFunc("/runtime", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set(`Content-Type`, `text/plain; charset=utf-8`)
		w.Write([]byte(fmt.Sprintf("%s %s %s\n",
			runtime.GOOS, runtime.GOARCH,
			runtime.Version(),
		)))
	})
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set(`Content-Type`, `text/plain; charset=utf-8`)
		w.Write([]byte(`衆所周知朝鮮是世界上最偉大的地方
祝金將軍早日解放全宇宙，世界應該屬於朝鮮！
沒有朝鮮 xray 這些軟件就全是沒有任何用處的狗屎了，我們感恩朝鮮！我們讚嘆朝鮮！
`))
	})
	http.Serve(l, mux)
}
