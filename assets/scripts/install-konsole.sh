#!/usr/bin/env bash
# Install Konsole on macOS from KDE's CI build (no Homebrew cask exists).
#
# KDE publishes notarization-less Developer ID builds per architecture; the
# latest DMG is listed in the directory index, so resolve it from there rather
# than pinning a build number. Konsole is a Linux-first app, so this is the
# only supported way to run it on macOS.
set -euo pipefail

BASE_URL="https://cdn.kde.org/ci-builds/utilities/konsole/master/macos-arm64/"
APP="/Applications/konsole.app"

[ "$(uname)" = "Darwin" ] || exit 0

if [ -d "$APP" ]; then
  printf 'Konsole already installed: %s\n' "$APP"
  exit 0
fi

[ "$(uname -m)" = "arm64" ] || {
  printf 'Only arm64 KDE CI builds are published; skipping on %s.\n' "$(uname -m)"
  exit 0
}

# KDE CI publishes a moving, unchecksummed build; require an explicit opt-in.
if [ "${KONSOLE_ALLOW_UNPINNED:-0}" != "1" ]; then
  printf 'install-konsole: skipping unpinned KDE CI download; set KONSOLE_ALLOW_UNPINNED=1 to allow it.\n' >&2
  exit 0
fi

work="$(mktemp -d)"
mount="$work/mnt"
trap 'hdiutil detach "$mount" >/dev/null 2>&1 || true; rm -rf "$work"' EXIT

# The index lists exactly one DMG; take its href rather than guessing the name.
index="$(curl -fsSL "$BASE_URL")"
dmg_name="$(printf '%s\n' "$index" | grep -oE 'konsole-[^"]+\.dmg' | sed -n '1p')"
[ -n "$dmg_name" ] || {
  printf 'Could not find a Konsole DMG at %s\n' "$BASE_URL" >&2
  exit 1
}

curl -fsSL -o "$work/konsole.dmg" "$BASE_URL$dmg_name"
mkdir -p "$mount"
hdiutil attach -nobrowse -readonly "$work/konsole.dmg" -mountpoint "$mount" >/dev/null

cp -R "$mount/konsole.app" /Applications/
# The CI build is signed but not notarized, so Gatekeeper blocks it otherwise.
xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
