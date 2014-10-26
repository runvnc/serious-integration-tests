#!/bin/bash

cp serious-backup-device/config.json serious-backup-device/tmpconfig.json
cp serious-backup-device/localconfig.json serious-backup-device/config.json

scripts/precommon.sh
scripts/predevice.sh
scripts/preserver.sh

scripts/testcommonstart.sh

scripts/testcommonend.sh

cp serious-backup-device/tmpconfig.json serious-backup-device/config.json

