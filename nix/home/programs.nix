{ pkgs, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  # Fzf (fuzzy finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  # Eza (better ls)
  programs.eza = {
    enable = true;
    enableZshIntegration = false; # We use custom aliases
    enableBashIntegration = false;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # Direnv (environment management)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
