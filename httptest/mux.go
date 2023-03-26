package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func getHandler() (mux *http.ServeMux) {
	mux = http.NewServeMux()
	mux.HandleFunc("/", root)
	mux.HandleFunc("/version", version)
	return
}
func readerJSON(w http.ResponseWriter, r *http.Request, obj any) {
	b, e := json.MarshalIndent(obj, "", "\t")
	if e != nil {
		log.Println(e)
		w.Header().Set(`Content-Type`, `text/plain; charset=utf-8`)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(e.Error()))
		return
	}
	log.Println(r.Method, r.URL.Path, string(b))
	w.Header().Set(`Content-Type`, `application/json`)
	w.Write(b)
}
func version(w http.ResponseWriter, r *http.Request) {
	readerJSON(w, r, map[string]any{
		"platform": fmt.Sprintf(`%s %s %s`,
			runtime.GOOS, runtime.GOARCH,
			runtime.Version(),
		),
		"version": Version,
	})
}
func root(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet && websocket.IsWebSocketUpgrade(r) {
		c, e := upgrader.Upgrade(w, r, nil)
		if e != nil {
			log.Println(e)
			w.Header().Set(`Content-Type`, `text/plain; charset=utf-8`)
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte(e.Error()))
			return
		}
		defer c.Close()
		b0 := make([]byte, 1024*32)
		buffer := bytes.NewBuffer(b0[:0])
		writeMetadata(buffer, r)
		fmt.Print(buffer.String())
		e = c.WriteMessage(websocket.TextMessage, buffer.Bytes())
		if e != nil {
			return
		}
		for {
			t, p, e := c.ReadMessage()
			if e != nil {
				break
			}
			switch t {
			case websocket.TextMessage, websocket.PingMessage, websocket.PongMessage:
				log.Println(`recv:`, t, string(p))
			default:
				log.Println(`recv:`, t, p)
			}
			e = c.WriteMessage(t, p)
			if e != nil {
				break
			}
		}
	} else {
		writer := bufio.NewWriterSize(io.MultiWriter(os.Stdout, w), 1024*32)
		writeMetadata(writer, r)
		writer.Flush()
		if r.Body != nil {
			writer.WriteString("- body: \n")
			io.Copy(writer, r.Body)
			writer.WriteString("\n")
			writer.Flush()
		}
	}
}
func writeMetadata(w io.StringWriter, r *http.Request) {
	w.WriteString(fmt.Sprintln(r.Proto, time.Now()))
	w.WriteString(`- method: ` + r.Method + "\n")
	w.WriteString(`- host: ` + r.Host + "\n")
	w.WriteString(`- url: ` + r.URL.String() + "\n")
	values := r.URL.Query()
	if len(values) != 0 {
		w.WriteString("- query: \n")
		for k, v := range values {
			w.WriteString(fmt.Sprintf("%s=%v\n", k, v))
		}
	}
	header := r.Header
	if len(header) != 0 {
		w.WriteString("- header: \n")
		for k, v := range header {
			w.WriteString(fmt.Sprintf("%s=%v\n", k, v))
		}
	}
}
