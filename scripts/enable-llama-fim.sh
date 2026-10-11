#!/usr/bin/env bash
set -euo pipefail

# Enable and (re)start the local llama.cpp FIM server as a systemd user unit.
# The unit is linked by dotbot; this only activates it. Linux + systemd only.

[ "$(uname -s)" = "Linux" ] || exit 0
command -v systemctl >/dev/null 2>&1 || exit 0
[ -f "$HOME/.config/systemd/user/llama-fim.service" ] || exit 0

systemctl --user daemon-reload
systemctl --user enable --now llama-fim.service