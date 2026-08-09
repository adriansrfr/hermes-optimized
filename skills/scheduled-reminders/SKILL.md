---
name: scheduled-reminders
description: Schedule reminders; local delivery never pings a TUI user.
---

# Scheduled Reminders & Jobs

Use the `cronjob` tool to schedule a reminder or recurring task for the user. The deliverable is a job that actually *reaches* the user at the right time — not one that runs silently and is never seen.

## CRITICAL PITFALL — delivery channel
A `cronjob` with `deliver='local'` (the default when omitted) **saves its output but does NOT notify the user** in a CLI/TUI session. There is no live-delivery channel back into a terminal session. The job runs, output is logged (`cronjob action='list'`), and the user never sees it unless they go looking.

To actually reach the user, set `deliver` to a connected gateway channel:
- `whatsapp`, `telegram`, `discord`, `sms`, or `all` (fans out to every connected channel).
- Platform-targeted form: `telegram:-1001234567890:17585`, `discord:#engineering`.

If no gateway channel is connected, the reminder is effectively silent — confirm the channel before relying on it.

## How to create a reminder
```
cronjob action=create
  name="Human-friendly name"
  schedule="2026-07-28T09:00:00"        # ISO one-shot, or "0 9 * * *" (daily 9am), "30m", "every 2h"
  prompt="Self-contained instructions. No chat context is injected — write it as if to a fresh agent."
  deliver="whatsapp"                      # MUST be a gateway channel to notify
  skills=["obsidian"]                     # optional: skills to load before running the prompt
```
- For one-shot reminders use a single ISO timestamp and `repeat` omitted (defaults to once).
- `prompt` must be self-contained — a cron run has no memory of this conversation.
- Re-route later with `cronjob action=update` + the same `deliver` value.

## Verify the channel is live
You cannot confirm from the agent side whether a gateway channel is actually connected. If unsure, tell the user to check `hermes status` (or their gateway config), and offer to keep a local fallback (note that `local` alone will not ping them).

## Reminder FORMAT rule (best practice)
User preference: reminders should be **actionable checklists, not one-shot pings**:
- The `prompt` MUST open with a `[ ]` checkbox item (or a list of `[ ]` items) representing the thing to do.
- Schedule as **daily repeating** (`"0 19 * * *"` etc.) and let it run **until he marks it complete** — i.e. he tells you to remove the job (`cronjob action=update`/`remove`). Do NOT auto-expire it.
- Rationale: a bare one-shot reminder is "useless at 7pm" if he's not ready; a daily-until-done checkbox keeps it in front of him without re-asking.
- When he says "remind me at X to do Y" (or "tondo this"), interpret as: create a daily `[ ]` TODO at time X, repeat until completed.

## User preference
When the user asks about job state, they want to inspect state, not create a job. ACTION: call `cronjob action=list` and report the relevant job(s) — schedule, next_run_at, last_run_at, enabled/state. Date mismatches between requested and scheduled dates are common; listing jobs surfaces it instead of guessing. Never assume a reminder fired; verify against the job list.
Reminder prompts should account for his **confirmed typos** — e.g. he logs `tondo → todo` in a misspellings file; when a reminder request contains a garbled word, use the corrected form and flag the ambiguity rather than guessing silently.

## User preference
When the user asks about job state, they want to inspect state, not create a job. ACTION: call `cronjob action=list` and report the relevant job(s) — schedule, next_run_at, last_run_at, enabled/state. Date mismatches between requested and scheduled dates are common; listing jobs surfaces it instead of guessing. Never assume a reminder fired; verify against the job list.

## Pitfalls
- `deliver='local'` is silent — always use a gateway channel to actually reach the user.
- Don't auto-expire daily-until-done reminders; he removes them himself.
- A one-shot reminder dated wrong (off-by-a-day) silently misses — verify schedule vs today's date when he questions it.
- **CRON SCHEDULES ARE UTC, NOT LOCAL — off-by-hours delivery bug (recurred across sessions).** Hermes `cronjob` evaluates `"0 19 * * *"` etc. in **UTC**, regardless of the VM's local TZ. If the user is on a non-UTC wall clock, a "7pm" job fires at the UTC hour, which is hours off locally — and looks like "the reminder never fired." This session: `0 19 * * *` fired at **19:00 UTC = 15:00 EDT** (4h early for an Eastern user). FIX: convert local→UTC. For US Eastern, local 7pm EDT (UTC-4) = `0 23 * * *`; in winter EST (UTC-5) it becomes `0 0 * * *`. Always confirm the user's TZ before changing a running job.
- **Setting the VM's OS TZ does NOT fix cron.** `timedatectl set-timezone America/New_York` (or `/etc/localtime` symlink) only changes what `date`/`now` DISPLAY — cron still evaluates in UTC by design. So the schedule fix above is mandatory, not cosmetic. The OS-TZ change is a separate, real clock-display fix (root symlink, or `export TZ=America/New_York` in `~/.bashrc` for no-root shells).
