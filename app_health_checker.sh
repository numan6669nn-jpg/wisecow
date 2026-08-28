#!/usr/bin/env bash

URL="${1:-http://example.com}"

echo "===== Application Health Check ====="
echo "URL: $URL"
echo "Time: $(date)"
echo

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$URL")

if [[ "$HTTP_STATUS" =~ ^2[0-9][0-9]$ ]]; then
    echo "Application Status: UP"
    echo "HTTP Status Code: $HTTP_STATUS"
    exit 0
else
    echo "Application Status: DOWN"
    echo "HTTP Status Code: $HTTP_STATUS"
    exit 1
fi
