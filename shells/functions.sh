#!/bin/bash
# Shared shell functions for bash and zsh

# Lazy-load conda/mamba: auto_activate is false, and `conda` routes to `mamba`.
# Both initialize the shell hook on first use.
mamba_lazy_init() {
  local shell_name="$1"
  export MAMBA_ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-$HOME/.miniforge3}"
  export MAMBA_EXE="$MAMBA_ROOT_PREFIX/bin/mamba"
  [ -x "$MAMBA_EXE" ] || return 0

  _mamba_init() {
    unset -f conda mamba 2>/dev/null
    eval "$("$MAMBA_EXE" shell hook --shell "$shell_name" --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
    alias conda='mamba'
  }
  conda() {
    _mamba_init
    mamba "$@"
  }
  mamba() {
    _mamba_init
    mamba "$@"
  }
}

# Open a URL in Chrome when it is installed, else the platform's default
# browser: google-chrome (Arch/Fedora/openSUSE) and google-chrome-stable
# (Debian/Ubuntu) lead on Linux; macOS has the app bundle plus `open`.
_open_url() {
  local __browser
  for __browser in google-chrome google-chrome-stable chromium chromium-browser; do
    if command -v "$__browser" >/dev/null 2>&1; then
      "$__browser" "$1"
      return
    fi
  done
  if [ "$(uname -s)" = Darwin ] && [ -d "/Applications/Google Chrome.app" ]; then
    open -a "Google Chrome" "$1"
    return
  fi
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$1"
    return
  fi
  if command -v open >/dev/null 2>&1; then
    open "$1"
    return
  fi
  echo "open-url: no browser launcher found" >&2
  return 1
}

pp() {
  _open_url "https://www.perplexity.ai/search?q=$*"
}

g() {
  _open_url "https://www.google.com/search?q=$*"
}

gai() {
  _open_url "https://www.google.com/search?udm=50&q=$*"
}

chfont-replace-file() {
  local file="$1" current_font="$2" new_font="$3" tmp_file

  tmp_file="$(mktemp "${file}.tmp.XXXXXX")" || return 1
  awk -v current="$current_font" -v new="$new_font" '
    function normalized(value) {
      gsub(/[[:space:]]+/, "", value)
      return value
    }

    function replace_family_values(line,    before, family, after, quote, rest, candidate) {
      rest = line
      line = ""
      while (match(rest, /family[[:space:]]*=[[:space:]]*["'\''][^"'\'']+["'\'']/)) {
        before = substr(rest, 1, RSTART - 1)
        family = substr(rest, RSTART, RLENGTH)
        after = substr(rest, RSTART + RLENGTH)
        quote = substr(family, index(family, "=") + 1)
        sub(/^[[:space:]]*/, "", quote)
        quote = substr(quote, 1, 1)
        candidate = family
        sub(/^[^"'\'']*["'\'']/, "", candidate)
        sub(/["'\''][^"'\'']*$/, "", candidate)
        if (normalized(candidate) == normalized(current)) {
          sub(/["'\''][^"'\'']+["'\'']$/, quote new quote, family)
        }
        line = line before family
        rest = after
      }
      return line rest
    }

    {
      while ((idx = index($0, current)) > 0) {
        $0 = substr($0, 1, idx - 1) new substr($0, idx + length(current))
      }
      $0 = replace_family_values($0)
      print
    }
  ' "$file" >"$tmp_file" && mv "$tmp_file" "$file"
  local replace_status=$?
  [ "$replace_status" -ne 0 ] && rm -f "$tmp_file"
  return "$replace_status"
}

chfont() {
  local current_font="${1:-}" new_font="${2:-}" root_dir file

  if [ -z "$current_font" ] || [ -z "$new_font" ]; then
    echo "Usage: chfont <current> <new>" >&2
    return 1
  fi

  root_dir="$HOME/.dotfiles"
  if [ ! -d "$root_dir" ]; then
    echo "chfont: dotfiles repo not found: $root_dir" >&2
    return 1
  fi

  for file in \
    "$root_dir/editors/zed/settings.json" \
    "$HOME/.config/Code/User/settings.json" \
    "$HOME/Library/Application Support/Code/User/settings.json" \
    "$HOME/.config/Cursor/User/settings.json" \
    "$HOME/Library/Application Support/Cursor/User/settings.json" \
    "$HOME/.config/Windsurf/User/settings.json" \
    "$HOME/Library/Application Support/Windsurf/User/settings.json"; do
    [ -f "$file" ] || continue
    chfont-replace-file "$file" "$current_font" "$new_font" || return 1
  done
}

# Remove Python/Rust tool caches under a directory (default: current dir),
# plus the global Cargo download cache.
clean-caches() {
  local root="$PWD" dry_run=0 assume_yes=0 reply
  local -a targets=()

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -n | --dry-run) dry_run=1 ;;
      -y | --yes) assume_yes=1 ;;
      -h | --help)
        echo "Usage: clean-caches [-n|--dry-run] [-y|--yes] [directory]" >&2
        return 0
        ;;
      -*)
        echo "clean-caches: unknown option: $1" >&2
        return 2
        ;;
      *) root="$1" ;;
    esac
    shift
  done

  [ -d "$root" ] || {
    echo "clean-caches: not a directory: $root" >&2
    return 1
  }
  root="$(cd "$root" && pwd)" || return 1

  while IFS= read -r dir; do
    targets+=("$dir")
  done < <(find "$root" \
    \( -name .git -o -name node_modules -o -name .venv -o -name venv \) -prune -o \
    -type d \( -name __pycache__ -o -name .mypy_cache -o -name .ruff_cache -o -name .pytest_cache \) -prune -print 2>/dev/null)

  while IFS= read -r dir; do
    [ -f "${dir%/*}/Cargo.toml" ] || continue
    targets+=("$dir")
  done < <(find "$root" \
    \( -name .git -o -name node_modules -o -name .venv -o -name venv \) -prune -o \
    -type d -name target -prune -print 2>/dev/null)

  local cargo_home="${CARGO_HOME:-$HOME/.cargo}" cargo_dir
  for cargo_dir in \
    "$cargo_home/registry/cache" \
    "$cargo_home/registry/src" \
    "$cargo_home/git"; do
    [ -d "$cargo_dir" ] && targets+=("$cargo_dir")
  done

  if [ "${#targets[@]}" -eq 0 ]; then
    echo "clean-caches: nothing to clean" >&2
    return 0
  fi

  printf '%s\n' "${targets[@]}"
  du -ch "${targets[@]}" 2>/dev/null | tail -n 1

  if [ "$dry_run" -eq 1 ]; then
    echo "clean-caches: dry run, nothing removed" >&2
    return 0
  fi

  if [ "$assume_yes" -ne 1 ]; then
    printf 'Remove %d paths? [y/N] ' "${#targets[@]}" >&2
    read -r reply || reply=
    case "$reply" in
      [yY]*) ;;
      *)
        echo "clean-caches: aborted" >&2
        return 1
        ;;
    esac
  fi

  rm -rf -- "${targets[@]}"
  echo "clean-caches: removed ${#targets[@]} paths" >&2
}
