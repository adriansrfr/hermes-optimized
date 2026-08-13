# Generic Watchdog Pattern

Copy into `~/.hermes/scripts/`, rename, and adapt the threshold check.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Config
THRESHOLD="${1:-10}"        # e.g. GB, percent, count
MOUNT_POINT="${2:-/}"       # filesystem to check
LABEL="${3:-resource}"      # human label for alerts

# Check
value=$(df -Pk "$MOUNT_POINT" | awk 'NR==2 {print $4}')
free_gb=$((value / 1024 / 1024))

if [ "$free_gb" -lt "$THRESHOLD" ]; then
  echo "WATCHDOG: ${LABEL} low on ${MOUNT_POINT}: ${free_gb}GB free (threshold ${THRESHOLD}GB)"
fi
```

Usage in Hermes cron:

```bash
hermes cron action=create \
  name="Disk Space Watchdog" \
  schedule="0 9 * * *" \
  script="watchdog.sh" \
  args="10 / disk" \
  no_agent=true \
  deliver="origin"
```

Rules:
- Exit 0 with empty stdout = silent success.
- One-line stdout only when degraded.
- No secrets, no personal paths in committed templates.
