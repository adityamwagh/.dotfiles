# Shared tool initializations

has_fzf=$(command -v fzf 2>/dev/null)
has_gh=$(command -v gh 2>/dev/null)
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

# Sync global git identity after switching GitHub auth account.

__dotfiles_set_git_identity_from_gh_user() {
  local gh_user="$1"
  local expected_name=""
  local expected_email=""

  case "$gh_user" in
  aditya-neuraco)
    expected_name="aditya-neuraco"
    expected_email="aditya.wagh@neuracore.com"
    ;;
  adityamwagh)
    expected_name="adityamwagh"
    expected_email="adityamwagh@outlook.com"
    ;;
  *)
    echo "[gh-auth-sync] Unknown GitHub user '$gh_user'; leaving git global identity unchanged." >&2
    return 0
    ;;
  esac

  git config --global user.name "$expected_name"
  git config --global user.email "$expected_email"
  echo "[gh-auth-sync] Set git global identity to: $expected_name <$expected_email>"
}

__dotfiles_sync_git_identity_from_gh() {
  local gh_user

  gh_user="$(command gh api user --jq .login 2> /dev/null || true)"
  if [ -z "$gh_user" ]; then
    echo "[gh-auth-sync] Could not detect current GitHub user; leaving git global identity unchanged." >&2
    return 0
  fi

  __dotfiles_set_git_identity_from_gh_user "$gh_user"
}

if [ -n "$has_gh" ]; then
  gh() {
    if [ "$#" -ge 2 ] && [ "$1" = "auth" ] && [ "$2" = "switch" ]; then
      command gh "$@" || return $?
      __dotfiles_sync_git_identity_from_gh || true
      return 0
    fi

    command gh "$@"
  }
fi

# Starship prompt
if [ -n "$ZSH_VERSION" ] && [ -n "$has_starship" ]; then
  eval "$("$has_starship" init zsh)"
elif [ -n "$BASH_VERSION" ] && [ -n "$has_starship" ]; then
  eval "$("$has_starship" init bash)"
fi

# uv completions
if [ -n "$ZSH_VERSION" ]; then
  [ -n "$has_uv" ]  && eval "$("$has_uv"  generate-shell-completion zsh 2>/dev/null)"
  [ -n "$has_uvx" ] && eval "$("$has_uvx" --generate-shell-completion zsh 2>/dev/null)"
elif [ -n "$BASH_VERSION" ]; then
  [ -n "$has_uv" ]  && eval "$("$has_uv"  generate-shell-completion bash 2>/dev/null)"
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
