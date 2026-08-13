# Cron Templates

This directory contains public-safe cron job templates and patterns for Hermes. Personal job definitions stay local; these are reusable starting points.

## Design principles

- **Silent on success, loud on failure**: watchdog scripts print nothing when healthy; emit a single line when degraded.
- **Self-contained prompts**: cron jobs run in a fresh session with no chat context. Prompts must stand alone.
- **UTC schedules**: Hermes evaluates cron expressions in UTC regardless of VM local time. Convert local→UTC explicitly.
- **Idempotent**: safe to run on schedule without manual cleanup. For repeating tasks, prefer daily until explicitly removed.
- **Public-safe only**: never include API keys, vault paths, machine names, or personal identifiers in committed templates.

## Included templates

- `watchdog.sh` — generic resource watchdog pattern for disk, memory, or custom thresholds
- `prompt-patterns.md` — reusable prompt shapes for vault checks, provider health, and project sweeps

## Usage

```bash
cp cron/templates/watchdog.sh ~/.hermes/scripts/my-watchdog.sh
chmod +x ~/.hermes/scripts/my-watchdog.sh
hermes cron action=create \
  name="My Watchdog" \
  schedule="0 9 * * *" \
  script="my-watchdog.sh" \
  no_agent=true \
  deliver="origin"
```

## Skills

- `scheduled-reminders` — reminder/job creation patterns, delivery rules, UTC pitfalls
- `prompt-engineering` — prompt shapes for cron and subagent runs
