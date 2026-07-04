#!/usr/bin/env bash
set -euo pipefail

# Install opencode via its official installer script.

if command -v opencode >/dev/null 2>&1; then
  exit 0
fi

curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
