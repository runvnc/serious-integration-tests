#!/bin/bash

echo We need mocha to run tests

if hash mocha 2>/dev/null; then
  echo Mocha found.
else
  echo Did not find mocha.
  echo Trying to install mocha.
  npm install -g mocha >/dev/null
fi

echo Making sure submodules are installed.
git submodule init >/dev/null
git submodule update >/dev/null
cd serious-backup-device && npm install; cd .. > /dev/null
cd serious-backup-server && npm install; cd .. >/dev/null
cd serious-backup-device-sdk && npm install; cd .. >/dev/null

echo The test uses pgrep to check if servers are already running.
echo Verifying this is installed.

sudo apt-get install procps >/dev/null

