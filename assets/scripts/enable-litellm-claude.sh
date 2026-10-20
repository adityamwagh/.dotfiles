#!/usr/bin/env bash
set -euo pipefail

# Serve the LiteLLM Claude→LithosAI proxy on 127.0.0.1:4001 as a user service.
#
# Runs as a launchd agent on macOS and a systemd user unit on Linux so the
# first `claude` of the session never waits for LiteLLM's ~3s startup.
# The key is read from ~/.env at service start and never written to disk here.

port=4001
config="$HOME/.config/litellm/claude.yaml"
label=cloud.lithosai.claude-proxy
plist="$HOME/Library/LaunchAgents/$label.plist"
unit="$HOME/.config/systemd/user/lithos-claude-proxy.service"
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/litellm"

[ -f "$config" ] || exit 0

# Prefer the litellm on PATH, falling back to uv's default tool bin dir.
litellm_bin=$(command -v litellm || true)
if [ -z "$litellm_bin" ] && [ -x "$HOME/.local/bin/litellm" ]; then
  litellm_bin="$HOME/.local/bin/litellm"
fi
[ -n "$litellm_bin" ] || exit 0

case "$(uname -s)" in
  Darwin)
    command -v launchctl >/dev/null 2>&1 || exit 0
    mkdir -p "$log_dir" "$(dirname "$plist")"
    cat >"$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-lc</string>
    <string>[ -f "\$HOME/.env" ] &amp;&amp; . "\$HOME/.env"; exec "$litellm_bin" --config "$config" --host 127.0.0.1 --port $port</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ThrottleInterval</key><integer>10</integer>
  <key>StandardOutPath</key><string>$log_dir/lithos-claude-proxy.log</string>
  <key>StandardErrorPath</key><string>$log_dir/lithos-claude-proxy.log</string>
</dict>
</plist>
EOF
    launchctl bootout "gui/$(id -u)/$label" >/dev/null 2>&1 || true
    launchctl bootstrap "gui/$(id -u)" "$plist"
    launchctl enable "gui/$(id -u)/$label"
    launchctl kickstart -k "gui/$(id -u)/$label"
    ;;
  Linux)
    command -v systemctl >/dev/null 2>&1 || exit 0
    systemctl --user show-environment >/dev/null 2>&1 || exit 0
    mkdir -p "$log_dir" "$(dirname "$unit")"
    cat >"$unit" <<EOF
[Unit]
Description=LiteLLM proxy serving Claude Code on LithosAI models
After=network-online.target

[Service]
Type=simple
EnvironmentFile=-%h/.env
ExecStart=$litellm_bin --config $config --host 127.0.0.1 --port $port
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable --now lithos-claude-proxy.service
    systemctl --user restart lithos-claude-proxy.service
    ;;
  *) exit 0 ;;
esac

# Give it a moment, then report whether the proxy actually came up.
for _ in $(seq 1 60); do
  if curl -fsS -m 1 "http://127.0.0.1:$port/health/liveliness" >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done
echo "lithos-claude-proxy did not become healthy; see $log_dir/lithos-claude-proxy.log" >&2
exit 1
