#!/bin/bash

echo Making sure submodules are installed.
git submodule init >/dev/null
git submodule update >/dev/null

echo The test uses pgrep to check if servers are already running.
echo Verifying this is installed.

sudo apt-get install procps >/dev/null

