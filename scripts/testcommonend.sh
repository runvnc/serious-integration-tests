#!/bin/bash
echo "Killing client backup device server"
pkill -f apiserver.js 

echo "Killing backup server"
pkill -f server.js

pkill -f file-server.js

pm2 stop file-server
pkill -f file-server

pm2 stop file-server
#pkill -f node

rm ~/.pm2/logs/*

