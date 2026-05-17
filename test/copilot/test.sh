#!/bin/bash
set -e

source dev-container-features-test-lib

check "gh copilot extension is installed" bash -c "gh extension list | grep -i copilot"
check "gh copilot help" bash -c "gh copilot --help"

reportResults
