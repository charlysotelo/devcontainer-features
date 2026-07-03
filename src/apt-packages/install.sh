#!/usr/bin/env bash
set -eo pipefail

PACKAGES="${PACKAGES:-}"

mapfile -t PACKAGE_LIST < <(printf '%s' "${PACKAGES}" \
    | tr ',' '\n' \
    | sed -E 's/^[[:space:]]+|[[:space:]]+$//g' \
    | sed '/^$/d')

if [ "${#PACKAGE_LIST[@]}" -eq 0 ]; then
    echo "No apt packages requested."
    exit 0
fi

echo "Installing apt packages: ${PACKAGE_LIST[*]}"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --no-install-recommends "${PACKAGE_LIST[@]}"
rm -rf /var/lib/apt/lists/*

echo "Done. Installed apt packages: ${PACKAGE_LIST[*]}"