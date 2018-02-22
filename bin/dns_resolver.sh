#!/bin/sh

# Example to follow a DNS change:
# watch -n 5 "dns_resolver.sh www.mydomain.com"

NAME_TO_TEST=$1
DNS_SERVERS="Internal: 127.0.1.1
Google: 8.8.8.8
Quad9: 9.9.9.9
OpenDNS: 208.67.222.222"

echo "${DNS_SERVERS}" | while read line;
do
  name=$(echo $line | cut -d ':' -f 1)
  dns=$(echo $line | cut -d ':' -f 2)
  echo "--- ${name}"
  nslookup ${NAME_TO_TEST} ${dns} | egrep -v "Server:|#53" | egrep "Name:|Address:"
done
