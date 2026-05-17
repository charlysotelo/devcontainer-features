#!/bin/bash
set -e

source dev-container-features-test-lib

check "talosctl is on PATH" command -v talosctl
check "talosctl version" bash -c "talosctl version --client"

reportResults
