#!/usr/bin/env bash

# VS Code / Cursor
SETTINGS="${HOME}/.config/Code/User/settings.json"
CURSOR_SETTINGS="${HOME}/.config/Cursor/User/settings.json"

[ -f "$SETTINGS" ] && sed -i 's/"workbench\.colorTheme":\s*"[^"]*"/"workbench.colorTheme": "Gruvbox Light Soft"/' "$SETTINGS" && \
  sed -i 's/"workbench\.preferredDarkColorTheme":\s*"[^"]*"/"workbench.preferredDarkColorTheme": "Gruvbox Light Soft"/' "$SETTINGS" && \
  sed -i 's/"workbench\.preferredLightColorTheme":\s*"[^"]*"/"workbench.preferredLightColorTheme": "Gruvbox Light Soft"/' "$SETTINGS"

[ -f "$CURSOR_SETTINGS" ] && sed -i 's/"workbench\.colorTheme":\s*"[^"]*"/"workbench.colorTheme": "Gruvbox Light Soft"/' "$CURSOR_SETTINGS" && \
  sed -i 's/"workbench\.preferredDarkColorTheme":\s*"[^"]*"/"workbench.preferredDarkColorTheme": "Gruvbox Light Soft"/' "$CURSOR_SETTINGS" && \
  sed -i 's/"workbench\.preferredLightColorTheme":\s*"[^"]*"/"workbench.preferredLightColorTheme": "Gruvbox Light Soft"/' "$CURSOR_SETTINGS" && \
  touch "$CURSOR_SETTINGS"

# Helix
HELIX_CONFIG="${HOME}/.config/helix/config.toml"
[ -f "$HELIX_CONFIG" ] && sed -i 's/theme = "[^"]*"/theme = "gruvbox_light_soft"/' "$HELIX_CONFIG" && pgrep -x hx >/dev/null && pkill -USR1 -x hx

# OpenCode
# Note: OpenCode doesn't support SIGUSR1 for theme reloading (feature requested in issue #815)
# We modify the config file; changes apply on next launch or via /theme command in TUI
OPENCODE_CONFIG="${HOME}/.config/opencode/opencode.json"
if [ -f "$OPENCODE_CONFIG" ]; then
  sed -i 's/"theme":\s*"[^"]*"/"theme": "gruvbox-light-soft"/' "$OPENCODE_CONFIG"
fi