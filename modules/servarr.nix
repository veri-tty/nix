{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    library = {
      enable = lib.mkEnableOption {
        description = "Enable ebooks and library management";
        default = false;
      };
    };
  };
  imports = [
        inputs.nixarr.nixosModules.default
      ];
  config = {
    nixarr = lib.mkIf config.library.enable {
      enable = true;
      stateDir = "/mnt/dockerdata/servarr/";
      readarr = {
        enable = true;
      };
    };
  };
}
