#!/bin/bash
set -e

source dev-container-features-test-lib

check "just is on PATH" command -v just
check "just version" bash -c "just --version"

reportResults
