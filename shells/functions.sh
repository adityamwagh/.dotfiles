#!/bin/bash
# Shared shell functions for bash and zsh

pp() {
  google-chrome "https://www.perplexity.ai/search?q=$*"
}

g() {
  google-chrome "https://www.google.com/search?q=$*"
}

gai() {
  google-chrome "https://www.google.com/search?udm=50&q=$*"
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
    "$root_dir/terminals/ghostty/config.ghostty" \
    "$root_dir/terminals/wezterm/.wezterm.lua" \
    "$HOME/.config/Code/User/settings.json" \
    "$HOME/.config/Cursor/User/settings.json" \
    "$HOME/.config/Windsurf/User/settings.json"; do
    [ -f "$file" ] || continue
    chfont-replace-file "$file" "$current_font" "$new_font" || return 1
  done
}
