#!/usr/bin/env bash
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
CONFIG="$HERMES_HOME/config.yaml"
JOBS_FILE="$HERMES_HOME/cron/jobs.json"
LOG="$HERMES_HOME/cron/pin-sync.log"

now() { date '+%Y-%m-%d %H:%M:%S'; }
log() { echo "$(now) $*" >> "$LOG"; }

if [[ ! -f "$CONFIG" ]]; then
  log "SKIP: config.yaml missing"
  exit 0
fi

if [[ ! -f "$JOBS_FILE" ]]; then
  log "SKIP: jobs.json missing"
  exit 0
fi

# Resolve current global provider/model from config.yaml
current_provider=$(python3 - "$CONFIG" <<'PY'
import sys, yaml
with open(sys.argv[1]) as f:
    cfg = yaml.safe_load(f) or {}
model = cfg.get("model") or {}
if isinstance(model, dict):
    print(model.get("provider", ""))
else:
    print(cfg.get("provider", ""))
PY
)

current_model=$(python3 - "$CONFIG" <<'PY'
import sys, yaml
with open(sys.argv[1]) as f:
    cfg = yaml.safe_load(f) or {}
model = cfg.get("model") or {}
if isinstance(model, dict):
    print(model.get("default") or model.get("model", ""))
else:
    print(model if isinstance(model, str) else "")
PY
)

current_provider=$(echo "$current_provider" | xargs || true)
current_model=$(echo "$current_model" | xargs || true)

if [[ -z "$current_provider" && -z "$current_model" ]]; then
  log "SKIP: no global model/provider resolved"
  exit 0
fi

# Re-pin any pinned cron jobs whose provider/model differ from global.
updated=0
python3 - "$JOBS_FILE" "$current_provider" "$current_model" <<'PY' | while read -r line; do
import json, sys
from pathlib import Path

jobs_path = Path(sys.argv[1])
current_provider = sys.argv[2] or None
current_model = sys.argv[3] or None

obj = json.loads(jobs_path.read_text())
changed = False

for job in obj.get("jobs", []):
    jid = job.get("id")
    pinned_provider = (job.get("provider") or "").strip() or None
    pinned_model = (job.get("model") or "").strip() or None

    if job.get("no_agent"):
        continue
    if pinned_provider is None and pinned_model is None:
        continue

    updates = {}
    if current_provider and pinned_provider != current_provider:
        updates["provider"] = current_provider
    if current_model and pinned_model != current_model:
        updates["model"] = current_model

    if updates:
        job.update(updates)
        changed = True
        print(f"UPDATE {jid}: {updates}")

if changed:
    jobs_path.write_text(json.dumps(obj, indent=2, ensure_ascii=False) + "\n")
    print("SAVED")
else:
    print("NO_CHANGE")
PY
  log "$line"
  if [[ "$line" == UPDATE* ]]; then
    updated=$((updated + 1))
  fi
done

if [[ $updated -gt 0 ]]; then
  log "UPDATED $updated job(s)"
else
  log "NO_DRIFT"
fi
