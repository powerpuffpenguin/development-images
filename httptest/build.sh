#!/bin/bash
set -e

cd `dirname $BASH_SOURCE`
export GOOS=linux
export GOARCH=386
export CGO_ENABLED=0
go build -ldflags "-s -w"