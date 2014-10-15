#!/bin/bash

echo Need 0mq 3.2 series installed.

if [ $(dpkg-query -W -f='${Status}' nano 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get --force-yes --yes install libzmq3-dev
else
  echo 0mq is installed.
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
git submodule init >/dev/null
git submodule update >/dev/null

cd serious-backup-device && npm install; cd .. > /dev/null
cd serious-backup-server && npm install; cd .. >/dev/null
cd serious-backup-device-sdk && npm install; cd .. >/dev/null

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

echo Starting device server if necessary.

if pgrep -f apiserver.js >/dev/null 2>&1; then
  echo Device backup server is running.
else
  echo Starting device backup server.
  set -e
  cd serious-backup-device && npm start &
  cd ..
  set +e
  echo Waiting a few seconds so backup device server can start.
  sleep 5
fi

if pgrep -f "node server.js" >/dev/null 2>&1; then
  echo "(Cloud) Backup server is running."
else
  echo "Starting (cloud) backup server."
  set -e
  cd serious-backup-server && npm start &
  cd ..
  set +e
  echo Waiting a few seconds so server can start.
  sleep 5
fi

