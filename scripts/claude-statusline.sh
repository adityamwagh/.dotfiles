#!/usr/bin/env bash
set -euo pipefail

# Claude Code statusline: starship's claude-code profile plus the fields
# starship's claude_* modules ignore. Reads the session JSON on stdin.
#
# Line 1: starship renders model, git branch, context gauge and cost.
# Line 2: effort level and rate limits, read straight from the JSON, since
#   starship 1.26.0's claude modules drop rate_limits (and have no $effort).

input=$(cat)

# Starship prints its line without a trailing newline, and pads the end with a
# space. Capture it, strip the trailing space, then append our fields.
line1=""
if command -v starship >/dev/null 2>&1; then
  line1=$(printf '%s' "$input" | starship statusline claude-code || true)
  # Trim a single trailing space left by starship's format padding.
  line1="${line1% }"
fi

# Without jq we can still show starship's line; skip the appended fields.
if ! command -v jq >/dev/null 2>&1; then
  [ -n "$line1" ] && printf '%s\n' "$line1"
  exit 0
fi

# Reasoning effort; absent when the model does not support the parameter.
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')

# Rate limit windows (claude.ai Pro/Max; absent otherwise). Each window is
# dropped by Claude Code once its resets_at passes. Resets are epoch seconds;
# render them as local clock time like cship's "5h {pct}% ({reset})".
limits=""
five_pct=""
seven_pct=""
five_hour=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour | select(.used_percentage != null) | "\(.used_percentage) \(.resets_at // empty)"')
seven_day=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day | select(.used_percentage != null) | "\(.used_percentage) \(.resets_at // empty)"')

window=""
if [ -n "$five_hour" ]; then
  five_pct=${five_hour%% *}
  reset=${five_hour#* }
  window="5h $(printf '%.0f' "$five_pct")%"
  [ -n "$reset" ] && window="$window ($(date -d "@$reset" +%H:%M 2>/dev/null || echo "$reset"))"
  limits="$window"
fi
if [ -n "$seven_day" ]; then
  seven_pct=${seven_day%% *}
  reset=${seven_day#* }
  window="7d $(printf '%.0f' "$seven_pct")%"
  [ -n "$reset" ] && window="$window ($(date -d "@$reset" '+%a %H:%M' 2>/dev/null || echo "$reset"))"
  limits="${limits:+$limits }$window"
fi

# Spend limit (Claude apps gateway only): dollars when reported, else percent.
spend_pct=$(printf '%s' "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty')
spend_usd=$(printf '%s' "$input" | jq -r '.rate_limits.spend_limit | select(.used_usd != null) | "$\(.used_usd)/$\(.limit_usd)"')
if [ -n "$spend_pct" ]; then
  limits="${limits:+$limits }spend ${spend_usd:-$(printf '%.0f' "$spend_pct")%}"
fi

# Line 2 is only printed when there is something to show.
line2=""
if [ -n "$effort" ]; then
  # Match starship's named-color usage so the terminal palette themes it.
  case "$effort" in
    low) style='\033[36m' ;;
    medium) style='\033[37m' ;;
    high) style='\033[33m' ;;
    xhigh | max) style='\033[1;33m' ;;
    *) style='\033[2m' ;;
  esac
  line2=$(printf '%b' "${style}effort:${effort}\033[0m")
fi

if [ -n "$limits" ]; then
  # Yellow at 70%, red at 90%, tracking the highest window.
  worst=${five_pct:-0}
  if [ -n "$seven_pct" ] && [ "$(printf '%.0f' "$seven_pct")" -gt "$(printf '%.0f' "$worst")" ]; then
    worst=$seven_pct
  fi
  worst=$(printf '%.0f' "$worst")
  if [ "$worst" -ge 90 ]; then
    style='\033[1;31m'
  elif [ "$worst" -ge 70 ]; then
    style='\033[33m'
  else
    style='\033[36m'
  fi
  line2="${line2:+$line2 }$(printf '%b' "${style}${limits}\033[0m")"
fi

[ -n "$line1" ] && printf '%s' "$line1"

if [ -n "$line2" ]; then
  # Separate from starship's line; prefix a space only when starship printed.
  printf '%s\n' "${line1:+ }$line2"
elif [ -n "$line1" ]; then
  printf '\n'
fi