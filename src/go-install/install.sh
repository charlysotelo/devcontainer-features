#!/usr/bin/env bash
set -eo pipefail

PACKAGES="${PACKAGES:-}"

mapfile -t PACKAGE_LIST < <(printf '%s' "${PACKAGES}" \
    | tr ',' '\n' \
    | sed -E 's/^[[:space:]]+|[[:space:]]+$//g' \
    | sed '/^$/d')

if [ "${#PACKAGE_LIST[@]}" -eq 0 ]; then
    echo "No Go packages requested."
    exit 0
fi

GO_CMD="$(command -v go || true)"
if [ -z "${GO_CMD}" ] && [ -x /usr/local/go/bin/go ]; then
    GO_CMD="/usr/local/go/bin/go"
fi

if [ -z "${GO_CMD}" ]; then
    echo "Go is required to install packages. Add ghcr.io/devcontainers/features/go before this feature." >&2
    exit 1
fi

echo "Installing Go packages: ${PACKAGE_LIST[*]}"
mkdir -p /usr/local/bin
GOBIN=/usr/local/bin "${GO_CMD}" install "${PACKAGE_LIST[@]}"

echo "Done. Installed Go packages: ${PACKAGE_LIST[*]}"