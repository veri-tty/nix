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
      caldav = {
        enable = lib.mkEnableOption "Enable baikal caldav via nixpkgs";
      };
      traefik = {
        enable = lib.mkEnableOption "Enable traefik reverse proxy via nixpkgs";
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
    };
    services.bitwarden-directory-connector-cli.domain = lib.mkIf config.server.vaultwarden.enable "vault.lunau.xyz";

    services.traefik = lib.mkIf config.server.traefik.enable {
      enable = true;
    };

    services.baikal = lib.mkIf config.server.caldav.enable {
      enable = true;
    };
  };
}
