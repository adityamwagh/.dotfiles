#!/usr/bin/env bash
set -euo pipefail

root_dir="${1:-$HOME/.dotfiles}"
fonts_src="$root_dir/fonts"

if [ ! -d "$fonts_src" ]; then
  exit 0
fi

case "$(uname -s)" in
  Darwin*)
    fonts_dst="$HOME/Library/Fonts"
    ;;
  *)
    fonts_dst="$HOME/.local/share/fonts"
    ;;
esac

mkdir -p "$fonts_dst"
fonts_changed=0

copy_if_different() {
  local src="$1"
  local dst="$2"

  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    return 1
  fi

  cp -f "$src" "$dst"
  return 0
}

copy_font_file() {
  local src="$1"
  local rel="${src#"$fonts_src"/}"
  local dst="$fonts_dst/$rel"
  mkdir -p "$(dirname "$dst")"
  if copy_if_different "$src" "$dst"; then
    fonts_changed=1
  fi
}

install_repo_fonts() {
  while IFS= read -r -d '' font_file; do
    copy_font_file "$font_file"
  done < <(
    find "$fonts_src" -type f \( \
      -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc" -o -iname "*.otc" \
      \) -print0
  )
}

install_sf_pro() {
  local target_dir="$fonts_dst/SFPro"
  local repo_dir="$tmp_dir/San-Francisco-family"
  local font_subdir="$repo_dir/SF Pro"

  if [ -d "$target_dir" ] && find "$target_dir" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -print -quit | grep -q .; then
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "Skipping SF Pro: git not found" >&2
    return
  fi

  if ! git clone -n --depth=1 --filter=tree:0 "https://github.com/thelioncape/San-Francisco-family.git" "$repo_dir" >/dev/null 2>&1; then
    echo "Skipping SF Pro: clone failed" >&2
    return
  fi

  (
    cd "$repo_dir" || exit 1
    git sparse-checkout set --no-cone "SF Pro" >/dev/null 2>&1
    git checkout >/dev/null 2>&1
  ) || {
    echo "Skipping SF Pro: sparse checkout failed" >&2
    return
  }

  if [ ! -d "$font_subdir" ]; then
    echo "Skipping SF Pro: expected font directory missing" >&2
    return
  fi

  while IFS= read -r -d '' font_file; do
    local base
    base="$(basename "$font_file")"
    mkdir -p "$target_dir"
    if copy_if_different "$font_file" "$target_dir/$base"; then
      fonts_changed=1
    fi
  done < <(find "$font_subdir" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -print0)
}

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

install_segoe_ui_linux() {
  local repo_dir="$tmp_dir/segoe-ui-linux"
  local target_dir="$fonts_dst/SegoeUILinux"

  if [ -d "$target_dir" ] && find "$target_dir" -type f -iname "*.ttf" -print -quit | grep -q .; then
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "Skipping segoe-ui-linux: git not found" >&2
    return
  fi

  if ! git clone --depth 1 https://github.com/mrbvrz/segoe-ui-linux.git "$repo_dir" >/dev/null 2>&1; then
    echo "Skipping segoe-ui-linux: clone failed" >&2
    return
  fi

  if [ -d "$repo_dir/font" ]; then
    while IFS= read -r -d '' font_file; do
      local base
      base="$(basename "$font_file")"
      mkdir -p "$target_dir"
      if copy_if_different "$font_file" "$target_dir/$base"; then
        fonts_changed=1
      fi
    done < <(find "$repo_dir/font" -type f -iname "*.ttf" -print0)
  fi
}

install_repo_fonts
install_sf_pro
install_segoe_ui_linux

if [ "$fonts_changed" -eq 1 ] && [ "$(uname -s)" = "Linux" ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$fonts_dst" >/dev/null 2>&1 || true
fi
