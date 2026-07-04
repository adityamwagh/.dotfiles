#!/usr/bin/env bash
set -euo pipefail

# Install llama via its official installer script.

if command -v llama >/dev/null 2>&1; then
  exit 0
fi

# The installer only warns about PATH; having the dir present keeps it quiet.
export PATH="$HOME/.local/bin:$PATH"

curl -LsSf https://llama.app/install.sh | sh
