#!/bin/bash

if [ ! -d "serious-backup-device" ]; then
  git submodule init >/dev/null
  git submodule update >/dev/null

  echo Running install in serious-backup-device dir
  cd serious-backup-device && npm install; cd .. > /dev/null
  cd serious-backup-device-sdk && npm install; cd .. >/dev/null
fi

echo Making sure submodules are downloaded.
if [ ! -f "serious-backup-device/package.json" ]; then
  echo "No serious-backup-device module found"
  exit 1
fi


if pgrep -f apiserver.js >/dev/null 2>&1; then
  echo Device backup server is running.
else
  echo Starting device backup server.
  export NODE_TLS_REJECT_UNAUTHORIZED=0
  set -e
  cd serious-backup-device && NODE_TLS_REJECT_UNAUTHORIZED=0 npm start &
  set +e
  echo Waiting a few seconds so backup device server can start.
  sleep 5
fi

