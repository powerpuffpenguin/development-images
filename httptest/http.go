package main

import (
	"net"
	"net/http"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

type Server struct {
	l                 net.Listener
	handler           http.Handler
	h2c               bool
	certFile, keyFile string
}

func NewHTTP(addr string) (srv *Server, e error) {
	l, e := net.Listen("tcp", addr)
	if e != nil {
		return
	}
	srv = &Server{
		l:       l,
		handler: h2c.NewHandler(getHandler(), &http2.Server{}),
		h2c:     true,
	}
	return
}
func NewHTTPS(addr, certFile, keyFile string) (srv *Server, e error) {
	l, e := net.Listen("tcp", addr)
	if e != nil {
		return
	}
	srv = &Server{
		l:        l,
		handler:  getHandler(),
		certFile: certFile,
		keyFile:  keyFile,
	}
	return
}
func (s *Server) Serve() (e error) {
	if s.h2c {
		e = http.Serve(s.l, s.handler)
	} else {
		e = http.ServeTLS(s.l, s.handler, s.certFile, s.keyFile)
	}
	return
}
