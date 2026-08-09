# FAQ

**Q: Is this a fork of Hermes Agent?**
No. It's a configuration template and curated skill pack. Install Hermes normally from the official installer, then apply these files.

**Q: Do I have to use these exact models?**
No. Edit `config.yaml` and `.env` to use any provider Hermes supports: Anthropic, OpenAI, OpenRouter, Google, xAI, Mistral, Gemini, local/Ollama, Nous Portal, etc.

**Q: Are skills mandatory?**
No. Skills are optional enhancements. The base config works without any skills.

**Q: What about my existing Hermes setup?**
Back up first:
```bash
cp ~/.hermes/config.yaml ~/.hermes/config.yaml.bak.$(date +%Y%m%d)
```
Then apply the curated config.

**Q: How do I create multiple profiles?**
```bash
mkdir -p ~/.hermes/profiles/<name>/skills
cp profiles/sample/config.yaml ~/.hermes/profiles/<name>/
hermes config set profiles.active <name>
```

**Q: Where do I put API keys?**
In `.env` in this repo, or in `~/.hermes/.env`. Never commit `.env`.

**Q: How do I contribute?**
PRs welcome — especially skill submissions, config refinements, and platform setup guides.
