#!/bin/bash
./prereq.sh

echo Making sure pgrep and pkill are installed.
set -e

pgrep --help >/dev/null
pkill --help >/dev/null

set +e

echo Making sure submodules are downloaded.
if [ ! -f "serious-backup-device/package.json" ]; then
  echo "No serious-backup-device module found"
  exit 1
fi

if [ ! -f "serious-backup-server/package.json" ]; then
  echo "No serious-backup-server module found"
  exit 1
fi

echo Outputting logs from job-processor and file-server.

tail -f ~/.pm2/logs/* | $(npm bin)/bunyan -o short &

echo Running tests on local system with mocha.

export NODE_TLS_REJECT_UNAUTHORIZED=0
NODE_TLS_REJECT_UNAUTHORIZED=0 mocha -R spec

echo "Killing client backup device server"
pkill -f apiserver.js 

echo "Killing backup server"
pkill -f server.js

pkill -f file-server.js

echo "Stopping job-processor"
pm2 stop job-processor
pkill -f job-processor

pm2 stop file-server
pkill -f file-server

pm2 stop file-server
#pkill -f node

rm ~/.pm2/logs/*

