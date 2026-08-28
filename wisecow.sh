#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 &&
    command -v nc >/dev/null 2>&1 ||
    {
        echo "Install prerequisites."
        exit 1
    }
}

main() {
    prerequisites

    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        mod=$(fortune)

        {
            printf 'HTTP/1.1 200 OK\r\n'
            printf 'Content-Type: text/html; charset=utf-8\r\n'
            printf 'Connection: close\r\n'
            printf '\r\n'
            printf '<pre>\n'
            cowsay "$mod"
            printf '</pre>\n'
        } > "$RSPFILE"

        cat "$RSPFILE" | nc -lN "$SRVPORT"
    done
}

main