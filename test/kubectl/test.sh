#!/bin/bash
set -e

source dev-container-features-test-lib

check "kubectl is on PATH" command -v kubectl
check "kubectl version" bash -c "kubectl version --client=true"

reportResults