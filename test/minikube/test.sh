#!/bin/bash
set -e

source dev-container-features-test-lib

check "minikube is on PATH" command -v minikube
check "minikube version" bash -c "minikube version --short"

reportResults