# .zshrc

[ -f /etc/zshrc ] && . /etc/zshrc
[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

[ -f "$HOME/.dotfiles/shells/tools/homebrew.sh" ] && . "$HOME/.dotfiles/shells/tools/homebrew.sh"

setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups
setopt hist_save_no_dups hist_ignore_dups hist_find_no_dups

HISTSIZE=5000
# shellcheck disable=SC2034
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
# shellcheck disable=SC2034
HISTDUP=erase

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -e

setopt aliases

[ -f "$HOME/.dotfiles/shells/aliases.sh" ]   && . "$HOME/.dotfiles/shells/aliases.sh"
[ -f "$HOME/.dotfiles/shells/functions.sh" ] && . "$HOME/.dotfiles/shells/functions.sh"

fpath+=(~/.zfunc)
autoload -Uz compinit
if [ -n "$(find "$HOME" -maxdepth 1 -name '.zcompdump' -mmin +1440 -print -quit 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi

[ -f "$HOME/.dotfiles/shells/tools/fzf.sh" ] && . "$HOME/.dotfiles/shells/tools/fzf.sh"
[ -f "$HOME/.dotfiles/shells/tools/uv.sh" ]  && . "$HOME/.dotfiles/shells/tools/uv.sh"
[ -f "$HOME/.dotfiles/shells/tools/bun.sh" ] && . "$HOME/.dotfiles/shells/tools/bun.sh"
[ -f "$HOME/.dotfiles/shells/tools/gh.sh" ]  && . "$HOME/.dotfiles/shells/tools/gh.sh"

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_load() { unset -f nvm node npm npx yarn pnpm; . "$NVM_DIR/nvm.sh"; }
  nvm()  { _nvm_load; nvm  "$@"; }
  node() { _nvm_load; node "$@"; }
  npm()  { _nvm_load; npm  "$@"; }
  npx()  { _nvm_load; npx  "$@"; }
  yarn() { _nvm_load; yarn "$@"; }
  pnpm() { _nvm_load; pnpm "$@"; }
fi

[ -f "$HOME/.dotfiles/shells/tools/starship.sh" ] && . "$HOME/.dotfiles/shells/tools/starship.sh"
[ -f "$HOME/.dotfiles/shells/zsh/zsh.sh" ]        && . "$HOME/.dotfiles/shells/zsh/zsh.sh"
[ -f "$HOME/.dotfiles/shells/tools/zoxide.sh" ]   && . "$HOME/.dotfiles/shells/tools/zoxide.sh"
