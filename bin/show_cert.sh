#!/bin/sh
test -z "$1" && echo "Usage $0 [https://]site-name" && exit 1
site_url="$1"
domain_name=$(echo ${site_url} | sed 's#^https://\([^/]\+\)\(/.*\)\?$#\1#g')

echo | openssl s_client -showcerts -servername ${domain_name} -connect ${domain_name}:443 2>/dev/null | openssl x509 -inform pem -noout -text
