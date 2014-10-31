#!/bin/bash

echo Making sure pgrep and pkill are installed.
set -e

pgrep --help >/dev/null
pkill --help >/dev/null

set +e

echo Outputting logs from job-processor and file-server.

tail -f ~/.pm2/logs/* | $(npm bin)/bunyan -o short &

echo Running tests on local system with mocha.

export NODE_TLS_REJECT_UNAUTHORIZED=0
NODE_TLS_REJECT_UNAUTHORIZED=0 mocha -R spec


