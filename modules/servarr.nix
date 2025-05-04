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
    ]
    nixarr = {
      enable = true;
      vpn = {
        enable = true;
        wgConf = "/placeholder/for/wg.conf";
      }
    };
  };
}
