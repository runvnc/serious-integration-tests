#!/bin/bash

echo 127.0.0.1 >serious-backup-server/myipaddress

cp serious-backup-device/config.json serious-backup-device/tmpconfig.json
cp serious-backup-device/localconfig.json serious-backup-device/config.json

scripts/precommon.sh
scripts/preserver.sh
scripts/predevice.sh

scripts/testcommonstart.sh

scripts/testcommonend.sh

cp serious-backup-device/tmpconfig.json serious-backup-device/config.json

