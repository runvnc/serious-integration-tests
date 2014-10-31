#!/bin/bash

rm serious-backup-device/restore/*

cp serious-backup-device/config.json serious-backup-device/tmpconfig.json
cp serious-backup-device/remoteconfig.json serious-backup-device/config.json

scripts/precommon.sh
scripts/predevice.sh

scripts/testcommonstart.sh

scripts/testcommonend.sh

cp serious-backup-device/tmpconfig.json serious-backup-device/config.json

