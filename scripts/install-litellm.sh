#!/usr/bin/env bash
set -euo pipefail

# Install LiteLLM as an isolated uv tool. Claude Code reaches LithosAI models
# through it (see litellm/claude.yaml and scripts/enable-litellm-claude.sh).
#
# The version is pinned because LiteLLM's release pipeline has been compromised
# twice: 1.82.7/1.82.8 in March 2026 and 1.107.0 in October 2026, both replaced
# on PyPI with credential stealers. 1.106.2 is the version their post-incident
# advisory recommends; never install an unpinned or "latest" release.

version=1.106.2

command -v uv >/dev/null 2>&1 || exit 0

installed=$(uv tool list 2>/dev/null | awk '$1 == "litellm" {print $2}')
[ "$installed" = "v$version" ] && exit 0

uv tool install --force "litellm[proxy]==$version"
