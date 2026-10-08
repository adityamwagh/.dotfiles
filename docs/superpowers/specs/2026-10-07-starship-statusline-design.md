# Claude Code statusline via starship + shim — design

Date: 2026-10-07

## Goal

Replace cship with starship's built-in Claude Code statusline, keeping the
fields starship drops (rate-limit usage, effort). Reverses the 2026-06-10 cship
decision now that starship ships native `claude_*` modules.

## Why

starship 1.26.0 ships `claude_model`, `claude_context` and `claude_cost`, and
parses the Claude Code statusline JSON on stdin. That covers model, context
gauge, cost, duration, lines changed, git branch and directory. It does not
expose `rate_limits` (or `effort`, though main has an unreleased `$effort`), so
a small shim recovers those from the same stdin payload.

## Components

### 1. Shim — `scripts/claude-statusline.sh`

- Bash, `set -euo pipefail`, kebab-case, guarded (`command -v starship`,
  `command -v jq`). Dotbot-linked to `~/.local/bin/claude-statusline`.
- Reads the session JSON once, then:
  - pipes it to `starship statusline claude-code` for line 1,
  - renders effort and rate limits itself from the same JSON with `jq` for the
    appended segment.
- Rate limits: `5h <pct>% (<HH:MM>)`, `7d <pct>% (<Day HH:MM>)`; spend limit
  (`rate_limits.spend_limit`) as `spend $used/$limit` or a percentage when the
  gateway omits dollars. Window `resets_at` is epoch seconds, formatted as local
  time. Absent windows are skipped; a `null` `used_percentage` is treated as
  absent.
- Effort styled to cship's thresholds; usage segment goes yellow at 70%, red at
  90%, tracking the highest window. Named/explicit ANSI colors only, so the
  terminal palette themes it.
- Degrades safely: no starship prints only the jq segment; no jq prints only
  starship's line. Always exits 0.

### 2. starship — `starship/starship.toml`

- `[profiles] claude-code` unchanged in shape.
- `claude_context` gains default-matched `[[claude_context.display]]` thresholds
  (hidden below 30%, green/yellow/red at 30/60/80).
- `claude_cost` gains `[[claude_cost.display]]` (hidden below $1, yellow at $1,
  red at $5).

### 3. Settings — `claude/settings.json`

`statusLine.command` changes from `"cship"` to `"claude-statusline"`.

### 4. Install — `install.conf.yaml`

- Adds `~/.local/bin/claude-statusline: scripts/claude-statusline.sh`.
- Removes the `~/.config/cship.toml` link and the `install-cship.sh` shell step.

### 5. Removed

`scripts/install-cship.sh` and `cship/cship.toml` (and the `cship/` directory).

## Data flow

Claude Code → JSON on stdin → `claude-statusline` → `starship statusline
claude-code` (line 1) → jq-rendered effort + rate limits appended → stdout.

## Error handling

- Missing starship: line 1 empty, limits still render from jq.
- Missing jq: starship's line only.
- Missing/null rate-limit windows: those segments are omitted.
- No silent failure modes beyond the graceful degradations above.

## Testing

- Pipe sample payloads with/without `rate_limits`, `effort`, `spend_limit`, and
  with only one window; verify resets format and threshold colours.
- `shellcheck scripts/claude-statusline.sh` clean.
- `./install -v` links `~/.local/bin/claude-statusline` and removes the stale
  cship link.

## Out of scope

- starship's unreleased `$effort` variable (handled in the shim until a release
  ships it).
- Removing starship's `claude_*` modules.