{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    themeing = {
      enable = lib.mkEnableOption {
        description = "Enable themeing (catppuccin for now duh)";
        default = false;
      };
    };
  };
  config = lib.mkIf config.themeing.enable {
    # Home Manager configuration only - system level removed
    home-manager.users.ml = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      # Home Manager level catppuccin settings
      catppuccin = {
        enable = true;
        accent = "maroon";
        flavor = "mocha";
        cache.enable = true;
      };
    };
  };
}
