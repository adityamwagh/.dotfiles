#!/usr/bin/env bash
set -euo pipefail

# Link selected Homebrew tools into /usr/local/bin.
#
# Some systems set sudo's secure_path, which omits the Homebrew prefix, so
# `sudo nvim` fails even though `nvim` resolves in the shell. /usr/local/bin
# is on the default PATH everywhere we care about, so a link there makes the
# tool reachable both ways. Distributions without secure_path (Arch) already
# inherit the caller's PATH, so the links are harmless there.

tools=(nvim)

if ! command -v brew >/dev/null 2>&1; then
  echo "Skipping Homebrew PATH links: brew not found" >&2
  exit 0
fi

brew_bin="$(brew --prefix)/bin"

for tool in "${tools[@]}"; do
  target="$brew_bin/$tool"
  link="/usr/local/bin/$tool"

  if [ ! -x "$target" ]; then
    echo "Skipping $tool: $target not found" >&2
    continue
  fi

  if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
    echo "$tool link already present at $link"
    continue
  fi

  # Never clobber a real binary or a link we do not own.
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "Skipping $tool: $link exists and is not a symlink" >&2
    continue
  fi

  if ! sudo ln -sfn "$target" "$link"; then
    echo "Skipping $tool: could not create $link (needs sudo)" >&2
    continue
  fi
  echo "Linked $link -> $target"
done
