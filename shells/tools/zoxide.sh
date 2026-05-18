# zoxide init
: "${_ZO_DOCTOR:=0}"
export _ZO_DOCTOR

if [ -n "$ZSH_VERSION" ]; then
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
elif [ -n "$BASH_VERSION" ]; then
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd bash)"
fi
