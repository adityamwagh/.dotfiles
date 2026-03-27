# .bashrc

case "$(uname -s)" in
  Linux*)  [ -f /etc/bashrc ]      && . /etc/bashrc ;;
  Darwin*) [ -f /etc/bash.bashrc ] && . /etc/bash.bashrc ;;
esac

[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

[ -f "$HOME/.dotfiles/shells/tools/homebrew.sh" ] && . "$HOME/.dotfiles/shells/tools/homebrew.sh"

if [ -n "${HOMEBREW_PREFIX:-}" ]; then
  if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
    . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
  elif [ -r "$HOMEBREW_PREFIX/share/bash-completion/bash_completion" ]; then
    . "$HOMEBREW_PREFIX/share/bash-completion/bash_completion"
  fi
fi

HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:la:ll:cd:cd -:pwd:exit:clear"
export HISTFILE=~/.bash_history
export HISTSIZE
export HISTFILESIZE

shopt -s expand_aliases

[ -f "$HOME/.dotfiles/shells/aliases.sh" ]   && . "$HOME/.dotfiles/shells/aliases.sh"
[ -f "$HOME/.dotfiles/shells/functions.sh" ] && . "$HOME/.dotfiles/shells/functions.sh"

[ -f "$HOME/.dotfiles/shells/tools/fzf.sh" ] && . "$HOME/.dotfiles/shells/tools/fzf.sh"
[ -f "$HOME/.dotfiles/shells/tools/uv.sh" ]  && . "$HOME/.dotfiles/shells/tools/uv.sh"
[ -f "$HOME/.dotfiles/shells/tools/bun.sh" ] && . "$HOME/.dotfiles/shells/tools/bun.sh"
[ -f "$HOME/.dotfiles/shells/tools/gh.sh" ]  && . "$HOME/.dotfiles/shells/tools/gh.sh"

[ -f "$HOME/.dotfiles/shells/tools/starship.sh" ] && . "$HOME/.dotfiles/shells/tools/starship.sh"
[ -f "$HOME/.dotfiles/shells/tools/zoxide.sh" ]   && . "$HOME/.dotfiles/shells/tools/zoxide.sh"
