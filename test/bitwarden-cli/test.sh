#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "bw on PATH" command -v bw
check "bw version" bw --version

reportResults
