#!/usr/bin/env bash
[ -f "$HOME/.gitconfig.local" ] ||
  printf '# Machine-local Git overrides (identity, employer setup); loaded last by ~/.gitconfig.\n' >"$HOME/.gitconfig.local"