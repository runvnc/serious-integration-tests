#!/bin/bash

# check if the folders exist
# if they do then don't do anything

if [ ! -d "serious-backup-server" ]; then
  git submodule init >/dev/null
  git submodule update >/dev/null

  echo Running install in serious-backup-device dir
  cd serious-backup-server && npm install; cd .. >/dev/null
fi

if pgrep -f "node server.js" >/dev/null 2>&1; then
  echo "(Cloud) Backup server is running."
else
  echo "Starting (cloud) backup server."  
  export NODE_TLS_REJECT_UNAUTHORIZED=0
  set -e
  cd serious-backup-server && NODE_TLS_REJECT_UNAUTHORIZED=0 ./start.sh &
  set +e
  echo Waiting a few seconds so server can start.
  sleep 5
fi

