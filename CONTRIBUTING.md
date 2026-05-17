# Contributing

## Commit Messages

This repo uses [Conventional Commits](https://www.conventionalcommits.org/). Every commit to `main` must follow the format:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | When to use | Version bump |
|------|-------------|--------------|
| `fix` | Bug fix in a feature's install or behavior | Patch (`1.0.x`) |
| `feat` | New capability added to a feature | Minor (`1.x.0`) |
| `feat!` / `BREAKING CHANGE:` | Incompatible change (e.g. renamed binary, removed option) | Major (`x.0.0`) |
| `chore` | Maintenance, CI, docs, tooling | None |
| `refactor` | Code restructuring with no behavior change | None |

### Scopes

Use the feature name as the scope to make it clear which component a commit affects:

```
fix(openpelo): install curl before downloading release
feat(copilot): add version option to pin a specific release
chore: update CI matrix base images
```

The scope is optional but encouraged. Release-please determines which packages to version based on which **files changed**, not the scope — but scopes keep the changelog readable.

## How Releases Work

Releases are fully automated via [release-please](https://github.com/googleapis/release-please).

1. **Push conventional commits to `main`** — release-please opens a Release PR with bumped versions and a generated changelog.
2. **Review and merge the Release PR** — release-please creates the GitHub release and tag.

Each feature (`src/copilot`, `src/openpelo`) versions independently. A commit that only touches `src/openpelo/` will only bump the `openpelo` version. The root repo version bumps whenever any releasable commit lands.

Version files updated automatically on release:
- `version.txt` — primary version file per package
- `src/<feature>/devcontainer-feature.json` — kept in sync via release-please `extra-files`

You should **never manually edit** `version.txt`, `devcontainer-feature.json` versions, or `.release-please-manifest.json`.

## Adding a New Feature

See the checklist in [`.github/copilot-instructions.md`](.github/copilot-instructions.md).

Every new feature must be registered in **5 places**:

### 1. Feature files (required by devcontainers spec)

```
src/<feature-name>/devcontainer-feature.json   # metadata
src/<feature-name>/install.sh                  # install logic (chmod +x)
src/<feature-name>/version.txt                 # initial value: 1.0.0
test/<feature-name>/test.sh                    # at minimum: check binary, reportResults
```

### 2. `.github/workflows/test.yml` — two spots

Add a filter entry under `dorny/paths-filter`:
```yaml
<feature-name>:
  - 'src/<feature-name>/**'
  - 'test/<feature-name>/**'
```

Add the name to the `workflow_dispatch` hardcoded array:
```yaml
echo 'features=["copilot","openpelo","<feature-name>"]' >> $GITHUB_OUTPUT
```

### 3. `release-please-config.json`

Add a package entry so release-please tracks and versions it:
```json
"src/<feature-name>": {
  "release-type": "simple",
  "component": "<feature-name>",
  "changelog-path": "src/<feature-name>/CHANGELOG.md",
  "extra-files": [
    {
      "type": "json",
      "path": "src/<feature-name>/devcontainer-feature.json",
      "jsonpath": "$.version"
    }
  ]
}
```

### 4. `.release-please-manifest.json`

Seed the initial version:
```json
"src/<feature-name>": "1.0.0"
```

### 5. Bootstrap GitHub release (one-time)

Create an initial release so release-please has a baseline and doesn't scan the full commit history:
```bash
gh release create <feature-name>-v1.0.0 --title "<feature-name> v1.0.0" --notes "Initial release" --target main
```

### 6. `README.md`

Add a row to the features table.

## Testing

```bash
npm install -g @devcontainers/cli

# Test a single feature
devcontainer features test --skip-scenarios -f <feature-name> -i ubuntu:24.04 .
```

CI runs automatically on pull requests for any feature whose files changed.
