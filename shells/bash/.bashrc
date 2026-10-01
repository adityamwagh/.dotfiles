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

if [ -n "${brew_bin:-}" ]; then
  # Cache brew shellenv (stable output) to skip ~60ms of brew startup per shell.
  __brew_env="${XDG_CACHE_HOME:-$HOME/.cache}/bash/brew_shellenv.bash"
  mkdir -p "${__brew_env%/*}"
  [ -s "$__brew_env" ] && [ ! "$brew_bin" -nt "$__brew_env" ] || "$brew_bin" shellenv >"$__brew_env"
  # shellcheck source=/dev/null
  . "$__brew_env"
  unset __brew_env
fi
unset brew_bin

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

command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

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

[ -f "$HOME/.dotfiles/shells/tools/gh.sh" ] && . "$HOME/.dotfiles/shells/tools/gh.sh"

# ############################################
# #                   NVM                   #
# ############################################

nvm_lazy_init

# ############################################
# #                   PNPM                  #
# ############################################

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ############################################
# #              CONDA / MAMBA              #
# ############################################

# Lazy init (auto_activate is false); `conda` routes to `mamba`.
mamba_lazy_init bash

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
