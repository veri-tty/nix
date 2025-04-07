{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    applications = {
      enable = lib.mkEnableOption {
        description = "Enable desktop applications";
        default = false;
      };
      office = {
        enable = lib.mkEnableOption {
          description = "Enable office applications";
          default = false;
        };
      };
      media = {
        enable = lib.mkEnableOption {
          description = "Enable media applications";
          default = false;
        };
      };
      crypto = {
        enable = lib.mkEnableOption {
          description = "Enable cryptocurrency wallets";
          default = false;
        };
      };
      printing = {
        enable = lib.mkEnableOption {
          description = "Enable 3D printing applications";
          default = false;
        };
      };
    };
  };

  config = {
    home-manager.users.ml.home.packages = lib.mkIf config.applications.enable (
      (lib.optionals config.applications.office.enable [
        pkgs.libreoffice
        pkgs.obsidian
      ])
      ++ (lib.optionals config.applications.media.enable [
        pkgs.spotify
      ])
      ++ (lib.optionals config.applications.crypto.enable [
        # Crypto Wallets
        pkgs.electrum # btc
        pkgs.feather # xmr
      ])
      ++ (lib.optionals config.applications.printing.enable [
        pkgs.bambu-studio # 3D printing slicer
      ])
      ++ [
        # Remote desktop
        pkgs.remmina # rdp client
      ]
    );
  };
}
