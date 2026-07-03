#!/bin/bash
set -e

source dev-container-features-test-lib

check "protoc is on PATH" command -v protoc
check "protoc version" bash -c "protoc --version"

reportResults