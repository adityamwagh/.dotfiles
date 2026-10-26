#!/usr/bin/env bash
set -euo pipefail

# Neovim ships from Homebrew at /home/linuxbrew/.linuxbrew/bin/nvim, which is
# not in sudo's secure_path. Link it into /usr/local/bin (which is) so that
# `sudo nvim` and `sudoedit` find it. Prefer `sudoedit` for editing root files.

target="/home/linuxbrew/.linuxbrew/bin/nvim"
link="/usr/local/bin/nvim"

if [ ! -x "$target" ]; then
  echo "Skipping nvim symlink: $target not found" >&2
  exit 0
fi

if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
  echo "nvim symlink already present at $link"
  exit 0
fi

if [ -e "$link" ]; then
  echo "Skipping nvim symlink: $link already exists and is not our link" >&2
  exit 0
fi

if ! sudo ln -s "$target" "$link"; then
  echo "Skipping nvim symlink: could not create $link (needs sudo)" >&2
  exit 0
fi
echo "Linked $link -> $target"
