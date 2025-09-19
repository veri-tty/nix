{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    syncthing = {
      enable = lib.mkEnableOption "Enable Syncthing file synchronization";
    };
    samba = {
      enable = lib.mkEnableOption "Enable Samba file sharing";
    };
  };

  config = {
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = lib.mkIf config.samba.enable [pkgs.cifs-utils];
    fileSystems."/mnt/share" = lib.mkIf config.samba.enable {
      device = "//u455112.your-storagebox.de/backup";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=/home/ml/.smbcredentials"];
    };

    services.syncthing = lib.mkIf config.syncthing.enable {
      enable = true;
      user = "ml";
      dataDir = "/home/ml"; # default location for new folders
      configDir = "/home/ml/.config/syncthing";
      guiAddress = "127.0.0.1:8384";
    };
  };
}
