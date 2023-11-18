#!/bin/sh

token={YOUR_TOKEN_HERE}
domain={YOUR_DOMAIN_HERE}
interval=60
if=br0

cache=/tmp/ddns.cache

while true; do
  ip6=$(ip -6 addr show dev ${if} scope global | grep inet6 | grep -v secondary | cut -d' ' -f6 | cut -d'/' -f1 | grep -v '^f' | head -n 1)
  if [ "$ip6" != "" ]; then
    if [ ! -e "$cache" ] || [ "$ip6" != "$(cat $cache)" ]; then
      echo "$ip6" > "$cache"
      query="https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=&ipv6=${ip6}"
      result=$(curl -s "$query")
      if [ "$result" != OK ]; then
        echo FAIL
      fi
    fi
  fi
  sleep $interval
done
