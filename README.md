# hermes-optimized

Opinionated Hermes Agent configuration and curated skills — stripped of all personal data, optimized for real-world use, and designed to be cloned by anyone.

## What's in here

| Path | Purpose |
|---|---|
| `config.yaml` | Production-ready Hermes config with sane defaults |
| `.env.example` | Secrets template — copy to `.env`, fill in your keys |
| `SOUL.md` | System prompt identity — customize for your own personality |
| `MEMORY.md` | Memory prompt template |
| `USER.md` | User profile template |
| `profiles/sample/` | Example profile with config + skills |
| `skills/` | Curated skill pack (read-only templates + copy-able skills) |
| `scripts/` | Setup and maintenance helpers |
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

- **`config.yaml`** — main config. Sections: model, agent, terminal, web, browser, guardrails, compression, prompt caching, display, gateway. Edit directly or use `hermes config set`.
- **`.env.example`** → `.env` — API keys, provider tokens. Never commit `.env`.
- **`SOUL.md`** — identity/personality prompt. Good defaults included.
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

The `skills/` directory contains a small, high-value set of broadly useful skills. Each skill is self-contained with a `SKILL.md` frontmatter file.

To install: copy the skill directories into `~/.hermes/skills/`.

## Design principles

- **No secrets** — everything public-safe, `.env`-gated
- **No personal identifiers** — no usernames, paths, machine names, tokens
- **Opinionated but portable** — good defaults that work across platforms
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
