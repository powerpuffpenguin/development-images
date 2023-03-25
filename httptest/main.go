package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"runtime"
	"time"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

const (
	Version = "v0.0.1"
)

func main() {
	var (
		help                    bool
		addr, certFile, keyFile string
	)
	flag.BoolVar(&help, "help", false, "display help")
	flag.StringVar(&addr, "addr", ":80", "http listen address")
	flag.StringVar(&certFile, "cert", "", "x509 cert file path")
	flag.StringVar(&keyFile, "key", "", "x509 key file path")
	flag.Parse()
	if help {
		flag.PrintDefaults()
		return
	}
	l, e := net.Listen("tcp", addr)
	if e != nil {
		log.Fatalln(e)
	}

	var (
		mux    = http.NewServeMux()
		server http.Server
	)
	mux.HandleFunc("/", root)
	mux.HandleFunc("/version", version)
	if certFile == `` || keyFile == `` {
		log.Println("h2c listen", addr)
		server.Handler = h2c.NewHandler(mux, &http2.Server{})
		e = server.Serve(l)
	} else {
		log.Println("h2 listen", addr)
		server.Handler = mux
		e = server.ServeTLS(l, certFile, keyFile)
	}
	if e != nil {
		log.Fatalln(e)
	}
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
	writer := bufio.NewWriterSize(io.MultiWriter(os.Stdout, w), 1024*32)
	writer.WriteString(fmt.Sprintln(r.Proto, time.Now()))
	writer.WriteString(`- method: ` + r.Method + "\n")
	writer.WriteString(`- host: ` + r.Host + "\n")
	writer.WriteString(`- url: ` + r.URL.String() + "\n")
	values := r.URL.Query()
	if len(values) != 0 {
		writer.WriteString("- query: \n")
		for k, v := range values {
			writer.WriteString(fmt.Sprintf("%s=%v\n", k, v))
		}
	}
	header := r.Header
	if len(header) != 0 {
		writer.WriteString("- header: \n")
		for k, v := range header {
			writer.WriteString(fmt.Sprintf("%s=%v\n", k, v))
		}
	}
	writer.Flush()
	if r.Body != nil {
		writer.WriteString("- body: \n")
		io.Copy(writer, r.Body)
		writer.WriteString("\n")
		writer.Flush()
	}
}
