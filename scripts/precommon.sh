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

