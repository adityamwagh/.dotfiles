{ config, pkgs, user, ... }:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./shell.nix
  ];

  home = {
    username = user.name;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.name}" else "/home/${user.name}";
    stateVersion = "24.11";

    # Session variables
    sessionVariables = {
      EDITOR = "nvim";
      PYTEST_ADDOPTS = "-v -s --color=yes";

      # GTK scaling for X11 (fixes Ghostty UI scaling on KDE)
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
    };

    # Symlink dotfiles
    file = {
      ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/terminals/kitty";
      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/terminals/ghostty";
      ".config/rio".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/terminals/rio";
      ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/terminals/wezterm/.wezterm.lua";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/editors/nvim";
      ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/editors/helix";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/starship/starship.toml";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      core.editor = "cursor --wait --new-window";
      diff.tool = "cursor";
      difftool.cursor.cmd = "cursor --wait --diff $LOCAL $REMOTE";
      merge.tool = "cursor";
      mergetool.cursor.cmd = "cursor --wait $MERGED";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
