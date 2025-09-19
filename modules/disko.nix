{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    disko = {
      enable = lib.mkEnableOption "Enable disko disk configuration";
    };
  };

  imports = [ 
    # Import all disk configurations - they will only be activated
    # if disko.enable is true and they match the hostname
    ../disks/fitz.nix
    ../disks/kerberos.nix
    ../disks/roamer.nix
  ];

  config = lib.mkIf config.disko.enable {
    # We don't need common settings here since each disk config defines its own root FS
  };
}