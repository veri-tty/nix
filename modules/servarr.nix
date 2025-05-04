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
  config = {
    modules = [
      inputs.nixarr.nixosModules.default
    ];
    nixarr = lib.mkIf config.library.enable {
      enable = true;
      stateDir = "/mnt/dockerdata/servarr/";
      vpn = {
        enable = true;
        wgConf = "/placeholder/for/wg.conf";

      };
      readarr = {
        enable = true;
      };
      transmission = {
        enable = true;
        flood.enable = true;
        privateTrackers.cross-seed.enable = true;
        vpn.enable = true;
      };
    };
    services = lib.mkIf config.library.enable {
      calibre-web = {
        enable = true;
        options.enableKepubify = true;
      };
    };
  };
}
