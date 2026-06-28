#!/usr/bin/env bash
set -euo pipefail

# Install Segoe UI fonts from the upstream GitHub repo on Linux.
# Segoe UI is not on Homebrew, so this is Linux-only with no macOS counterpart.

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Skipping Segoe UI: git not found" >&2
  exit 0
fi

target_dir="$HOME/.local/share/fonts/SegoeUILinux"

# Idempotent: bail out if any font is already installed.
if [ -d "$target_dir" ] && find "$target_dir" -type f -iname "*.ttf" -print -quit | grep -q .; then
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
repo_dir="$tmp_dir/segoe-ui-linux"

if ! git clone --depth 1 https://github.com/mrbvrz/segoe-ui-linux.git "$repo_dir" >/dev/null 2>&1; then
  echo "Skipping Segoe UI: clone failed" >&2
  exit 0
fi

font_subdir="$repo_dir/font"
if [ ! -d "$font_subdir" ]; then
  echo "Skipping Segoe UI: expected font directory missing" >&2
  exit 0
fi

mkdir -p "$target_dir"
installed=0

while IFS= read -r -d '' font_file; do
  cp -f "$font_file" "$target_dir/$(basename "$font_file")"
  installed=1
done < <(find "$font_subdir" -type f -iname "*.ttf" -print0)

if [ "$installed" -eq 1 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$target_dir" >/dev/null 2>&1 || true
  echo "Installed Segoe UI fonts to $target_dir"
fi
