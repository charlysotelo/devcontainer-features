#!/bin/bash
set -e

source dev-container-features-test-lib

check "helmfile is on PATH" command -v helmfile
check "helmfile version" bash -c "helmfile --version"

reportResults
