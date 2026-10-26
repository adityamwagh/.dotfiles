#!/usr/bin/env bash
set -euo pipefail

# Link Homebrew tools into /usr/local/bin.
#
# These are user tools rather than system ones, so preferring the Homebrew
# build is intentional. The links also put them on sudo's PATH where the
# system sets secure_path without the Homebrew prefix; distributions that do
# not (Arch) inherit the caller's PATH, so the links are simply harmless.
#
# Entries are binary names; the Homebrew formula may differ (git-delta
# installs the delta binary).

tools=(
  bat
  delta
  eza
  fd
  fzf
  gh
  jq
  nvim
  rg
  tmux
  yq
  zoxide
)

if ! command -v brew >/dev/null 2>&1; then
  echo "Skipping Homebrew PATH links: brew not found" >&2
  exit 0
fi

brew_bin="$(brew --prefix)/bin"

for entry in "${tools[@]}"; do
  binary="$entry"

  target="$brew_bin/$binary"
  link="/usr/local/bin/$binary"

  if [ ! -x "$target" ]; then
    echo "Skipping $binary: $target not found" >&2
    continue
  fi

  if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
    echo "$binary link already present at $link"
    continue
  fi

  # Never clobber a real binary or a link we do not own.
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "Skipping $binary: $link exists and is not a symlink" >&2
    continue
  fi

  if ! sudo ln -sfn "$target" "$link"; then
    echo "Skipping $binary: could not create $link (needs sudo)" >&2
    continue
  fi
  echo "Linked $link -> $target"
done
