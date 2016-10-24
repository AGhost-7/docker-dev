#!/usr/bin/env bash

/usr/share/elasticsearch/bin/plugin install appbaseio/mirage

cat >> /usr/share/elasticsearch/config/elasticsearch.yml <<CONFIG
http.port: 9200
http.cors.allow-origin: "http://127.0.0.1:9200"
http.cors.enabled: true
http.cors.allow-headers : X-Requested-With,X-Auth-Token,Content-Type, Content-Length, Authorization
http.cors.allow-credentials: true
CONFIG
