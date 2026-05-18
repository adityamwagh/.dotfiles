# zsh plugins: fzf-tab, autosuggestions, syntax highlighting (load after compinit)
[ -z "$ZSH_VERSION" ] && return

# fzf-tab (must load after compinit, before other plugins)
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]; then
  . "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
fi

# zsh-autosuggestions (load before syntax highlighting)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  . "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f /usr/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
  . /usr/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
elif [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
  . "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
elif [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
  . "$HOMEBREW_PREFIX/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi

if typeset -p FAST_HIGHLIGHT_STYLES >/dev/null 2>&1; then
  _set_fast_style() {
    local key="$1"
    local style="$2"
    # shellcheck disable=SC2004
    FAST_HIGHLIGHT_STYLES[$key]="$style"
    if [ -n "${FAST_THEME_NAME:-}" ]; then
      FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}${key}]="$style"
    fi
  }

  _set_fast_style unknown-token 'fg=red,bold'
  _set_fast_style reserved-word 'fg=yellow'
  _set_fast_style alias 'fg=green,bold'
  _set_fast_style suffix-alias 'fg=cyan,underline'
  _set_fast_style global-alias 'fg=cyan,bold'
  _set_fast_style builtin 'fg=yellow,bold'
  _set_fast_style function 'fg=green,bold'
  _set_fast_style command 'fg=green,bold'
  _set_fast_style precommand 'fg=green,underline'
  _set_fast_style commandseparator 'fg=magenta'
  _set_fast_style hashed-command 'fg=green,bold'
  _set_fast_style subcommand 'fg=11'
  _set_fast_style path-to-dir 'fg=white,underline'
  _set_fast_style globbing 'fg=blue,bold'
  _set_fast_style history-expansion 'fg=blue,bold'
  _set_fast_style double-hyphen-option 'fg=yellow'
  _set_fast_style single-hyphen-option 'fg=yellow'
  _set_fast_style back-quoted-argument 'fg=magenta'
  _set_fast_style single-quoted-argument 'fg=yellow'
  _set_fast_style double-quoted-argument 'fg=yellow'
  _set_fast_style dollar-quoted-argument 'fg=yellow'
  _set_fast_style redirection 'fg=magenta'
  _set_fast_style path 'fg=white,underline'
  _set_fast_style comment 'fg=black,bold'
  _set_fast_style arg0 'fg=green'
  _set_fast_style default 'fg=white'
  _set_fast_style bracket-level-1 'fg=blue,bold'
  _set_fast_style bracket-level-2 'fg=green,bold'
  _set_fast_style bracket-level-3 'fg=magenta,bold'

  unset -f _set_fast_style
fi
