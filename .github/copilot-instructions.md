# Copilot Instructions

This is a personal collection of [Dev Container Features](https://containers.dev/implementors/features/) published under `ghcr.io/charlysotelo/devcontainer-features`.

## Repository Structure

Each feature lives under `src/<feature-name>/` and requires exactly two files:
- `devcontainer-feature.json` — feature metadata (id, version, name, description, options)
- `install.sh` — runs as root inside the container during feature installation

Each feature has a corresponding test at `test/<feature-name>/test.sh`.

## Testing

Tests use the `@devcontainers/cli` test framework. `dev-container-features-test-lib` (providing `check` and `reportResults`) is injected by the CLI at runtime — it is not installed manually.

**Run tests for a single feature:**
```bash
npm install -g @devcontainers/cli
devcontainer features test --skip-scenarios -f <feature-name> -i ubuntu:24.04 .
```

**Run against a specific base image:**
```bash
devcontainer features test --skip-scenarios -f <feature-name> -i ubuntu:22.04 .
```

CI runs against both `ubuntu:22.04` and `ubuntu:24.04` on every push and PR.

## Conventions

**install.sh**
- Always use `set -eo pipefail` (not just `set -e`) so pipe failures like `curl ... | bash` are caught
- Install missing system dependencies (e.g. `curl`) via `apt-get` before using them — base Ubuntu images are minimal
- Scripts run as root; no `sudo` needed

**test.sh**
- Use `check "<label>" <cmd> [args...]` for each assertion
- Always end with `reportResults`
- Keep tests minimal: verify the installed command exists and responds

**devcontainer-feature.json**
- `id` must match the directory name under `src/`
- Reference `ghcr.io/charlysotelo/devcontainer-features/<id>:<major-version>` in usage examples

## Adding a New Feature

1. Create `src/<feature-name>/devcontainer-feature.json` and `install.sh`
2. Create `test/<feature-name>/test.sh`
3. Add the feature to the matrix in `.github/workflows/test.yml`
4. Add a row to the features table in `README.md`
