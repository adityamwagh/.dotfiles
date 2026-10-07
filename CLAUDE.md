# CLAUDE.md

This file provides guidance to coding agents when working with code in this repository.

## What This Repo Does

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Running `./install` symlinks all configs into place and bootstraps the system.

## Key Commands

- `~/.dotfiles/install` — apply/update symlinks, cleanup stale repo links, and run bootstrap steps
- `~/.dotfiles/install --server` — headless profile: no Homebrew, GUI apps, fonts, or LLM runtimes; includes neovim + CLI tools
- `~/.dotfiles/install -n` — dry run before applying
- `pre-commit run --all-files` — run repo checks (trailing whitespace hook)
- `brew bundle --file ~/.dotfiles/Brewfile` — install/update Homebrew packages
- For install or bootstrap changes, test a fresh clone plus `./install` in Docker before merging, on both `ubuntu:latest` and `fedora:latest` (covers the apt and dnf paths of the `unipkg` directive). Recipe: install `git curl sudo python3 file build tools` (Ubuntu also `procps unzip ca-certificates`), create a non-root user with passwordless sudo (Homebrew refuses root), then as that user `git clone --recurse-submodules https://github.com/adityamwagh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/install -v`. Push commits first (the container clones from GitHub) and run the two distro tests sequentially — parallel runs exhaust the shared 60/hour unauthenticated GitHub API quota and the codex installer fails its version lookup.

## Architecture

**Entry points:**
- `install` — bash bootstrap script; fetches Dotbot if missing, then runs it. `--server` is consumed here (set to `DOTFILES_SERVER=1`, stripped from dotbot args)
- `install.conf.yaml` — Dotbot config: declares symlinks, clean targets, native/Homebrew package install, and font install

**Server profile:** `--server` exports `DOTFILES_SERVER=1`. Desktop-only items are guarded with `if: '[ -z "$DOTFILES_SERVER" ]'`; server-only items with `if: '[ -n "$DOTFILES_SERVER" ]'`. `link` supports `if:` natively; `unipkg` and `brewfile` do too (both submodules are forked forks that add block-level `if:`). The built-in `shell` directive does **not** support `if:`, so shell steps use a short-circuit guard instead: `'[ -z "$DOTFILES_SERVER" ] || <script>'` (desktop-only) — the guard always exits 0 so dotbot sees success whether or not the script runs.

**Config is grouped by domain:** `shells/`, `editors/`, `terminals/`, `starship/`

**Scripts** in `scripts/` are installer helpers run as dotbot `shell` steps during `./install`; they are not linked onto PATH.

**Font management:** per-font scripts in `scripts/` (`install-custom-iosevka-extended.sh`, `install-helvetica-now.sh`, `install-segoe-ui.sh`, `install-sf-pro.sh`, `install-source-code-pro.sh`) install fonts from `fonts/` sources or remote downloads; other fonts come from Brewfile casks.

**Neovim config** (`editors/nvim/`) uses Lazy.nvim with modular Lua files under `lua/plugins/`. Stylua formatting: 2-space indent (see `.stylua.toml`).

**dotbot/** is vendored upstream. **dotbot-brew/** and **dotbot-unipkg/** are the user's forks (`adityamwagh/dotbot-brew`, `adityamwagh/dotbot-unipkg`) that add block-level `if:` support; keep changes upstreamable.

**Package split:** tools that touch system directories or hardware (e.g. `eza`, `ddcutil`, `zsh`) install via the native package manager (`unipkg` directive); on desktop everything else comes from the Brewfile. Servers (`--server`) get no Homebrew; their CLI tools and neovim come from `unipkg`.

## Theme and Config Policy

**Themes:** each tool keeps its theme files under its own theme directory (Neovim `colors/`, Zed `themes/`, Contour `contour.yml`, Konsole colorschemes). Which theme is active is set in each tool's own config and is the user's choice — do not change the active theme or record specific theme names in this file. When adding or editing a theme, keep all of its variants consistent and mirror upstream colors faithfully.

**Zed settings:** Preserve the file header comment in `editors/zed/settings.json`. Keep option comments inline. Pane border size should be `active_pane_modifiers.border_size = 1.0`. Keep the explicit spacing-related Zed options unless there is a concrete reason to change them.

**KDE/Konsole settings:** Dotbot links Konsole colorscheme files and the shared `Main.profile`/`Main Dark.profile` profiles. Shared profiles must stay machine-independent (no hardcoded home directory or machine paths). Machine-local values live in untracked `<Profile>.local.profile` files in the Konsole data dir that inherit the shared profile via `Parent=`; `konsolerc` is local and untracked too, since it selects the local profiles by name. Do not manage Plasma themes, KDE services, or other KDE settings through these dotfiles. `konsolerc.example` documents the expected local `konsolerc` shape.

**Comments:** keep config option comments as short one-line inline comments where the file format supports it. File-level headers, such as the Zed settings documentation header, may remain as standalone comments.

## Atomic Commit Principle

Every commit must be independently installable: `./install` at that commit sets up only what has been committed so far. When adding a tool, editor, or terminal: update its file(s), `.zshrc`, `.bashrc`, `aliases.sh` (if it has aliases), and `install.conf.yaml` (if it needs symlinks) all in the same commit.

Group commits by **semantic change, not by tool**. One logical change that spans several tools (e.g. "add theme X across all editors/terminals", "switch active light theme") is a single commit covering every tool it touches — not one commit per tool. Split commits only when the changes are distinct concepts (e.g. "add theme X" vs "fix theme Y's palette"), keeping each concept's cross-tool edits together.

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
