#!/bin/bash
set -e

source dev-container-features-test-lib

check "openpelo is on PATH" command -v openpelo
check "openpelo version" bash -c "cat /opt/openpelo/data/flutter_assets/version.json"
check "openpelo shared libraries resolve" ldd /opt/openpelo/openpelo
check "libEGL present" ldconfig -p | grep libEGL
check "Mesa DRI software renderer present" test -d /usr/lib/x86_64-linux-gnu/dri
check "libGLESv2 present" ldconfig -p | grep libGLESv2

reportResults
