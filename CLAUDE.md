# CLAUDE.md

This file provides guidance to coding agents when working with code in this repository.

## What This Repo Does

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io). This repository _is_ the chezmoi source state: `sourceDir` points here (set in the machine-local `~/.config/chezmoi/chezmoi.toml`). `chezmoi apply` renders the source into `$HOME` and runs the bootstrap scripts when their content changes.

## Key Commands

- `chezmoi apply` — write the source state to `$HOME` and run pending scripts
- `chezmoi apply -n -v` — dry run showing every change
- `chezmoi diff` / `chezmoi status` — preview drift between source and `$HOME`
- `chezmoi add <path>` / `chezmoi re-add` — capture a live file (or all of them) back into the source
- `chezmoi edit <path>` — edit the source copy of a target
- `chezmoi update` — `git pull` in the source, then apply
- `DOTFILES_SERVER=1 chezmoi apply` — headless server profile (no Homebrew, GUI apps, fonts, or LLM runtimes)
- `pre-commit run --all-files` — formatters and linters (oxfmt/oxlint, StyLua, shfmt, shellcheck)
- `brew bundle --file ~/.Brewfile` — install/update Homebrew packages (also runs from the packages script)

For bootstrap changes, test a fresh clone plus `chezmoi apply` in Docker on both `ubuntu:latest` and `fedora:latest` (covers the apt and dnf paths). Install `git curl sudo python3 build-essential` (Ubuntu also `procps unzip ca-certificates`), create a non-root user with passwordless sudo, clone this repo to `~/.dotfiles`, point `sourceDir` at it, then run `chezmoi apply -v` as that user. Push commits first — the container clones from GitHub.

## Architecture

**Source layout:** chezmoi naming encodes the target. `dot_zshrc` → `~/.zshrc`, `dot_config/nvim/` → `~/.config/nvim/`, `private_Library/...` → `~/Library/...` with private modes. Only components whose target name starts with a dot carry `dot_`. Everything in the source root is applied to `$HOME`, so repo-only files (`.pre-commit-config.yaml`, `.stylua.toml`, `.oxfmtrc.json`, `assets/`, docs) are listed in `.chezmoiignore`.

**`.chezmoiignore` is a template.** It gates platform-specific and server-specific targets:

- `.Brewfile` and `.config/zed` are ignored when `DOTFILES_SERVER` is set
- `Library` is ignored off macOS and on servers
- `.config/sublime-text`, `.config/systemd`, `.local/share/konsole` are ignored off Linux and on servers
- the Claude Code mod's generated `.claude-plugin/types` is always ignored

**`.chezmoidata/packages.yaml`** holds the Linux `desktop` and `server` package lists, consumed by the packages script.

**`.chezmoiscripts/`** holds bootstrap actions. `run_once_` scripts run once per machine (tracked in chezmoi state); `run_onchange_` scripts rerun when their rendered content changes:

- `bootstrap-common` — default shell, zsh-patina, Claude Code, LiteLLM
- `bootstrap-desktop` — fonts, Codex, Konsole, llama.cpp, Ollama, rustup, sweep (skipped on servers)
- `bootstrap-packages` — `brew bundle` on macOS (hashed against `.Brewfile`), apt/dnf on Linux using `.chezmoidata`
- `theme-switch` — installs `theme_switch.sh` on Linux desktops (hashed against the asset)
- `watchman` — registers a `chezmoi apply --force` trigger for the source directory
- `seed-gitconfig-local` — creates `~/.gitconfig.local` if absent

**`assets/`** is repo-only: installer helpers (`assets/scripts/`) and font sources (`assets/fonts/`). Bootstrap scripts call them with `{{ .chezmoi.sourceDir }}/assets`.

**Package split:** macOS packages come from `dot_Brewfile`; Linux packages come from `.chezmoidata/packages.yaml` (native package manager). Servers get no Homebrew; their CLI tools and neovim come from the server package list.

**Neovim config** (`dot_config/nvim/`) uses Lazy.nvim with modular Lua files under `lua/plugins/`. StyLua formatting: 2-space indent (repo-root `.stylua.toml`).

## Theme and Config Policy

**Themes:** each tool keeps its theme files under its own theme directory (Neovim `dot_config/nvim/colors/`, Zed `dot_config/zed/themes/`, Contour `dot_config/contour/contour.yml`, Konsole `dot_local/share/konsole/colorschemes/` and the macOS Library counterpart). Which theme is active is set in each tool's own config and is the user's choice — do not change the active theme or record specific theme names in this file. When adding or editing a theme, keep all of its variants consistent and mirror upstream colors faithfully.

**Zed settings:** Preserve the file header comment in `dot_config/zed/settings.json`. Keep option comments inline. Pane border size should be `active_pane_modifiers.border_size = 1.0`. Keep the explicit spacing-related Zed options unless there is a concrete reason to change them.

**KDE/Konsole settings:** chezmoi manages Konsole colorscheme files and the shared `Light.profile`/`Dark.profile` profiles at `dot_local/share/konsole` (Linux) and `private_Library/private_Application Support/private_konsole` (macOS). Shared profiles must stay machine-independent (no hardcoded home directory or machine paths). Machine-local values live in untracked `<Profile>.local.profile` files in the Konsole data dir that inherit the shared profile via `Parent=`; `konsolerc` is local and untracked too, since it selects the local profiles by name. Konsole, Kate, KWrite and Haruna are native installs; Contour is native too. KDE-runtime Flatpaks, when present, get per-app `kdeglobals` copies from `theme_switch.sh`. Do not manage Plasma themes, KDE services, or other KDE settings through these dotfiles beyond that script. `assets/konsole/konsolerc.example` documents the expected local `konsolerc` shape.

**Comments:** keep config option comments as short one-line inline comments where the file format supports them. File-level headers, such as the Zed settings documentation header, may remain as standalone comments.

## Atomic Commit Principle

Every commit must be independently applicable: `chezmoi apply` at that commit sets up only what has been committed so far. When adding a tool, editor, or terminal: update its source files (`dot_*`), `dot_config/shell/aliases.sh` (if it has aliases), the rc files as needed, and `.chezmoiignore`/`.chezmoiscripts` (if it needs platform gating or bootstrap) all in the same commit.

Group commits by **semantic change, not by tool**. One logical change that spans several tools (e.g. "add theme X across all editors/terminals", "switch active light theme") is a single commit covering every tool it touches — not one commit per tool. Split commits only when the changes are distinct concepts (e.g. "add theme X" vs "fix theme Y's palette"), keeping each concept's cross-tool edits together.

## Shell/Script Coding Style

- **Minimal and correct:** do only what is needed; no speculative or future-proofing code
- **Guard everything:** use `command -v`, `[ -f ... ]`, `[ -n "$ZSH_VERSION" ]` etc. before calling tools
- **Modular:** one concern per file; source files are small and focused
- **Readable:** prefer clarity over cleverness; add short comments only where intent is not obvious
- **Cross-shell:** everything under `dot_config/shell/` and all bootstrap scripts must work in both bash and zsh; zsh-only files are the rc files (`dot_zshrc`, `dot_zprofile`, `dot_zshenv`)
- **`set -euo pipefail`** in scripts; not in interactive shell files

## Coding Conventions

- Shell scripts: Bash with `set -euo pipefail`
- Script filenames: kebab-case (e.g. `some-script.sh`)
- Prefer feature detection (`command -v ...`) over hardcoded paths for cross-platform portability
- Small, composable config files per domain rather than monolithic files
- Commits: Conventional Commits prefixes (`feat:`, `fix:`, `refactor:`), scoped by subsystem
- Before committing, run `chezmoi apply -n -v` and `pre-commit run --all-files`, and fix any errors first
- Keep history linear: no merge commits. Integrate branches only by squash merge or rebase; never rewrite published history.
- Alphabetical order: when a list's element order does not affect behavior (e.g. `.gitignore` rules, `auto_install_extensions`, package/font lists), keep entries alphabetically sorted, and re-check the ordering whenever you add or edit such a list. Never reorder order-sensitive content (font fallback chains, `tap` before `brew` in the Brewfile, positional ANSI arrays, code).
