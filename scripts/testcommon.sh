#!/bin/bash
./prereq.sh

echo Making sure pgrep and pkill are installed.
set -e

pgrep --help >/dev/null
pkill --help >/dev/null

set +e

echo Outputting logs from file-server.

tail -f ~/.pm2/logs/* | $(npm bin)/bunyan -o short &

echo Running tests on local system with mocha.

export NODE_TLS_REJECT_UNAUTHORIZED=0
NODE_TLS_REJECT_UNAUTHORIZED=0 mocha -R spec

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

