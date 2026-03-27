# fzf initialization
if [ -n "$ZSH_VERSION" ]; then
  if [ -f ~/.fzf.zsh ]; then
    # shellcheck source=/dev/null
    . ~/.fzf.zsh
  elif command -v fzf > /dev/null 2>&1; then
    eval "$(fzf --zsh)"
  fi
elif [ -n "$BASH_VERSION" ]; then
  if [ -f ~/.fzf.bash ]; then
    # shellcheck source=/dev/null
    . ~/.fzf.bash
  elif command -v fzf > /dev/null 2>&1; then
    eval "$(fzf --bash)"
  fi
fi
