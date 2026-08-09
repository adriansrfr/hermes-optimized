---
name: prompt-engineering
description: Write effective agent, subagent, and cron prompts.
---

# Prompt Engineering

Apply these patterns when writing prompts for subagents, cron jobs, reviewers,
fixers, and any LLM-driven task. Goal: reliable first-pass results, minimal retries,
deterministic outputs.

## User preferences (enforce these automatically)

- **Skills over memory for reusable patterns.** Memory is for facts/state; skills
  are for procedures. Memory injects every turn (no lazy loading); skills load
  on demand. Always prefer a skill when the content is a "how to" or a reusable
  workflow.
- **Automate when possible.** If a check or standard can be wired into an existing
  skill's `skills:` frontmatter list, do that instead of asking the user to
  request it manually. The user expects enforcement to happen automatically
  during normal workflows (review, scaffolding).

## 1. Single Responsibility per Prompt

One prompt = one job. If a task needs both data collection and analysis, split it
into two chained cron jobs or two sequential subagent calls.

**Bad:**
```python
delegate_task(goal="Fetch the repo, run tests, summarize coverage, and draft a fix.")
```

**Good:**
```python
# Step 1: data collection
delegate_task(goal="Run pytest in /path and return ONLY the failure count and failing test names.")
# Step 2: analysis
delegate_task(goal="Given these failing tests: [list], identify root cause categories.")
# Step 3: fix
delegate_task(goal="Fix only issue #3 from the analysis. Do not refactor.")
```

## 2. Explicit Success Signal

Every prompt must define what "done" looks like. Without it, the agent improvises.

- **Subagent goals:** "Return ONLY valid JSON with keys X, Y, Z."
- **Cron prompts:** "If stdout is empty, send nothing. If non-empty, send verbatim."
- **Review prompts:** "Set passed=false if ANY item in list is non-empty."

Avoid vague success signals like "be thorough" or "handle edge cases."

## 3. Fail-Closed Defaults

When the agent cannot parse or complete a task, the default outcome must be failure,
not silent success or improvisation.

```python
# Bad: silent success on parse failure
result = reviewer.return_json or {}
passed = result.get("passed", True)

# Good: fail-closed
try:
    result = json.loads(reviewer_output)
except json.JSONDecodeError:
    result = {"passed": False, "logic_errors": ["Reviewer returned non-JSON."]}
```

For reviewer subagents: if the diff is unparseable, passed must be false.

## 4. Deterministic Output Shape

Specify the exact output format. Free-form text invites retries.

- **JSON only:** "Return ONLY this JSON: { ... }"
- **Delimited text:** "Return lines as NAME: VALUE, one per line."
- **Verbose vs silent:** "If nothing to report, return the literal string NOTHING_TO_REPORT."

Don't ask for a "summary" and then complain it's too long or too short.

## 5. Context Economy

Long prompts waste tokens and introduce noise. Include only what the next agent needs.

**Include:**
- The diff, error message, or data to process
- The exact constraints (format, schema, fail conditions)
- Reference to prior context by ID, not inline dump ("see session X")

**Exclude:**
- Background narration about how the task was created
- Prior failed attempts unless the agent must avoid repeating them
- Duplicate data already in the system prompt

For cron jobs: prompts run in a fresh session with no chat context. Make them
self-contained — state dependencies, data sources, and expected outputs inline.

**Cron-specific:** state delivery target, silent-exit behavior, and idempotency
expectations in the prompt itself. Don't assume prior session context.

```python
# Bad: assumes context
cronjob(prompt="Check the vault and report issues.")

# Good: self-contained
cronjob(
    prompt="Run vault health check on <VAULT_PATH>/. "
           "Scan for orphan files, missing MOCs, stale frontmatter. "
           "If nothing needs action, produce no output. "
           "If issues found, list them with priority and suggested fix. "
           "Deliver to whatsapp.",
    context_from=["vault-index-latest"],
)
```

## 6. Bounded Fix Loops

When dispatching a fixer subagent, cap retries explicitly.

- Maximum 2 fix-and-reverify cycles.
- After cap: escalate to user with remaining issues and a rollback suggestion.
- The fixer must NOT refactor, rename, or add features — fix only the reported items.

## 7. Prompt Anti-Patterns

| Anti-pattern | Why it fails | Fix |
|---|---|---|
| Mega-prompt with 5+ goals | Agent partial-completes, improvises on weak goals | Split into sequential prompts |
| "Be creative / thorough" | Unbounded scope, unpredictable output | Define exact deliverable and format |
| Vague error handling | Agent swallows errors or improvises fixes | Specify fail-closed or exact retry count |
| Implicit context ("you know the repo") | Fresh agent doesn't know it | State what's needed inline or pass file paths |
| Free-form success criteria | Agent decides what "good enough" means | Define explicit passed/failed conditions |
