# Setup Guide

## Install Hermes

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Verify:
```bash
hermes --version
hermes doctor
```

## Clone this repo

```bash
git clone https://github.com/<YOUR_USERNAME>/hermes-optimized.git ~/hermes-optimized
cd ~/hermes-optimized
```

## Configure secrets

```bash
cp .env.example .env
# Edit .env with your provider keys
```

## Run setup wizard

```bash
hermes setup
```

Follow the prompts to pick model/provider. Then run:

```bash
# Apply curated config
cp config.yaml ~/.hermes/config.yaml

# Install skills
cp -r skills/* ~/.hermes/skills/

# Optional: create a profile
mkdir -p ~/.hermes/profiles/work/skills
cp profiles/sample/config.yaml ~/.hermes/profiles/work/
hermes config set profiles.active work
```

## Verify

```bash
hermes chat -q "Say hello in one short sentence."
```

## Updates

```bash
cd ~/hermes-optimized
git pull
cp config.yaml ~/.hermes/config.yaml
cp -r skills/* ~/.hermes/skills/
```
