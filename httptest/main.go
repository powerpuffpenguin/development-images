package main

import (
	"bufio"
	"crypto/tls"
	"encoding/base64"
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"os"
	"strings"
	"sync"

	"github.com/gorilla/websocket"
)

const (
	Version = "v0.0.1"
)

func main() {
	var (
		help                       bool
		h2c, h2, certFile, keyFile string
		url                        string
	)
	flag.BoolVar(&help, "help", false, "display help")
	flag.StringVar(&h2c, "h2c", "", "listen address and start a h2c server")
	flag.StringVar(&h2, "h2", "", "listen address and start a h2 server")
	flag.StringVar(&certFile, "cert", "test.crt", "x509 cert file path for h2 server")
	flag.StringVar(&keyFile, "key", "test.key", "x509 key file path for h2 server")
	flag.StringVar(&url, "url", "", "use websocket connect url")

	flag.Parse()
	if help {
		flag.PrintDefaults()
		return
	} else if url != `` {
		connect(url)
		return
	}
	var srvs []*Server
	if h2c != `` {
		srv, e := NewHTTP(h2c)
		if e != nil {
			log.Fatalln(e)
		}
		srvs = append(srvs, srv)
		log.Println("h2c listen", h2c)
	}
	if h2 != `` {
		srv, e := NewHTTPS(h2, certFile, keyFile)
		if e != nil {
			log.Fatalln(e)
		}
		srvs = append(srvs, srv)
		log.Println("h2 listen", h2)
	}
	if len(srvs) == 0 {
		flag.PrintDefaults()
		os.Exit(1)
		return
	}
	var wait sync.WaitGroup
	for _, srv := range srvs {
		wait.Add(1)
		go func(s *Server) {
			e := s.Serve()
			if e != nil {
				log.Fatalln(e)
			}
			wait.Done()
		}(srv)
	}
	wait.Wait()
}
func connect(url string) {
	dialer := websocket.Dialer{
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true,
		},
	}
	c, _, e := dialer.Dial(url, nil)
	if e != nil {
		log.Fatalln(e)
	}
	defer c.Close()
	go func() {
		t := websocket.TextMessage
		var send []byte
		r := bufio.NewReader(os.Stdin)
		for {
			s, e := r.ReadString('\n')
			if e != nil {
				break
			}
			s = s[:len(s)-1]
			if s == `help` || s == `h` {
				fmt.Println(`# set send type
# * 1 TextMessage
# * 2 BinaryMessage
# * 8 CloseMessage
# * 9 PingMessage
# * 10 PongMessage
type=1

# send data from text
text=abc
# send data from hex
hex=123456
# send data from hex
base64=abc`)
				continue
			}
			if strings.HasPrefix(s, `type=`) {
				s = s[len(`type=`):]
				switch s {
				case "1":
					t = websocket.TextMessage
					fmt.Println(`change send type to TextMessage`)
				case "2":
					t = websocket.BinaryMessage
					fmt.Println(`change send type to BinaryMessage`)
				case "8":
					t = websocket.CloseMessage
					fmt.Println(`change send type to CloseMessage`)
				case "9":
					t = websocket.PingMessage
					fmt.Println(`change send type to PingMessage`)
				case "10":
					t = websocket.PongMessage
					fmt.Println(`change send type to PongMessage`)
				default:
					fmt.Println(`unknow message type: ` + s)
				}
				continue
			}
			if strings.HasPrefix(s, `hex=`) {
				s = s[len(`hex=`):]
				send, e = hex.DecodeString(s)
				if e != nil {
					fmt.Println(e)
					continue
				}
			} else if strings.HasPrefix(s, `base64=`) {
				s = s[len(`base64=`):]
				if strings.HasSuffix(s, `=`) {
					send, e = base64.StdEncoding.DecodeString(s)
				} else {
					send, e = base64.RawStdEncoding.DecodeString(s)
				}
				if e != nil {
					fmt.Println(e)
					continue
				}
			} else if strings.HasPrefix(s, `text=`) {
				send = []byte(s[len(`text=`):])
			} else {
				fmt.Println(`unknown command, use 'help' or 'h' display help info`)
				continue
			}
			switch t {
			case websocket.TextMessage, websocket.PingMessage, websocket.PongMessage:
				log.Println(`send:`, t, string(send))
			default:
				log.Println(`send:`, t, send)
			}
			e = c.WriteMessage(t, send)
			if e != nil {
				break
			}
		}
	}()
	for {
		t, p, e := c.ReadMessage()
		if e != nil {
			log.Fatalln(e)
		}
		switch t {
		case websocket.TextMessage, websocket.PingMessage, websocket.PongMessage:
			log.Println(`recv:`, t, string(p))
		default:
			log.Println(`recv:`, t, p)
		}
	}
}
