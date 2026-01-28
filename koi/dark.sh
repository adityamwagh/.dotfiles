#!/usr/bin/env bash

# VS Code / Cursor
SETTINGS="${HOME}/.config/Code/User/settings.json"
CURSOR_SETTINGS="${HOME}/.config/Cursor/User/settings.json"

[ -f "$SETTINGS" ] && sed -i 's/"workbench\.colorTheme":\s*"[^"]*"/"workbench.colorTheme": "Gruvbox Dark Hard"/' "$SETTINGS" && \
  sed -i 's/"workbench\.preferredDarkColorTheme":\s*"[^"]*"/"workbench.preferredDarkColorTheme": "Gruvbox Dark Hard"/' "$SETTINGS" && \
  sed -i 's/"workbench\.preferredLightColorTheme":\s*"[^"]*"/"workbench.preferredLightColorTheme": "Gruvbox Dark Hard"/' "$SETTINGS"

[ -f "$CURSOR_SETTINGS" ] && sed -i 's/"workbench\.colorTheme":\s*"[^"]*"/"workbench.colorTheme": "Gruvbox Dark Hard"/' "$CURSOR_SETTINGS" && \
  sed -i 's/"workbench\.preferredDarkColorTheme":\s*"[^"]*"/"workbench.preferredDarkColorTheme": "Gruvbox Dark Hard"/' "$CURSOR_SETTINGS" && \
  sed -i 's/"workbench\.preferredLightColorTheme":\s*"[^"]*"/"workbench.preferredLightColorTheme": "Gruvbox Dark Hard"/' "$CURSOR_SETTINGS" && \
  touch "$CURSOR_SETTINGS"

# Helix
HELIX_CONFIG="${HOME}/.config/helix/config.toml"
[ -f "$HELIX_CONFIG" ] && sed -i 's/theme = "[^"]*"/theme = "gruvbox_dark_hard"/' "$HELIX_CONFIG" && pgrep -x hx >/dev/null && pkill -USR1 -x hx

# OpenCode
OPENCODE_CONFIG="${HOME}/.config/opencode/opencode.json"
[ -f "$OPENCODE_CONFIG" ] && sed -i 's/"theme":\s*"[^"]*"/"theme": "gruvbox-dark-hard"/' "$OPENCODE_CONFIG"

# Konsole - switch profile via dbus (runs after system color scheme change)
# This makes Konsole change at the same pace as other KDE apps
for konsole in $(qdbus | grep org.kde.konsole); do
  # Switch all existing sessions to Dark profile
  for session in $(qdbus "$konsole" | grep /Sessions/); do
    qdbus "$konsole" "$session" org.kde.konsole.Session.setProfile "Dark" 2>/dev/null || true
  done
  # Set default profile for new tabs in each window
  for window in $(qdbus "$konsole" | grep /Windows/); do
    qdbus "$konsole" "$window" org.kde.konsole.Window.setDefaultProfile "Dark" 2>/dev/null || true
  done
done

# Konsole - update default profile in config for new Konsole windows
KONSOLERC="${HOME}/.config/konsolerc"
[ -f "$KONSOLERC" ] && sed -i 's/^DefaultProfile=.*/DefaultProfile=Dark.profile/' "$KONSOLERC"