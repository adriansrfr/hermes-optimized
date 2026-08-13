# Cron Pin Sync

Re-pin pinned cron jobs to match the current global model/provider from `config.yaml`. Safe to run hourly; silent when there is no drift.

Usage:

```bash
cp cron/templates/cron-pin-sync.sh ~/.hermes/scripts/cron-pin-sync.sh
chmod +x ~/.hermes/scripts/cron-pin-sync.sh

hermes cron action=create \
  name="Sync cron pin drift with global model/provider" \
  schedule="0 * * * *" \
  script="cron-pin-sync.sh" \
  no_agent=true \
  deliver="local"
```

## Behavior

- Reads `HERMES_HOME/config.yaml` for current `model.provider` and `model.default`.
- Reads `HERMES_HOME/cron/jobs.json`.
- Skips `no_agent=true` jobs and jobs with no pinned provider/model.
- Updates only jobs whose pins differ from global.
- Logs to `HERMES_HOME/cron/pin-sync.log`.
- Stdout is empty when nothing changes; prints `UPDATE ...` lines when drift is corrected.

## Public-safe guarantees

- No secrets, no vault paths, no machine names.
- Paths are parameterized via `HERMES_HOME`, defaulting to `~/.hermes`.
