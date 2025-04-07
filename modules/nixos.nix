{
  lib,
  config,
  pkgs,
  ...
}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };
  boot.loader.systemd-boot.configurationLimit = 120;
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  users.users.ml = {
    isNormalUser = true;
    description = "ml";
    extraGroups = ["wheel" "docker"];
  };

  home-manager.users.ml.home.stateVersion = "24.11";
  system.stateVersion = "24.11";
}
