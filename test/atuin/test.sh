#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "atuin on PATH" command -v atuin
check "atuin version" atuin --version

reportResults
