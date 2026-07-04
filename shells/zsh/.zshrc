# .zshrc

# ############################################
# #               SYSTEM RC                 #
# ############################################

# Source system zshrc once per session; it re-runs all /etc/profile.d/*.sh
# (~60ms) which only need to set up the exported env once. Children inherit it.
[ -z "$ETC_ZSHRC_DONE" ] && [ -f /etc/zshrc ] && { . /etc/zshrc; export ETC_ZSHRC_DONE=1; }

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
zstyle ':completion:*:descriptions' format '%d'
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
# Full compinit only if the dump is missing or >1 day old, else fast cached path.
# The glob qualifier (#qN.md+1) tests age natively — no `find $HOME` subprocess.
if [[ -n ~/.zcompdump(#qN.md+1) ]]; then
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

[ -f "$HOME/.dotfiles/shells/tools/gh.sh" ] && . "$HOME/.dotfiles/shells/tools/gh.sh"

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

expand-alias-or-space() {
  zle _expand_alias 2>/dev/null
  zle self-insert
}
zle -N expand-alias-or-space
bindkey ' ' expand-alias-or-space

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
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# opencode
export PATH=/home/aditya/.opencode/bin:$PATH
