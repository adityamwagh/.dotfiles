#!/bin/bash
# Shared aliases for bash and zsh

alias clr="/usr/bin/clear"
alias cls="/usr/bin/clear"
alias clear="/usr/bin/clear"

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

alias rm='rm -i'
alias vi='nvim'
alias vim='nvim'

if [ -n "$ZSH_VERSION" ]; then
  alias pip='noglob pip'
  alias pip3='noglob pip3'
  alias uv='noglob uv'
  alias uvrun='noglob uv run --no-sync'
fi
alias bun='bun --no-save'

alias aliases='$EDITOR ~/.config/shell/aliases.sh'
alias envvars='$EDITOR ~/.config/shell/envvars.sh'
alias bashrc='$EDITOR ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'
alias starshipconf='$EDITOR ~/.config/starship.toml'
alias nvimc='$EDITOR ~/.config/nvim/'
alias zedconf='$EDITOR ~/.config/zed/settings.json'
alias contourconf='$EDITOR ~/.var/app/org.contourterminal.Contour/config/contour/contour.yml'

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

alias e='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sudo='sudo env PATH=$PATH'

alias update-dotfiles='chezmoi apply'

# Claude Code runs on LithosAI models through the local LiteLLM proxy (scripts/lithos-claude.sh).
# Remote Control is omitted: it needs a claude.ai login, which the proxy replaces.
alias claude='~/.local/bin/lithos-claude --allow-dangerously-skip-permissions'

# Run mini-swe-agent with the LithosAI key injected from 1Password
if command -v op >/dev/null 2>&1; then
  alias mini="op run --env-file=\$HOME/.config/mini-swe-agent/lithosai.env -- mini"
fi

[ -f "$HOME/.local/shell/aliases.sh" ] && . "$HOME/.local/shell/aliases.sh"
[ -f "$HOME/.local/shell/functions.sh" ] && . "$HOME/.local/shell/functions.sh"
