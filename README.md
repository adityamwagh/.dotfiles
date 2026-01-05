# Dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Install

```bash
git clone --recursive https://github.com/adityamwagh/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install
```

## What's Included

- **Shells**: zsh, bash (aliases, tools, starship prompt)
- **Editors**: neovim, helix, zed
- **Terminals**: ghostty, kitty, wezterm, rio, contour

## Structure

```
~/.dotfiles/
├── editors/      # neovim, helix, zed
├── shells/       # zsh, bash, aliases, tools
├── terminals/    # terminal emulator configs
├── starship/     # prompt config
├── nix/          # optional nix flake config
└── install       # setup script
```
