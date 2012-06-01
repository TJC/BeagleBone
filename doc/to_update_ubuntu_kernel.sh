#!/bin/bash
export DIST=precise
export ARCH=armhf
# For BeagleBone:
export BOARD=omap-psp

wget http://rcn-ee.net/deb/${DIST}-${ARCH}/LATEST-${BOARD}
wget $(cat ./LATEST-${BOARD} | grep STABLE | awk '{print $3}')

echo 'Now run this command:'
echo '/bin/bash install-me.sh'
