#!/bin/bash
set -e

source dev-container-features-test-lib

check_installs_packages_separately() {
	tmpdir="$(mktemp -d)"
	trap 'rm -rf "${tmpdir}"' RETURN

	cat > "${tmpdir}/go" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${GO_INSTALL_LOG}"
EOF
	chmod +x "${tmpdir}/go"

	GO_INSTALL_LOG="${tmpdir}/go-install.log" \
		PATH="${tmpdir}:${PATH}" \
		PACKAGES="example.com/one/cmd/one@latest, example.com/two/cmd/two@v1.2.3" \
		bash .devcontainer/go-install/install.sh

	diff -u - "${tmpdir}/go-install.log" <<'EOF'
install example.com/one/cmd/one@latest
install example.com/two/cmd/two@v1.2.3
EOF
}

check "go-install default is a no-op" true
check "go-install installs package specs separately" check_installs_packages_separately

reportResults