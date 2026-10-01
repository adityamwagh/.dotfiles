# Dotfiles

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Use

Clone the repo and run the installer:

```bash
git clone https://github.com/adityamwagh/.dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

Preview changes before applying them:

```bash
~/.dotfiles/install -n
```

Re-run the installer any time after pulling updates:

```bash
~/.dotfiles/install
```

The installer links configs into `$HOME`, cleans stale repo-managed links, applies `Brewfile` when Homebrew is available, and runs the font installer.

For a headless server, use the `--server` profile:

```bash
~/.dotfiles/install --server
```

This installs a server-appropriate subset: shell configs, starship, completions, zsh-patina, Claude Code, neovim, and CLI tools via the native package manager. It does **not** install Homebrew, GUI apps/terminals/editors, fonts, or LLM runtimes.

Run checks before committing:

```bash
pre-commit run --all-files
```
