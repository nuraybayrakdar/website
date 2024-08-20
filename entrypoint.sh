#!/bin/bash

# Filebeat'i arka planda çalıştır
filebeat -e -c /etc/filebeat/filebeat.yml &

# Node.js uygulamanızı başlat
npm start
