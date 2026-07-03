#!/bin/bash
set -e

source dev-container-features-test-lib

check "kustomize is on PATH" command -v kustomize
check "kustomize version" bash -c "kustomize version"

reportResults