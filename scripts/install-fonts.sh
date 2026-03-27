#!/usr/bin/env bash
set -euo pipefail

root_dir="${1:-$HOME/.dotfiles}"
exec bash "$root_dir/fonts/install-fonts.sh" "$root_dir"
