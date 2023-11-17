#!/bin/sh

token=041e30cd-e1ea-421e-a3f3-fb0105d3ca86
domain=opcc
interval=60
if=br0

cache=/tmp/ddns.cache

while true; do
  ip6=$(ip -6 addr show dev ${if} scope global | grep inet6 | cut -d' ' -f6 | cut -d'/' -f1 | grep -v '^f' | head -n 1)
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
