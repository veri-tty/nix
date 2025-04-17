{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland";
    };
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland";
    };
  };
  config = {
    services.immich = lib.mkIf config.server.immich.enable {
      enable = true;
      settings = "";
      database.user = "ml";
      database.name = "immich";
    };
    services.vaultwarden = lib.mkIf config.server.vaultwarden.enable {
      enable = true;
      bitwarden-directory-connector-cli.domain = "vault.lunau.xyz";
    }
  };
}
