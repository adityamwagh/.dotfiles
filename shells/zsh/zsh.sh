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

zle_highlight+=(paste:none) # no background on pasted text

# zsh-patina syntax highlighting (must initialize last)
command -v zsh-patina >/dev/null 2>&1 && eval "$(zsh-patina activate)"
