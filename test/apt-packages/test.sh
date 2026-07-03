#!/bin/bash
set -e

source dev-container-features-test-lib

check "apt-get is on PATH" command -v apt-get

reportResults