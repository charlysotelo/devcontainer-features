#!/bin/bash
set -e

source dev-container-features-test-lib

check "openpelo is on PATH" command -v openpelo
check "openpelo version" bash -c "cat /opt/openpelo/data/flutter_assets/version.json"
check "openpelo shared libraries resolve" ldd /opt/openpelo/openpelo

reportResults
