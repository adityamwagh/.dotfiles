# Nix Configuration Setup

This repository contains a complete Nix configuration for both **NixOS** and **macOS** (using nix-darwin), with Home Manager for user-level configuration.

## Structure

```
.dotfiles/
├── nix/                   # All Nix configuration files
│   ├── flake.nix          # Main flake configuration
│   ├── home/              # Home Manager configuration (shared)
│   │   ├── default.nix    # Main home config
│   │   ├── packages.nix   # User packages
│   │   ├── programs.nix   # Program configurations
│   │   └── shell.nix      # Shell configuration
│   ├── nixos/             # NixOS-specific configuration
│   │   ├── configuration.nix  # Main NixOS config
│   │   └── packages.nix   # System packages
│   └── darwin/            # macOS-specific configuration (Apple Silicon)
│       └── configuration.nix  # Main nix-darwin config
├── shells/                # Shell dotfiles
├── terminals/             # Terminal configs
└── editors/               # Editor configs
```

## Installation

### NixOS

1. **Initial setup** (if not already using flakes):
   ```bash
   # Enable flakes in your current configuration
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   sudo nixos-rebuild switch
   ```

2. **Clone dotfiles**:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles/nix
   ```

3. **Update flake inputs**:
   ```bash
   nix flake update
   ```

4. **Apply configuration**:
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles/nix#devBox
   ```

### macOS (nix-darwin)

1. **Install Nix** (if not already installed):
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. **Enable flakes**:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Clone dotfiles**:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles/nix
   ```

4. **Install nix-darwin**:
   ```bash
   nix run nix-darwin -- switch --flake ~/.dotfiles/nix#macbook
   ```

5. **Subsequent updates**:
   ```bash
   darwin-rebuild switch --flake ~/.dotfiles/nix#macbook
   ```

### Standalone Home Manager (non-NixOS Linux)

1. **Install Nix**:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enable flakes**:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Clone dotfiles**:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles/nix
   ```

4. **Install Home Manager**:
   ```bash
   nix run home-manager/master -- switch --flake ~/.dotfiles/nix#aditya
   ```

5. **Subsequent updates**:
   ```bash
   home-manager switch --flake ~/.dotfiles/nix#aditya
   ```

## Updating

### Update flake inputs
```bash
cd ~/.dotfiles/nix
nix flake update
```

### Apply updates

**NixOS:**
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles/nix#devBox
```

**macOS:**
```bash
darwin-rebuild switch --flake ~/.dotfiles/nix#macbook
```

**Home Manager only:**
```bash
home-manager switch --flake ~/.dotfiles/nix#aditya
```

## Customization

### Adding Packages

- **System packages (NixOS)**: Edit `nixos/packages.nix`
- **System packages (macOS)**: Edit `darwin/configuration.nix`
- **User packages**: Edit `home/packages.nix`

### Modifying Dotfiles

Your existing dotfiles in `shells/`, `terminals/`, and `editors/` are automatically symlinked by Home Manager. Any changes to those files will be reflected immediately without rebuilding.

### macOS-specific Apps

For GUI applications on macOS that aren't available in nixpkgs, use Homebrew casks defined in `darwin/configuration.nix`:

```nix
homebrew.casks = [
  "your-app-name"
];
```

## Useful Commands

### NixOS
```bash
# Rebuild and switch
sudo nixos-rebuild switch --flake ~/.dotfiles/nix#devBox

# Test without switching
sudo nixos-rebuild test --flake ~/.dotfiles/nix#devBox

# Build without activating
sudo nixos-rebuild build --flake ~/.dotfiles/nix#devBox
```

### macOS
```bash
# Rebuild and switch
darwin-rebuild switch --flake ~/.dotfiles/nix#macbook

# Check what would change
darwin-rebuild build --flake ~/.dotfiles/nix#macbook
```

### Home Manager
```bash
# Switch to new configuration
home-manager switch --flake ~/.dotfiles/nix#aditya

# List generations
home-manager generations

# Rollback
home-manager generations | head -2 | tail -1 | awk '{print $NF}' | xargs -I{} {} activate
```

### Maintenance
```bash
# Clean old generations (frees up space)
sudo nix-collect-garbage -d

# Optimize nix store
nix-store --optimize
```

## Configuration Highlights

### Shared via Home Manager
- Shell configuration (zsh, bash)
- Git configuration
- Terminal configurations (kitty, ghostty, wezterm, rio)
- Editor configurations (nvim, helix)
- Starship prompt
- Development tools (fzf, zoxide, ripgrep, eza, bat)

### NixOS-specific
- KDE Plasma 6 desktop environment
- Silent boot with Plymouth
- Tailscale VPN
- Flatpak support
- Latest kernel

### macOS-specific
- System defaults (Dock, Finder, keyboard, trackpad)
- Touch ID for sudo
- Homebrew integration for GUI apps
- Caps Lock remapped to Escape

## Troubleshooting

### Flake evaluation errors
```bash
# Check flake syntax
nix flake check ~/.dotfiles

# Show flake outputs
nix flake show ~/.dotfiles
```

### Permission issues on macOS
```bash
# Fix Nix daemon permissions
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

### Home Manager symlink conflicts
```bash
# Remove conflicting files manually
rm ~/.zshrc  # Example
home-manager switch --flake ~/.dotfiles/nix#aditya
```

## Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
