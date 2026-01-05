{
  description = "Aditya's Nix configuration for NixOS and macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-darwin for macOS
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      # System configurations
      systems = {
        linux = "x86_64-linux";
        mac = "aarch64-darwin";
      };

      # User configuration
      user = {
        name = "aditya";
        fullName = "Aditya Wagh";
        email = "adityamwagh@outlook.com";
      };

      # Helper to make pkgs for each system
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # NixOS configuration
      nixosConfigurations = {
        devBox = nixpkgs.lib.nixosSystem {
          system = systems.linux;
          specialArgs = { inherit inputs user; };
          modules = [
            ./nixos/configuration.nix

            # Home Manager NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user.name} = import ./home;
              home-manager.extraSpecialArgs = { inherit user; };
            }
          ];
        };
      };

      # macOS (nix-darwin) configuration for Apple Silicon
      darwinConfigurations = {
        macbook = darwin.lib.darwinSystem {
          system = systems.mac;
          specialArgs = { inherit inputs user; };
          modules = [
            ./darwin/configuration.nix

            # Home Manager darwin module
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user.name} = import ./home;
              home-manager.extraSpecialArgs = { inherit user; };
            }
          ];
        };
      };

      # Standalone home-manager configuration (for non-NixOS Linux)
      homeConfigurations = {
        "${user.name}" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs systems.linux;
          extraSpecialArgs = { inherit user; };
          modules = [ ./home ];
        };
      };
    };
}
