#!/usr/bin/env bash
set -euo pipefail

# Install the repo-vendored HelveticaNow fonts. Cross-platform: the bytes ship
# in this repo (no upstream download), so it runs on both macOS and Linux.

root_dir="${1:-$HOME/.dotfiles}"
src_dir="$root_dir/fonts/HelveticaNow"

if [ ! -d "$src_dir" ]; then
  exit 0
fi

case "$(uname -s)" in
  Darwin*) dst_root="$HOME/Library/Fonts" ;;
  *) dst_root="$HOME/.local/share/fonts" ;;
esac

installed=0
while IFS= read -r -d '' font_file; do
  rel="${font_file#"$root_dir"/fonts/}"
  dst="$dst_root/$rel"
  if [ -f "$dst" ] && cmp -s "$font_file" "$dst"; then
    continue
  fi
  mkdir -p "$(dirname "$dst")"
  cp -f "$font_file" "$dst"
  installed=1
done < <(find "$src_dir" -type f \( -iname "*.otf" -o -iname "*.ttf" -o -iname "*.ttc" -o -iname "*.otc" \) -print0)

if [ "$installed" -eq 1 ] && [ "$(uname -s)" = Linux ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$dst_root" >/dev/null 2>&1 || true
fi
