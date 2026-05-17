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

## Releases & Versioning

Releases are automated via [release-please](https://github.com/googleapis/release-please) in manifest mode. **Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/).**

Each package versions independently:
- `src/copilot` — bumps only when commits touch files under `src/copilot/` or `test/copilot/`
- `src/openpelo` — bumps only when commits touch files under `src/openpelo/` or `test/openpelo/`
- `.` (root) — bumps on any commit to `main`

Common types:
- `fix: ...` → patch bump
- `feat: ...` → minor bump
- `feat!: ...` or `BREAKING CHANGE:` footer → major bump

Use scopes to clarify which feature a commit targets (e.g. `fix(openpelo): ...`), though release-please determines the affected package from the changed file paths, not the scope.

Version files: `version.txt` is the primary version file per package. `devcontainer-feature.json` is kept in sync automatically as an extra-file.

## Adding a New Feature

1. Create `src/<feature-name>/devcontainer-feature.json` and `install.sh`
2. Create `test/<feature-name>/test.sh`
3. Create `src/<feature-name>/version.txt` with initial value `1.0.0`
4. Add a job for the feature in `.github/workflows/test.yml` (copy an existing job, update the feature name and paths-filter entry)
5. Add the feature as a package in `release-please-config.json` and seed its version in `.release-please-manifest.json`
6. Add a row to the features table in `README.md`
