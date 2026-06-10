# Claude Code statusline via cship — design

Date: 2026-06-10

## Goal

Replace `starship statusline claude-code` with [cship](https://github.com/stephenleo/cship) so the Claude Code statusline shows usage limits and richer session info: model, git branch, context gauge, input/output tokens, effort, cost, lines added/removed, session duration, 5-hour and 7-day usage limit percentages with reset times.

## Why cship

Claude Code passes `rate_limits.five_hour` / `rate_limits.seven_day` (each `used_percentage` + `resets_at`) in the statusline JSON, but starship 1.25.1 only ships `claude_model`, `claude_context`, and `claude_cost` modules, and starship custom modules receive neither the JSON on stdin nor via env. cship has a native `usage_limits` module plus starship passthrough for prompt modules like `$git_branch`.

## Components

### 1. Install script — `scripts/install-cship.sh`

- Bash, `set -euo pipefail`, kebab-case, guarded: exits 0 if `command -v cship` already succeeds.
- Pinned version `v1.7.1`. Maps `uname -s`/`uname -m` to the release target triple
  (`cship-x86_64-unknown-linux-musl`, `cship-aarch64-unknown-linux-musl`,
  `cship-x86_64-apple-darwin`, `cship-aarch64-apple-darwin`).
- Downloads the raw binary from
  `https://github.com/stephenleo/cship/releases/download/<version>/<asset>`
  to `~/.local/bin/cship` and `chmod +x`.
- Deliberately NOT the official `cship.dev/install.sh`: that installer writes a starter
  config and edits `~/.claude/settings.json`, which is dotbot-managed.
- Run as a `shell` step in `install.conf.yaml` (same pattern as the font install).

### 2. Config — `cship/cship.toml`

Dotbot-linked to `~/.config/cship.toml`. Two-line layout:

- Line 1 (where + session state): `$directory` and `$git_branch` via starship passthrough,
  then `$cship.model`, `$cship.effort`, `$cship.context_bar`,
  `$cship.context_window.used_tokens`, and current input/output token counts
  (`$cship.context_window.total_input_tokens`, `$cship.context_window.total_output_tokens`).
- Line 2 (spend + limits): `$cship.cost`, `+$cship.cost.total_lines_added` /
  `-$cship.cost.total_lines_removed`, `$cship.cost.total_duration`, `$cship.usage_limits`
  with `five_hour_format = "5h {pct}% ({reset})"` and
  `seven_day_format = "7d {pct}% ({reset})"`.
- Thresholds: context bar and usage limits warn at 70 (yellow), critical at 90 (bold red);
  cost warn at 5.0 USD, critical at 10.0 USD.
- Styles use named ANSI colors only (no hex), so the terminal palette
  (Ghostty Dark 2026 / Catppuccin Latte auto-switch) themes the statusline; no separate
  dark/light variants needed.
- Short one-line inline comments per option, matching repo comment policy.

### 3. Settings — `claude/settings.json`

`statusLine.command` changes from `"starship statusline claude-code"` to `"cship"`.

### 4. Starship config — unchanged

`starship/starship.toml` keeps the `[profiles]` and `claude_*` blocks as a revert path.
cship's passthrough invokes starship for prompt modules (`$directory`, `$git_branch`)
which are configured independently of the claude-code profile.

## Data flow

Claude Code → JSON on stdin → `cship` → reads `~/.config/cship.toml` → renders native
modules from the JSON, shells out to starship for passthrough tokens → two stdout lines
→ Claude Code displays them.

## Error handling

- Install script fails loudly (`set -euo pipefail`) on unsupported OS/arch or download error.
- If cship is missing at runtime, Claude Code shows no statusline; rerunning `./install`
  repairs it. No silent fallback layer.
- `usage_limits` `ttl` left at default for caching across concurrent sessions.

## Testing

- Pipe a sample Claude Code JSON payload (with `rate_limits`, `context_window`, `cost`,
  `effort`) into `cship` and verify both lines render with limits and reset times.
- `cship explain` to inspect field mapping if a module renders empty.
- `./install -v` passes; `~/.config/cship.toml` symlink and `~/.local/bin/cship` exist.
- Fresh-clone Docker test per repo policy before merging.

## Commit plan

Single atomic commit: `scripts/install-cship.sh`, `cship/cship.toml`,
`install.conf.yaml` (link + shell step), `claude/settings.json`. Independently
installable per repo policy.

## Out of scope

- Removing starship claude modules or profile.
- Per-model usage breakdown (`show_per_model`) — off initially; one-line config flip later.
- Managing cship version upgrades automatically.
