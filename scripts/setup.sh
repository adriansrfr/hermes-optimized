#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HERMES_DIR="${HOME}/.hermes"

echo "==> Hermes optimized setup"
echo "==> Repo: ${REPO_DIR}"
echo "==> Target: ${HERMES_DIR}"

if [ ! -f "${REPO_DIR}/.env" ]; then
  cp "${REPO_DIR}/.env.example" "${REPO_DIR}/.env"
  echo "Created .env from .env.example — edit before use."
fi

read -p "Apply config.yaml to ~/.hermes/config.yaml? [y/N] " yn
if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
  cp "${REPO_DIR}/config.yaml" "${HERMES_DIR}/config.yaml"
  echo "Copied config.yaml"
fi

read -p "Install curated skills into ~/.hermes/skills/? [y/N] " yn
if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
  mkdir -p "${HERMES_DIR}/skills"
  for skill in "${REPO_DIR}/skills/"*; do
    name="$(basename "$skill")"
    cp -r "$skill" "${HERMES_DIR}/skills/${name}"
    echo "Installed skill: ${name}"
  done
fi

echo "Setup complete. Run: hermes setup"
