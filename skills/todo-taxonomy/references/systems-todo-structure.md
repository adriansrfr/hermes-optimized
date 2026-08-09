# Systems Todo Structure Reference

Canonical pattern for `todo_systems.md` or equivalent systems-level todo files.

## Required top sections

1. `## 🏆 Biggest Bang for Buck` — highest-impact hardware/work items
2. `## 🛠️ Infrastructure` — git, network, remote access
3. `## ⚡ Efficiency / Automation` — tooling, scripts, integrations
4. `## 📍 Quick Location Filter` — same items grouped by `[HOME/TAILSCALE]`, `[HOME]`, `[AWAY]`, `[ANYWHERE]`
5. `## 🔄 Active Plan / Next Steps` — top 3 actions only
6. `## 🔄 Weekly Review / Calibration` — friction log + promotion review notes

## Rules to preserve in header

- P0/P1 only in systems todo
- P1★ = highest P1; plain P1 = lower queue
- Sections sorted by priority
- Zero P0 for 2 cycles → promotion review, not auto-promote
- Biweekly promotion review via cron

## Active Plan shape

```markdown
1. **[P0] Task name** `[LOCATION]`
   - status notes / next action

2. **[P1] Task name**
   - notes / plan link

3. **[P1] Task name**
   - notes
```

## Pointer convention

Default expectation: if a systems-todo item is sufficiently complex, it should be accompanied by a plan/pointer; if it is simple enough that a separate plan would be overhead, explicitly omit it. This should be a deliberate choice, not accidental.

For vault/wiki/hygiene tasks, prefer a concrete pointer over a bare folder path:
- Good: `Pointer: [[vimwiki_optimization]] → vimwiki_work/LLM_Wiki_OKF_Adoption_Plan.md`
- Bad: `Pointer: vimwiki_work_/`
