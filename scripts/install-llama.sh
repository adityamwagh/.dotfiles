#!/usr/bin/env bash
set -euo pipefail

# Install llama via its official installer script.

if command -v llama >/dev/null 2>&1; then
  exit 0
fi

curl -LsSf https://llama.app/install.sh | sh
