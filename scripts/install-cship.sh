#!/usr/bin/env bash
set -euo pipefail

# Install the cship Claude Code statusline binary from a pinned GitHub release.
# Avoids the official installer, which edits the dotbot-managed Claude settings.

CSHIP_VERSION="v1.7.1"

if command -v cship >/dev/null 2>&1; then
  exit 0
fi

case "$(uname -s)" in
  Linux) target_os="unknown-linux-musl" ;;
  Darwin) target_os="apple-darwin" ;;
  *)
    echo "Skipping cship install: unsupported OS $(uname -s)" >&2
    exit 0
    ;;
esac

case "$(uname -m)" in
  x86_64 | amd64) target_arch="x86_64" ;;
  arm64 | aarch64) target_arch="aarch64" ;;
  *)
    echo "Skipping cship install: unsupported architecture $(uname -m)" >&2
    exit 0
    ;;
esac

asset="cship-${target_arch}-${target_os}"
url="https://github.com/stephenleo/cship/releases/download/${CSHIP_VERSION}/${asset}"

mkdir -p ~/.local/bin
curl -fsSL "$url" -o ~/.local/bin/cship
chmod +x ~/.local/bin/cship
echo "Installed cship ${CSHIP_VERSION} to ~/.local/bin/cship"
