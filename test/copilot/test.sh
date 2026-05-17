#!/bin/bash
set -e

source dev-container-features-test-lib

check "copilot command exists" command -v copilot
check "copilot help" bash -c "copilot --help"

reportResults
