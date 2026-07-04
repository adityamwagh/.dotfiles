#!/usr/bin/env bash
set -euo pipefail

# Install the Rust toolchain via rustup. Shell configs already source
# ~/.cargo/env, so the installer must not modify them.

if command -v cargo >/dev/null 2>&1 || [ -x "$HOME/.cargo/bin/cargo" ]; then
  exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
