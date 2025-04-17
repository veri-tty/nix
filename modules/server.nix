{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    server = {
      immich = {
        enable = lib.mkEnableOption "Enable baremetal immich via nixpkgs";
      };
      vaultwarden = {
        enable = lib.mkEnableOption "Enable vaultwarden via nixpkgs";
      };
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
