# hermes-optimized

Opinionated Hermes Agent configuration and curated skills — stripped of all personal data, optimized for real-world use, and designed to be cloned by anyone.

## What's optimized

### Context & cost efficiency
- **Compression**: `compression.enabled` with `threshold: 0.5`, `target_ratio: 0.2`, `protect_last_n: 20`, `protect_first_n: 3` — keeps long sessions under control without losing early framing or recent turns.
- **Prompt caching**: `prompt_caching.cache_ttl: 5m` — reduces repeat token spend on repeated system prompt hits.
- **Reasoning discipline**: `agent.reasoning_effort: medium` — matches effort to task complexity instead of always maxing out.

### Stability & loop prevention
- **Tool loop guardrails**: graduated warnings then hard stops on exact failure repeats, same-tool thrashing, and idempotent no-progress loops.
- **Bounded shell sessions**: `terminal.lifetime_seconds: 300` — forces periodic refresh instead of stale long-lived shells.
- **Browser hygiene**: `browser.inactivity_timeout: 120` — kills idle browser sessions fast.

### Responsiveness
- `display.streaming: true` + `interim_assistant_messages: true` + `tool_progress: all` — streaming UX so it feels responsive, not batch-and-wait.

### Knowledge systems
- **Karpathy-style LLM Wiki**: folder `index.md` MOC pattern, concept-centric linking, cross-vault consolidation-first cleanup.
- **OKF frontmatter alignment**: Google Open Knowledge Format v0.1 schema (`type`, `title`, `description`, `timestamp`) for semantic vault hygiene.
- **Hybrid indexing**: SQLite + FTS5 + vector + link graph query router, with phased indexing for large vaults and vault-indexer integration.

### Todo & task discipline
- **Pareto-first ordering**: `todo-pareto-prioritization` skill — critical first, then Pareto impact/effort.
- **Pareto install gate**: `software-install-pareto` — no new tool without function check.
- **Minimalism constraints**: clutter rule, home/away split, session-recovery active plan blocks, demotion valve when backlog overflows.
- **Systematic debugging**: 4-phase root-cause loop with hypothesis, minimal repro, and regression test.

### Model resilience
- Cloud-first fallback chain, local Ollama last-resort (`gemma4:e2b-it-qat`), daily health checks, deterministic watchdog/cron for availability.

## What's in here

| Path | Purpose |
|---|---|
| `config.yaml` | Optimized config with compression, caching, guardrails, terminal bounds |
| `.env.example` | Secrets template — copy to `.env`, fill in your keys |
| `SOUL.md` | System prompt identity — customize for your own personality |
| `MEMORY.md` | Memory prompt template |
| `USER.md` | User profile template |
| `profiles/sample/` | Example profile with config + skills |
| `skills/` | Curated skill pack encoding Pareto, TDD, systematic debugging, wiki maintenance, model cataloging |
| `docs/` | Setup guides, FAQ, troubleshooting |

## Quick start

```bash
# 1. Install Hermes (if not already installed)
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# 2. Clone this repo
git clone https://github.com/<YOUR_USERNAME>/hermes-optimized.git ~/hermes-optimized
cd ~/hermes-optimized

# 3. Set up secrets
cp .env.example .env
# Edit .env with your API keys

# 4. Run setup wizard
hermes setup

# 5. Apply config
hermes config set model.default <your-model>
# Then edit config.yaml directly or use: hermes config set <section>.<key> <value>

# 6. Optional: copy in the curated skills
cp -r skills/* ~/.hermes/skills/
```

## Structure

### Core files

- **`config.yaml`** — optimized config. Not vanilla defaults. Sections: model, agent, terminal, web, browser, guardrails, compression, prompt caching, display, gateway. Each tuned for real usage patterns.
- **`.env.example`** → `.env` — API keys, provider tokens. Never commit `.env`.
- **`SOUL.md`** — identity/personality prompt.
- **`MEMORY.md`** — memory system prompt template.
- **`USER.md`** — user profile template.

### Profiles

See `profiles/sample/` for a complete example profile layout:

```
profiles/sample/
├── config.yaml       # profile-specific config overrides
├── skills/           # skills activated for this profile
│   └── ...
├── SOUL.md           # profile-specific identity
└── memories/         # profile memory seeds
    ├── MEMORY.md
    └── USER.md
```

To create a profile:
```bash
mkdir -p ~/.hermes/profiles/my-profile/skills
cp profiles/sample/config.yaml ~/.hermes/profiles/my-profile/
hermes config set profiles.active my-profile
```

### Curated skills

The `skills/` directory contains skills that encode the optimizing principles:

- **`systematic-debugging`** — 4-phase root-cause debugging: understand before fixing
- **`test-driven-development`** — RED-GREEN-REFACTOR, tests before code
- **`prompt-engineering`** — reliable first-pass results, minimal retries
- **`todo-taxonomy`** — HOME/AWAY split, active plan blocks, demotion valve
- **`todo-pareto-prioritization`** — Pareto impact/effort ordering
- **`software-install-pareto`** — Pareto check before any new software install
- **`free-model-catalog`** — scrape, rank, persist free models from provider APIs
- **`plan`** — markdown plan to `.hermes/plans/`; no execution

To install: copy the skill directories into `~/.hermes/skills/`.

## Design principles

- **No secrets** — everything public-safe, `.env`-gated
- **No personal identifiers** — no usernames, paths, machine names, tokens
- **Opinionated and optimized** — every non-default setting has a reason
- **Minimal but complete** — essential config only, no bloat
- **Extensible** — drop-in skills, profiles, and templates

## Updating your local Hermes

```bash
cd ~/hermes-optimized
git pull
# Check CHANGELOG.md, review diffs, then:
cp -r skills/* ~/.hermes/skills/
cp config.yaml ~/.hermes/config.yaml
```

## License

MIT — do whatever you want with it.
