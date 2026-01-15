# AGENTS.md — capCaptcha

## Purpose
This repository is a thin wrapper that runs the upstream `tiago2/cap` Docker image. There is no application source code in this repo; you mainly interact with Docker Compose and environment configuration. Treat this as an ops/configuration repo.

## Quick orientation
- `docker/dev/compose.yaml`: Main compose file used by `up.sh`
- `docker/prod/compose.yaml`: Reserved for production compose (currently empty)
- `.env` / `.env.example`: Environment variable placeholders (no code uses them here)
- `up.sh`: Convenience script to start the dev container

## Build / Lint / Test
There are no build, lint, or test scripts in this repo itself. Use the Docker image or upstream project for any actual build/test tooling.

### Common commands
- Start dev container: `./up.sh`
- Equivalent compose command: `docker compose -f docker/dev/compose.yaml up -d`
- Stop dev container: `docker compose -f docker/dev/compose.yaml down`
- View container logs: `docker logs -f cap`

### Single test guidance
- There are no tests in this repo. If you need to run a single test, you must run it inside the `tiago2/cap` container or its upstream repository.
- Example (if you exec into the container): `docker exec -it cap sh`
- Once inside, follow the upstream project’s test docs (not present here).

## Configuration
- `docker/dev/compose.yaml` sets `ADMIN_KEY` and a data volume at `/usr/src/app/.data`.
- Treat `.env` as local-only secrets; do not commit secrets or credentials.
- The `cap` container exposes port `3292` → `3000`.

## Code style guidelines
There is no application code in this repo. Follow these guidance points when editing shell scripts or YAML configs:

### Shell scripts (`.sh`)
- Use `bash` (`#!/bin/bash`) and keep scripts short and explicit.
- Avoid complex inline logic; prefer clarity over cleverness.
- Quote variables and paths unless intentionally relying on word splitting.
- Use `set -euo pipefail` for non-trivial scripts (only if compatible).
- Keep command flags long-form where possible (readability).

### YAML / Compose files
- Two-space indentation, no tabs.
- Keep keys ordered logically: `services` → service name → image/ports/env/volumes/restart.
- Prefer explicit port mappings and volume paths.
- Use environment variables for secrets, not hardcoded values.
- Avoid duplicate keys and ensure valid YAML syntax.

### Naming conventions
- Container names: short and descriptive (e.g., `cap`).
- Volumes: snake-case or kebab-case, consistent with existing (`cap-data`).
- Environment variables: `SCREAMING_SNAKE_CASE`.

### Error handling and safety
- Prefer failing fast in scripts; avoid silent failures.
- Avoid destructive Docker commands unless explicitly requested (e.g., `docker volume rm`).
- Always verify container names and ports before changing them.

## Formatting & tooling
- No formatter configured in this repo.
- Keep file edits minimal and focused.
- Avoid adding new dependencies or tooling unless requested.

## Cursor/Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` files present in this repo.

## When in doubt
- Document any assumptions.
- Ask before making structural changes.
- If you need code-level guidance, consult the upstream `tiago2/cap` project.
