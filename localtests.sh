#!/bin/bash
./prereq.sh

echo Making sure pgrep is installed.
set -e

pgrep --help >/dev/null

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

mocha

