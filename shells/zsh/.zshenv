# Keep this minimal; sourced by every zsh invocation

if [ -z "${PATH-}" ]; then
  PATH="/usr/bin:/bin"
fi

typeset -U path
if ((${path[(I) / usr / bin]} == 0)); then
  # shellcheck disable=SC2206
  path=(/usr/bin /bin $path)
fi
export PATH
