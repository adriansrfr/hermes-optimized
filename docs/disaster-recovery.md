# Disaster Recovery

This repo is public and contains **no secrets, no personal identifiers, and no private vaults**. This guide covers what *should* be backed up, where, and how to recover when something breaks.

## Scope

Public-safe artifacts:
- `hermes-optimized` repo: config, skills, docs, templates.
- `~/.hermes/skills/`, `~/.hermes/config.yaml`, `~/.hermes/cron/` (if public-safe).

Keep private / never commit here:
- `~/.hermes/.env` — API keys, tokens, provider credentials.
- Private vaults: `~/vimwiki_work/`, `~/vimwiki_health/`, `~/vimwiki_systems/`, etc.
- Personal `SOUL.md`, `MEMORY.md`, `USER.md` files that contain real preferences, paths, machine names, or identities.
- Session data: `~/.hermes/sessions/`, `~/.hermes/logs/`.

## Git hygiene

- Personal Hermes setup: private repo, private remote. Never force-push shared refs.
- Public config/skills repos: push only public-safe content.
- Use branch protection and signed commits if the repo is shared.
- Quick recovery of public-safe config:

```bash
git clone <public-repo-url> ~/hermes-optimized
cp -r skills/* ~/.hermes/skills/
cp config.yaml ~/.hermes/config.yaml
```

## Vault protection

- Do **not** version private vaults in this repo. Use a separate private backup target.
- Preferred cadence: daily incremental, weekly full snapshot.
- Ignore vaults from any Hermes backup scripts; keep them on their own backup plane.

## Hermes state backup

Back up these paths together so a restore is atomic enough to work:
- `~/.hermes/config.yaml`
- `~/.hermes/.env`
- `~/.hermes/skills/`
- `~/.hermes/cron/`
- `~/.hermes/memories/` (only if public-safe)
- `~/.hermes/profiles/*/config.yaml` and skill overrides

Example backup script:

```bash
#!/usr/bin/env bash
set -euo pipefail
BACKUP="$HOME/backups/hermes-$(date +%Y%m%d-%H%M%S).tar.gz"
mkdir -p "$(dirname "$BACKUP")"
tar -czf "$BACKUP" \
  -C "$HOME" .hermes/config.yaml \
  -C "$HOME" .hermes/.env \
  -C "$HOME" .hermes/skills \
  -C "$HOME" .hermes/cron \
  -C "$HOME" .hermes/memories \
  -C "$HOME" .hermes/profiles
echo "Backup written to $BACKUP"
```

Restore:

```bash
tar -xzf backups/hermes-YYYYMMDD-HHMMSS.tar.gz -C "$HOME"
hermes doctor
```

## Trash / soft-delete

Prefer soft-delete over `rm`:
- Desktop: use the system trash (`gio trash` / `trash-cli`).
- Vimwiki / vaults: move to `trash/` within the vault root instead of permanent delete.
- Hermes vault operations: if a skill supports `trash: true`, use it; otherwise copy to a `trash/` folder with a date prefix before cleanup.
- Rule of thumb: anything recoverable within a week should never hit `/dev/null`.

## Hardware / infra

- Single-box failure mode: one disk or VM loss kills config, vaults, and Hermes state together.
- Mitigation:
  - Redundant storage: RAID1/10 for OS and data, or at least separate partitions.
  - Offsite sync: encrypted snapshot to another host or cloud storage on a schedule.
  - Network path: Tailscale or VPN bridge to another node for live fallback.
  - UPS: avoid filesystem corruption on power loss; run clean shutdown on outage.
- Recovery priority order: restore `config.yaml` and `.env` first, then vaults, then skills.

## Disaster test

Run this quarterly:
1. Restore from a backup older than 30 days onto a fresh environment.
2. Run `hermes doctor` — verify config loads, providers connect, skills index.
3. Open a vault and confirm recent files exist and FTS search works.
4. Confirm cron jobs are present and fire on schedule.
5. Verify `.env` secrets are intact but never committed.
6. Document gaps and fix backup script or retention policy.

## Provider outage

If cloud providers are unavailable:
- Local fallback: Ollama with `gemma4:e2b-it-qat` or equivalent lightweight model.
- Free tier catalog: run the `free-model-catalog` skill to enumerate fallback providers.
- Watchdog: a cron job should probe primary provider availability and alert when degraded.
- Manual override: set `HERMES_MODEL` in `.env` or use `hermes chat --model <provider>/<model>`.
