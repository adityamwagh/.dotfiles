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

**Single theme:** the only theme is Pierre. Four variants are kept: `Pierre Dark`, `Pierre Light`, and the softer `Pierre Dark Soft` / `Pierre Light Soft`. Colors are taken verbatim from the upstream Pierre theme (`https://github.com/pierrecomputer/theme`). The active pair is `Pierre Dark Soft` (dark) / `Pierre Light Soft` (light); the non-soft variants are available for manual switching. All other theme families (Ayu, Gruvbox, Catppuccin, Tokyo Night, VS Code 2026, One Monokai) were removed — do not re-add them.

**Theme files:** Pierre outputs are checked in directly for Zed, WezTerm, Ghostty, Konsole colorschemes, and Neovim, plus a zsh-patina prompt theme. Keep all four variants consistent when changing the palette; mirror any upstream change across every tool.

**Canonical palette source:**
- Pierre theme (VS Code / Zed / Shiki): `https://github.com/pierrecomputer/theme` — `themes/pierre-{dark,light,dark-soft,light-soft}.json` hold the authoritative UI + syntax + ANSI hex values.
- Dark variants pair their backgrounds with the vivid ANSI ramp (`#ff2e3f`, `#0dbe4e`, `#009fff`…). Dark editor background is `#0a0a0a`, dark-soft `#171717`.

**Local deviations from upstream:**
- **Pierre Light Soft syntax/ANSI.** Upstream pairs Light Soft's soft chrome with the *vivid* (dark-tuned) ANSI ramp — string `#0dbe4e`, number/operator `#08c0ef`, keyword `#ff678d`, variable `#fe8c2c`, constant `#ffca00`, function `#9d6afb`, type `#d568ea`, ANSI `#ff2e3f`/`#0dbe4e`/`#009fff`… — which collapses to 1.5–2.8:1 contrast on the `#ffffff` editor and is unreadable. We replaced Light Soft's syntax, accents, and ANSI with Pierre Light's *muted* ramp — string `#199f43`, number `#1ca1c7`, keyword `#d32a61`, variable `#d47628`, constant `#d5a910`, function `#693acf`, type `#a631be`, ANSI `#d52c36`/`#18a46c`/`#1a85d4`… — and kept only the soft chrome/foreground. The other three variants stay upstream-exact. Applied across Zed, Neovim, Ghostty, WezTerm, Konsole.
- **Dark readability.** Upstream's dimmest grays were illegible for editor UI: bumped Zed `predictive` (inline/ghost completion text) and `text.muted` (completion detail) `#636363`/`#525252` → `#8a8a8a` in Dark and Dark Soft, and Neovim inactive `LineNr` `#525252` → `#737373` in both dark variants.

**Zed theme:** `editors/zed/themes/pierre.json` is one file defining all four themes (`Pierre Light - Custom No Italics`, `Pierre Light Soft - Custom No Italics`, `Pierre Dark - Custom No Italics`, `Pierre Dark Soft - Custom No Italics`). Comments are italic; otherwise no italics.

**Zed settings:** Zed should use dark `Pierre Dark Soft - Custom No Italics` and light `Pierre Light Soft - Custom No Italics`. Preserve the file header comment in `editors/zed/settings.json`. Keep option comments inline. Pane border size should be `active_pane_modifiers.border_size = 1.0`. Keep the explicit spacing-related Zed options unless there is a concrete reason to change them.

**KDE/Konsole settings:** Dotbot may link Konsole colorscheme files only. Do not manage Konsole profiles, `konsolerc`, Plasma themes, KDE services, or other KDE settings through these dotfiles.

**Tool-specific active themes:**
- Zed: dark `Pierre Dark Soft - Custom No Italics`, light `Pierre Light Soft - Custom No Italics`
- Ghostty: `theme = dark:pierre-dark-soft,light:pierre-light-soft`
- WezTerm: load `Pierre Dark Soft` for dark mode and `Pierre Light Soft` for light mode
- Neovim: load `pierre-dark-soft` for dark mode and `pierre-light-soft` for light mode
- zsh-patina: use the Pierre prompt theme (`theme = "file:~/.config/zsh-patina/pierre.toml"`); it maps Pierre roles to ANSI names and follows the terminal palette

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
