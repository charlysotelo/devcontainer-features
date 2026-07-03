#!/bin/bash
set -e

source dev-container-features-test-lib

check "go-install default is a no-op" true

reportResults