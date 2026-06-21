# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## What This Repo Does

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Running `./install` symlinks all configs into place and bootstraps the system.

## Key Commands

- `~/.dotfiles/install` — apply/update symlinks, cleanup stale repo links, and run bootstrap steps
- `~/.dotfiles/install -n` — dry run before applying
- `pre-commit run --all-files` — run repo checks (trailing whitespace hook)
- `brew bundle --file ~/.dotfiles/Brewfile` — install/update Homebrew packages
- For install or bootstrap changes, test a fresh clone plus `./install` in Docker before merging.

## Architecture

**Entry points:**
- `install` — bash bootstrap script; fetches Dotbot if missing, then runs it
- `install.conf.yaml` — Dotbot config: declares symlinks, clean targets, Homebrew bundle install, and font install

**Config is grouped by domain:** `shells/`, `editors/`, `terminals/`, `starship/`

**Scripts and fonts** in `scripts/` and `fonts/` are linked to `~/.local/bin/`.

**Font management:** `fonts/install-fonts.sh` installs IosevkaExtended from the repo and downloads SF Pro, Selawik, and Segoe UI from remote sources.

**Neovim config** (`editors/nvim/`) uses Lazy.nvim with modular Lua files under `lua/plugins/`. Stylua formatting: 2-space indent (see `.stylua.toml`).

**dotbot/** is a vendored submodule — treat as upstream.

## Theme and Config Policy

**Themes:** each tool keeps its theme files under its own theme directory (Neovim `colors/`, Zed `themes/`, Ghostty `themes/`, WezTerm `colors/`, Konsole colorschemes). Which theme is active is set in each tool's own config and is the user's choice — do not change the active theme or record specific theme names in this file. When adding or editing a theme, keep all of its variants consistent and mirror upstream colors faithfully.

**Zed settings:** Preserve the file header comment in `editors/zed/settings.json`. Keep option comments inline. Pane border size should be `active_pane_modifiers.border_size = 1.0`. Keep the explicit spacing-related Zed options unless there is a concrete reason to change them.

**KDE/Konsole settings:** Dotbot may link Konsole colorscheme files only. Do not manage Konsole profiles, `konsolerc`, Plasma themes, KDE services, or other KDE settings through these dotfiles.

**Comments:** keep config option comments as short one-line inline comments where the file format supports it. File-level headers, such as the Zed settings documentation header, may remain as standalone comments.

## Atomic Commit Principle

Every commit must be independently installable: `./install` at that commit sets up only what has been committed so far. When adding a tool, editor, or terminal: update its file(s), `.zshrc`, `.bashrc`, `aliases.sh` (if it has aliases), and `install.conf.yaml` (if it needs symlinks) all in the same commit.

## Shell/Script Coding Style

- **Minimal and correct:** do only what is needed; no speculative or future-proofing code
- **Guard everything:** use `command -v`, `[ -f ... ]`, `[ -n "$ZSH_VERSION" ]` etc. before calling tools
- **Modular:** one concern per file; source files are small and focused
- **Readable:** prefer clarity over cleverness; add short comments only where intent is not obvious
- **Cross-shell:** all files outside `shells/zsh/` must work in both bash and zsh
- **`set -euo pipefail`** in scripts; not in interactive shell files

## Coding Conventions

- Shell scripts: Bash with `set -euo pipefail`
- Script filenames: kebab-case (e.g. `some-script.sh`)
- Prefer feature detection (`command -v ...`) over hardcoded paths for cross-platform portability
- Small, composable config files per domain rather than monolithic files
- Commits: Conventional Commits prefixes (`feat:`, `fix:`, `refactor:`), scoped by subsystem
- Before committing, always run `./install -v` and fix any errors first
- Keep history aligned with `origin/main`; do not rewrite or squash commits unless explicitly requested.
- Alphabetical order: when a list's element order does not affect behavior (e.g. `.gitignore` rules, `auto_install_extensions`, package/font lists), keep entries alphabetically sorted, and re-check the ordering whenever you add or edit such a list. Never reorder order-sensitive content (font fallback chains, `tap` before `brew` in the Brewfile, positional ANSI arrays, code).
