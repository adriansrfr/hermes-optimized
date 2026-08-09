---
name: free-model-catalog
description: "Scrape, rank, persist free models from provider APIs."
version: 1.0.0
tags: [llm, free-tier, catalog, ranking, fallback, providers, nous, openrouter, vault]
---

# Free Model Catalog

Build and maintain a ranked reference database of free LLM models from live provider APIs, with weekly refresh and optional Hermes fallback wiring.

## Trigger

Use when: user asks to rank free models, build a model catalog, set up weekly refresh of free-tier listings, wire free models into Hermes fallback, compare providers' free tiers, or create an AI-friendly artifact that embeds live data summaries for LLM interpretation. Also applies when the user wants a ranked company list of providers offering free premium tiers, or when expanding coverage beyond a single provider.

## Method

1. **Probe the provider's public model list** — `/v1/models` for OpenAI-compatible providers, public HTML for others. Use a real browser UA; many endpoints block bare `urllib`.
2. **Extract free models** — filter on `pricing.prompt == 0` AND `pricing.completion == 0`. Some providers mark `prompt: 0` but charge for completion; filter strictly.
3. **Rank** — primary sort: context length desc. Secondary sort: multimodal breadth (input+output modality count desc). Tertiary: model id for determinism.
4. **Brief each model** — use the provider's own `description` field, truncated to ~120 chars. Include: context, input modalities, output modalities, and a one-line use note.
5. **Compute overlap** — compare against existing catalogs; flag shared models so duplicate vault entries get cross-references, not duplication.
6. **Persist JSON + vault note** — raw JSON in `~/.hermes/shared/<provider>_models_free.json`. Vault note in `~/Documents/Obsidian Vault/<Provider> Free Models.md` with ranked table + routing notes.
7. **Cross-link sibling notes** — link to other provider catalogs, `Free LLM Tier Providers.md`, and `SETUP - Agent VM Build Log.md`.
8. **Set weekly refresh** — systemd user timer: `OnCalendar=Mon *-*-* HH:MM:00`, `Persistent=true`. Service runs the same probe+rank script.
9. **Warn on unverified direct access** — if the provider's free tier is rumored but not confirmed from an unauthenticated probe, mark it `[ ] NEEDS AUTH` and note what key/account is required before claiming it works.

### Ranked company list (premium free tiers)

When the user asks for a ranking of companies that offer free premium LLM tiers:
1. Search current web sources for confirmed free-tier providers (not just rumors).
2. Rank by: quality of free models + generosity of limits + no-credit-card requirement + reliability.
3. Output: tiered list (Tier 1 = best value, no credit card; Tier 2 = strong free tier, minor friction; Tier 3 = niche/trial).
4. Save to vault as `Free LLM Tier Providers.md` with integration path for each provider.
5. Cross-link from all provider-specific free model notes.

### AI-friendly artifact pattern

When embedding live-data summaries for LLM interpretation:
1. Add a hidden `<div id="ai-<thing>-report">` near the data it summarizes.
2. Write structured JSON (not prose) after each data-refresh callback.
3. Include: timestamp, current selection context, observations, forecast/hourly breakdown, and any derived ratings.
4. Keep it `display:none` so it doesn't affect UX; the LLM reads the DOM directly.
5. Update it from every code path that mutates the visible summary (forecast render, detail render, chart render, live obs refresh).

## Provider-specific notes

- **Nous** — `/v1/models` requires a real UA + `Authorization: Bearer <token>`. Both endpoints return the same 323-model catalog. Free models count ~4. Rate-limit model: ~47 req/min, ~475k tok/min, no daily cap.
- **OpenRouter** — `/api/v1/models` is public, no auth. Free models are explicitly `prompt == 0` AND `completion == 0`. 17 free models, 14 unique. Rate-limit is IP-based, not token-based.
- **Google AI Studio** — free tier confirmed but model availability requires authenticated probe (`/v1beta/models?key=`). Don't claim specific free models without key verification.
- **NVIDIA** — public `integrate.api.nvidia.com/v1/models` lists models but NOT pricing tiers. Free access must be checked via developer account / build.nvidia.com.
- **HuggingFace** — open-weight models (Apache 2.0, etc.) can be served free via HF Inference API, rate-limited per model. Requires `HF_TOKEN`.

## Pattern for the vault note layout

```markdown
# <Provider> Free Models — ranked + reference
> Auto-refreshed weekly by `~/.config/systemd/user/<provider>-models.timer`
> Source: `<endpoint URL>`
> Last refresh: <ISO date>

## Free models (<N> total)
| Rank | Model | Context | Input | Output | Notes |
...

## Quick routing notes
- <category> → <model suggestion>

## Full free list
<numbered, same columns>

## Refresh
- systemd user timer: `<provider>-models.timer` → `<provider>-models.service`
- Manual refresh: `systemctl --user start <provider>-models.service`
```

## Pattern for the weekly refresh service

```ini
# ~/.config/systemd/user/<provider>-models.service
[Unit]
Description=Refresh <Provider> free model catalog
[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /tmp/rank-<provider>-models.py
```

```ini
# ~/.config/systemd/user/<provider>-models.timer
[Unit]
Description=Weekly <Provider> free model catalog refresh
[Timer]
OnCalendar=Mon *-*-* HH:MM:00
Persistent=true
[Install]
WantedBy=timers.target
```

Then: `systemctl --user daemon-reload && systemctl --user enable --now <provider>-models.timer`

## Direct-provider strategy

When OpenRouter's IP rate-limit is too tight, add direct provider access:
1. Identify which free models have native API access (Google AI Studio, NVIDIA NIM, HF Inference, etc.)
2. Add each provider's API key to `~/.hermes/.env` or `hermes auth add <provider>`
3. Add the provider to Hermes's `config.yaml` provider section
4. Add top free models as `fallback_providers` entries (before OpenRouter in the chain)
5. Update the vault note's probing status per-provider
6. Document each provider's actual free model listing, not just rumors.

## Anti-patterns

- Don't mark a model "free" without checking BOTH `prompt` and `completion` pricing.
- Don't claim direct provider access without actually probing with auth.
- Don't hardcode daily token caps if the provider is rate-limit only (e.g., Nous, OpenRouter).
- Don't add a model to Hermes's fallback chain if it's not confirmed to exist on the provider's API.
- Don't duplicate model IDs across vault notes — cross-reference instead.
- Don't let `fallback_providers` stay Nous-only when direct providers are confirmed free + key'd; prepend direct entries first.
