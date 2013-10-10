#!/usr/bin/env bash
solr_responding() {
  url=$1
  echo "Trying to connect to $url"
  curl -o /dev/null $url > /dev/null 2>&1
}

if [ $# -ne 1 ];then
  echo "Usage $0 PORT"
  echo "Where PORT is the port where solr is listening."
  exit 1
fi

port=$1
retries=0
MAX_RETRIES=120
url="http://localhost:$port/solr/admin/ping"

while ! solr_responding $url; do
  retries=$(( $retries + 1 ))
  if [ $retries -gt $MAX_RETRIES ];then
    echo "Sorry solr is not responding. I have tried connecting to $url for $MAX_RETRIES seconds without luck. Exiting..."
    exit 1
  fi
  sleep 1
done

echo "Solr is running on $url"



