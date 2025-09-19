{
  description = "NixOS configuration";

  # Input sources
  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    schizofox.url = "github:schizofox/schizofox";

    nixarr.url = "github:rasmus-kirk/nixarr";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theme
    catppuccin.url = "github:catppuccin/nix";

    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom packages and repositories
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    rycee,
    catppuccin,
    disko,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    specialArgs = {inherit inputs;}; # pass the inputs into the configuration module

    # Define a helper function to create machine configs
    mkMachine = {
      system,
      modules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            ./modules # Import all modules
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ]
          ++ modules;
      };
  in rec {
    ## System configurations
    nixosConfigurations = {
      roamer = mkMachine {
        system = "x86_64-linux";
        modules = [./machines/roamer.nix];
      };

      fitz = mkMachine {
        system = "x86_64-linux";
        modules = [./machines/fitz.nix];
      };

      kerberos = mkMachine {
        system = "x86_64-linux";
        modules = [./machines/kerberos.nix];
      };
    };

    ## Home configurations
    homeConfigurations = {
      roamer = nixosConfigurations.roamer.config.home-manager.users.ml.home;
      fitz = nixosConfigurations.fitz.config.home-manager.users.ml.home;
      kerberos = nixosConfigurations.kerberos.config.home-manager.users.ml.home;
    };
  };
}
