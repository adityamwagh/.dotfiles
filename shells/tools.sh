# Shared tool initializations

has_fzf=$(command -v fzf 2>/dev/null)
has_starship=$(command -v starship 2>/dev/null)
has_uv=$(command -v uv 2>/dev/null)
has_uvx=$(command -v uvx 2>/dev/null)
has_zoxide=$(command -v zoxide 2>/dev/null)

# fzf initialization
if [ -n "$ZSH_VERSION" ]; then
  if [ -f ~/.fzf.zsh ]; then
    # shellcheck source=/dev/null
    . ~/.fzf.zsh
  elif [ -n "$has_fzf" ]; then
    eval "$("$has_fzf" --zsh)"
  fi
elif [ -n "$BASH_VERSION" ]; then
  if [ -f ~/.fzf.bash ]; then
    # shellcheck source=/dev/null
    . ~/.fzf.bash
  elif [ -n "$has_fzf" ]; then
    eval "$("$has_fzf" --bash)"
  fi
fi

# Starship prompt
if [ -n "$ZSH_VERSION" ] && [ -n "$has_starship" ]; then
  eval "$("$has_starship" init zsh)"
elif [ -n "$BASH_VERSION" ] && [ -n "$has_starship" ]; then
  eval "$("$has_starship" init bash)"
fi

# uv completions
if [ -n "$ZSH_VERSION" ]; then
  [ -n "$has_uv" ] && eval "$("$has_uv" generate-shell-completion zsh 2>/dev/null)"
  [ -n "$has_uvx" ] && eval "$("$has_uvx" --generate-shell-completion zsh 2>/dev/null)"
elif [ -n "$BASH_VERSION" ]; then
  [ -n "$has_uv" ] && eval "$("$has_uv" generate-shell-completion bash 2>/dev/null)"
  [ -n "$has_uvx" ] && eval "$("$has_uvx" --generate-shell-completion bash 2>/dev/null)"
fi

# bun completions
[ -n "$ZSH_VERSION" ] && [ -s "$HOME/.bun/_bun" ] && . "$HOME/.bun/_bun"

# zoxide
export _ZO_DOCTOR="${_ZO_DOCTOR:-0}"

if [ -n "$ZSH_VERSION" ] && [ -n "$has_zoxide" ]; then
  eval "$("$has_zoxide" init --cmd cd zsh)"
elif [ -n "$BASH_VERSION" ] && [ -n "$has_zoxide" ]; then
  eval "$("$has_zoxide" init --cmd cd bash)"
fi
