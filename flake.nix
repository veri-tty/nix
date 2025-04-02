{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    mic92.url = "github:Mic92/nur-packages";
    catppuccin.url = "github:catppuccin/nix";
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
    nixosConfigurations = {
      fitz = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./machines/fitz.nix
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.ml = import ./home.nix;
          }
        ];
      };
      roamer = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./machines/roamer.nix
          home-manager.nixosModules.home-manager
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
