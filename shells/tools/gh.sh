# Sync global git identity after switching GitHub auth account.

__dotfiles_set_git_identity_from_gh_user() {
  local gh_user="$1"
  local expected_name=""
  local expected_email=""

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
    echo "[gh-auth-sync] Unknown GitHub user '$gh_user'; leaving git global identity unchanged." >&2
    return 0
    ;;
  esac

  git config --global user.name "$expected_name"
  git config --global user.email "$expected_email"
  echo "[gh-auth-sync] Set git global identity to: $expected_name <$expected_email>"
}

__dotfiles_sync_git_identity_from_gh() {
  local gh_user

  if ! command -v gh > /dev/null 2>&1; then
    return 0
  fi

  gh_user="$(command gh api user --jq .login 2> /dev/null || true)"
  if [ -z "$gh_user" ]; then
    echo "[gh-auth-sync] Could not detect current GitHub user; leaving git global identity unchanged." >&2
    return 0
  fi

  __dotfiles_set_git_identity_from_gh_user "$gh_user"
}

if command -v gh > /dev/null 2>&1; then
  gh() {
    if [ "$#" -ge 2 ] && [ "$1" = "auth" ] && [ "$2" = "switch" ]; then
      command gh "$@" || return $?
      __dotfiles_sync_git_identity_from_gh
      return $?
    fi

    command gh "$@"
  }
fi
