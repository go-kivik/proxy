[![Build Status](https://travis-ci.org/go-kivik/proxy.svg?branch=master)](https://travis-ci.org/go-kivik/proxy)  [![GoDoc](https://godoc.org/github.com/go-kivik/proxy?status.svg)](http://godoc.org/github.com/go-kivik/proxy)

# Kivik Proxy

This package provides a CouchDB proxy accessible as a Go
[`http.Handler`](https://golang.org/pkg/net/http/#Handler).

## Example

```go
package main

import (
    "log"

    "github.com/go-kivik/proxy"
)

func main() {
    p, err := proxy.New("http://localhost:5984")
    if err != nil {
        log.Fatal(err)
    }
    s := &http.Server{
        Handler: p,
    }
    log.Fatal(s.ListenAndServe(":8080")) // localhost:5984 now proxied to localhost:8080
}
```

## What license is Kivik released under?

This software is released under the terms of the Apache 2.0 license. See
LICENCE.md, or read the [full license](http://www.apache.org/licenses/LICENSE-2.0).
