# Troubleshooting

## Hermes won't start

```bash
hermes doctor
# Check for missing deps, Python version, venv
```

## Model errors

- Verify key in `.env` / `~/.hermes/.env`
- Check `model.provider` and `model.base_url` in `config.yaml`
- Run `hermes model` to test connectivity

## Gateway not connecting

- Set `gateway.enabled: true`
- Provide platform token in `.env` or `config.yaml`
- Check `gateway_state.json` and `logs/` for errors

## Skills not loading

- Verify `SKILL.md` exists in the skill directory
- Ensure the skill directory is under `~/.hermes/skills/`
- Run `hermes setup` to refresh skill index

## Compaction / context issues

- Tune `compression.threshold` and `compression.target_ratio`
- Enable `prompt_caching.cache_ttl`
- Use smaller system prompts in `SOUL.md`
