#!/usr/bin/env bash
set -euo pipefail

# Install SF Pro fonts from the upstream GitHub repo on Linux.
# macOS gets it from Homebrew (Brewfile cask); this script is Linux-only.

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Skipping SF Pro: git not found" >&2
  exit 0
fi

target_dir="$HOME/.local/share/fonts/SFPro"

# Idempotent: bail out if any font is already installed.
if [ -d "$target_dir" ] && find "$target_dir" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -print -quit | grep -q .; then
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
repo_dir="$tmp_dir/San-Francisco-family"

if ! git clone -n --depth=1 --filter=tree:0 \
  https://github.com/thelioncape/San-Francisco-family.git "$repo_dir" >/dev/null 2>&1; then
  echo "Skipping SF Pro: clone failed" >&2
  exit 0
fi

(
  cd "$repo_dir" || exit 1
  git sparse-checkout set --no-cone "SF Pro" >/dev/null 2>&1
  git checkout >/dev/null 2>&1
) || {
  echo "Skipping SF Pro: sparse checkout failed" >&2
  exit 0
}

font_subdir="$repo_dir/SF Pro"
if [ ! -d "$font_subdir" ]; then
  echo "Skipping SF Pro: expected font directory missing" >&2
  exit 0
fi

mkdir -p "$target_dir"
installed=0

while IFS= read -r -d '' font_file; do
  cp -f "$font_file" "$target_dir/$(basename "$font_file")"
  installed=1
done < <(find "$font_subdir" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -print0)

if [ "$installed" -eq 1 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$target_dir" >/dev/null 2>&1 || true
  echo "Installed SF Pro fonts to $target_dir"
fi
