#!/bin/bash
./prereq.sh

echo Making sure pgrep and pkill are installed.
set -e

pgrep --help >/dev/null
pkill --help >/dev/null

echo Making sure submodules are downloaded.
if [ ! -f "serious-backup-device/package.json" ]; then
  echo "No serious-backup-device module found"
  exit 1
fi

if [ ! -f "serious-backup-server/package.json" ]; then
  echo "No serious-backup-server module found"
  exit 1
fi

echo Running tests on local system with mocha.

export NODE_TLS_REJECT_UNAUTHORIZED=0
NODE_TLS_REJECT_UNAUTHORIZED=0 mocha -R spec

echo "Killing client backup device server"
pkill -f apiserver.js 

echo "Killing backup server"
pkill -f server.js
