# Sync git identity in ~/.gitconfig.local after switching GitHub auth account.

gh_sync_identity() {
  local gh_user gh_id gh_email

  command -v gh >/dev/null 2>&1 || return 0
  gh_user="$(command gh api user --jq .login 2>/dev/null || true)"

  if [ -z "$gh_user" ]; then
    echo "[gh-auth-sync] Could not detect current GitHub user." >&2
    return 0
  fi

  # Prefer the account's public email; fall back to the GitHub noreply address.
  gh_email="$(command gh api user --jq '.email // empty' 2>/dev/null || true)"
  if [ -z "$gh_email" ]; then
    gh_id="$(command gh api user --jq .id 2>/dev/null || true)"
    gh_email="${gh_id:+${gh_id}+}${gh_user}@users.noreply.github.com"
  fi

  git config --file "$HOME/.gitconfig.local" user.name "$gh_user"
  git config --file "$HOME/.gitconfig.local" user.email "$gh_email"
  echo "[gh-auth-sync] Identity set to: $gh_user <$gh_email>"
}

if command -v gh >/dev/null 2>&1; then
  gh() {
    command gh "$@"
    [ "$1" = "auth" ] && [ "$2" = "switch" ] && gh_sync_identity
  }
fi
