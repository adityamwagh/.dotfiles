#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

if command -v zsh >/dev/null 2>&1; then
  exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
  run_as_root() {
    "$@"
  }
elif command -v sudo >/dev/null 2>&1; then
  run_as_root() {
    sudo "$@"
  }
else
  run_as_root() {
    return 1
  }
fi

install_zsh_with_pkcon() {
  command -v pkcon >/dev/null 2>&1 || return 1
  pkcon install -y zsh
}

install_zsh_with_apt() {
  command -v apt-get >/dev/null 2>&1 || return 1
  run_as_root apt-get update
  run_as_root apt-get install -y zsh
}

install_zsh_with_dnf() {
  command -v dnf >/dev/null 2>&1 || return 1
  run_as_root dnf install -y zsh
}

install_zsh_with_yum() {
  command -v yum >/dev/null 2>&1 || return 1
  run_as_root yum install -y zsh
}

install_zsh_with_pacman() {
  command -v pacman >/dev/null 2>&1 || return 1
  run_as_root pacman -Sy --noconfirm zsh
}

install_zsh_with_zypper() {
  command -v zypper >/dev/null 2>&1 || return 1
  run_as_root zypper --non-interactive install zsh
}

if install_zsh_with_pkcon; then
  exit 0
fi

if install_zsh_with_apt; then
  exit 0
fi

if install_zsh_with_dnf; then
  exit 0
fi

if install_zsh_with_yum; then
  exit 0
fi

if install_zsh_with_pacman; then
  exit 0
fi

if install_zsh_with_zypper; then
  exit 0
fi

echo "Skipping Linux system packages: no supported package manager found for zsh" >&2
exit 0
