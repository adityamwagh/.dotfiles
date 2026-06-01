# .bashrc

# ############################################
# #               SYSTEM RC                 #
# ############################################

case "$(uname -s)" in
  Linux*) [ -f /etc/bashrc ] && . /etc/bashrc ;;
  Darwin*) [ -f /etc/bash.bashrc ] && . /etc/bash.bashrc ;;
esac

# ############################################
# #                 ENV VARS                #
# ############################################

[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

# ############################################
# #                HOMEBREW                 #
# ############################################

brew_bin=""
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
  brew_bin="${HOMEBREW_PREFIX}/bin/brew"
elif command -v brew >/dev/null 2>&1; then
  brew_bin="$(command -v brew)"
elif [ -x /opt/homebrew/bin/brew ]; then
  brew_bin="/opt/homebrew/bin/brew"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  brew_bin="$HOME/.linuxbrew/bin/brew"
fi

[ -n "$brew_bin" ] && eval "$("$brew_bin" shellenv)"

# Keep Linux system tools ahead of Homebrew by appending brew paths.
if [ "$(uname -s)" = "Linux" ] && [ -n "${HOMEBREW_PREFIX:-}" ]; then
  PATH=":${PATH}:"
  PATH="${PATH//:${HOMEBREW_PREFIX}\/bin:/:}"
  PATH="${PATH//:${HOMEBREW_PREFIX}\/sbin:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
  export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
fi

# ############################################
# #              COMPLETIONS                #
# ############################################

if [ -n "${HOMEBREW_PREFIX:-}" ]; then
  if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
    . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
  elif [ -r "$HOMEBREW_PREFIX/share/bash-completion/bash_completion" ]; then
    . "$HOMEBREW_PREFIX/share/bash-completion/bash_completion"
  fi
fi

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set colored-completion-prefix on'
bind 'set mark-symlinked-directories on'

# ############################################
# #                 HISTORY                 #
# ############################################

HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T "
export HISTFILE=~/.bash_history
export HISTSIZE HISTFILESIZE HISTTIMEFORMAT

# ############################################
# #             SHELL OPTIONS               #
# ############################################

shopt -s histappend autocd cdspell dirspell globstar checkwinsize expand_aliases

PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# ############################################
# #              KEYBINDINGS                #
# ############################################

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# ############################################
# #          ALIASES & FUNCTIONS            #
# ############################################

[ -f "$HOME/.dotfiles/shells/aliases.sh" ] && . "$HOME/.dotfiles/shells/aliases.sh"
[ -f "$HOME/.dotfiles/shells/functions.sh" ] && . "$HOME/.dotfiles/shells/functions.sh"

# ############################################
# #                   FZF                   #
# ############################################

if [ -f ~/.fzf.bash ]; then
  # shellcheck source=/dev/null
  . ~/.fzf.bash
elif command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# ############################################
# #             UV COMPLETIONS              #
# ############################################

if command -v uv >/dev/null 2>&1; then eval "$(uv generate-shell-completion bash 2>/dev/null)"; fi
if command -v uvx >/dev/null 2>&1; then eval "$(uvx --generate-shell-completion bash 2>/dev/null)"; fi

# ############################################
# #                   BUN                   #
# ############################################

export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac

# ############################################
# #                    GH                   #
# ############################################

gh_sync_identity() {
  local gh_user expected_name expected_email

  command -v gh >/dev/null 2>&1 || return 0
  gh_user="$(command gh api user --jq .login 2>/dev/null || true)"

  if [ -z "$gh_user" ]; then
    echo "[gh-auth-sync] Could not detect current GitHub user." >&2
    return 0
  fi

  case "$gh_user" in
    adityamwagh)
      expected_name="adityamwagh"
      expected_email="adityamwagh@outlook.com"
      ;;
    adityamwagh)
      expected_name="adityamwagh"
      expected_email="adityamwagh@outlook.com"
      ;;
    *)
      echo "[gh-auth-sync] Unknown user '$gh_user'; git identity unchanged." >&2
      return 0
      ;;
  esac

  git config --global user.name "$expected_name"
  git config --global user.email "$expected_email"
  echo "[gh-auth-sync] Identity set to: $expected_name <$expected_email>"
}

if command -v gh >/dev/null 2>&1; then
  gh() {
    command gh "$@"
    [ "$1" = "auth" ] && [ "$2" = "switch" ] && gh_sync_identity
  }
fi

# ############################################
# #                   NVM                   #
# ############################################

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm_load() {
    unset -f nvm node npm npx yarn pnpm
    . "$NVM_DIR/nvm.sh"
  }
  nvm() {
    nvm_load
    nvm "$@"
  }
  node() {
    nvm_load
    node "$@"
  }
  npm() {
    nvm_load
    npm "$@"
  }
  npx() {
    nvm_load
    npx "$@"
  }
  yarn() {
    nvm_load
    yarn "$@"
  }
  pnpm() {
    nvm_load
    pnpm "$@"
  }
fi

# ############################################
# #                   PNPM                  #
# ############################################

export PNPM_HOME="/home/aditya/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ############################################
# #                 STARSHIP                #
# ############################################

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# ############################################
# #                  ZOXIDE                 #
# ############################################

: "${_ZO_DOCTOR:=0}"
export _ZO_DOCTOR
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd bash)"
