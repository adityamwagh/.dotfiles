# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io). This repository is the chezmoi source state.

## Use

On a new machine, install chezmoi, clone the source, and point chezmoi at it:

```bash
brew install chezmoi                       # or: sh -c "$(curl -fsLS get.chezmoi.io)"
git clone https://github.com/adityamwagh/.dotfiles.git ~/.dotfiles
mkdir -p ~/.config/chezmoi
cp ~/.dotfiles/chezmoi.toml.example ~/.config/chezmoi/chezmoi.toml
chezmoi apply
```

Preview changes before applying them:

```bash
chezmoi apply -n -v
```

Apply updates after pulling:

```bash
chezmoi update
```

For a headless server, set the profile for the apply:

```bash
DOTFILES_SERVER=1 chezmoi apply
```

The server profile installs shell configs, neovim, tmux, Claude Code, and CLI tools from the native package manager. It does **not** install Homebrew, GUI apps/terminals/editors, fonts, or LLM runtimes.

## Editing

- Edit the source and apply: `chezmoi edit ~/.zshrc && chezmoi apply`
- Edit a live file and capture it: `chezmoi add ~/.zshrc` (or `chezmoi re-add` for everything)
- Working in `~/.dotfiles` directly is fine; run `chezmoi apply` afterwards

## Layout

- `dot_*` / `private_*` — the source state (`dot_zshrc` → `~/.zshrc`); only hidden target names carry `dot_`
- `.chezmoiscripts/` — `run_once_`/`run_onchange_` bootstrap scripts
- `.chezmoidata/packages.yaml` — Linux desktop/server package lists
- `.chezmoiignore` — templated platform/server gating and repo-only files
- `dot_Brewfile` — macOS packages
- `assets/` — repo-only installer scripts and font sources

Run checks before committing:

```bash
pre-commit run --all-files
```
