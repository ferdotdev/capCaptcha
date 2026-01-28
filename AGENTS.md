# AGENTS.md - capCaptcha

## Purpose
This repository is a lightweight wrapper around the upstream `tiago2/cap` Docker image.
There is no application source code here; treat it as ops/configuration only.

## Scope and intent
- This file applies to the entire repo.
- Use the upstream project for application-level changes or tests.
- Keep changes minimal, explicit, and reversible.
- Treat this repository as infrastructure configuration.

## Quick orientation
- `docker/dev/compose.yaml`: Development Docker Compose definition (image `tiago2/cap:latest`).
- `docker/prod/compose.yaml`: Production compose definition (image `tiago2/cap:2.1.4`).
- `docker/dev/.env.example`: Example env values for dev.
- `docker/prod/.env.example`: Example env values for prod.
- `docker/dev/.env`: Local dev secrets (do not commit real credentials).
- `up.sh`: Interactive helper to deploy/down the dev container.
- `README.md`: Minimal repo description.
- `.dockerignore`, `LICENSE`: Standard metadata.

## Runtime access
- App served at `http://localhost:${CAP_PORT}` after container start.
- Admin key uses `ADMIN_KEY`; keep it secret and local.
- Static assets served when `ENABLE_ASSETS_SERVER=true`.
- Data persists in the Docker volume `cap-data`.

## Build / Lint / Test
There are no build, lint, or test scripts in this repo itself.
All build/test workflows live in the upstream `tiago2/cap` project.
Do not add build tooling unless explicitly requested.

### Common commands
- Start dev container (interactive): `./up.sh` then choose `deploy`.
- Stop dev container (interactive): `./up.sh` then choose `down`.
- Start dev container (non-interactive): `docker compose -f docker/dev/compose.yaml up -d`
- Stop dev container (non-interactive): `docker compose -f docker/dev/compose.yaml down`
- Check running services: `docker compose -f docker/dev/compose.yaml ps`
- View logs: `docker logs -f cap`
- Restart container: `docker compose -f docker/dev/compose.yaml restart cap`

### Single test guidance
- There are no tests in this repo; run tests inside the upstream container.
- Start the container before attempting tests.
- Exec into container: `docker exec -it cap sh`
- App path inside container: `/usr/src/app`
- Identify upstream package manager/scripts (check `package.json` or docs).
- Run the upstream test runner from inside the container.
- Typical single-test patterns (only if upstream uses them):
  - `npm test -- path/to/test`
  - `pnpm test --filter <testname>`
  - `yarn test <testname>`
  - `pytest path/to/test.py::test_name`
- If the upstream repo is needed, clone it separately.

## Configuration and environment
- `docker/dev/compose.yaml` defines the `cap` service.
- The container exposes `${CAP_PORT}` on host -> `3000` in the container.
- Env vars: `CAP_PORT`, `ADMIN_KEY`, `ENABLE_ASSETS_SERVER`, `WIDGET_VERSION`, `WASM_VERSION`.
- `.env` files are for local secrets; do not commit real credentials.
- Prefer editing `.env.example` to document new vars.
- Keep `.env` files in sync with compose defaults.

## Change checklist
- Keep `up.sh` pointing at the correct compose file.
- Update `docker/dev/.env.example` and `docker/prod/.env.example` for any new env vars.
- Keep port mappings consistent across docs and compose.
- Confirm volume names match existing data.
- Avoid committing `.env` with secrets.
- Note breaking changes in `README.md`.

## Code style guidelines
There is no application code here. Apply these rules to scripts, YAML, and configs.

### Shell scripts (`.sh`)
- Use `#!/usr/bin/env bash`.
- Keep scripts short and explicit; avoid clever one-liners.
- Quote variables and paths (`"$VAR"`) unless word splitting is intended.
- For non-trivial scripts, use `set -euo pipefail`.
- Prefer long-form flags for readability.
- Use `printf` for predictable output; avoid echo flags.
- Exit non-zero on failure; propagate command errors.
- Avoid interactive prompts in automation; prefer explicit flags or docs.

### YAML / Compose files
- Two-space indentation; never tabs.
- Keep keys ordered logically: `services` -> service -> image/ports/environment/volumes/restart.
- Quote port mappings as strings.
- Use environment variables for secrets; avoid hardcoded values.
- Keep blank lines between top-level sections for readability.
- Avoid YAML anchors/aliases unless they simplify repeated blocks.

### Env files (`.env`, `.env.example`)
- Use `SCREAMING_SNAKE_CASE` for variables.
- Keep comments concise and on their own line.
- Do not commit secret values; use placeholders.
- Avoid spaces around `=` to match existing style.

### Naming conventions
- Container names: short, descriptive (`cap`).
- Volume names: kebab-case or snake_case (`cap-data`).
- Script names: lower-case with dashes if needed (`up.sh`).
- Environment variables: `SCREAMING_SNAKE_CASE`.
- Service names in compose: lower-case.

### Imports and module structure
- This repo does not contain application source code.
- If you add scripts in JS/TS/Python, follow upstream conventions.
- Suggested import order: standard library -> third-party -> local.
- Keep import lists sorted and avoid unused imports.
- Prefer absolute paths only when consistent with upstream.

### Types and data handling
- Prefer explicit types when the language supports them.
- Avoid `any`/dynamic types unless required by upstream.
- Validate external inputs (env vars, CLI args) before use.
- Convert numeric env vars to numbers in code, not in YAML.

### Error handling and safety
- Fail fast in scripts; avoid silent failures.
- Check for required env vars before running dependent commands.
- Guard against missing Docker or compose binaries.
- Avoid destructive Docker commands unless explicitly requested.
- Verify container names and ports before making changes.

### Formatting and tooling
- No formatter or linter is configured in this repo.
- Keep diffs minimal and focused.
- Do not introduce new dependencies or tooling without asking.
- Avoid reformatting unrelated lines.

## Docker-specific guidance
- Prefer `docker compose -f docker/dev/compose.yaml` over default compose.
- Use explicit service names (`cap`) in `docker` commands.
- Do not remove volumes unless asked; they contain data.
- When adding ports, keep mappings explicit (`host:container`).
- Keep volume names stable to avoid data loss.

## Documentation
- Keep README changes brief and factual.
- Document any new environment variables in `.env.example`.
- Mention port or volume changes in `README.md` if you add them.

## Cursor/Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` present.

## When in doubt
- Ask before making structural changes.
- Document assumptions in the PR or final summary.
- For app-level changes, consult the upstream `tiago2/cap` project.
- Prefer conservative operations over destructive ones.
