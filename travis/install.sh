#!/bin/bash
set -euC
set -o xtrace

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew install glide
fi

# glide install

function generate {
    go get -u github.com/jteeuwen/go-bindata/...
    go generate $(go list ./... | grep -v /vendor/)
}

function wait_for_server {
    printf "Waiting for $1"
    n=0
    until [ $n -gt 5 ]; do
        curl --output /dev/null --silent --head --fail $1 && break
        printf '.'
        n=$[$n+1]
        sleep 1
    done
    printf "ready!\n"
}

function setup_couch21 {
    if [ "$TRAVIS_OS_NAME" == "osx" ]; then
        return
    fi
    docker pull apache/couchdb:2.1.1
    docker run -d -p 6002:5984 -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=abc123 --name couchdb21 apache/couchdb:2.1.1
    wait_for_server http://localhost:6002/
    curl --silent --fail -o /dev/null -X PUT http://admin:abc123@localhost:6002/_users
    curl --silent --fail -o /dev/null -X PUT http://admin:abc123@localhost:6002/_replicator
    curl --silent --fail -o /dev/null -X PUT http://admin:abc123@localhost:6002/_global_changes
    curl --silent --fail -o /dev/null -X PUT http://admin:abc123@localhost:6002/_node/nonode@nohost/_config/replicator/interval -d '"1000"'
}

case "$1" in
    "standard")
        setup_couch21
        generate
    ;;
    "linter")
        go get -u gopkg.in/alecthomas/gometalinter.v1
        gometalinter.v1 --install
    ;;
    "coverage")
        setup_couch21
        generate
    ;;
esac
