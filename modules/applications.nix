{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    applications = {
      enable = lib.mkEnableOption {
        description = "Enable desktop applications";
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages = lib.mkIf config.applications.enable [
      pkgs.libreoffice
      pkgs.obsidian
      pkgs.spotify
      # Crypto Wallets
      pkgs.electrum # btc
      pkgs.feather # xmr
      pkgs.bambu-studio # 3D printing slicer
      pkgs.element-desktop
      # Remote desktop
      pkgs.remmina # rdp client
      pkgs.discord
      pkgs.motrix
      pkgs.qbittorrent
      pkgs.vlc
      pkgs.bottles
      pkgs.lutris
      pkgs.wineWowPackages.waylandFull
    ];
  };
}
