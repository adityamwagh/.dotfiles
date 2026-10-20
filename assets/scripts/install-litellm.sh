#!/usr/bin/env bash
set -euo pipefail

# Install LiteLLM as an isolated uv tool. Claude Code reaches LithosAI models
# through it (see claude/litellm.yaml and scripts/enable-litellm-claude.sh).
#
# The version is pinned: 1.82.7 and 1.82.8 were briefly replaced on PyPI in
# March 2026 by a credential stealer, so this stays on a current release.

version=1.106.1

command -v uv >/dev/null 2>&1 || exit 0

installed=$(uv tool list 2>/dev/null | awk '$1 == "litellm" {print $2}')
[ "$installed" = "v$version" ] && exit 0

uv tool install --force "litellm[proxy]==$version"