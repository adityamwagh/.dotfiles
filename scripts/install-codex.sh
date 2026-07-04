#!/usr/bin/env bash
set -euo pipefail

# Install codex via its official installer script.

if command -v codex >/dev/null 2>&1; then
  exit 0
fi

curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
