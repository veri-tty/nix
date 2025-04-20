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
    };
    services.vaultwarden = lib.mkIf config.server.vaultwarden.enable {
      enable = true;
    };
    services.bitwarden-directory-connector-cli.domain = lib.mkIf config.server.vaultwarden.enable "vault.lunau.xyz";

    services.traefik = lib.mkIf config.server.traefik.enable {
      enable = true;
      staticConfigOptions = {
        log = {
          level = "WARN";
        };
        api = {}; # enable API handler
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure = {
            address = ":443";
          };
        };
      };
    };
    systemd.services.traefik.serviceConfig = lib.mkIf config.server.traefik.enable {
      EnvironmentFile = ["/var/lib/traefik/env"];
    };
    networking.firewall.allowedTCPPorts = lib.mkIf config.server.traefik.enable [80 443];


    services.baikal = lib.mkIf config.server.caldav.enable {
      enable = true;
    };
  };
}
