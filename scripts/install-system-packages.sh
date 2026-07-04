#!/usr/bin/env bash
set -euo pipefail

# Install the given system packages (by command name) with the native Linux
# package manager. Idempotent: exits without sudo when nothing is missing.

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

[ "$#" -gt 0 ] || exit 0

missing=()
for pkg in "$@"; do
  command -v "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
done

if [ "${#missing[@]}" -eq 0 ]; then
  exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
  as_root() { "$@"; }
elif command -v sudo >/dev/null 2>&1; then
  as_root() { sudo "$@"; }
else
  echo "Skipping system packages (${missing[*]}): not root and sudo unavailable" >&2
  exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
  as_root apt-get update
  as_root apt-get install -y "${missing[@]}"
elif command -v dnf >/dev/null 2>&1; then
  as_root dnf install -y "${missing[@]}"
elif command -v yum >/dev/null 2>&1; then
  as_root yum install -y "${missing[@]}"
elif command -v pacman >/dev/null 2>&1; then
  as_root pacman -Sy --noconfirm "${missing[@]}"
elif command -v zypper >/dev/null 2>&1; then
  as_root zypper --non-interactive install "${missing[@]}"
else
  echo "Skipping system packages (${missing[*]}): no supported package manager" >&2
fi
