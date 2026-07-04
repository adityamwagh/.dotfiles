#!/usr/bin/env bash
set -euo pipefail

# Install the zsh-patina syntax highlighter from a pinned GitHub release.
# macOS gets it from Homebrew (Brewfile); the tap ships no Linux binaries.

ZSH_PATINA_VERSION="1.8.0"

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

if command -v zsh-patina >/dev/null 2>&1; then
  exit 0
fi

case "$(uname -m)" in
  x86_64 | amd64) target_arch="x86_64" ;;
  arm64 | aarch64) target_arch="aarch64" ;;
  *)
    echo "Skipping zsh-patina install: unsupported architecture $(uname -m)" >&2
    exit 0
    ;;
esac

asset="zsh-patina-v${ZSH_PATINA_VERSION}-${target_arch}-unknown-linux-musl"
url="https://github.com/michel-kraemer/zsh-patina/releases/download/${ZSH_PATINA_VERSION}/${asset}.tar.gz"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL "$url" | tar -xz -C "$tmpdir"
mkdir -p ~/.local/bin ~/.zfunc
install -m 755 "$tmpdir/$asset/zsh-patina" ~/.local/bin/zsh-patina
install -m 644 "$tmpdir/$asset/completion/_zsh-patina" ~/.zfunc/_zsh-patina
echo "Installed zsh-patina ${ZSH_PATINA_VERSION} to ~/.local/bin/zsh-patina"
