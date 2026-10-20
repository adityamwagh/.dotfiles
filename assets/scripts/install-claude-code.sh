#!/usr/bin/env bash
set -euo pipefail

# Install claude-code via its official installer script.

if command -v claude >/dev/null 2>&1; then
  exit 0
fi

curl -fsSL https://claude.ai/install.sh | bash
