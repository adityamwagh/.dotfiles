# .zshrc

# ############################################
# #               SYSTEM RC                 #
# ############################################

[ -f /etc/zshrc ] && . /etc/zshrc

# ############################################
# #                 ENV VARS                #
# ############################################

[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

# ############################################
# #                HOMEBREW                 #
# ############################################

brew_bin=""
if   [ -n "${HOMEBREW_PREFIX:-}" ] && [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
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

fpath+=(~/.zfunc)
autoload -Uz compinit
zstyle ':completion:*' menu select
# shellcheck disable=SC2296
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
if [ -n "$(find "$HOME" -maxdepth 1 -name '.zcompdump' -mmin +1440 -print -quit 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi

# ############################################
# #                 HISTORY                 #
# ############################################

setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups
setopt hist_save_no_dups hist_ignore_dups hist_find_no_dups EXTENDED_HISTORY

HISTSIZE=5000
# shellcheck disable=SC2034
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
# shellcheck disable=SC2034
HISTDUP=erase

# ############################################
# #             SHELL OPTIONS               #
# ############################################

setopt AUTO_CD NO_BEEP GLOB_DOTS aliases

# ############################################
# #              KEYBINDINGS                #
# ############################################

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -e

# ############################################
# #          ALIASES & FUNCTIONS            #
# ############################################

[ -f "$HOME/.dotfiles/shells/aliases.sh" ] && . "$HOME/.dotfiles/shells/aliases.sh"
[ -f "$HOME/.dotfiles/shells/functions.sh" ] && . "$HOME/.dotfiles/shells/functions.sh"

# ############################################
# #                   FZF                   #
# ############################################

if [ -f ~/.fzf.zsh ]; then
  # shellcheck source=/dev/null
  . ~/.fzf.zsh
elif command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# ############################################
# #             UV COMPLETIONS              #
# ############################################

if command -v uv  >/dev/null 2>&1; then eval "$(uv  generate-shell-completion zsh  2>/dev/null)"; fi
if command -v uvx >/dev/null 2>&1; then eval "$(uvx --generate-shell-completion zsh  2>/dev/null)"; fi

# ############################################
# #                   BUN                   #
# ############################################

export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
[ -s "$HOME/.bun/_bun" ] && . "$HOME/.bun/_bun"

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
    adityamwagh) expected_name="adityamwagh"; expected_email="adityamwagh@outlook.com" ;;
    adityamwagh)    expected_name="adityamwagh";    expected_email="adityamwagh@outlook.com"   ;;
    *)
      echo "[gh-auth-sync] Unknown user '$gh_user'; git identity unchanged." >&2
      return 0
      ;;
  esac

  git config --global user.name  "$expected_name"
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
  nvm_load() { unset -f nvm node npm npx yarn pnpm; . "$NVM_DIR/nvm.sh"; }
  nvm()  { nvm_load; nvm  "$@"; }
  node() { nvm_load; node "$@"; }
  npm()  { nvm_load; npm  "$@"; }
  npx()  { nvm_load; npx  "$@"; }
  yarn() { nvm_load; yarn "$@"; }
  pnpm() { nvm_load; pnpm "$@"; }
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

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ############################################
# #              ZSH PLUGINS                #
# #         (load after compinit)           #
# ############################################

# fzf-tab (must load after fzf, before other plugins)
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -f "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]; then
  . "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
fi

# zsh-autosuggestions
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  . "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

zle_highlight+=(paste:none) # no background on pasted text

# ############################################
# #                  ZOXIDE                 #
# ############################################

: "${_ZO_DOCTOR:=0}"
export _ZO_DOCTOR
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

# ############################################
# #          SYNTAX HIGHLIGHTING            #
# ############################################

# zsh-patina must initialize at the end of .zshrc
command -v zsh-patina >/dev/null 2>&1 && eval "$(zsh-patina activate)"
