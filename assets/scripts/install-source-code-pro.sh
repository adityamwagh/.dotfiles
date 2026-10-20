#!/usr/bin/env bash
set -euo pipefail

# Install Source Code Pro static OTF fonts from the upstream GitHub repo.
# macOS gets it from Homebrew (Brewfile cask); Homebrew has no Linux cask.
# Skips the variable fonts and every weight below Regular (ExtraLight, Light).

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Skipping Source Code Pro: git not found" >&2
  exit 0
fi

target_dir="$HOME/.local/share/fonts/SourceCodePro"

# Idempotent: bail out if any font is already installed.
if [ -d "$target_dir" ] && find "$target_dir" -type f -iname "*.otf" -print -quit | grep -q .; then
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
repo_dir="$tmp_dir/source-code-pro"

# The release branch carries the built static fonts under OTF/ (sources live on main).
if ! git clone -n --depth=1 --filter=tree:0 -b release \
  https://github.com/adobe-fonts/source-code-pro.git "$repo_dir" >/dev/null 2>&1; then
  echo "Skipping Source Code Pro: clone failed" >&2
  exit 0
fi

(
  cd "$repo_dir" || exit 1
  git sparse-checkout set --no-cone OTF >/dev/null 2>&1
  git checkout >/dev/null 2>&1
) || {
  echo "Skipping Source Code Pro: sparse checkout failed" >&2
  exit 0
}

mkdir -p "$target_dir"
installed=0

while IFS= read -r -d '' font_file; do
  base="$(basename "$font_file")"
  # Drop weights below Regular (400); "*-Light*" also matches "ExtraLight".
  case "$base" in
    *-Light* | *-ExtraLight*) continue ;;
  esac
  cp -f "$font_file" "$target_dir/$base"
  installed=1
done < <(find "$repo_dir/OTF" -type f -iname "*.otf" -print0)

if [ "$installed" -eq 1 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$target_dir" >/dev/null 2>&1 || true
  echo "Installed Source Code Pro static fonts to $target_dir"
fi
