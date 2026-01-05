{ config, pkgs, user, ... }:

{
  # User configuration
  users.users.${user.name} = {
    name = user.name;
    home = "/Users/${user.name}";
  };

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Terminal emulators (macOS compatible)
    kitty
    wezterm

    # Editors
    neovim

    # System utilities
    coreutils
    findutils
    gnused
    gnutar
    gzip

    # Development tools
    git
    gh
    curl
    wget

    # Fonts
    fontconfig
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      hack-font
      inter
      nerd-fonts.dejavu-sans-mono
      cascadia-code
    ];
  };

  # macOS-specific settings
  system = {
    # Set macOS system defaults
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
      };

      # NSGlobalDomain settings
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3; # Full keyboard control
        ApplePressAndHoldEnabled = false; # Enable key repeat
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Tap to click
        TrackpadThreeFingerDrag = true;
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    stateVersion = 5;
  };

  # Enable Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Homebrew configuration (for GUI apps not in nixpkgs)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # Taps
    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
    ];

    # Homebrew packages
    brews = [
      "mas" # Mac App Store CLI
    ];

    # GUI applications via Homebrew Cask
    casks = [
      "1password"
      "google-chrome"
      "visual-studio-code"
      "cursor"
      "ghostty"
    ];

    # Mac App Store applications
    masApps = {
      # Add Mac App Store apps here
      # Example: "Xcode" = 497799835;
    };
  };

  # Services
  services = {
    nix-daemon.enable = true;

    # Tailscale (if available on macOS via nix)
    # tailscale.enable = true;
  };

  # Shell configuration
  programs.zsh.enable = true;
  programs.bash.enable = true;

  # Set default shell
  environment.shells = [ pkgs.zsh pkgs.bash ];
}
