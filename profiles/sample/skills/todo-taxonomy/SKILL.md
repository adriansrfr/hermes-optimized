---
name: todo-taxonomy
description: Todo priority taxonomy and systems-todo structure for markdown/vault files. Covers P0/P1-only systems todos, P1★ hierarchy, biweekly promotion reviews, and project-detail pointers.
---

# Todo Taxonomy

Class-level skill for todo priority systems in markdown/vault files.

## Adopted priority taxonomy

Use these exact markers unless a project already defines its own:

- **P0** = Focus Lock. Default session work. Only one P0 at a time.
- **P1** = This week.
- **P2** = This month.
- **P3** = Someday / backlog.
- **HOLD** = Over a month or dependency-blocked. Not ready to schedule.

Do not collapse HOLD into P3; they have different intent. HOLD means “do not schedule,” P3 means “schedule eventually.”

## Formatting rules

- Prefix every actionable item with one of: `[P0]`, `[P1]`, `[P2]`, `[P3]`, `[HOLD]`.
- Untagged items are treated as unprioritized backlog.
- Keep location context when relevant: `[HOME]`, `[AWAY]`, `[HOME/TAILSCALE]`, or `[ANYWHERE]`.
- When “Active Plan / Next Steps” exists, keep it to the next 3 actions only.
- Dropbox/sync-style gating rules should be stated in one sentence near the Active Plan, not repeated inline.

## Maintenance rules

- Re-tag items when the taxonomy changes; do not leave old bare `[ ]` lines in active lists.
- Checked items should be moved to a log/DONE section or removed per the todo hygiene rules.
- Blocked/hold items should include trigger or dependency text, not just status.

## Systems todo scope

- The systems todo should contain **only P0 and P1** items. Substeps, acceptance criteria, and project details live in the project repo/note.
- Each section in the systems todo must be **sorted by priority**, highest first.
- If there are **zero P0s for two consecutive review cycles**, force a promotion review instead of auto-promoting.
- A **biweekly promotion review** should scan project files for P2+ candidates and surface them for possible promotion. Do not auto-promote without explicit approval.

- **Draft filing:** When the user asks for a plan or proposal and it is clearly P3/backlog, write it directly as a markdown file under a drafts or plans folder. Include `Status: Draft` and `Delete when: Completed` in the frontmatter/heading. This makes it easy to resume later and self-destructs on completion. Do not keep the same draft in chat memory after filing.

- **Plan pointers:** When a P1/P2 item in systems-todo is governed by a separate plan note, point to that plan with a vault pointer (`[[wikilink]]` or path), not a bare folder. The plan itself should contain the detailed `## Todo` checklist. This keeps systems-todo thin and makes the plan self-contained.
- **Skip plan files for simple todos:** If a systems-todo item is straightforward enough that it does not need a separate plan note, omit the plan pointer and keep only the action line + context. Use a plan file only when the item is sufficiently complex to warrant one.

## Relationship to other skills

- Use `todo-pareto-prioritization` for impact/effort ordering when a file lacks explicit priority markers.
- Use `todo-log-system` for hygiene, logging, and trivial-vs-significant completion rules.
- See `references/systems-todo-structure.md` for the canonical systems-todo layout and rules.
