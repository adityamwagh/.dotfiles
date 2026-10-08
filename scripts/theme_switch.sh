#!/usr/bin/env bash
# Toggle Plasma between Breeze light and dark and keep the KDE Flatpaks in step.
#
# The KDE Flatpaks (Konsole, Kate, KWrite) get a full copy of the host
# kdeglobals per toggle: their plasma-integration palette only live-updates
# when that per-app file is rewritten (inotify) plus a notifyChange wave —
# verified: with the host file bound read-only instead, the palette is frozen
# at app launch and no signal refreshes it. Non-KDE apps follow the theme
# through the appearance portal and need no per-app state.
# Running instances are told over D-Bus:
#
#   org.kde.KGlobalSettings notifyChange(PaletteChanged) — unicasted to each
#     running KDE app so it re-reads the palette. Must not be broadcast: the
#     Settings portal reacts to the broadcast form and re-emits the previous
#     scheme, which un-flips Chromium apps such as VS Code.
#   org.kde.KGlobalSettings notifyChange(IconChanged)
#     makes running instances re-read [Icons] Theme (safe to broadcast).
#
# Konsole's profile (terminal colours) is swapped for new instances via
# konsolerc and for open sessions over DBus.
#
# Launch-only surfaces (correct after an app relaunch, frozen while running —
# verified against the System Settings Colors KCM, which freezes them too, so
# this is an app/KDE-runtime limitation and no signal fixes it):
#   KWin titlebars: server-side decorations are created per window at
#     creation time (Plasma 5.27 Wayland), so only new windows pick up a
#     theme change.
# Konsole, Kate, KWrite and Haruna are native apt installs (2026-10): a native
# Qt5/KConfig app reads the host kdeglobals directly, so all of them flip
# fully live with no per-app state — verified live for Haruna (whose flatpak
# build froze its QML body) and expected for Kate's toolbar (the flatpak's
# 6.10 runtime Breeze lacked the ToolsAreaManager refresh; Qt5 Breeze has the
# KConfigWatcher path that predates it).
# Do not run this script concurrently (kdeglobals write races observed).
set -euo pipefail

KONSOLE_CONF="$HOME/.config/konsolerc"
LOG="$HOME/.cache/theme_switch.log"

# The shortcut handler launches this script and waits; anything slow here
# blocks KWin and freezes Plasma. Detach onto our own process group first.
if [ "${THEME_SWITCH_DETACHED:-0}" != "1" ]; then
  THEME_SWITCH_DETACHED=1 setsid --fork "$0" "$@" </dev/null >/dev/null 2>&1 &
  exit 0
fi

log() { printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$LOG" 2>/dev/null || true; }

# Best-effort wrapper: capture output to the log, log failures.
run() { "$@" >>"$LOG" 2>&1 || log "failed: $* ($?)"; }

# A global command shortcut launches with a bare environment, so the KDE tools
# crash on a missing display and bus address. Rebuild the session's values.
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
if [ -z "${WAYLAND_DISPLAY:-}" ]; then
  for sock in "$XDG_RUNTIME_DIR"/wayland-[0-9]*; do
    [ -e "$sock" ] || continue
    WAYLAND_DISPLAY=${sock##*/}
    break
  done
fi
WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}"
: "${DISPLAY:=:1}"
: "${DBUS_SESSION_BUS_ADDRESS:=unix:path=$XDG_RUNTIME_DIR/bus}"
if [ -n "$WAYLAND_DISPLAY" ]; then
  : "${QT_QPA_PLATFORM:=wayland}"
  export QT_QPA_PLATFORM
fi
: "${LANG:=en_GB.UTF-8}"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac
export XDG_RUNTIME_DIR WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS LANG PATH

# Copy the host kdeglobals into a Flatpak's config dir and add the scheme and
# icon theme. A full copy rather than a palette-only file: toolbar text needs
# the fonts and widget style too. Drop the [$Version] block so no kconf_update
# script the sandbox happens to ship mutates the copy.
sync_flatpak_config() {
  local app=$1
  local conf_dir="$HOME/.var/app/$app/config"
  flatpak info "$app" >/dev/null 2>&1 || return 0

  # The per-app copy must own the sandbox's kdeglobals; remove the read-only
  # host-file bind if one is present (it would shadow the copy).
  if flatpak info --show-permissions "$app" 2>/dev/null | grep -q 'xdg-config/kdeglobals'; then
    run flatpak override --user --nofilesystem=xdg-config/kdeglobals "$app"
  fi
  mkdir -p "$conf_dir"

  local tmp
  tmp="$(mktemp "$conf_dir/kdeglobals.XXXXXX")"
  sed '/^\[\$Version\]$/,/^$/d' "$HOME/.config/kdeglobals" >"$tmp"
  run kwriteconfig5 --file "$tmp" --group General --key ColorScheme "$scheme"
  run kwriteconfig5 --file "$tmp" --group Icons --key Theme "$icon_theme"
  run mv -f "$tmp" "$conf_dir/kdeglobals"
}

# KDE-runtime Flatpaks are the Qt/KConfig apps whose palette only live-updates
# through a per-app kdeglobals copy; detect them rather than hardcoding.
kde_flatpaks() {
  flatpak list --app --columns=application 2>/dev/null |
    while read -r app _; do
      [ -n "$app" ] || continue
      flatpak info "$app" 2>/dev/null | grep -q 'org\.kde\.Platform' && printf '%s\n' "$app"
    done
}

# Switch tabs that are already open: the Flatpak registers instance-specific
# bus names, so discover them and flip each session's profile. This needs
# EnableSecuritySensitiveDBusAPI=true in the [KonsoleWindow] group of konsolerc.
switch_konsole_sessions() {
  local services svc nodes n
  services="$(gdbus call --session --dest org.freedesktop.DBus \
    --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ListNames 2>/dev/null \
    | tr ',' '\n' | grep -oE 'org\.kde\.konsole[^"]*' | tr -d " '\"")" || true
  log "konsole services: ${services:-none}"
  for svc in $services; do
    nodes="$(gdbus introspect --session --dest "$svc" --object-path /Sessions 2>/dev/null \
      | grep -oE 'node [0-9]+' | awk '{print $2}')" || true
    for n in $nodes; do
      run gdbus call --session --dest "$svc" --object-path "/Sessions/$n" \
        --method org.kde.konsole.Session.setProfile "$profile"
    done
  done
}

# Pick the target scheme, Konsole profile and look-and-feel from the current one.
current="$(kreadconfig5 --file kdeglobals --group General --key ColorScheme)"
if [[ "$current" == *Dark* ]]; then
  scheme="BreezeLight"
  profile="Light"
  profile_file="Light.profile"
else
  scheme="BreezeDark"
  profile="Dark"
  profile_file="Dark.profile"
fi
log "toggle -> scheme=$scheme profile=$profile (was=$current)"

# plasma-apply-colorscheme applies the palette and broadcasts the palette
# change itself — that broadcast is what flips Chromium apps (VS Code, Chrome).
# Do not add plasma-apply-lookandfeel or a manual PaletteChanged wave here:
# both race the portal's reload and leave VS Code on the previous scheme.
run plasma-apply-colorscheme "$scheme"

# ColorSchemeHash is the SHA1 of the applied .colors file, as the colors KCM
# writes; plasma-apply-colorscheme leaves it stale, which makes hash-watching
# apps miss the change.
scheme_file="/usr/share/color-schemes/${scheme}.colors"
if [ -f "$scheme_file" ] && command -v sha1sum >/dev/null 2>&1; then
  run kwriteconfig5 --file kdeglobals --group General --key ColorSchemeHash \
    "$(sha1sum "$scheme_file" | awk '{print $1}')"
fi

# KWin draws the titlebar and is not notified by plasma-apply-colorscheme. Ask
# it to reload in the background: we are started by KWin's shortcut handler, so
# a synchronous call would have KWin wait on us while we wait on KWin.
if command -v qdbus >/dev/null 2>&1; then
  run qdbus org.kde.KWin /KWin org.kde.KWin.reconfigure &
fi

# plasma-apply-colorscheme does not switch the icon theme; set it to match
# the scheme before the icon waves below.
icon_theme="breeze"
[ "$scheme" = "BreezeDark" ] && icon_theme="breeze-dark"
run kwriteconfig5 --file kdeglobals --group Icons --key Theme "$icon_theme"
log "icon theme: $icon_theme"

# Rewrite each KDE-runtime Flatpak's config copy so running instances pick up
# the new palette via inotify; the wave below tells them to re-read it.
if command -v flatpak >/dev/null 2>&1; then
  for app in $(kde_flatpaks); do
    sync_flatpak_config "$app"
  done
fi

# Tell running KDE apps to reload the palette. Unicast, not broadcast: the
# Settings portal reacts to the broadcast form and re-emits the previous
# colour-scheme to the bus, which un-flips Chromium apps such as VS Code
# (verified with dbus-monitor). Targeted delivery reaches Konsole and Kate
# without touching the portal.
if command -v dbus-send >/dev/null 2>&1; then
  palette_services="$(gdbus call --session --dest org.freedesktop.DBus \
    --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ListNames 2>/dev/null \
    | tr ',' '\n' | grep -oE 'org\.kde\.(kate|kwrite|konsole)[^"]*' | tr -d " '\"")" || true
  for svc in $palette_services; do
    run dbus-send --session --type=signal --dest="$svc" /KGlobalSettings \
      org.kde.KGlobalSettings.notifyChange int32:0 int32:0
  done

  # Icon theme: broadcast is safe here — the portal only forwards [Icons]
  # Theme from this signal, which Chromium ignores. notifyChange(IconChanged=4)
  # is what the colors KCM sends; the per-group KIconLoader.iconChanged waves
  # additionally tell toolbars etc. (KIconLoader groups 0..6) to re-read.
  run dbus-send --session --type=signal /KGlobalSettings \
    org.kde.KGlobalSettings.notifyChange int32:4 int32:0
  for group in {0..6}; do
    run dbus-send --session --type=signal /KIconLoader \
      org.kde.KIconLoader.iconChanged int32:"$group"
  done
fi

# New Konsole instances start in the matching profile; Konsole's own light/dark
# sync is disabled in konsolerc for this reason.
if [ -f "$KONSOLE_CONF" ]; then
  sed -i "s|^DefaultProfile=.*|DefaultProfile=${profile_file}|" "$KONSOLE_CONF"
fi

if command -v gdbus >/dev/null 2>&1; then
  switch_konsole_sessions
fi

log "done"
