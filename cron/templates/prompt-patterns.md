# Cron Prompt Patterns

## Vault health check

```
Run the vault lint checklist:
1. Scan index.md for broken links.
2. Check notes for missing frontmatter fields.
3. Sweep Inbox/ for untagged files.
4. Report violations and repairs, or "Vault lint clean."
```

## Provider availability

```
Probe the configured primary provider with a lightweight request.
If it fails or times out, report the provider name and error.
If healthy, report nothing.
```

## Project state sweep

```
Scan ~/Projects for new or modified top-level folders.
Update projects.md with current state.
Report only if changes detected or errors occur.
```

## Token/cost status

```
Run the token status script. If output indicates degraded quota or errors, surface it.
Otherwise stay silent.
```

## General shape

```
You are a watchdog. Your job is to check ONE thing and report ONLY if it is wrong.
Silent on healthy runs.
One-line summary on failure.
No suggestions, no fixes, no follow-up questions.
```
