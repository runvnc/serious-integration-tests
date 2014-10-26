#!/bin/bash

echo Linux required.
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  echo Linux detected. 
else
  echo uname output is $unamestr.
  echo Linux not found. This system only works on linux, sorry. Exiting.
  exit 2
fi

echo "You need the new 0mq rc version 4.1.0 http://download.zeromq.org/zeromq-4.1.0-rc1.tar.gz and also libsodium https://download.libsodium.org/libsodium/releases/libsodium-1.0.0.tar.gz installed."
echo "Make sure libsodium is installed first, then zeromq."
echo "If you aren't sure please cancel and make sure they are installed."
read input

if [ ! -d "node_modules" ]; then
  npm install
fi

echo Need pm2
if hash pm2 2>/dev/null; then
  echo pm2 found.
else
  echo pm2 not found, installing.
  npm install -g pm2
fi

echo We need mocha to run tests

if hash mocha 2>/dev/null; then
  echo Mocha found.
else
  echo Did not find mocha.
  echo Trying to install mocha.
  npm install -g mocha >/dev/null
fi

echo Making sure submodules are installed.

# check if the folders exist
# if they do then don't do anything

if [ ! -d "serious-backup-device" ]; then
  git submodule init >/dev/null
  git submodule update >/dev/null

  echo Running install in serious-backup-device dir
  cd serious-backup-device && npm install; cd .. > /dev/null
  cd serious-backup-server && npm install; cd .. >/dev/null
  cd serious-backup-device-sdk && npm install; cd .. >/dev/null
fi

echo The test uses pgrep to check if servers are already running.
echo Verifying this is installed.

sudo apt-get install procps >/dev/null

echo Testing for redis running.
if pgrep -f redis-server >/dev/null 2>&1; then
  echo Redis is running.
else
  echo Redis is not running.  Make sure redis is installed and running.
  exit 2
fi

if pgrep -f "node server.js" >/dev/null 2>&1; then
  echo "(Cloud) Backup server is running."
else
  echo "Starting (cloud) backup server."  
  export NODE_TLS_REJECT_UNAUTHORIZED=0
  set -e
  cd serious-backup-server && NODE_TLS_REJECT_UNAUTHORIZED=0 npm start &
  set +e
  echo Waiting a few seconds so server can start.
  sleep 5
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

