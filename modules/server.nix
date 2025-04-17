{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    server = {
      immich = {
        enable = lib.mkEnableOption "Immich Backend via Baremetal Nixpkgs deployment";
        default = false;

      };
    };
    server = {
      immich = {
        enable = lib.mkEnableOption "Vaultwarden Backend for Bitwarden via Baremetal Nixpkgs deployment";
        default = false;
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
