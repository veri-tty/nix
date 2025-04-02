{
  description = "NixOS configuration";

  # Input sources
  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Theme
    catppuccin.url = "github:catppuccin/nix";
    
    # Custom packages and repositories
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    mic92.url = "github:Mic92/nur-packages";
    claude-code-nix.url = "path:./pkgs/claude-code";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    mic92,
    rycee,
    catppuccin,
    claude-code-nix,
    ...
  } @ inputs: {
    # Define NixOS configurations for different machines
    nixosConfigurations = {
      # Desktop configuration
      fitz = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          # Base modules
          ./configuration.nix
          ./machines/fitz.nix
          
          # Home manager integration
          home-manager.nixosModules.home-manager
          
          # Theme
          catppuccin.nixosModules.catppuccin
          
          # Home manager configuration
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.ml = import ./home.nix;
          }
        ];
      };
      
      # Laptop configuration
      roamer = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          # Base modules
          ./configuration.nix
          ./machines/roamer.nix
          
          # Home manager integration
          home-manager.nixosModules.home-manager
          
          # Home manager configuration
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.ml = import ./home.nix;
          }
        ];
      };
    };
  };
}