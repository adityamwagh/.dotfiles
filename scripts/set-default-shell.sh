#!/usr/bin/env bash
set -euo pipefail

zsh_bin=""
for candidate in /usr/bin/zsh /bin/zsh; do
  if [ -x "$candidate" ] && grep -Fxq "$candidate" /etc/shells 2>/dev/null; then
    zsh_bin="$candidate"
    break
  fi
done

if [ -z "$zsh_bin" ]; then
  echo "Skipping shell switch: no registered zsh found" >&2
  exit 0
fi

user_name="${USER:-$(id -un)}"
current_shell=""
if command -v getent >/dev/null 2>&1; then
  current_shell="$(getent passwd "$user_name" | awk -F: '{print $7}' 2>/dev/null || true)"
fi
if [ -z "$current_shell" ] && command -v dscl >/dev/null 2>&1; then
  current_shell="$(dscl . -read "/Users/$user_name" UserShell 2>/dev/null | awk '{print $2}' || true)"
fi
if [ -z "$current_shell" ]; then
  current_shell="${SHELL:-}"
fi

if [ "$current_shell" = "$zsh_bin" ]; then
  exit 0
fi

if ! command -v chsh >/dev/null 2>&1; then
  echo "Skipping shell switch: chsh not found" >&2
  exit 0
fi

# chsh prompts for a password; close stdin and fall back to passwordless sudo.
if ! chsh -s "$zsh_bin" "$user_name" </dev/null 2>/dev/null; then
  if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo chsh -s "$zsh_bin" "$user_name"
  else
    echo "Skipping shell switch: chsh needs authentication" >&2
    exit 0
  fi
fi
echo "Set login shell to $zsh_bin"
