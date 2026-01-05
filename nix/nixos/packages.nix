{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    neovim
    wget
    curl
    git

    # Shell
    zsh

    # Development
    python3
    uv
    ruff
    bun
    stylua

    # CLI tools
    fzf
    zoxide
    ripgrep
    eza
    bat
    gh
    starship

    # GUI Applications
    vscode
    google-chrome
    evil-helix
    _1password-gui
    _1password-cli
    appimage-run

    # KDE applications
    kdePackages.kate
    kdePackages.koi

    # Services
    tailscale

    # Formatters
    nixfmt-rfc-style
  ];

  # Fonts
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      hack-font
      inter
      nerd-fonts.dejavu-sans-mono
      cascadia-code
    ];
  };
}
