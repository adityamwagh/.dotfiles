{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell utilities
    fzf
    zoxide
    ripgrep
    eza
    bat
    fd

    # Development tools
    neovim
    git
    gh
    curl
    wget

    # Python development
    python3
    uv
    ruff

    # JavaScript/TypeScript
    bun
    nodejs

    # Formatters and linters
    stylua
    nixfmt-rfc-style

    # Other CLI tools
    starship
    pre-commit

    # Optional GUI applications (Linux only)
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    vscode
    google-chrome
    _1password-gui
    _1password-cli
  ];

  # Fonts
  fonts.fontconfig.enable = true;
}
