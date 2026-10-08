#!/usr/bin/env bash
set -euo pipefail

# Install ollama via its official installer script.

if command -v ollama >/dev/null 2>&1; then
  exit 0
fi

# The installer cleans old versions with sudo, and dotbot runs this step
# without a TTY, so sudo cannot prompt. Skip instead of failing the run.
if ! sudo -n true 2>/dev/null; then
  echo "Skipping ollama install: needs interactive sudo." >&2
  exit 0
fi

curl -fsSL https://ollama.com/install.sh | sh
