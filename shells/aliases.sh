#!/bin/bash
# Shared aliases for bash and zsh

alias clr="clear"
alias cls="clear"

alias ls='eza --git --group-directories-first'
alias la='eza -a --git --group-directories-first'
alias l='eza -l --git --group-directories-first'
alias ll='eza -lah --git --group-directories-first'
alias tree='eza --tree --group-directories-first'
alias t='eza --tree --level=1 --git --group-directories-first'
alias tt='eza --tree --level=2 --git --group-directories-first'
alias ttt='eza --tree --level=3 --git --group-directories-first'
alias lt='eza --tree --level=1 --long --git --group-directories-first'
alias ltt='eza --tree --level=2 --long --git --group-directories-first'
alias lttt='eza --tree --level=3 --long --git --group-directories-first'
alias lsd='eza --only-dirs --git --group-directories-first'

if command -v ddcutil >/dev/null 2>&1; then
  alias brightness="ddcutil setvcp 10"
fi

alias vi='nvim'
alias vim='nvim'

alias pip='noglob pip'
alias pip3='noglob pip3'
alias uv='noglob uv'

alias aliases='$EDITOR ~/.dotfiles/shells/aliases.sh'
alias envvars='$EDITOR ~/.dotfiles/shells/envvars.sh'
alias bashrc='$EDITOR ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'

alias nvimc='$EDITOR ~/.config/nvim/'
alias zedconf='$EDITOR ~/.config/zed/settings.json'
alias weztermconf='$EDITOR ~/.wezterm.lua'

alias pcra='pre-commit run --color=always --all-files'
alias pci='pre-commit install'

alias gcm='git commit -m'
alias gc-am='git commit --amend'
alias gc-amne='git commit --amend --no-edit'
alias gc-amra='git commit --amend --reset-author'
alias gc='git commit'
alias gp-fwl='git push --force-with-lease'
alias gf='git fetch --prune'
alias gco='git checkout'
alias gs='git status'
alias gpl='git pull'
alias gre='git rebase'
alias gd='git diff'

alias gll='git log --oneline --graph --decorate -10'
alias gla='git log --all --graph --decorate --oneline'
alias gl='git log --oneline --graph --decorate --all'

alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sudo='sudo '

alias update-dotfiles='~/.dotfiles/install'

alias starshipconf='$EDITOR ~/.config/starship.toml'

[ -f "$HOME/.local/shell/aliases.sh" ] && . "$HOME/.local/shell/aliases.sh"
[ -f "$HOME/.local/shell/functions.sh" ] && . "$HOME/.local/shell/functions.sh"
